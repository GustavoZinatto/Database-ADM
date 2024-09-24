

--ACESSAR O BANCO DE DADOS ------------------------------------------

use VendasInfoM
go

--CRIAR UMA PROCEDURE PARA CADASTRAR VENDEDORES ------------------------------------------
--TODO VENDEDOR É UMA PESSOA

create procedure sp_CadVendedor(@nomeVend varchar(50), @cpfVendedor varchar(14), @salarioVendedor money)
as
begin
	--INSERINDO OS DADOS DA PESSOA
	insert into Pessoas (nome, cpf, status)
	values(@nomeVend, @cpfVendedor, 1)

	--INSERIR OS DADOS DO VENDEDOR
	insert into Vendedores(pessoaId, salario)
	values(@@IDENTITY, @salarioVendedor) --@@IDENTITY recupera o último id gerado, idependentemente da tabela
end
go

-- USAR A PROCEDURE PARA CADASTRAR UM VENDEDOR

exec sp_CadVendedor 'Ademar Reis', '123.455.853-78', 5200.00
go

exec sp_CadVendedor 'Carlos Magnus', '258.654.753-87', 5100.00
go

-- CONSULTAR OS VENDEDORES PELA VIEW
select * from v_Vendedores
go

-- CONSULTAR PESSOAS
select * from Pessoas
go

-- CONSULTAR VENDEDORES
select * from Vendedores
go

-- CRIAR TABELA ENDEREÇO DOS CLIENTES

create table Enderecos (
	idEnd int not null identity,
	rua varchar(100) not null,
	numero varchar(10) not null,
	bairro varchar(50) not null,
	cep varchar(8) not null,
	cidade varchar(30) not null,
	idCliente int not null,

	primary key (idCliente, idEnd),

	foreign key(idCliente) references Clientes(pessoaId)
)
go

-- CRIAR UMA PROCEDURE PARA CADASTRAR CLIENTE
-- TODO CLIENTE É UMA PESSOA E TEM ENDEREÇO

create procedure sp_CadCliente
(
	--lista de parâmetros recebidos
	@nomeCli varchar(50),
	@cpfCli varchar(14),
	@rendaCli money,
	@ruaCli varchar(100),
	@numeroCli varchar(10),
	@bairroCli varchar(50),
	@cepCli varchar(8),
	@cidadeCli varchar(30)
)
as
begin
	--cadastrar os dados da Pessoa
	insert into Pessoas (nome, cpf, status)
	values(@nomeCli, @cpfCli, 1)

	--Declarar uma variável para armazenar o id gerado para a tabela Pessoas
	declare @idCli int
	--atribuir para essa variavel o id gerado para a tabela Pessoas
	set @idCli = @@IDENTITY

	--cadastrar os dados do cliente
	insert into Clientes(pessoaId, renda, credito)
	values (@idCli, @rendaCli, (@rendaCli * 0.3))

	-- cadastrar os dados do endereço
	insert into Enderecos(rua, numero, bairro, cep, cidade, idCliente)
	values (@ruaCli, @numeroCli, @bairroCli, @cepCli, @cidadeCli, @idCli)
end
go

--cadastrar um novo cliente
exec sp_CadCliente 'Alexandre Ducatti', '456.987.123-99', 7000.00, 'Rua A', '10', 'Eldorado', '150148-555', 'Barretos'
go

--consultar clientes
select vc.*, E.*
from v_Cliente vc	LEFT JOIN	Enderecos E ON vc.Cod_Cliente = E.idCliente
go


-- CRIAR UMA PROCEDURE PARA CADASTRAR PRODUTOS ----------------------------------

create procedure sp_cadProduto (
	
	--lista de Parâmetros
	@descricao varchar(100), @qtd int, @valor decimal(10,2)
) 
as
begin
	--inserir os dados na tabela Produtos
	insert into Produtos (descricao, qtd, valor, status)
	values (@descricao, @qtd, @valor, 1)
end
go

execute sp_cadProduto 'Pacote de Amendoim', '100', 13.99
go

select * from v_Produtos
go

-- CRIAR PROCEDURE PARA CADASTRAR PEDIDOS
-- LEMBRE-SE QUE UM PEDIDO É FEITO POR UM CLIENTE E REGISTRADO POR UM VENDEDOR

create procedure sp_cadPedido (
	--lista de Parêmetros
	@idVend int, @idCli int
)
as
begin
	--cadastrar pedidos
	insert into Pedidos(data, status, vendedorId, clienteId)
	values (getdate(), 1, @idVend, @idCli)
end
go

select * from v_Cliente
go

select * from v_Vendedores
go

--executar procedure
exec sp_cadPedido 1, 1
go
exec sp_cadPedido 3, 2
go

select * from Pedidos
go

-- CRIAR UMA PROCEDURE PARA DAR BAIXA EM ESTOQUE

create procedure sp_baixaEstoque (
	--lista de parâmetros
	@idProduto int, @qtdVendida int
)
as
begin
	--atualizar a tabela Produtos
	update Produtos set qtd = qtd - @qtdVendida
	where	idProduto = @idProduto and
			qtd >= @qtdVendida and
			@qtdVendida > 0
end
go

select * from v_Produtos
go

-- DAR BAIXA EM ESTOQUE DO PRODUTO 5
exec sp_baixaEstoque 5, 10
go

exec sp_baixaEstoque 5, 100
go

-- CRIAR UMA PROCEDURE PARA ATUALIZAR O ESTOQUE QUANDO FOR FEITA A COMPRA DE UM PRODUTO

create procedure sp_atualizaEstoque (
	@idProd int, @qtdComprada int
)
as
begin
	--atualização de qtd na tabela Produtos
	update	Produtos set qtd = qtd + @qtdComprada
	where	idProduto = @idProd and
			@qtdComprada > 0
end
go

select * from v_Produtos
go

exec sp_atualizaEstoque 10, 15
go