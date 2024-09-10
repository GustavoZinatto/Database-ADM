---------------------------------------------------------------------------------------------
-- VIEW

---------------------------------------------------------------------------------------------
-- ACESSAR BANCO DE DADOS

use VendasInfoM
go

---------------------------------------------------------------------------------------------
-- CRIAR UMA VIEW PARA CONSULTAR TODOS OS DADOS DOS PRODUTOS CADASTRADOS

create view v_Produtos
as
	select * from Produtos
go

---------------------------------------------------------------------------------------------
-- EXECUTAR A VIEW
select * from v_Produtos
go

---------------------------------------------------------------------------------------------
-- ALTERAÇÃO DA VIEW PARA CONFIGURAR MAIS COMPREENSÍVEL

alter view v_Produtos
as	
	select idProduto Codigo_Prod, descricao Produto, qtd Qts_Estoque, valor Preco_Prod,
		case status
			when 1 then 'Ativo'
			when 2 then 'Inativo'
			else 'Cancelado'
		end Situacao_Prod
	from Produtos
go

---------------------------------------------------------------------------------------------
-- ATUALIZAÇÃO DA TABELA PRODUTOS

update Produtos set status = null 
where idProduto in (5, 7, 11)
go

---------------------------------------------------------------------------------------------
-- CONSULTAR TODOS OS PRODUTOS COM O PREÇO MAIOR QUE R$ 7,00
-- ORDENADA PELO PRODUTO EM ORDEM ASCENDENTE

select * from v_Produtos
where Preco_Prod > 7.00
order by Preco_Prod ASC
go

exec sp_help pessoas
go

---------------------------------------------------------------------------------------------
-- CRIAR UMA VIEW PARA CONSULTAR TODOS OS DADOS DO CLIENTE

create view v_Cliente
as
	select	p.idPessoa Cod_Cliente, p.nome Cliente, p.cpf CPF_CLiente,
			c.renda Renda, c.credito Crédito,
			case p.status
				when 1 then 'Ativo'
				when 2 then 'Inativo'
				when 3 then 'Bloqueado'
				else 'Cancelado'
			end Situacao_Cliente
	from Pessoas p INNER JOIN Clientes c ON p.idPessoa = c.pessoaId
go

---------------------------------------------------------------------------------------------
-- EXECUTAR A VIEW

select * from v_Cliente

---------------------------------------------------------------------------------------------
-- ATUALIZAÇÃO DA TABELA PESSOAS

update Pessoas set status = 3
where idPessoa = 5
go

update Pessoas set status = null
where idPessoa = 9
go

---------------------------------------------------------------------------------------------
-- CADASTRAR UM NOVO PRODUTO NA TABELA PRODUTOS USANDO A VIEW

insert into v_Produtos (Produto, Qts_Estoque, Preco_Prod)
values	('Bolo de Rolo de Doce de Leite', 10, 25.00)
go

select * from Produtos
select * from v_Produtos

---------------------------------------------------------------------------------------------
-- CRIAR UMA VIEW PARA CONSULTAR TODOS OS DADOS DOS VENDEDORES

create view v_Vendedores
as
	select	p.nome Vendedor, p.cpf CPF_Vendedor,
			v.pessoaId Cod_Vendedor, v.salario Salario,
			case p.status
				when 1 then 'Ativo'
				when 2 then 'Inativo'
				when 3 then 'Bloqueado'
				else 'Cancelado'
			end Situacao_Vendedor
	from	Pessoas p INNER JOIN Vendedores v ON p.idPessoa = v.pessoaId
go
 
select * from v_Vendedores

---------------------------------------------------------------------------------------------
-- CRIAR UMA VIEW PARA CONSULTAR TODOS OS DADOS DOS PEDIDOS E TRAZER OS NOMES DOS CLIENTES E VENDEDORES QUE FIZERAM PEDIDOS
-- OBJETIVO: JUNTAR TABELAS COM VIEWS

create view v_Pedido
as
	select	Pe.idPedidos No_Pedido, Pe.data Data_Pedido, Pe.valor Total_Pedido,
			vC.Cod_Cliente, vC.Cliente, vV.Cod_Vendedor, vV.Vendedor,
			case Pe.status
				when 1 then 'Em andamento'
				when 2 then 'Finalizado'
				when 3 then 'Entregue'
				else 'Cancelado'
			end Situacao_Pedido
	from	Pedidos Pe, v_Cliente vC, v_Vendedores vV
	where	Pe.clienteId = vC.Cod_Cliente and Pe.vendedorId = vV.Cod_Vendedor
go

select * from v_Pedido