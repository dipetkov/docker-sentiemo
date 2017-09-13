#' ---
#' title: "Learn about Docker, Git and NLP APIs"
#' subtitle: "and make your own sentiment analysis app"
#' date: "`r Sys.Date()`"
#' output:
#'   prettydoc::html_pretty:
#'     theme: leonids
#' highlight: github
#' number_sections: no
#' fig_caption: yes
#' split_by: none
#' self_contained: True
#' ---

#+ , echo = FALSE
library("knitr")
library("prettydoc")
opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE, collapse = TRUE,
               comment = "#>", out.width = "100%",
               fig.asp = 1 / 1.6, fig.width = 5, dpi = 600, fig.retina = NULL,
               fig.path = "figures/")

#' ## Summary
#' 
#' You are curious about data science, machine learning and artificial intelligence (the hottest term[^AI_is_hot_really_hot]) and you listened to a podcast, attended a talk or read a blog post, in which a "smart person" might have said something like this: 
#' 
#' [^AI_is_hot_really_hot]: How hot is AI? [AI is so hot right now researchers are posing for Yves Saint Laurent](https://www.theverge.com/tldr/2017/8/31/16234342/ai-so-hot-right-now-ysl-alexandre-robicquet)
#' 
#' `
#' Our team uses git repos for code development; We dockerize our app for shipment & deployment.
#' `
#' 
#' What does this even mean?! 
#' 
#' From start to finish, a data science project often requires several tools. Fortunately, most tools are open source and their basic functionality is often simple to use. Here I show how to use Docker, Git and a natural language processing (NLP) API to create an app for sentiment & emotion analysis on text.
#' 
#' This post can be read on three levels: You can read Part I to learn some jargon that data scientists often use without explaining. You can read Part II to learn how to set up the sentiment & emotion app and use it in your browser. (This also requires creating a free account with the text analysis service that powers the app.) And if really interested, you can download the code for this entire project, learn how the app is created and modify it in any way you'd like.
#' 
#' # Part I
#' 
#' ## Docker
#' 
#' Docker is a technology to create and use software containers: stand-alone, isolated application packages. A container comes complete with all libraries and dependencies necessary to run an application. And if properly tested beforehand, all parts will be compatible and have the right version. Containers are created from an image; the image is created by Docker from a set of instruction written in a Dockerfile.
#' 
#' Docker containers have several advantages. They are portable and platform-independent: the same Docker container will run on Windows, on Mac, on a server or in the cloud (once Docker is properly installed). They use resources more efficiently than virtual machines.[^containers_cv_virtual_machines] And they are easily shareable: you can discover and download (pull) hundreds of popular Docker images in Docker Hub, a centralized, cloud-based platform for code repositories and official libraries. The image for creating the sentiment & emotion analysis container, `sentiemo`, is available in Docker Hub as well.
#' 
#' [^containers_cv_virtual_machines]: The key difference between containers and VMs is that a virtual machine abstracts an entire device while a container abstracts just the operating system kernel.
#' 
#' ## R + Shiny
#' 
#' One of the most important decisions that a budding data scientist is asked to make is to commit to using either R or Python in their projects.[^R_or_Python] Both are high-level, open-source programming languages: You write instructions in a plain text script rather than use a graphical interface as you do with a point&click tool like JMP. The script is a permanent record of the work needed to perform an analysis and makes workflows reproducible and easy to modify, share and extend. 
#' 
#' [^R_or_Python]: R and Python have the largest data science communities, so it will be easiest to find tutorials, examples & support if working in either R or Python.
#' 
#' This project uses R for one of its coolest features: how easy it is to create functional, interactive apps. The sentiment & emotion app is written in just 120 lines of code!
#' 
#' ## Git + GitHub
#' 
#' If a project takes more than a couple of days to develop, it can get difficult to keep track of the changes being made (to the code, to the documentation, to the report). This becomes even more difficult if there are multiple people collaborating on the same project, who can make changes independently at the same time. 
#' 
#' Git is a powerful system for distributed version control. *Version control* means that Git keeps track of the entire history of changes to a project (called a repository or a repo, for short) and helps with merging concurrent changes; *distributed* means that the repository can be hosted on a server so that each contributor makes changes to a local version and then merges his updates into the *master* when the changes are ready. So a team can collaborate on writing code and analyzing data in a way that is similar to how a team can edit a shared report in Dropbox.
#' 
#' All the work for this project (the Dockerfile to generate the Docker image, the R scripts to create the Shiny app and generate the report) is available at its GitHub repository: <https://github.com/dipetkov/docker-sentiemo>.
#' 
#' ## NLP APIs
#' 
#' In theory, we can use Docker to package any software application and we can use Git to organize any programming project. Let's use them in practice to create and use a simple, yet useful tool: an app to detect sentiment and emotions in text. The app will be powered by an API accessible online through HTTPS requests.
#' 
#' Natural language APIs are built specifically for text analysis and language semantics and understanding. Most offer a pay-as-you-service (you pay per text snippet analyzed) and many have a free tier, which allows the user to use the API for a limited number of free transactions every month. Common text analysis functions provided by NLP APIs include language detection, summarization, named entity recognition[^entities_in_text], sentiment analysis.
#' 
#' [^entities_in_text]: A named entity is a real-word object like a person, an organization, a location, a unit of time, etc. For example, the sentence *"P&G has its headquarters in Cincinnati, Ohio"* has two entities: P&G (an organization) and Cincinnati, Ohio (a location).
#' 
#' For the `sentiemo` app, I chose [Indico](https://indico.io) because it does both sentiment and emotion analysis, its API is straightforward to use, it has 10,000 free credits per month and I like reading its technical blog. However, I have not evaluated its performance systematically and I do not claim it performs well at either sentiment or emotion analysis.
#' 
#' # Part II
#' 
#' First install Docker (community edition) for free. Get *Docker for Windows* if you have Windows 10 or *Docker Toolbox* if you have Windows 7. Get *Docker for Mac* if you have a Mac.
#' 
#' On Windows installing Docker can be tricky. It requires Hyper-V and that the CPU supports virtualization <https://docs.docker.com/docker-for-windows/troubleshoot/#hyper-v> and this has to be activated in the BIOS, which might be password protected. After installation is complete, make sure that Docker is set up correctly by typing `docker run hello-world` in the command line interface (CLI). If Docker is installed and working, you will get a "Hello from Docker!" message.
#' 
#' Then use Kitematic (available in the Docker menu; provides a convenient graphical interface to Docker Hub) to sign up for Docker Hub and search for and pull the `sentiemo` image. Click on `Create`. Once the container is running, open your browser and enter `http://{AccessURL}:{port_number}/myapp/`. You will find the URL and the port number in the Kitematic window, under "Access URL". This will open a Shiny app for sentiment and emotion analysis of text.
#' 
#' See Figure 1 for a visual explanation of the steps necessary to get the Docker container of the app up and running.
#' 
#' ![Figure 1: Running the app. a) Kitematic, a graphical user interface (GUI) to Docker Hub where you can search for and pull Docker images. Click on "Docker CLI" to open the command line interface and test the installation by typing `docker run hello-world`. b) In the search bar, enter “sentiemo”, the name of the image created for the sentiment & emotion detection app. c) When you click “Create”, the image will start downloading. d) Once the image is downloaded, Docker will create a container from the image and run it. The localhost port number is given on the right under "Access URL".](figures/Figure1.png)
#' 
#' Once its Docker container is running, the app should be accessible at `http://{AccessURL}:{port_number}/myapp/`.
#' 
#' To use the app, create an account at <https://indico.io>. After you sign up, copy your API key and paste it in the empty input box labeled "Fill in your Indico API key". Now you are ready to upload a plain text file, with one piece of text per line (a review, a tweet or a short paragraph) and press the "Score sentiment" and/or "Score emotions" buttons. The data is sent to the Indico API using the secure HTTPS protocol. You can download the results with the "Download table" button.
#' 
#' ![Figure 2: Using the app. Create an account at <https://indico.io> and make a note of your Indico API key. Upload a plain text file without a header, with one review/comment per line. This example shows the results of analyzing five Amazon reviews about Tide Pods. The sentiment scores seem appropriate, the emotions less so. For example, the "anger" & "sadness" scores for the positive reviews seem too high. It is tempting to speculate that in the first review, "They don't create residue" contributes to higher anger/sadness: in a general statement "don't create" might have a disappointment connotation but for a detergent this is a benefit, not a downside.](figures/Figure2.png)
#' 
#' # Part III
#' 
#' ## Ideas how to use the tool
#' 
#' With care! This is a general-purpose tool, it might not perform accurately on specific types of text. Sentiment and emotion analysis of one text snippet requires 1 credit each and you get 10,000 free credits every month.
#' 
#' ## Ideas how to improve the tool
#' 
#' 1. Plug in the app to another natural language API which provides sentiment functionality. Here is a recent list and review of NLP APIs: <https://friendlydata.io/blog/best-nlp-apis>.
#' 2. Allow the user to upload their API key from a file so that it is not visible in the app window.
#' 3. Enhance the conditional coloring of sentiment scores, so that negative scores (< 0.5) are highlighted in red, neutral score (~0.5) are highlighted in gray and positive scores (> 0.5) are highlighted in green.
#' 4. Modify the app to upload a csv file or an excel spreadsheet and analyze the column "text" for sentiment and emotion. Bonus: Let the user choose the column to be analyzed from a list of the available columns.
#' 5. Explore whether emotions with a high-score (say, > 0.8) are accurately detected. Technically, you can investigate the *sensitivity* and the *specificity* of detecting emotions as you vary the detection threshold.
#' 6. Investigate whether sentiment scores (or emotions scores) correlate strongly with other variables of interest, e.g., star rating.
#' 
#' ## Learn more
#' 
#' * A quick introduction to Docker: http://odewahn.github.io/docker-jumpstart/
#' * A simple guide for getting started with Git: http://rogerdudler.github.io/git-guide/
#' * Which language should you learn for data science: https://medium.freecodecamp.org/which-languages-should-you-learn-for-data-science-e806ba55a81f 
#' * Top natural language processing (NLP) APIs: https://friendlydata.io/blog/best-nlp-apis
