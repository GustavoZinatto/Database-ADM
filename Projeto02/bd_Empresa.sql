------------------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR BANCO DE DADOS

create database bd_Empresa
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- ACESSAR BANCO DE DADOS

use bd_Empresa
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR TABELA DEPARTAMENTO

create table Departamentos (
	IdDepartamento	int				not null	primary key		identity,
	nome			varchar(50)	not null
) 
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR TABELA FUNCION�RIOS

create table Funcionarios (
	IdFunc			int				not	null	primary key		identity,
	nome			varchar(200)	not null,
	cargo			varchar(200)		null,
	departamentoId	int
	-- Foreign Key
	foreign key(departamentoId) references Departamentos(IdDepartamento)
)
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- SELECTS DAS TABELAS

select * from Departamentos

select * from Funcionarios

------------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRAR PELO MENOS 5 DEPARTAMENTOS

insert into Departamentos
values	('Financeiro'),
		('Marketing'),
		('RH'),
		('Vendas'),
		('Compras')
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRAR FUNCION�RIOS E RELACIONANDO AOS DEPARTAMENTOS

-- Departamento 01:
insert into Funcionarios(nome, cargo, departamentoId)
values		('Valeria', 'Diretora', 1),
			('Jos� Antonio', 'Auxiliar Administrativo', 1)
go

-- Departamento 02:
insert into Funcionarios(nome, cargo, departamentoId)
values		('Ana Maria', 'Gerente', 2)
go

-- Departamento 04:
insert into Funcionarios(nome, departamentoId)
values		('Miguel Augusto', 4),
			('Pedro Augusto', 4),
			('Talles Augusto', 4)
go

-- Funcion�rios sem Departamento:
insert into Funcionarios(nome, cargo)
values		('Vanessa Cristina', 'Vendedora'),
			('Maria Rosa', 'Controladora'),
			('Danilo Volpe', 'Controlador')
go

------------------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS FUNCION�RIOS E OS DEPARTAMENTOS QUE ELES TRABALHAM

--INNER JOIN
select	f.IdFunc Cod_Cliente, F.nome Funcionario, F.cargo Cargo,
		D.IdDepartamento Cod_Departamento, D.nome Departamento
from	Departamentos D INNER JOIN Funcionarios F ON F.departamentoId = D.IdDepartamento
go

------------------------------------------------------------------------------------------------------------------------------------------------
--	CONSULTAR TODOS OS DEPARTAMENTOS QUE TEM OU N�O FUNCION�RIOS
--	SA�DA DEVE TRAZER OS DADOS DOS DEPARTAMENTOS E DOS FUNCION�RIOS RELACIONADOS. SE N�O TIVE FUNCION�RIO, TRAZER NULL

select	D.IdDepartamento Cod_Departamento, D.nome Departamento,
		F.IdFunc Cod_Funcionario, F.nome Funcionario, F.cargo Cargo
from	Departamentos D LEFT JOIN Funcionarios F ON D.IdDepartamento = F.departamentoId
go

------------------------------------------------------------------------------------------------------------------------------------------------
--	CONSULTAR TODOS OS FUNCION�RIOS QUE EST�O OU N�O EM DEPARTAMENTOS
--	SA�DA DEVE TRAZER TODOS OS FUNCION�RIO E SEUS DEPARTAMENTOS
--	SE N�O EXISTIR DEPARTAMENTO RELACIONADO, TRAZER NULL

select	D.IdDepartamento Cod_Departamento, D.nome Departamento,
		F.IdFunc Cod_Funcionario, F.nome Funcionario, F.cargo Cargo
from	Departamentos D RIGHT JOIN Funcionarios F ON D.IdDepartamento = F.departamentoId
go

------------------------------------------------------------------------------------------------------------------------------------------------
--	CONSULTAR TODOS OS DEPARTAMENTOS E FUNCION�RIOS

select	f.IdFunc Cod_Cliente, F.nome Funcionario, F.cargo Cargo,
		D.IdDepartamento Cod_Departamento, D.nome Departamento
from	Departamentos D FULL OUTER JOIN Funcionarios F ON d.IdDepartamento = F.departamentoId
go
