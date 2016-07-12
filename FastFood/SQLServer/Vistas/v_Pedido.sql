-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea la vista v_Pedido
-- Programado por :  Eric G. Coronel Castillo
--                   Teléfono: 521-4991
--                   email:    gcoronel@uni.edu.pe

ALTER VIEW v_Pedido( IdPedido, Documento, Numero, Cliente, RUC, Empleado, 
	Fecha, Monto, Descuento, IGV, Total )
AS
Select	P.IdPedido, D.NomDocumento, P.NumDocumento,
	Case 
		When P.IdCliente Is NULL Then P.NomCliente
		Else (Select NomCliente From Cliente Where IdCliente = P.IdCliente)
	End,
	Case 
		When P.IdCliente Is NULL Then ''
		Else (Select RUC From Cliente Where IdCliente = P.IdCliente)
	End,
	E.ApeEmpleado + ', ' + E.NomEmpleado,
	P.Fecha, P.Monto, P.Descuento, 
	P.IGV, P.Total
From	Empleado E
Inner Join Pedido P
On	E.IdEmpleado = P.IdEmpleado
Inner Join Documento D
On 	P.IdDocumento = D.IdDocumento
GO

Select * From v_Pedido
GO