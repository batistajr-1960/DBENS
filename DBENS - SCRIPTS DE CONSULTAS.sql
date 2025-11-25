
-- ANEXOS
SELECT id, declaracao_id, nome, contenttype, arquivo, tipoarquivo, declaradoem
	FROM public.anexo
	LIMIT 100

-- HISTÓRICO	
SELECT id, declaracao_id, tipo, data, logindeclarante
	FROM public.historicodeclaracao
	
-- BEM ... DECLARACAO_ID	
SELECT b.id
       , tipodobem_id
	   , upper(t.descricao) tipodobem_descricao
	   , pais_id
	   , upper(nome) pais_nome
	   , declaracao_id
	   , upper(b.descricao) descricao
	   , ultimaatualizacao
	   , valor
	   , servidorexclusao
	   , datahoraexclusao
	   , declaradoem
	FROM public.bem	b
INNER JOIN public.pais p on p.id = pais_id	
INNER JOIN public.tipobem T ON T.id = b.tipodobem_id

61.682


-- HISTÓRICO MODIFICAÇÕES - periododeclaracao_id
SELECT id, periododeclaracao_id, datamodificacao, login, anoreferencia, datainicial, datafinal
	FROM public.historicoperiododeclaracao

-- RETIFICACAO ... DECLARACAO_ID
SELECT id, declaracao_id, loginretificacao, numerodocumento, origemdocumento, dataliberacao
	FROM public.retificacao



	



SELECT id, dataativacao, datainativacao, logininclusao, servidorid
	FROM public.declaracaobyreceita 



/*
SELECT id, nome
	FROM public.pais;	

SELECT id, periododeclaracao_id, datafinalizacao, matriculaservidor, logindeclarante, tipodeclaracao, idantigo, bdantigo, servidor_id
	FROM public.declaracao


SELECT id, anoreferencia, datainicial, datafinal, portaria_id
	FROM public.periododeclaracao
	LIMIT 100

SELECT id, nome, contenttype, arquivo, numero, data
	FROM public.portaria;
*/	


	




	


	
	