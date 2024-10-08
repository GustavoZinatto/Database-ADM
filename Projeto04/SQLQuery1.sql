
-- CRIAR BANCO DE DADOS ---------------------------------------------------------------------------------

create database Construtora
go

-- ACESSAR BANCO DE DADOS ---------------------------------------------------------------------------------

use Construtora
go

-- CRIAR TABELA FUNCIONÁRIOS ---------------------------------------------------------------------------------

create table Funcionarios (
	idFunc int not null primary key identity,
	nomeFunc varchar(50) not null,
	cpf varchar(14) not null unique,
	dataNasc date null,
	status int null check(status in (1,2))
)
go

select * from Funcionarios
go

-- CRIAR TABELA DEPENDENTES ---------------------------------------------------------------------------------
create table Dependentes (
	idDep int not null identity,
	nomeDep varchar(50) not null,
	idade int null,
	parentesco varchar(15) not null,
	funcId int not null,
	--chave primária composta - entidade fraca
	primary  key(funcId, idDep),
	--chave estrangeira
	foreign key(funcId) references Funcionarios(idFunc)
)
go

select * from Dependentes
go

-- CRIAR TABELA DEPARTAMENTOS ---------------------------------------------------------------------------------

create table Departamentos (
	idDepto int not null primary key identity,
	nomeDepto varchar(30) not null,
	local varchar(30) not null,
	telefone varchar(15) not null unique,
)
go

select * from Departamentos
go

-- CRIAR TABELA ENGENHEIROS ---------------------------------------------------------------------------------

create table Engenheiros (
	funcId int not null primary key,
	especialidade varchar(20) not null,
	anoExp int not null,
	classificacao varchar(20) not null,
	deptoId int not null,
	--chave estrangeiras
	foreign key(funcId) references Funcionarios(idFunc),
	foreign key(funcId) references Departamentos(idDepto)
)
go

select * from Engenheiros
go

-- CRIAR BANCO DE DADOS ---------------------------------------------------------------------------------

create table Tecnicos (
	funcId int not null primary key,
	valorHora decimal(10,2) not null check(valorHora > 0.0),
	salario decimal (10,2) null check(salario > 0.0),
	--chave estrangeira
	foreign key(funcId) references Funcionarios(idFunc)
)
go

select * from Tecnicos
go

-- CRIAR TABLELA PROJETOS ---------------------------------------------------------------------------------

create table Projetos (
	idProj int not null primary key identity,
	nomeProj varchar(25) not null,
	local varchar(30) not null,
	orcamento money not null check(orcamento > 0.0),
	--chave estrangeira
	deptoId int not null references Departamentos(idDepto),
)
go

select * from Projetos
go

-- CRIAR TABELA DE TÉCNICO EXECUTAM PROJETOS  ---------------------------------------------------------------------------------

create table Tec_executa_Projeto (
	tecId int not null,
	projId int not null, 
	qtdHoras int not null,
	dataInicio date not null,
	dataFim date null
	--chave primária composta - relação N x N
	primary key (tecId, projId)
	--chave estrangeira
	foreign key(tecId) references Tecnicos(funcId),
	foreign key(projId) references Projetos(idProj)
)
go

select * from Tec_executa_Projeto
go

-- CRIAR A TABELA ENGENHEIRO GERENCIAM PROJETOS ---------------------------------------------------------------------------------

create table Eng_gerencia_Proj (
	engId int not null,
	projId int not null,
	qtdHoras int not null check(qtdHoras >= 0),
	--chave primária composta - N x N
	primary key (engId, projId),
	--chaves estrangeiras
	foreign key (engId) references Engenheiros(funcId),
	foreign key (projId) references Projetos(idProj)
)
go

select * from Eng_gerencia_Proj
go


-- TRABALHO ADM DE BANCO DE DADOS ----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Criar uma procedure para cadastrar Departamento
-----------------------------------------------------------------------------

create procedure sp_CadDepartamento(@nomeDepto varchar(30), @local varchar(30), @telefone varchar(15))
as
begin
-- INSERIR DADOS
	insert into Departamentos (nomeDepto, local, telefone)
	values (@nomeDepto, @local, @telefone)
end
go

-----------------------------------------------------------------------------
-- Use a procedure para cadastrar 5 departamentos
-----------------------------------------------------------------------------

exec	sp_CadDepartamento 'Financeiro', 'Bloco A', '0800 111'
exec	sp_CadDepartamento 'Marketing', 'Bloco B', '0800 222' 
exec	sp_CadDepartamento 'Limpeza', 'Bloco C', '0800 333'
exec	sp_CadDepartamento 'TI', 'Bloco D', '0800 444'
exec	sp_CadDepartamento 'Cozinha', 'Pátio', '0800 555'
exec	sp_CadDepartamento 'Construção', 'Obras', '0800 333'
go

-----------------------------------------------------------------------------
-- Criar uma procedure para cadastrar Engenheiro
-----------------------------------------------------------------------------

create procedure sp_cadEngenheiro(@nomeFunc varchar(50), @cpf varchar(14), @dataNasc date, @especialidade varchar(50), @anoExp int, @classificacao varchar(20), @deptoId int)
as 
begin
	--insert Funcionario
	insert into Funcionarios(nomeFunc, cpf, dataNasc, status)
	values (@nomeFunc, @cpf,  @dataNasc, 1)

	--insert Engenheiros
	insert into Engenheiros(funcId, anoExp, especialidade, classificacao, deptoId)
	values (@@IDENTITY, @anoExp, @especialidade,  @classificacao, @deptoId)
end
go

-----------------------------------------------------------------------------
-- Use a procedure para cadastrar 5 engenheiros
-----------------------------------------------------------------------------

exec sp_cadEngenheiro	'Luis F', '111.111.111-11', '2004-05-12', 'Produção', 5, 'Sênior', 1
exec sp_cadEngenheiro	'Renato', '222.222.222-22', '2004-12-08', 'Luz e Som', 3, 'Junior', 2
exec sp_cadEngenheiro	'Neves', '555.555.555-55', '1990-05-15', 'Estruturas', 5, 'Pleno', 1
exec sp_cadEngenheiro	'Matheus', '333.333.333-33', '1985-09-20', 'Mecânica', 7, 'Sênior', 3
exec sp_cadEngenheiro	'Rosana', '444.444.444-44', '1992-02-10', 'Elétrica', 4, 'Pleno', 2
go

-----------------------------------------------------------------------------
-- Criar uma procedure para cadastrar Técnico
-----------------------------------------------------------------------------

create procedure cad_Tecnico(@nomeFunc varchar(50), @cpf varchar(14), @dataNasc date, @valorHora decimal, @salario decimal)
as
begin
	--insert Funcionario
	insert into Funcionarios(nomeFunc, cpf, dataNasc, status)
	values (@nomeFunc, @cpf,  @dataNasc, 2)

	--insert Tecnico
	insert into Tecnicos(funcId, valorHora, salario)
	values (@@IDENTITY, @valorHora, @salario)
end
go

-----------------------------------------------------------------------------
-- Use a procedure para cadastrar 10 Técnicos
-----------------------------------------------------------------------------

exec cad_Tecnico 'João Silva', '123.456.789-00', '1985-05-15', 50.00, 3500.00
exec cad_Tecnico 'Maria Oliveira', '987.654.321-11', '1990-08-22', 60.00, 4000.00
exec cad_Tecnico 'Pedro Santos', '321.654.987-22', '1988-12-05', 55.00, 3800.00
exec cad_Tecnico 'Ana Costa', '456.789.123-33', '1992-03-19', 70.00, 4500.00
exec cad_Tecnico 'Lucas Pereira', '789.123.456-44', '1987-07-10', 48.00, 3300.00
exec cad_Tecnico 'Fernanda Lima', '654.321.987-55', '1991-11-25', 52.00, 3700.00
exec cad_Tecnico 'Carlos Andrade', '111.222.333-66', '1986-04-12', 65.00, 4200.00
exec cad_Tecnico 'Juliana Souza', '444.555.666-77', '1989-09-30', 58.00, 3900.00
exec cad_Tecnico 'Rafael Alves', '222.333.444-88', '1993-01-06', 62.00, 4100.00
exec cad_Tecnico 'Larissa Gomes', '555.666.777-99', '1994-06-14', 45.00, 3400.00
go

select * from Tecnicos
go

-----------------------------------------------------------------------------
-- Criar uma procedure para cadastrar Dependente
-----------------------------------------------------------------------------

create procedure sp_cadDependente(@funcId int, @nomeDep varchar(50), @idade int, @parentesco varchar(15))
as 
begin
	--inserts
	insert into Dependentes (funcId, nomeDep, idade, parentesco)
	values (@funcId, @nomeDep, @idade, @parentesco)
end
go

-----------------------------------------------------------------------------
-- Use a procedure para cadastrar dependentes: 1 funcionário com 2 dependentes,
-- 1 funcionário com 3 dependentes, 2 funcionários com 1 dependentes
-----------------------------------------------------------------------------

select * from Funcionarios
select * from Departamentos
go

exec sp_cadEngenheiro 'Pedro Roberto', '123.456.789-90', '2004-01-15', 'Civil', 10, 'Sênior', 1
exec sp_cadEngenheiro 'Mário Sasso', '987.654.321-69', '1990-03-22', 'Mecânico', 8, 'Pleno', 2
exec cad_Tecnico 'Odair', '123.321.456-22', '1988-11-05', 55.00, 3800.00
exec cad_Tecnico 'Wesley', '654.987.321-33', '1992-02-19', 60.00, 4200.00
go

exec sp_cadDependente 16, 'Paulo', 25, 'Irmão' 
exec sp_cadDependente 16, 'José T.', 60, 'Pai'

exec sp_cadDependente 17, 'Lorenzo', 9, 'Filho'
exec sp_cadDependente 17, 'Fábio', 13, 'Filho'
exec sp_cadDependente 17, 'Beatriz', 6, 'Sobrinha'

exec sp_cadDependente 18, 'Bruno', 33, 'Primo'
exec sp_cadDependente 19, 'Márcia', 66, 'Mãe'
go

select * from Dependentes
go
-----------------------------------------------------------------------------
-- Criar uma procedure para cadastrar Projetos
-----------------------------------------------------------------------------

create procedure sp_cadProjetos (@deptoId int, @nomeProj varchar(25), @local varchar (30), @orcamento money)
as
begin
	--inserts
	insert into Projetos (deptoId, nomeProj, local, orcamento)
	values( @deptoId, @nomeProj, @local, @orcamento)
end
go

select * from Projetos
go
-----------------------------------------------------------------------------
-- Use a procedure para cadastrar 8 projetos
-----------------------------------------------------------------------------

execute sp_cadProjetos 4, 'Projeto Carlos Nóbrega', 'São Paulo', 1300000.00
execute sp_cadProjetos 1, 'Projeto Maria Ferreira', 'Rio de Janeiro', 2500000.00
execute sp_cadProjetos 4, 'Projeto Novo Terminal', 'Rio Preto', 1800000.00
execute sp_cadProjetos 4, 'Projeto Silva e Souza', 'Belo Horizonte', 2200000.00
execute sp_cadProjetos 2, 'Projeto Infraestrutura Norte', 'Manaus', 3200000.00
execute sp_cadProjetos 4, 'Projeto Oliveira e Costa', 'Brasília', 1500000.00
execute sp_cadProjetos 4, 'Projeto Andrade Construções', 'Curitiba', 2750000.00
execute sp_cadProjetos 2, 'Projeto Expansão Industrial', 'Salvador', 1900000.00
go

select * from Projetos
go

-----------------------------------------------------------------------------
-- Criar uma procedure para cadastrar técnicos que executam projetos
-----------------------------------------------------------------------------

create procedure sp_cadTecnicos_Projetos (@tecId int, @projId int, @qtdHoras int, @dataInicio date, @dataFim date)
as
begin
	-- inserts
	insert into Tec_executa_Projeto(tecId, projId, qtdHoras, dataInicio, dataFim)
	values (@tecId, @projId, @qtdHoras, @dataInicio, @dataFim)
end
go

select * from Tec_executa_Projeto
go
-----------------------------------------------------------------------------
-- Use a procedure para relacionar os técnicos que executam projetos
-----------------------------------------------------------------------------
select * from Tecnicos
select * from Projetos
go

exec sp_cadTecnicos_Projetos 6, 9, 150, '2024-09-28', '2025-10-28'
exec sp_cadTecnicos_Projetos 6, 10, 200, '2024-10-01', '2025-11-01'
exec sp_cadTecnicos_Projetos 7, 11, 180, '2024-11-15', '2025-12-15'
exec sp_cadTecnicos_Projetos 8, 12, 220, '2024-12-05', '2025-12-05'
exec sp_cadTecnicos_Projetos 7, 13, 160, '2024-10-15', '2025-10-15'
exec sp_cadTecnicos_Projetos 11, 14, 140, '2024-11-01', '2025-11-01'
exec sp_cadTecnicos_Projetos 9, 15, 190, '2024-12-10', '2025-12-10'
exec sp_cadTecnicos_Projetos 13, 16, 210, '2024-09-30', '2025-09-30'
go
-----------------------------------------------------------------------------
-- Criar uma procedure para cadastrar engenheiros que gerenciam projetos
-----------------------------------------------------------------------------

create procedure sp_cadEngenheiro_Projetos( @engId int, @projId int, @qtdHoras int)
as
begin
	-- inserts
	insert into Eng_gerencia_Proj (engId, projId, qtdHoras)
	values (@engId, @projId, @qtdHoras)
end
go

select * from Eng_gerencia_Proj
go

-----------------------------------------------------------------------------
-- Use a procedure para relacionar os engenheiros que gerenciam projetos
-----------------------------------------------------------------------------

select * from Engenheiros
select * from Projetos
go

exec sp_cadEngenheiro_Projetos 1, 9, 150
exec sp_cadEngenheiro_Projetos 2, 10, 200
exec sp_cadEngenheiro_Projetos 3, 11, 180
exec sp_cadEngenheiro_Projetos 3, 9, 150
exec sp_cadEngenheiro_Projetos 4, 12, 220
exec sp_cadEngenheiro_Projetos 5, 13, 160
go


-----------------------------------------------------------------------------
-- VIEW
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Crie uma view para consultar todos os engenheiros. Lembre-se que engenheiro
-- é um funcionário
-----------------------------------------------------------------------------


create view v_Engenheiros
as
	select	f.idFunc Cod_Engenheiro, f.nomeFunc Nome, f.cpf CPF, f.dataNasc, 
			e.deptoId Cod_Departamento, e.especialidade Especialidade, e.anoExp Anos_Experiencia, e.classificacao Classificacao,
			case f.status
				when 1 then 'ATIVO'
				when 2 then 'INATIVO'
				when 3 then 'CANCELADO'
			else 'BLOQUEADO'
			end Status_Funcionario
	from Funcionarios f INNER JOIN Engenheiros e ON f.idFunc = e.funcId
go

select * from v_Engenheiros
go
-----------------------------------------------------------------------------
-- Crie uma view para consultar todos os técnicos. Lembre-se que técnico
-- é um funcionário
-----------------------------------------------------------------------------

create view v_Tecnicos
as
	select	f.idFunc Cod_Funcionario, f.nomeFunc Nome, f.cpf CPF, f.dataNasc, 
			t.salario Salario, t.valorHora Valor_Hora,
			case f.status
				when 1 then 'ATIVO'
				when 2 then 'INATIVO'
				when 3 then 'CANCELADO'
			else 'BLOQUEADO'
			end Status_Funcionario
	from Funcionarios f INNER JOIN Tecnicos t ON f.idFunc = t.funcId
go

select * from v_Tecnicos
go

-----------------------------------------------------------------------------
-- Crie uma view para consultar os dependentes de cada funcionário
-----------------------------------------------------------------------------

create view v_Dependentes
as
	select	f.idFunc Cod_func, f.nomeFunc Nome_Funcionario, 
			d.idDep Cod_Dependentes, d.nomeDep Nome_Dependente, d.parentesco Parentesco, d.idade Idade
	from Dependentes d INNER JOIN Funcionarios f ON f.idFunc = d.funcId
go

select * from v_Dependentes
go

-----------------------------------------------------------------------------
-- Crie uma view para consultar todos os engenheiros e o departamento que cada
-- um trabalha
-----------------------------------------------------------------------------

create view v_Engenheiros_Departamentos
as
	select	vE.Cod_Engenheiro, vE.Nome, vE.CPF, vE.dataNasc Nascimento, vE.Especialidade, vE.Classificacao, vE.Anos_Experiencia,
			d.idDepto Cod_Departamento, d.nomeDepto Departamento, d.local Local_Depto, d.telefone Telefone_Depto
	from	Departamentos d INNER JOIN v_Engenheiros vE ON d.idDepto = vE.Cod_Engenheiro
go

select * from v_Engenheiros_Departamentos
go
-----------------------------------------------------------------------------
-- Crie uma view para consultar todos os projetos
-----------------------------------------------------------------------------

create view v_Projetos
as
	select	p.idProj Cod_Projeto, p.nomeProj Nome_Projeto, p.local Local_Projeto, p.orcamento Orcamento, p.deptoId Cod_Depto
	from Projetos p
go

select * from v_Projetos
go
-----------------------------------------------------------------------------
-- Crie uma view para consultar todos os departamentos
-----------------------------------------------------------------------------

create view v_Departamentos 
as
	select d.idDepto Cod_Departamento, d.nomeDepto Departamento, d.telefone Telefone, d.local Local_Departamento
	from Departamentos d
go

select * from v_Departamentos
go
-----------------------------------------------------------------------------
-- Crie uma view para consultar todos os projetos, os técnicos que executam
-- os projetos, os engenheiros que gerenciam os projetos, qual departamento
-- o projeto está vinculado
-----------------------------------------------------------------------------
create view v_Projetos_Infos_Gerais
as
	select	P.idProj Cod_Projeto, P.nomeProj Nome_Projeto, P.local Local_Projeto, P.orcamento Orçamento_Projeto, 
			tep.tecId Cod_tecnico, tep.qtdHoras Quantidade_de_Horas, tep.dataInicio Data_de_Inicio, tep.dataFim Data_de_Entrega,
			egp.engId Cod_Engenheiro, egp.qtdHoras Quantidade_de_Horas_Engenheito,
			D.nomeDepto Nome_Departamento, D.local Local_Departamento, D.telefone Telefone_Departamento 
	from	Projetos P
			INNER JOIN Tec_executa_Projeto tep ON P.idProj = tep.projId
			INNER JOIN Eng_gerencia_Proj egp ON egp.projId = P.idProj
			INNER JOIN Departamentos D ON D.idDepto = P.deptoId
go

select * from v_Projetos_Infos_Gerais
go
	-----------------------------------------------------------------------------
	-- Crie uma view para consultar todos os engenheiros e seus dependentes
	-----------------------------------------------------------------------------

	create view v_Engenheiros_Dependentes
	as
		select	ve.Cod_Engenheiro, vD.Nome_Funcionario, vd.Nome_Dependente, vd.Parentesco, vd.Idade
		from v_Engenheiros vE INNER JOIN v_Dependentes vD ON ve.Cod_Engenheiro = vd.Cod_Dependentes
	go

select * from v_Engenheiros_Dependentes
go

-----------------------------------------------------------------------------
-- Crie uma view para consultar todos os técnicos e seus dependentes
-----------------------------------------------------------------------------

create view v_Tecnicos_Dependentes
as
	select	vT.Cod_Funcionario, vD.Nome_Funcionario, vd.Nome_Dependente, vd.Parentesco, vd.Idade
	from v_Tecnicos vT INNER JOIN v_Dependentes vD ON vT.Cod_Funcionario = vd.Cod_Dependentes
go

select * from v_Tecnicos_Dependentes
go