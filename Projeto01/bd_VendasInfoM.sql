------------------------------------------------------------------------------------------------------------------------------------------------
--Criando Banco de dados

create database VendasInfoM;
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
--Acessar o Banco de Dados
use VendasInfoM
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
--Criar tabela Pessoas

create table Pessoas (
	idPessoa int not null primary key identity,
	nome varchar(50) not null,
	cpf varchar(14) not null unique,
	status int null,
	--restrições Status 1 = Ativo | 2 = Inativo | 3 = Cancelado
	check (status in(1,2,3))
)
go
------------------------------------------------------------------------------------------------------------------------------------------------

--Consultar informações sobre a Tabela
exec sp_help Pessoas
go

------------------------------------------------------------------------------------------------------------------------------------------------
--CRIAR TABELA CLIENTES

create table Clientes (
	pessoaId	int				not null	primary key,
	renda		decimal(10,2)	not null,
	credito		decimal(10,2)	not null,
	--chave estrangeira FK
	foreign	key(pessoaId)	references Pessoas(idPessoa),
	--restrições
	check(renda>=700.00),
	check(credito >= 100.00)
)
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
--CRIAR TABELA VENDEDORES

create table Vendedores (
	pessoaId	int			not null	primary key,
	salario		decimal		not null	check(salario >= 1000.00),
	--chave estrangeira FK
	foreign	key(pessoaId)	references Pessoas(idPessoa)
)
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- Cadastrar 10 Pessoas - INSERT NA TABELA PESSOAS

insert into Pessoas (nome, cpf, status)
values	('Valéria Maria Volpe', '111.111.111-11', 1),
		('Mário Henrique Pardo', '222.222.222-22', null),
		('Waldir Barros', '333.333.333-33', 2),
		('Lucimar Sasso Vieira', '444.444.444-44', 3),
		('Maura Frigo', '555.555.555-55', 1),
		('Lucimeire Schinelo', '666.666.666-66', 2),
		('Adriano Simonato', '777.777.777-77', 1),
		('Adriana Generoso', '888.888.888-88', 1),
		('Claudia Hidalgo', '999.999.999-99', 2),
		('Luciene Cavalcanti', '101.010.101-01', 3)
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- Cadastrar 5 Clientes - INSERT NA TABELA CLIENTES

insert into Clientes(pessoaId, renda, credito)
values	(1, 1500.00, 750.00),
		(3, 2500.00, 750.00),
		(5, 5000.00, 1500.00),
		(7, 1700.00, 980.00),
		(9, 1872.00, 258.00)
go

------------------------------------------------------------------------------------------------------------------------------------------------

select * from Pessoas
go

select * from Clientes
go

select * from Vendedores
go

select * from Pedidos
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODAS AS PESSOAS QUE SÃO CLIENTES

--SELECT MOSTRANDO A INTERSECÇÃO (traz tudo que é comum; Intersecção)
select	Pessoas.idPessoa Cod_Cliente, Pessoas.nome Cliente, Pessoas.cpf CPF_Cliente, Pessoas.status Situacao, Clientes.renda Renda_Cliente,
		Clientes.credito Credito_Cliente
from	Pessoas, Clientes
where	Pessoas.idPessoa = Clientes.pessoaId

--usando o INNER JOIN
select	Pessoas.idPessoa Cod_Cliente, Pessoas.nome Cliente, Pessoas.cpf CPF_Cliente, Pessoas.status Situacao, Clientes.renda Renda_Cliente,
		Clientes.credito Credito_Cliente
from Pessoas INNER JOIN Clientes ON Pessoas.idPessoa = Clientes.pessoaId
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRAR 5 VENDEDORES - INSERT NA TABELA VENDEDORES

insert into Vendedores (pessoaId, salario)
values	(2, 1500.00),
		(4, 2000.00),
		(8, 1000.00),
		(10, 5500.00)
go

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTE TODAS AS PESSOAS QUE SÃO VENDEDORES

--Select Mostrando a Intersecção
select	p.idPessoa Cod_Vendedor, p.nome Vendedor, p.cpf CPF_Vendedor, p.status Situacao, v.salario Salario_Vendedor
from	Pessoas p, Vendedores as v
where	p.idPessoa = v.pessoaId

--Select Inner 
select p.idPessoa Cod_Vendedor, p.nome Vendedir, p.cpf CPF_Vendedor, p.status Situacao, v.salario Salario_Vendedor
from Pessoas p INNER JOIN Vendedores v On p.idPessoa = v.pessoaId

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR TABELA PEDIDOS 

create table Pedidos (
idPedidos	int			not null	primary key		identity,
data		datetime	not null,
valor		money			null,
status		int				null,
vendedorId	int			not null,
clienteId	int			not null,
--chave estrangeira FK
foreign key(vendedorId)	references Pessoas(idPessoa),
foreign key(clienteId)	references Pessoas(idPessoa),
--restrições Status 1 = Ativo | 2 = Inativo | 3 = Cancelado
check (status between 1 and 3)
)
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRAR 5 PEDIDOS - INSERT NA TABELA PEDIDOS

insert into Pedidos(data, status, vendedorId, clienteId)
values	('2023-25-08', 1, 2, 1),
		(GETDATE(), 1, 4, 1),		
		(GETDATE(), 2, 6, 5),
		('2024-17-04', 1,8,7),
		('2023-04-10', 3,6,1)
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS CLIENTES QUE FIZERAM PEDIDOS 

select	p.idPessoa Cod_Cliente, p.nome Cliente, p.cpf CPF_Cliente, p.status Situacao, c.renda Renda_Cliente,
		c.credito Credito_Cliente,
		pe.idPedidos No_pedido, pe.data Data_Pedido, pe.status Situacao_Pedido, pe.vendedorId Cod_Vendedor,
		(
			select Pessoas.nome
			from Pessoas, Vendedores
			where Pessoas.idPessoa = Vendedores.pessoaId
			and Vendedores.pessoaId = pe.vendedorId
		) Vendedor

from Pessoas p, Clientes c, Pedidos pe
where p.idPessoa = c.pessoaId and c.pessoaId = pe.clienteId
go

--Usando Inner Join

select	P.idPessoa Cod_Cliente, P.nome Cliente, P.cpf CPF_Cliente, P.status Situacao,
		C.renda Renda, Pe.idPedidos No_Pedido, Pe.data Data_Pedido, Pe.status Situacao_Pedido,
		Pe.vendedorId Cod_Vendedor,
		(
			select P.nome
			from Pessoas P, Vendedores V
			where P.idPessoa = V.pessoaId and V.pessoaId = Pe.vendedorId
		) Vendedor
from Pessoas P	INNER JOIN  Clientes C ON P.idPessoa = C.pessoaId
				INNER JOIN Pedidos Pe ON C.pessoaId = Pe.clienteId
------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------
-- CRIANDO A TABELA DE PRODUTOS

create table Produtos
(
	idProduto	int				not null	primary key		identity,
	descricao	varchar(100)	not null,
	qtd			int					null,
	valor		money				null,
	status		int					null,
	--restrições
	check(qtd	>= 0),
	check(status=1 or status = 2)
)
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRAR 15 PRODUTOS

insert into Produtos (descricao, qtd, valor, status)
values	('Coxinha de Frango', 100, 5.50, 1),
		('Bolo de Chocolate', 50, 20.50, 1),
		('Coca Cola 350ml', 250, 4.50, 2),
		('Coca Cola 1L', 20, 8.90, 1),
		('Sorvete de Chocolate', 55, 9.90, 1),
		('Pastel de carne', 21, 8.90, 1),
		('Pastel de Frango', 250, 5.00, 1),
		('Pastel de Camarão', 250, 10.00, 1),
		('Pastel de Milho', 100, 10.00, 1),
		('Pastel de Brócolis', 250, 10.00, 1),
		('Pastel de Palmito', 300, 7.50, 1),
		('Pastel de Camarão', 280, 12.00, 1),
		('Pastel de Nutella', 90, 18.00, 1),
		('Pastel de Pizza', 250, 10.00, 1),
		('Pastel de Vento', 250, 5.00, 1)
go

select * from Produtos

------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR TABELA Itens_Pedidos

create table Itens_Pedidos (
	
	pedidoId		int		not null,	
	produtoId		int		not null,
	qtd				int			null,	check(qtd > 0),
	valor			money		null	check(valor > 0),
	--chave primária composta (relação N x N)
	primary key(pedidoId, produtoId),
	--chave estrangeira
	foreign key(pedidoId)	references Pedidos(idPedidos),
	foreign key(produtoId)	references Produtos(idProduto)
)
go

select * from Itens_Pedidos

------------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRAR OS ITENS DO PEDIDO

--Pedido 01
insert into Itens_Pedidos(pedidoId, produtoId, qtd, valor)
values	(1, 1, 5, 5.50),
		(1, 4, 1, 8.90)
go

--Pedido 02
insert into Itens_Pedidos(pedidoId, produtoId, qtd, valor)
values	(2, 9, 2, 10.00),
		(2, 12, 2, 12.00),
		(2, 5, 2, 9.90)
go

--Pedido 03
insert into Itens_Pedidos(pedidoId, produtoId, qtd, valor)
values	(3, 15, 2, 5.00)
go

--Pedido 04
insert into Itens_Pedidos(pedidoId, produtoId, qtd, valor)
values	(4, 2, 1, 20.50),
		(4, 3, 2, 4.50),
		(4, 11, 1, 7.50 ),
		(4, 6, 1, 8.90),
		(4, 1, 2, 5.50)
go

--Pedido 05
insert into Itens_Pedidos(pedidoId, produtoId, qtd, valor)
values	(5, 15, 2, 5.00),
		(5, 6, 6, 8.90)
go


select * from Itens_Pedidos
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR CADA ITEM DE CADA PEDIDO

--where
select	Pedidos.idPedidos No_Pedido, Pedidos.data Data_Pedido, 
		Produtos.idProduto Cod_Produto, Produtos.descricao Produto,
		Itens_Pedidos.qtd Qtd_Vendida, Itens_Pedidos.valor Valor_Pago
from	Pedidos, Itens_Pedidos,Produtos
where	Pedidos.idPedidos = Itens_Pedidos.pedidoId and 
Itens_Pedidos.produtoId = Produtos.idProduto
go

--INNER JOIN
select	Pedidos.idPedidos No_Pedido, Pedidos.data Data_Pedido, 
		Produtos.idProduto Cod_Produto, Produtos.descricao Produto,
		Itens_Pedidos.qtd Qtd_Vendida, Itens_Pedidos.valor Valor_Pago
from Pedidos	INNER JOIN Itens_Pedidos ON Pedidos.idPedidos = Itens_Pedidos.pedidoId
				INNER JOIN Produtos	ON Itens_Pedidos.produtoId = Produtos.idProduto
go

-- TESTE PARA APRENDER --------------------------------------------------------------------------------

select Pedidos.idPedidos No_Pedido, Produtos.descricao Nome_Produto
from Pedidos INNER JOIN Produtos ON Pedidos.idPedidos = Produtos.idProduto
go


select	Pedidos.idPedidos no_Pedidos, Itens_Pedidos.valor Valor,  Produtos.descricao Nome
from	Pedidos		INNER JOIN	Itens_Pedidos ON Pedidos.idPedidos = Itens_Pedidos.pedidoId
					INNER JOIN Produtos ON Itens_Pedidos.produtoId = Pedidos.idPedidos
go
------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS DADOS DOS PRODUTOS COM VALOR ENTRE 5.00 A 10.00

--between
select * from Produtos
where valor between 5.00 and 10.00
go

--usando operador relacional
select * from Produtos
where valor >= 5.00 and  valor <= 10.00
go


------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS DADOS DOS PRODUTOS COM VALORES QUE NÃO ESTÃO ENTRE 5.00 A 10.00

--between
select * from Produtos
where valor not between 5.00 and 10.00
go

--usando operador relacional
select * from Produtos
where valor < 5.00 or valor > 10.00
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS DADOS DO CLIENTE COM NOME COM SILABA "NA"

select P.idPessoa Cod_CLiente, P.nome Cliente, C.Renda Renda_Cliente
from Pessoas P, Clientes C
where P.idPessoa = C.pessoaId and nome like '%o'
go
-- % a direita = nomes que terminam com 'o'

select * from Pessoas
where nome LIKE 'ad%'
go
-- % a esquerda = nomes que começam com 'ad'

select * from Pessoas 
where nome LIKE '%ma%'
go
-- 'ma' entre % buscam pessoas que possuem a silaba por entre o nome

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS DADOS DAS PESSOAS COM NOME A SEGUNDA LETRA U E A QUARTA LETRA C"

select * from Pessoas
where nome LIKE '_u_i%'
go

-- o _ significa a posição da letra

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS DADOS DAS PESSOAS QUE O NOME NÃO TERMINA COM A LETRA C

select * from Pessoas
where nome NOT LIKE '%o'
go

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR OS DADOS DOS PEDIDOS COM STATUS 2 OU 3

--IN
select * from Pedidos
where status IN (2,3)
go

-- OPERADOR RELACIONAL
select * from Pedidos
where status = 2 OR status = 3
go
------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR OS DADOS DOS PEDIDOS COM STATUS DIFERENTE DE 2 OU 3

--NOT IN
select * from Pedidos
where status NOT IN (2,3)
go

-- OPERADOR RELACIONAL
select * from Pedidos
where status != 2 AND status != 3
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR OS DADOS DAS PESSOAS COM STATUS NULL

--teste com *
select * from Pessoas
where status = NULL
go

-- IS NULL
select * from Pessoas
where status IS NULL
go

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR OS DADOS DAS PESSOAS QUE O STATUS NÃO É NULL

-- IS NOT NULL
select * from Pessoas
where status IS NOT NULL
go

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS DADOS DAS PESSOAS E MOSTRAR ORDENADO PELO NOME EM ORDEM ALFABÉTICA ASCENDENTE / DESCENDENTE

-- ASC: ASCENDENTE
select * from Pessoas
order by nome ASC
go

select * from Produtos
order by valor ASC
go

--DESC: DESCENDENTE
select * from Pessoas
order by nome DESC
go

select * from Produtos
order by valor DESC
go

------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS DADOS DOS PRODUTOS QUE TENHAM CHOCOLATE NA DESCRIÇÃO COM VALOR ENTRE 2.00 RS 26.00 ORDENADOS DO MAIS CARO PARA MAIS BARATO

select * from Produtos
where	descricao LIKE '%chocolate%' and
		valor between 2.00 and 26.00
order by valor DESC
go

select valor from Pedidos
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR OS VALORES DOS PRODUTOS

-- DISTINCT PARA TIRAR OS VALORES REPETIDOS
select DISTINCT valor from Produtos
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR O PRODUTO MAIS CARO, MAIS BARATO, O CALOR MÉDIO, O VALOR TOTAL DO ESTOQUE E QUANTIDADE DE ITENS NO ESTOQUE
select	max(valor) Produto_Caro, min(valor) Produto_Barato,
		AVG(valor) Valor_Medio, sum(valor * qtd) Valor_Total,
		COUNT(*) Total_Itens
from Produtos
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODAS AS PESSOAS E VENDEDORES

select	P.idPessoa, P.nome, P.cpf, p.status,
		V.Salario
from	Pessoas P LEFT JOIN Vendedores as V ON P.idPessoa = V.pessoaId
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODAS AS PESSOAS QUE FIZERAM OU NÃO PEDIDOS 
select	P.idPessoa, P.nome, P.cpf, p.status,
		Pe.idPedidos, Pe.data, Pe.valor, Pe.Status
from	Pessoas P LEFT JOIN Pedidos Pe ON P.idPessoa = Pe.clienteId
go


------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS PRODUTOS QUE ESTÃO OU NÃO EM PEDIDOS
-- CONSULTAR TODAS OS PRODUTOS QUE FORAM OU NÃO VENDIDOS

select	IP.produtoId, IP.qtd, IP.valor, IP.pedidoId,
		Pr.IdProduto, Pr.descricao, Pr.valor, Pr.status
from	Itens_Pedidos as IP		RIGHT JOIN	Produtos as Pr	ON	IP.produtoId = Pr.idProduto
go

--DOIS RIGHT JOIN
--???

--TESTES PARA VER SE EU APRENDI (APRENDI!)

select	Pessoas.nome Nome, Pessoas.cpf CPF, Pessoas.status Status_PEssoa,
		Produtos.descricao, Produtos.valor
from	Pessoas LEFT JOIN Produtos ON Pessoas.idPessoa = Produtos.idProduto
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR A QUANTIDADE DE PEDIDOS FEITOS POR CLIENTES

select	P.idPessoa Cod_Cliente, P.nome Cliente, count(*) Qtd_Pedidos, sum(Pe.valor) Total_Gasto
from	Pessoas P, Clientes C, Pedidos Pe
where	P.idPessoa = C.pessoaId and C.pessoaId = Pe.clienteId
group by P.idPessoa, P.nome
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR PESSOAS E VENDEDORES

select	P.*, V.*
from	Pessoas as P full outer join Vendedores V
on	P.idPessoa = V.pessoaId
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- 