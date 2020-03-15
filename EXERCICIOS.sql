/*
EXERCÍCIO 1 
Crie o banco de dados treino com as tabelas conforme diagrama.
*/
CREATE DATABASE TREINO
GO
USE TREINO

--CRIAR TABELAS
--CRIANDO TABELA CIDADE
--DROP TABLE CIDADE
CREATE TABLE CIDADE
(
	ID_CIDADE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CIDADE VARCHAR(60) NOT NULL,
	UF VARCHAR(2) NOT NULL
)

--CRIANDO TABELA CATEGORIA DE PRODUTOS
--DROP TABLE CATEGORIA
CREATE TABLE CATEGORIA
(
	ID_CATEGORIA INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CATEGORIA VARCHAR(20) NOT NULL
)

--CRIANDO A TABELA UNIDADE DE MEDIDAS
--DROP TABLE UNIDADE
CREATE TABLE UNIDADE
(
	ID_UNIDADE VARCHAR(3) NOT NULL PRIMARY KEY,
	DESC_UNIDADE VARCHAR(25) NOT NULL
)

--CRIANDO TABELA VENDEDORES
--DROP TABLE VENDEDORES
CREATE TABLE VENDEDORES
(
	ID_VENDEDOR INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_VENDED VARCHAR(60)NOT NULL,
	SALARIO DECIMAL(10,2) NOT NULL
)

--CRIANDO A TABELA CLIENTE
--DROP TABLE CLIENTE
CREATE TABLE CLIENTE
(
	ID_CLIENTE INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_CLIENTE VARCHAR(60)NOT NULL,
	ENDERECO VARCHAR(60) NOT NULL,
	NUMERO VARCHAR(10) NOT NULL,
	ID_CIDADE INT NOT NULL,
	CEP VARCHAR(9),
	CONSTRAINT FK_CLI1 FOREIGN KEY (ID_CIDADE) 
	REFERENCES CIDADE(ID_CIDADE)
)

--CRIAÇÃO DA TABELA VENDAS
--DROP TABLE VENDAS
CREATE TABLE VENDAS
(
	NUM_VENDA INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	DATA_VEN DATETIME NOT NULL,
	ID_CLIENTE INT NOT NULL,
	ID_VENDEDOR INT NOT NULL,
	STATUS CHAR(1) NOT NULL DEFAULT('N'), --N NORMAL | C CANCELADA
	CONSTRAINT FK_VENDAS1 FOREIGN KEY (ID_CLIENTE) 
	REFERENCES CLIENTE(ID_CLIENTE),
	CONSTRAINT FK_VENDAS2 FOREIGN KEY (ID_VENDEDOR) 
	REFERENCES VENDEDORES(ID_VENDEDOR)
)

--CRIANDO TABELA DE PRODUTOS
--DROP TABLE PRODUTOS
CREATE TABLE PRODUTOS
(
	ID_PROD INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	NOME_PROD VARCHAR(50) NOT NULL,
	ID_CATEGORIA INT NOT NULL,
	ID_UNIDADE VARCHAR(3) NOT NULL,
	PRECO DECIMAL(10,2),
	CONSTRAINT FK_PRODUTOS1 FOREIGN KEY (ID_CATEGORIA) 
	REFERENCES CATEGORIA(ID_CATEGORIA),
	CONSTRAINT FK_PRODUTOS2 FOREIGN KEY (ID_UNIDADE) 
	REFERENCES UNIDADE(ID_UNIDADE)
)

--CRIAÇÃO DA TABELA DETALHE VENDA ITEM
--DROP TABLE VENDA_ITENS
CREATE TABLE VENDA_ITENS
(
	NUM_VENDA INT NOT NULL,
	NUM_SEQ INT NOT NULL,
	ID_PROD INT NOT NULL,
	QTDE DECIMAL(10,2) NOT NULL,
	VAL_UNIT DECIMAL(10,2) NOT NULL,
	VAL_TOTAL DECIMAL(10,2),
	CONSTRAINT PK_VENDA_ITENS1 PRIMARY KEY (NUM_VENDA,NUM_SEQ),
	CONSTRAINT FK_VENDA_ITENS1 FOREIGN KEY (NUM_VENDA) 
	REFERENCES VENDAS(NUM_VENDA),
	CONSTRAINT FK_VENDA_ITENS2 FOREIGN KEY (ID_PROD) 
	REFERENCES PRODUTOS(ID_PROD)
)

/*
EXERCÍCIO 2 
Restaurar o arquivo  treino.bak no banco de dados criado.
*/

USE [master]
--DROP DATABASE
drop database treino
GO 
--RESTORE DATABASE
RESTORE DATABASE [treino] FROM  DISK = N'C:\TREINO.BAK' 
WITH  FILE = 1,  MOVE N'TREINO' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\treino.mdf',  
MOVE N'TREINO_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\treino_log.ldf',  NOUNLOAD,  
STATS = 5
 
GO

/*
EXERCÍCIO 3 
Liste todos os clientes com seus nomes e com suas respectivas cidade e estados
*/

SELECT 
	A.NOME_CLIENTE, 
	B.NOME_CIDADE, 
	B.UF 
FROM 
	CLIENTE A 
LEFT JOIN 
	CIDADE B
ON 
	A.ID_CIDADE = B.ID_CIDADE
  
/*
EXERCÍCIO 4 
Liste o código do produto, descrição do produto e descrição das categorias dos produtos que tenham o valor unitário na 
faixa de R$ 10,00 a R$ 1500
*/

SELECT 
	A.ID_PROD, 
	A.NOME_PRODUTO,
	B.NOME_CATEGORIA
FROM
	PRODUTOS A
LEFT JOIN 
	CATEGORIA B
ON
	A.ID_CATEGORIA = B.ID_CATEGORIA
WHERE
	A.PRECO BETWEEN 10 AND 1500
--	A.PRECO >= 10
--AND
--	A.PRECO <= 1500

/*
EXERCÍCIO 5 
Liste o código do produto, descrição do produto e descrição da categorias dos produtos, e também apresente uma coluna condicional  com o  nome de "faixa de preço" 
Com os seguintes critérios
•	preço< 500 : valor da coluna será  igual  "preço abaixo de 500"
•	preço  >= 500 e <=1000 valor da coluna será igual  "preço entre 500 e 1000"
•	preço  > 1000 : valor da coluna será igual  "preço acima de 1000".
*/

SELECT 
	A.ID_PROD,
	A.NOME_PRODUTO,
	B.NOME_CATEGORIA,
	CASE 
		WHEN A.PRECO < 500 THEN 'PREÇO ABAIXO DE 500'
		WHEN A.PRECO >= 500 AND A.PRECO <= 1000 THEN 'PREÇO ENTRE 500 E 1000'
		WHEN A.PRECO > 1000 THEN 'PREÇO ACIMA DE 1000' END 'FAIXA DE PREÇO'
FROM
	PRODUTOS A
LEFT JOIN
	CATEGORIA B
ON
	A.ID_CATEGORIA = B.ID_CATEGORIA

/*
EXERCÍCIO  6
Adicione a coluna faixa_salario na tabela vendedor tipo char(1)
*/

ALTER TABLE 
	VENDEDORES 
ADD 
	FAIXA_SALARIO char(1)

/*
EXERCÍCIO 7 
Atualize o valor do campo faixa_salario da tabela vendedor com um update condicional .
Com os seguintes critérios
•	salario <1000 ,atualizar faixa = c
•	salario >=1000  and <2000 , atualizar faixa = b
•	salario >=2000  , atualizar faixa = a

**VERIFIQUE SE OS VALORES FORAM ATUALIZADOS CORRETAMENTE
*/

UPDATE 
	VENDEDORES 
SET 
	FAIXA_SALARIO = 
		CASE 
			WHEN SALARIO < 1000 THEN 'C'
			WHEN SALARIO BETWEEN 1000 AND 2000 THEN 'B'
			WHEN SALARIO >= 2000 THEN 'A'END


/*
EXERCÍCIO 8
Listar em ordem alfabética os vendedores e seus respectivos salários, mais uma coluna, simulando aumento de 12% em seus salários.
*/

SELECT 
	NOME_VENDEDOR,
	SALARIO AS 'SALÁRIO ATUAL',
	SALARIO*1.12 AUMENTO
FROM
	VENDEDORES
ORDER BY 
	NOME_VENDEDOR
	

/*EXERCÍCIO 9
Listar os nome dos vendedores, salário atual , coluna calculada com salario novo + reajuste de 18% sobre o salário atual, calcular  a 
coluna acréscimo e calcula uma coluna salario novo+ acresc.
Critérios
Se o vendedor for  da faixa “C”, aplicar  R$ 120 de acréscimo , outras faixas de salario acréscimo igual a 0(Zero )
*/

DECLARE @ACRES DECIMAL(10,2)=120;
DECLARE @PCT_AUMENTO DECIMAL(10,2)=0.18

SELECT
	NOME_VENDEDOR,
	FAIXA_SALARIO,
	SALARIO AS SALARIO_ATUAL,
	SALARIO*(1+@PCT_AUMENTO) AS SALARIO_NOVO,
	CASE WHEN FAIXA_SALARIO = 'C' THEN @ACRES ELSE 0 END ACRESC,
	CASE WHEN FAIXA_SALARIO = 'C' THEN @ACRES+SALARIO*(1+@PCT_AUMENTO) ELSE SALARIO*(1+@PCT_AUMENTO) END SALARIO_NOVO_ACRES
FROM
	VENDEDORES
ORDER BY 4 DESC

/*
EXERCÍCIO 10
Listar o nome e salários do vendedor com menor salario.
*/

SELECT TOP 1
	NOME_VENDEDOR,
	SALARIO
FROM
	VENDEDORES
ORDER BY SALARIO ASC


/*
EXERCÍCIO 11
Quantos vendedores ganham acima de R$ 2.000,00 de salário fixo?
*/

SELECT COUNT(*) QTD FROM VENDEDORES WHERE SALARIO > 2000

/*
EXERCÍCIO 12
Adicione o campo valor_total tipo decimal(10,2) na tabela venda.
*/

ALTER TABLE VENDAS ADD VALOR_TOTAL DECIMAL(10,2)

/*
EXERCÍCIO 13
Atualize o campo valor_tota da tabela venda, com a soma dos produtos das respectivas vendas.
*/

UPDATE VENDAS SET VALOR_TOTAL = (SELECT SUM(VAL_TOTAL) FROM VENDA_ITENS A WHERE VENDAS.NUM_VENDA=A.NUM_VENDA)

/*
EXERCÍCIO 14
Realize a conferencia do exercício anterior, certifique-se que o valor  total de cada venda e igual ao valor total da soma dos  produtos da venda, listar as vendas em que ocorrer diferença.
*/

SELECT 
	A.NUM_VENDA, 
	A.VALOR_TOTAL, 
	SUM(B.VAL_TOTAL)TOTAL_ITENS
FROM 
	VENDAS A
INNER JOIN
	VENDA_ITENS B
ON 
	A.NUM_VENDA=B.NUM_VENDA
GROUP BY
	A.NUM_VENDA, A.VALOR_TOTAL
HAVING
	A.VALOR_TOTAL<>SUM(B.VAL_TOTAL)



/*
EXERCÍCIO 15
Listar o número de produtos existentes, valor total , média do valor unitário referente ao mês 07/2018 agrupado por venda.
*/

SELECT
	A.NUM_VENDA,
	
	COUNT(B.NUM_SEQ) QTD_SKU,
	SUM(B.QTDE) QTDE,
	AVG(B.VAL_UNIT) MEDIA_UNIT,
	A.VALOR_TOTAL
FROM VENDAS A
INNER JOIN VENDA_ITENS B
ON A.NUM_VENDA=B.NUM_VENDA
WHERE MONTH(A.DATA_VENDA)=7
AND YEAR(A.DATA_VENDA)=2018
AND	STATUS = 'N'
GROUP BY A.NUM_VENDA, A.VALOR_TOTAL

/*
EXERCÍCIO 16
Listar o número de vendas, Valor do ticket médio, menor ticket e maior ticket referente ao mês 07/2017.
*/

SELECT
	COUNT(NUM_VENDA) 'NÚMERO DE VENDAS',	
	AVG(VALOR_TOTAL) 'TICKET MÉDIO',
	MIN(VALOR_TOTAL) 'MENOR TICKET',
	MAX(VALOR_TOTAL) 'MAIOR TICKET',
	SUM(VALOR_TOTAL) 'VALOR TOTAL'
FROM
	VENDAS
WHERE 
	MONTH(DATA_VENDA) = 7
	AND
	YEAR(DATA_VENDA) = 2017
	AND
	STATUS = 'N'

/*
EXERCÍCIO 17
Atualize o status das notas abaixo de normal(N) para cancelada (C)
--15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714

*/

UPDATE VENDAS SET STATUS='C' WHERE NUM_VENDA IN (15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714)

/*
EXERCÍCIO 18
Quais clientes realizaram mais de 70 compras?
*/

SELECT 
	A.NOME_CLIENTE,
	COUNT(B.NUM_VENDA) QTD
FROM
	CLIENTE A
INNER JOIN 
	VENDAS B
ON 
	A.ID_CLIENTE=B.ID_CLIENTE
WHERE 
	B.STATUS='N'
GROUP BY 
	A.NOME_CLIENTE
HAVING
	COUNT(B.NUM_VENDA)>70
ORDER BY 2 DESC

/*
EXERCÍCIO 19
Listar os produtos que estão incluídos em vendas que a quantidade total de produtos seja superior a 100 unidades.
*/

WITH T1 AS
(
SELECT
	A.NUM_VENDA,
	SUM(B.QTDE) AS QTD
FROM 
	VENDAS A
INNER JOIN 
	VENDA_ITENS B
ON 
	A.NUM_VENDA = B.NUM_VENDA
WHERE 
	A.STATUS = 'N'
GROUP BY A.NUM_VENDA
HAVING SUM(B.QTDE)>100
)

SELECT
	A.NUM_VENDA,
	B.ID_PROD,
	C.NOME_PRODUTO,
	B.QTDE
FROM 
	T1 A
INNER JOIN 
	VENDA_ITENS B
ON 
	A.NUM_VENDA = B.NUM_VENDA
INNER JOIN
	PRODUTOS C
ON
	B.ID_PROD = C.ID_PROD
/*
EXERCÍCIO 20
Trazer total de vendas do ano 2017 por categoria e apresentar total geral
*/

SELECT
	ISNULL(D.NOME_CATEGORIA,'TOTAL GERAL') AS CATEGORIA,
	SUM(A.VALOR_TOTAL) VAL_TOTAL
FROM
	VENDAS A
INNER JOIN 
	VENDA_ITENS B
ON
	A.NUM_VENDA = B.NUM_VENDA
INNER JOIN 
	PRODUTOS C
ON
	B.ID_PROD = C.ID_PROD
INNER JOIN
	CATEGORIA D
ON 
	C.ID_CATEGORIA = D.ID_CATEGORIA
WHERE
	YEAR(A.DATA_VENDA)=2017
GROUP BY ROLLUP (D.NOME_CATEGORIA)

/*
EXERCÍCIO 21
Listar total de vendas do ano 2017 por categoria e mês a mês apresentar subtotal dos meses e total geral ano.
*/

/*
EXERCÍCIO 22
Listar total de vendas por vendedores referente ao ano 2017, mês a mês apresentar subtotal do mês e total geral.
*/

/*
EXERCÍCIO 23
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias
*/

/*
EXERCÍCIO 24
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias, calcular seu percentual de participação com relação ao total geral.
*/

/*
EXERCÍCIO 25
Listar apenas o produto mais vendido de cada Mês com seu  valor total referente ao ano de 2017.
*/

/*
EXERCÍCIO 26
Lista o cliente e a data da última compra de cada cliente.
*/

/*
EXERCÍCIO 27
Lista o a data da última venda de cada produto.
*/
