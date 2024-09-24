create database Vendas
go

use Vendas
go

-- CRIANDO TABELA PESSOAS --------------------------------------------------------------------------------------------------------------------
create table Pessoas (
	idPessoas int not null primary key IDENTITY,
	nome varchar(200) not null,
	cpf varchar(14) not null unique,
	status int null
	check (status in(1,2,3))
)
go

select * from Pessoas
go

-- CRIANDO TABELA CLIENTES --------------------------------------------------------------------------------------------------------------------

create table Clientes (

	pessoaId int not null primary key,
	renda decimal(10,2) not null,
	credito decimal(10,2) not null,

	foreign key (pessoaId) references Pessoas(idPessoas),

	check (renda>=700.00),
	check (credito >= 100.00)
);
go

select * from Clientes
go

-- CRIANDO TABELA VENDEDORES --------------------------------------------------------------------------------------------------------------------

create table Vendedores (
	pessoaId int not null primary key,
	salario decimal(10,2) not null,

	foreign key (pessoaId) references Pessoas(idPessoas),

	check (salario >= 1000.00)
)
go

select * from Vendedores
go

-- CADASTROS --------------------------------------------------------------------------------------------------------------------

-- PESSOAS
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

-- CLIENTES
insert into Clientes(pessoaId, renda, credito)
values	(1, 1500.00, 750.00),
		(3, 2500.00, 750.00),
		(5, 5000.00, 1500.00),
		(7, 1700.00, 980.00),
		(9, 1872.00, 258.00)
go

-- VENDEDORES
insert into Vendedores (pessoaId, salario)
values	(2, 1500.00),
		(4, 2000.00),
		(8, 1000.00),
		(10, 5500.00)
go

-- EXIBINDO COM INNER JOIN --------------------------------------------------------------------------------------------------------------------

--EXIBIR APENAS PESSOAS QUE SÃO CLIENTES
select c.pessoaId Codigo, c.renda Renda_Cliente, p.nome Nome,
	case p.status
		when 1 then 'ATIVO'
		when 2 then 'INATIVO'
		when 3 then 'BLOQUEADO'
	else 'CANCELADO'
	end Situacao
from Pessoas p INNER JOIN Clientes c ON p.idPessoas = c.pessoaId 
go

--EXIBIR APENAS PESSOAS QUE SÃO VENDEDORES
select p.nome Nome, p.cpf CPF, v.salario Salario, p.status Situacao
from Pessoas p INNER JOIN Vendedores v ON p.idPessoas = v.pessoaId
go

--EXIBIR TODAS AS PESSOAS QUE NÃO SÃO VENDEDORES
select p.nome Nome, p.cpf CPF, v.salario Salario, p.status Situacao
from Pessoas p FULL OUTER JOIN Vendedores v ON p.idPessoas = v.pessoaId
go


-- CRIANDO A TABELA PEDIDOS --------------------------------------------------------------------------------------------------------------------

create table Pedidos (
	IdPedidos int not null primary key identity,
	data datetime not null,
	valor money null,
	status int null,
	vendedorId int not null,
	clienteId int not null,

	foreign key (vendedorId) references Pessoas(idPessoas),
	foreign key (clienteId) references Pessoas(idPessoas),

	check (status between 1 and 3)
)
go

select *from Pedidos
go

-- CRIANDO A TABELA PRODUTOS --------------------------------------------------------------------------------------------------------------------

create table Produtos (
	idProdutos int not null primary key identity,
	descricao varchar(200) not null,
	qtd int null,
	valor money null,
	status int null,

	check (qtd >= 0)
)
go

select * from Produtos
go

-- CRIANDO A TABELA ITENS PEDIDOS --------------------------------------------------------------------------------------------------------------------

create table Itens_Pedidos (
	pedidoId int not null,
	produtoId int not null,
	valor money null,
	qtd int null,

	primary key(pedidoId, produtoId),
	foreign key (pedidoId) references Pedidos(idPedidos),
	foreign key (produtoId) references Produtos(idProdutos)
)
go

select * from Itens_Pedidos
go

-- CADASTROS --------------------------------------------------------------------------------------------------------------------

insert into Pedidos(data, status, vendedorId, clienteId)
values	('2023-25-08', 1, 2, 1),
		(GETDATE(), 1, 4, 1),		
		(GETDATE(), 2, 6, 5),
		('2024-17-04', 1,8,7),
		('2023-04-10', 3,6,1)
go

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

-- CONSULTAS --------------------------------------------------------------------------------------------------------------------

-- CONSULTAR TODOS OS CLIENTES QUE FIZERAM PEDIDOS 

select	P.idPessoas Cod_Cliente, P.nome Cliente, P.cpf CPF_Cliente, P.status Situacao,
		C.renda Renda, Pe.idPedidos No_Pedido, Pe.data Data_Pedido, Pe.status Situacao_Pedido,
		Pe.vendedorId Cod_Vendedor,
		(
			select P.nome
			from Pessoas P, Vendedores V
			where P.idPessoas = V.pessoaId and V.pessoaId = Pe.vendedorId
		) Vendedor
from Pessoas P	INNER JOIN  Clientes C ON P.idPessoas = C.pessoaId
				INNER JOIN Pedidos Pe ON C.pessoaId = Pe.clienteId


select	pe.data Data, pe.valor,
		ip.qtd Quantidade,
		pr.descricao Nome, pr.idProdutos ID
from Pedidos pe		INNER JOIN Itens_Pedidos ip ON pe.IdPedidos = ip.pedidoId
					INNER JOIN Produtos pr ON ip.produtoId = pr.idProdutos


select	p.nome Nome, p.status Situacao,
		pr.descricao Produto, pr.qtd QTD,
		pe.data Data, pe.valor
from	Pessoas p	INNER JOIN Pedidos pe ON p.idPessoas = pe.clienteId
					INNER JOIN Produtos pr ON pr.idProdutos = pe.clienteId


-- CONSULTAS -----------------------------------------------

select * from Produtos
where valor between 2.00 and 15.00
go

select * from Pessoas
where nome LIKE 'ad%'
go

select * from Pessoas
where nome LIKE '%o'
go

select * from Produtos
where valor > 10.00
go

select * from Produtos
order by valor ASC
go

-- CRIANDO AS VIEWS

create view v_Clientes as

	select	p.nome Nome, p.cpf CPF, Clientes.renda
			
	case p.status
		when 1 then 'ATIVO'
		when 2 then 'INATIVO'
		when 3 then 'BLOQUEADO'
	else 'CANCELADO'
	end Situacao

	from Pessoas p LEFT JOIN Clientes c ON p.idPessoas = c.pessoaId
