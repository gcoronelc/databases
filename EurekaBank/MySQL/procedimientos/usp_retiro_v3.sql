/*
Empresa        :  EurekaBank
Software       :  Sistema de Cuentas de Ahorro
DBMS           :  MySQL Server
Base de Datos  :  eurekabank
Script         :  Crea procedimiento USP_EGCC_RETIRO
Responsable    :  Ing. Eric Gustavo Coronel Castillo
Telefono       :  (511) 9966-64457
Email          :  gcoronelc@gmail.com
Sitio Web      :  http://www.desarrollasoftware.com
Blog           :  http://gcoronelc.blogspot.com
Linkedin       :  https://www.linkedin.com/in/gcoronelc/
*/

DELIMITER $$

DROP PROCEDURE IF EXISTS usp_egcc_retiro$$

CREATE PROCEDURE usp_egcc_retiro(
	p_cuenta char(8), 
	p_importe decimal(12,2),
  p_clave char(6),
	p_empleado char(4)
)
BEGIN

  -- Variables
	DECLARE moneda char(2);
	DECLARE costoMov decimal(12,2);
	DECLARE cont int;
	DECLARE saldo decimal(12,2);

  -- Control de errores
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
	BEGIN
  
		-- Cancela la transacción
		rollback; 
    
		-- Propaga el error
    RESIGNAL;
    
	END;

	-- Iniciar transacción
	start transaction;
	
	-- Leer datos de la cuenta
	select int_cuencontmov, chr_monecodigo, dec_cuensaldo
	into cont, moneda, saldo
	from cuenta 
	where chr_cuencodigo = p_cuenta
	and chr_cuenclave = p_clave
  for update;
	
  -- Costo de Transacción
	select dec_costimporte into costoMov
	from costomovimiento
	where chr_monecodigo = moneda;

  -- Verifica saldo
	if saldo < (p_importe + costoMov) then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente';
  end if;

  -- Registrar el deposito
  update cuenta
    set dec_cuensaldo = dec_cuensaldo - p_importe - costoMov,
      int_cuencontmov = int_cuencontmov + 2
    where chr_cuencodigo = p_cuenta;

  -- Registrar el movimiento
  set cont := cont + 1;
  insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
    chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
    values(p_cuenta,cont,current_date,p_empleado,'004',p_importe,null);

  -- Registrar el costo del movimiento
  set cont := cont + 1;
  insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
    chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
    values(p_cuenta,cont,current_date,p_empleado,'010',costoMov,null);

  -- Confirma Transacción
  commit;
	
END$$

DELIMITER ;

/*

call usp_egcc_retiro('00100001',50000, '123456', '0001');

*/