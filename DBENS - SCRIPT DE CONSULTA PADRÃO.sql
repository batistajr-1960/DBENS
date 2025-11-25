with Portaria
as
(Select p.id 
        , upper(nome)        portaria_nome
	    , upper(contenttype) portaria_contenttype
	    , upper(numero)      portaria_numero
	    , data               portaria_data
   from portaria p
)

SELECT d.id
       , periododeclaracao_id
	   , anoreferencia
	   , datainicial
	   , datafinal
	   , portaria_id
       , portaria_nome
	   , portaria_contenttype
	   , portaria_numero
	   , portaria_data	
       , pd.anoreferencia      portaria_anoreferencia
       , pd.datainicial        portaria_datainicial
       , pd.datafinal          portaria_datafinal	   
	   , datafinalizacao   
	   , matriculaservidor
	   , logindeclarante
	   , tipodeclaracao
	   , idantigo
	   , bdantigo
	   , servidor_id
	FROM public.declaracao d
   INNER JOIN public.periododeclaracao pd on pd.id = d.periododeclaracao_id
   inner join portaria po on po.id = pd.portaria_id
	





public.anexo : 31.800
public.declaracao : 35.330
