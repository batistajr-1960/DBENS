
# Função para instalar e carregar pacotes
usar_pacote <- function(pacote) {
  if (!require(pacote, character.only = TRUE)) {
    install.packages(pacote)
    library(pacote, character.only = TRUE)
  } else {
    library(pacote, character.only = TRUE)
  }
}


# Pacotes necessários
pacotes <- c(
  "DBI", "RPostgres", "bizdays", "stringr", "lubridate", "dplyr", "readr", "tidyr",
  "bslib", "plotly", "DT", "reactable", "shiny", "shinydashboard", "shinyWidgets", "here", "writexl",
  "shinyjs","shinycssloaders"
)

lapply(pacotes, usar_pacote)

# Fontes de dados e módulos
source("filtros/ui.R")
source("filtros/server.R")
source("processos/ui.R")
source("processos/server.R")
source("ler_dados_setic.R")



Sys.setlocale("LC_TIME", "pt_BR.UTF-8")

# ReactiveValues global
dados_reativos <- reactiveValues()
processo_selecionado <- reactiveVal(NULL)


ui <- fluidPage(
  
  div(
    id = "loading_overlay",
    style = "
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background-color: white;
    z-index: 9999;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
  ",
    
    div(
      style = "text-align: center;",
      tags$img(src = "tjrn_logo_shiny.png", height = "100px"),
      br(),
      tags$h3("⏳ Carregando os dados, por favor aguarde..."),
      tags$p("Este processo pode levar pouco mais de 2 minutos.")
    ),
    
    # Barra de progresso visual (estática com animação CSS)
    tags$div(
      style = "
      margin-top: 30px;
      width: 60%;
      background-color: #ddd;
      border-radius: 10px;
      overflow: hidden;
      height: 20px;",
      tags$div(
        id = "progress-bar",
        style = "
        height: 100%;
        width: 0%;
        background-color: #14697F;
        animation: progressAnim 150s linear forwards;"
      )
    ),
    
    # Estilo da animação da barra de progresso
    tags$style(HTML("
    @keyframes progressAnim {
      from { width: 0%; }
      to   { width: 100%; }
    }
  "))
  ),
  
  
  tags$link(rel = "stylesheet", type = "text/css",
            href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"),
  shiny::includeCSS(here::here("styles.css")),
  useShinyjs(),
  
  tags$div(
    id = "tjrn-container",
    imageOutput('logo',inline = TRUE),
    tags$a(id = "tjrn", href = "https://tjrn.jus.br/", "TJRN.jus.br"),
    tags$p(class = "tjrn-text", "Tribunal de Justiça do Estado do Rio Grande do Norte"),    
  ),
  
  fluidRow(
    class = "nome-tela",
    div(
      class = "titulo-painel",
      style = "display: flex;  align-items: center; width: 100%;",  
      textOutput("data_atualizacao_ui", container = function(...) tags$p(class = "titulo_atualizacao", ...)),
      tags$p(class = "titulo_completo", "SAJ 1º GRAU - CONSULTA PÚBLICA"),     
      tags$p(class = "titulo_versao", "V.20250806 1700")
    )
  ),
  
  fluidRow(tags$div(class = "header-line", hr(class = "barra_cabecario"))),
  
  navbarPage(
    title = "SAJCon",  
    id = "tabs",
    header = tags$head(
      tags$style(HTML("
        .conteudo-margin-esquerda { margin-left: 10px; }
        .navbar-nav {
          float: none !important;
          margin: 0 AUTO  !important;
          display: table;
          table-layout: fixed;
        }
        
        .navbar-collapse {
          display: flex !important;
          justify-content: center !important;
        }
        
        /* Cor da fonte dos títulos das abas */
        .navbar-nav > li > a {
          color: #14697F !important;
          font-weight: bold;
        }
        
        /* Cor da aba ativa */
        .navbar-nav > .active > a, 
        .navbar-nav > .active > a:focus, 
        .navbar-nav > .active > a:hover {
          color: red !important;
        }
        

      "))
    ),    
    
    tabPanel("Visão Geral",  div(class = "centraliza-tab", filtros_UI("filtros"))),
    tabPanel("Processos",     div(class = "centraliza-tab", processos_UI("processos"))),    

  )
  
)

# Lógica do servidor
server <- function(input, output, session) {

  shinyjs::delay(100, {
    ler_dados_setic()
    
    dados_reativos$processos        <- processos
    dados_reativos$partes           <- partes
    dados_reativos$delegacias       <- delegacias
    dados_reativos$outrosnumeros    <- outrosnumeros
    dados_reativos$atualizacao_base <- atualizacao_base
    
    
    filtros_Server("filtros", processo_click = processo_selecionado, dados_reativos = dados_reativos)
    processos_Server("processos", processo_click = processo_selecionado, dados_reativos = dados_reativos)
    
    output$data_atualizacao_ui <- renderText({
      req(dados_reativos$atualizacao_base)  # Garante que o valor existe
      paste("", dados_reativos$atualizacao_base)
    }) 
    
    observeEvent(input$tabs, {
      if (input$tabs == "Processos" && is.null(processo_selecionado())) {
        updateTabsetPanel(session, "tabs", selected = "Visão Geral")
      }
      
    })      
    
    
    shinyjs::hide("loading_overlay")
    showNotification("✅ Dados atualizados com sucesso!", type = "message", duration = 4)
  })
  




  output$logo <- renderImage({
    list(src    = "tjrn_logo_shiny.png",
         alt    = "This is alternate text"
    )
  }, deleteFile = FALSE)
  
    
 
   
}


options(shiny.host = "0.0.0.0")
options(shiny.port = 8080)

shinyApp(ui = ui, server = server)
