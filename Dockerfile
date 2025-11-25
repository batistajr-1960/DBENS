# Base R Shiny image
FROM docker.io/rocker/shiny:latest

# Make a directory in the container
#RUN mkdir /home/shiny-app

# Trocando localizacao e linguagem
# Set the locale
RUN sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG pt_BR.UTF-8  
ENV LANGUAGE pt_BR:pt  
ENV LC_ALL pt_BR.UTF-8  

ENV SHINY_SERVER_VERSION ""

RUN  apt-get -y install locales

# instalando libpq5
RUN apt-get update && apt-get install libpq5 -y

# Define o mirror CRAN oficial (p3m.posit.it) - forçando o uso do Repositorio
RUN echo 'options(repos = c(CRAN = "https://p3m.posit.it/cran/__linux__/noble/latest"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install R dependencies
RUN R -e "install.packages(c('shiny','bslib','writexl','zoo','tidyr','bizdays','stringr','shinyWidgets','lubridate', 'dplyr','plotly', 'DBI', 'RPostgres', 'jsonlite', 'readr','here', 'data.table' ,'DT','shinydashboard','reactable'))"

# Copy the Shiny app code
COPY . .

# Remove variaveis de ambiente do Desenvolvimento
RUN rm -f .Rprofile

# Expose the application port
EXPOSE 8080

# Run the R Shiny app
CMD Rscript App.R