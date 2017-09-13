
RSCRIPT=docker-git-nlp-indico

all:
	Rscript -e "knitr::spin('$(RSCRIPT).R', knit = FALSE)"
	Rscript -e "rmarkdown::render('$(RSCRIPT).Rmd')"

clean:
	@echo "Cleaning..."
	rm -f *.md *.html
