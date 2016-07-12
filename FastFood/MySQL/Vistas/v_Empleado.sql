-- Empresa        :  FastFood Restaurant
-- Producto       :  Servicio de Comida Rápida
-- Software       :  Sistema de Atención al Público (SAP)
-- DBMS           :  SQL Server
-- Base de Datos  :  FastFood
-- Script         :  Crea la vista v_Empleado
-- Programado por :  Ing. Eric G. Coronel Castillo
-- Teléfono       :  (511) 996-664-457
-- Email          :  gcoronel@uni.edu.pe, gcoronelc@gmail.com


Create View vEmpleado(IdEmpleado, Nombre)
As
	Select	IdEmpleado,
		concat(ApeEmpleado, ', ', NomEmpleado) 
	From Empleado;


Select * From vEmpleado;