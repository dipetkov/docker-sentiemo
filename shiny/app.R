
pckg <- c("magrittr", "dplyr", "purrr", "readr", "indicoio", "DT")
inst <- suppressMessages(lapply(pckg, library, character.only = TRUE))

emotions <- c("anger", "joy", "surprise", "sadness", "fear")

call_api <- function(data, api = c("sentiment", "emotion"), api_key) {
  try({
    response <- if (api == "sentiment") {
      data$text %>% indicoio::sentiment_hq(api_key = api_key)
    } else {
      data$text %>% indicoio::emotion(api_key = api_key)
    }
    if (nrow(data) == 1) list(response) else response
  }, silent = TRUE)
}

add_sentiment <- function(data, api_key) {
  response <- call_api(data, "sentiment", api_key)
  if (class(response) == "try-error") {
    data
  } else {
    tibble(sentiment = map_dbl(response, `[`, 1)) %>%
      bind_cols(data) %>%
      select(text, everything())
  }
}

add_emotions <- function(data, api_key) {
  response <- call_api(data, "emotion", api_key)
  if (class(response) == "try-error") {
    data
  } else {
    response %>%
      map_df(`[`, emotions) %>%
      bind_cols(data) %>%
      select(text, everything())
  }
}

truncate_text <- function(text, n = 250) {
  ifelse(nchar(text) > n, paste0(substr(text, 1, n), "..."), text)
}

add_conditional_coloring <- function(df) {
  brks <- seq(.05, .95, by = 0.05)
  clrs <-
    round(seq(255, 40, length.out = length(brks) + 1), 0) %>%
    { paste0("rgb(255,", ., ",", ., ")") }
  df %>%
    mutate(text = truncate_text(text)) %>%
    datatable() %>%
    formatStyle(intersect(names(df), "sentiment"),
                backgroundColor = styleInterval(brks, clrs))
}

server <- function(input, output, session) {
  
  values <- reactiveValues(
    api_key = NULL,
    data_tbl = NULL
  )
  
  observeEvent(input$indico, {
    values$api_key <- input$indico
  })
  
  observeEvent(input$txtfile, {
    values$data_tbl <- 
      read_lines(input$txtfile$datapath) %>%
      data_frame(text = .) %>%
      filter(text > "")
  })
  
  observeEvent(input$sentiment, {
    if (is.null(values$data_tbl) | !nrow(values$data_tbl)) return(NULL)
    if (!exists("sentiment", values$data_tbl)) {
      values$data_tbl %<>% add_sentiment(values$api_key)
    }
  })
  
  observeEvent(input$emotions, {
    if (is.null(values$data_tbl) | !nrow(values$data_tbl)) return(NULL)  
    if (!all(emotions %>% map_lgl(exists, where = values$data_tbl))) {
      values$data_tbl %<>% add_emotions(values$api_key)
    }
  })
  
  output$scores <- renderDataTable({
    if (is.null(values$data_tbl)) return(NULL)
    values$data_tbl %>%
      mutate_if(is.numeric, round, digits = 2) %>%
      add_conditional_coloring()
  })
  
  output$download <- downloadHandler(
    filename = function() {
      "sentiment-emotion-results.csv"
    },
    content = function(file) {
      if (!is.null(values$data_tbl)) {
        values$data_tbl %>% write_csv(file)
      }
    })
}

ui <- fluidPage(
  
  titlePanel("Sentiment & Emotions"),
  
  p("Use this tool to recognize sentiment and emotion in plain text. For readability, in the results table, text is truncated after 250 characters. Sentiment scores range from 0 (very negative) to 1 (very positive). Five emotions (anger, joy, fear, sadness, surprise) are also scored on a 0-to-1 scale and moreover, for each piece of text, the emotion scores add up to 1."),
  
  sidebarPanel(
    textInput("indico", "Fill in your Indico API key", ""),
    fileInput("txtfile", "Choose a text file (no header, one review per line)",
              accept = c("text/plain")),
    actionButton("sentiment", "Score sentiment"),
    actionButton("emotions", "Score emotions"),
    hr(),
    downloadButton("download", "Downlad table")
  ),
  
  mainPanel(
    dataTableOutput("scores")
  )
)

shinyApp(ui = ui, server = server)
