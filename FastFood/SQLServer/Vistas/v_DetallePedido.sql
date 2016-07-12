-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea la vista v_DetallePedido
-- Programado por :  Eric G. Coronel Castillo
--                   Teléfono: 521-4991
--                   email:    gcoronel@uni.edu.pe

CREATE VIEW v_DetallePedido( IdPedido, Articulo,
	Cantidad, PreVenta, SubTotal )
AS
Select	DP.IdPedido, A.NomArticulo,
	DP.Cantidad, DP.PreVenta, DP.SubTotal
From DetallePedido DP
Inner Join Articulo A
On DP.IdArticulo = A.IdArticulo
GO

Select * From v_DetallePedido
GO