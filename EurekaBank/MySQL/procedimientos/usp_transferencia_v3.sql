/*
Empresa        :  EurekaBank
Software       :  Sistema de Cuentas de Ahorro
DBMS           :  MySQL Server
Base de Datos  :  eurekabank
Script         :  Crea procedimiento USP_EGCC_TRANSFERENCIA
Responsable    :  Ing. Eric Gustavo Coronel Castillo
Telefono       :  (511) 9966-64457
Email          :  gcoronelc@gmail.com
Sitio Web      :  http://www.desarrollasoftware.com
Blog           :  http://gcoronelc.blogspot.com
Linkedin       :  https://www.linkedin.com/in/gcoronelc/
*/

DELIMITER $$

DROP PROCEDURE IF EXISTS usp_egcc_transferencia$$

CREATE PROCEDURE usp_egcc_transferencia( 
	p_cuenta1 char(8),  -- Cuenta origen
	p_cuenta2 char(8),  -- Cuenta destino
	p_clave1  varchar(15), -- Clave de cuenta origen
	p_importe decimal(12,2), -- Importe a transferir
	p_empleado char(4)       -- Empleado que realiza la transacción
)
BEGIN

	DECLARE moneda1 char(2);
	DECLARE moneda2 char(2);
	DECLARE saldo1  decimal(12,2);
	DECLARE cargo decimal(12,2);
	DECLARE cont1 int;
	DECLARE cont2 int;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
	BEGIN
		-- Cancela la transacción
		rollback;
    
		-- Propaga el error    
    RESIGNAL;
    
	END;
  
  -- Iniciar Transacción
  start transaction;

	-- Datos de las cuentas
	select chr_monecodigo, dec_cuensaldo, int_cuencontmov
	into moneda1, saldo1, cont1
	from cuenta 
	where chr_cuencodigo = p_cuenta1
	and chr_cuenclave = p_clave1;
	
	select chr_monecodigo, int_cuencontmov
	into moneda2, cont2
	from cuenta 
	where chr_cuencodigo = p_cuenta2;
	
  -- Verifica moneda
	if ( moneda1 != moneda2 ) then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error, las cuentas deben ser de la misma moneda.';
	end if;

  -- Verifica saldo
  select dec_costimporte into cargo
  from costomovimiento where chr_monecodigo = moneda1;

  if(  (p_importe + cargo) > saldo1 ) then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error, no hay saldo suficinte.';
  end if;    

  -- Registrar el retiro en cuenta origen
  update cuenta
    set dec_cuensaldo = dec_cuensaldo - (p_importe + cargo),
       int_cuencontmov = int_cuencontmov + 2
    where chr_cuencodigo = p_cuenta1;

  set cont1 = cont1 + 1;

  insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
    chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
    values(p_cuenta1,cont1,current_date,p_empleado,'009',p_importe,p_cuenta2);

  set cont1 = cont1 + 1;

  insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
    chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
    values(p_cuenta1,cont1,current_date,p_empleado,'010',cargo,null);

  -- Registrar el deposito en cuenta destino

  update cuenta
    set dec_cuensaldo = dec_cuensaldo + p_importe - cargo,
       int_cuencontmov = int_cuencontmov + 2
    where chr_cuencodigo = p_cuenta2;

  set cont2 = cont2 + 1;

  insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
    chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
    values(p_cuenta2,cont2,current_date,p_empleado,'008',p_importe,p_cuenta1);

  set cont2 = cont2 + 1;

  insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
    chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
    values(p_cuenta2,cont2,current_date,p_empleado,'010',cargo,null);

  commit;

END$$

DELIMITER ;

/*

call usp_egcc_transferencia('00100001','00200001','123456',10000,'0001');

select * from cuenta where chr_cuencodigo in ('00100001','00200001');

select * from movimiento where chr_cuencodigo in ('00100001','00200001');

*/