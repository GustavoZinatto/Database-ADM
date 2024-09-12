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

---------------------------------------------------------------------------------------------
-- CRIAR UMA VIEW PARA OS ITENS DE PEDIDOS, TRAZENDO DADOS DOS PRODUTOS DE CADA PEDIDO.
-- OBJETIVO: JUNTAR TABELA COM VIEW

create view v_ItensPedidos
as
	select	IP.pedidoId No_Pedido, IP.qtd Quantidade,  IP.valor Valor,
			vP.Produto,
			(IP.qtd * IP.valor) Total_Item
	from	Itens_Pedidos IP INNER JOIN v_Produtos vP ON IP.produtoId = vP.Codigo_Prod
go


select * from v_ItensPedidos
ORDER BY valor DESC
go

---------------------------------------------------------------------------------------------
-- CALCULAR O TOTAL DE UM PEDIDO
-- CALCULAR O TOTAL DE PEDIDO 01

select sum(Total_Item) Total_Pedido
from v_ItensPedidos
where No_Pedido = 3
go


---------------------------------------------------------------------------------------------
-- CONSULTAR TPDPS OS DADOS DOS PEDIDOS, TRAZENDO OS PRODUTOS DE CADA PEDIDO, OS CLIENTES QUE FIZERAM O PEDIDO E OS VENDEDORES QUE RESTRARAM OS PEDIDOS
-- OBJETIVO: JUNTAR TODAS AS VIEWS

create view v_ProdPedido
as 
	select	vp.No_Pedido, vp.Data_Pedido, vp.Cod_Cliente, vp.Cliente, vp.Cod_Vendedor, vp.Vendedor, vp.Situacao_Pedido, 
			vip.Produto, vip.Quantidade, vip.Valor, vip.Total_Item
	from	v_Pedido vp, v_ItensPedidos vip
	where	vp.No_Pedido = vip.No_Pedido
go

select * from v_ProdPedido
go

select * from v_ProdPedido
where No_Pedido = 2
go

---------------------------------------------------------------------------------------------
-- CADASTRAR UM PRODUTO NOVO

insert into Produtos(descricao, qtd, valor, status)
values	('Paçoca', 50, 2.50, 1)
go

select * from Produtos