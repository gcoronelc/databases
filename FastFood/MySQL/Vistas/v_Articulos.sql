-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea la vista v_Articulos
-- Programado por :  Ing. Eric G. Coronel Castillo
-- Teléfono       :  (511) 996-664-457
-- Email          :  gcoronel@uni.edu.pe, gcoronelc@gmail.com


CREATE VIEW vArticulos(IdCategoria,NomCategoria,
	IdArticulo,NomArticulo, PreArticulo)
AS
	SELECT	C.IdCategoria,C.NomCategoria,
		A.IdArticulo,A.NomArticulo,A.PreArticulo
	FROM Categoria C INNER JOIN Articulo A
	ON C.IdCategoria = A.IdCategoria;


Select * From vArticulos;