ler_dados_setic <<- function() {
  
  tempo_inicio <<- Sys.time()
  print("🔄 Iniciando leitura dos dados...")
 
  #_______________________________________________________________________________________________________________________________________________
  t1 <<- Sys.time()
  print("🔄 Iniciando leitura PROCESSOS FILTROS...")
  
  con <- dbConnect (drv =RPostgres::Postgres(),
                    dbname = "paineis",
                    host = "brett-rizvi.intrajus.tjrn",         # ou IP do servidor
                    port = 5432,                                # porta padrão
                    user = "dbgpsmed",
                    password = "fWtjum7GgWBe")
  
  processos <<- dbGetQuery(con, "SELECT cdprocesso
                                        , cdprocessomaster
	                                      , nuprocesso
	                                      , nuprocessomascarado
	                                      , declasse
	                                      , nomeparteativa
	                                      , nomepartepassiva
                                        , situacao_processo
                                        , segredo_justica
                                        , area_processo
                                        , deassunto	
                                        , cc_deassuntocomplementar
                                        , dt_local_fisico
                                        , de_local_fisico
                                        , decompllocal	
	                                      , de_tipo_distribuicao	
                                        , dt_distribuicao
                                        , nome_vara	
                                        , nome_foro
	                                      , nome_juiz
                                        , justica_gratuita
                                        , valor_causa
	                                      , migrado_pje 
	                                 FROM saj_pg_consulta_publica.saj_processos_filtro
                                  order by nuprocesso")
  t2 <<- Sys.time()
  print(paste("Tempo para Carregar a Tabela PROCESSOS FILTROS: ", round(difftime(t2, t1, units = "secs"), 2), "s "))
  #_______________________________________________________________________________________________________________________________________________
  
  t1 <<- Sys.time()
  print("🔄 Iniciando leitura da Tabela PARTES DOS PROCESSOS ...")  
  
  partes <<- dbGetQuery(con, "SELECT cdprocesso
                                     , cdprocessomaster
	                                   , nuprocesso
	                                   , nuprocessomascarado
	                                   , declasse
	                                   , partetipo
	                                   , partenome
	                                   , partenomeadv	                                   
	                                   , parteoab
	                                   , partepai
	                                   , partemae
	                              FROM saj_pg_consulta_publica.saj_partes
                               ORDER BY partenome")
  
  
  t2 <<- Sys.time()
  print(paste("Tempo para Carregar a Tabela PARTES DOS PROCESSOS: ", round(difftime(t2, t1, units = "secs"), 2), "s "))
  #_______________________________________________________________________________________________________________________________________________

  t1 <<- Sys.time()
  print("🔄 Iniciando leitura da Tabela ATUALIZAÇÃO DA BASE ...")  
  
  atualizacao_base <<- dbGetQuery(con, "SELECT ultima_atualizacao_completa
	                                             FROM saj_pg_consulta_publica.saj_atualizacao_base")
  
 
  t2 <<- Sys.time()
  print(paste("Tempo para Carregar a Tabela ATUALIZAÇÃO DA BASE: ", round(difftime(t2, t1, units = "secs"), 2), "s "))
  #_______________________________________________________________________________________________________________________________________________
  t1 <<- Sys.time()
  print("🔄 Iniciando leitura DELEGACIAS...")
  
  delegacias <<- dbGetQuery(con, "SELECT cdprocesso
                                        , nuprocesso
	                                      , nuprocessomascarado
	                                      , descricao_delegacia
	                                      , nudocdpform
	                                 FROM saj_pg_consulta_publica.saj_delegacias
                                  order by nuprocesso	")
  t2 <<- Sys.time()
  print(paste("Tempo para Carregar a Tabela DELEGACIAS: ", round(difftime(t2, t1, units = "secs"), 2), "s "))
  #_______________________________________________________________________________________________________________________________________________  
  t1 <<- Sys.time()
  print("🔄 Iniciando leitura OUTROS NÚMEROS...")
  outrosnumeros <<- dbGetQuery(con, "SELECT cdprocesso
                                             , nuprocesso
	                                           , nuprocessomascarado
	                                           , nuoutronumeroform
	                                      FROM saj_pg_consulta_publica.saj_outrosnumeros
                                       order by nuoutronumeroform	")
  t2 <<- Sys.time()
  print(paste("Tempo para Carregar a Tabela OUTROS NÚMEROS: ", round(difftime(t2, t1, units = "secs"), 2), "s "))
  #_______________________________________________________________________________________________________________________________________________  
  
  
  tempo_fim <<- Sys.time()
  print(paste("🎯 Tempo total:", round(difftime(tempo_fim, tempo_inicio, units = "secs"), 2), "segundos"))
   
  # Sempre lembrar dessa parte no final do script ao abrir a conexão
  dbDisconnect(con)


}


