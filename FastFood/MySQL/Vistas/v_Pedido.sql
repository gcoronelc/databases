-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea la vista v_Pedido
-- Programado por :  Ing. Eric G. Coronel Castillo
-- Teléfono       :  (511) 996-664-457
-- Email          :  gcoronel@uni.edu.pe, gcoronelc@gmail.com

CREATE VIEW vPedido( IdPedido, Documento, Numero, CodCliente, Cliente, RUC, 
    Empleado, Fecha, Importe, Descuento, Subtotal, IGV, Total )
AS
Select	P.IdPedido, D.NomDocumento, P.NumDocumento,
	Case 
		When P.IdCliente Is NULL Then 'NONE'
		Else P.IdCliente
	End CodCliente,
	Case 
		When P.IdCliente Is NULL Then P.NomCliente
		Else (Select NomCliente From Cliente Where IdCliente = P.IdCliente)
	End Cliente,
	Case 
		When P.IdCliente Is NULL Then 'NONE'
		Else (Select RUC From Cliente Where IdCliente = P.IdCliente)
	End RUC,
	concat(E.ApeEmpleado, ', ', E.NomEmpleado),
	P.Fecha, P.Importe, P.Descuento, 
	P.Subtotal, P.IGV, P.Total
From	Empleado E
Inner Join Pedido P
On	E.IdEmpleado = P.IdEmpleado
Inner Join Documento D
On 	P.IdDocumento = D.IdDocumento;


Select * From vPedido;