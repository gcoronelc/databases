-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea la vista v_DetallePedido
-- Programado por :  Ing. Eric G. Coronel Castillo
-- Telúfono       :  (511) 996-664-457
-- Email          :  gcoronel@uni.edu.pe, gcoronelc@gmail.com

CREATE VIEW vDetallePedido( IdPedido, Articulo,
	Cantidad, PreVenta, SubTotal )
AS
Select	DP.IdPedido, A.NomArticulo,
	DP.Cantidad, DP.PreVenta, DP.SubTotal
From DetallePedido DP
Inner Join Articulo A
On DP.IdArticulo = A.IdArticulo;


Select * From vDetallePedido;