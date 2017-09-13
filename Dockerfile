FROM rocker/shiny:latest

LABEL maintainer="Desislava Petkova desislavka@gmail.com"
LABEL description="Shiny app for sentiment & emotion analysis using Indico API"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libssl-dev \
    libfftw3-dev \
    libjpeg-dev \
    libtiff-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds  

RUN install2.r --error \
    --repos "http://cran.rstudio.com" \
    abind \
    devtools \
    dplyr \
    fftwtools \
    jpeg \
    locfit \
    png \
    purrr \
    readr \
    tiff \
    DT \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN install2.r --error \
    -r "http://www.bioconductor.org/packages/release/bioc" \
    BiocInstaller \
    BiocGenerics \
    EBImage \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN Rscript -e "devtools::install_github('IndicoDataSolutions/IndicoIo-R')" \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

COPY ./shiny /srv/shiny-server/myapp
