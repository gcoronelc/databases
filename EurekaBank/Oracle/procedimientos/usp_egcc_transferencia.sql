----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
----------------------------------------------------

-- Procedimiento

CREATE OR REPLACE PROCEDURE usp_egcc_transferencia( 
	p_cuenta1 varchar2,  -- Cuenta origen
	p_importe number,    -- Importe a transferir
	p_clave1  varchar2,  -- Clave de cuenta origen  
	p_cuenta2 varchar2,  -- Cuenta destino  
	p_empleado varchar2  -- Empleado que realiza la transacción
)
AS

  v_msg     varchar2(1000);
	v_moneda1 char(2);
	v_moneda2 char(2);
	v_saldo1  number(12,2);
	v_cargo   number(12,2);
	v_cont1   number(5,0);
	v_cont2   number(5,0);
  v_estado1 varchar2(15);
  v_estado2 varchar2(15);
  
BEGIN

	-- Verificar la moneda y estado
  
	select chr_monecodigo, dec_cuensaldo, int_cuencontmov, vch_cuenestado
	into v_moneda1, v_saldo1, v_cont1, v_estado1
	from cuenta 
	where chr_cuencodigo = p_cuenta1 and chr_cuenclave = p_clave1
  for update;
	
	select chr_monecodigo, int_cuencontmov, vch_cuenestado
	into v_moneda2, v_cont2, v_estado2
	from cuenta 
	where chr_cuencodigo = p_cuenta2
  for update;
	
  if ( v_estado1 != 'ACTIVO' ) then
    raise_application_error(-20001,'Cuenta origen no esta activa.');
  end if;
  
  if ( v_estado2 != 'ACTIVO' ) then
    raise_application_error(-20001,'Cuenta destino no esta activa.');
  end if;
  
	if ( v_moneda1 != v_moneda2 ) then
    raise_application_error(-20001,'Error, las cuentas deben ser de la misma moneda.');
  end if;
  
  -- Cargo por la transacción

  select dec_costimporte into v_cargo
  from costomovimiento where chr_monecodigo = v_moneda1;

  -- Verificar saldo
  
	if(  (p_importe + v_cargo) > v_saldo1 ) then
    raise_application_error(-20001,'Error, no hay saldo suficinte.');
  end if;
  
	-- Registrar el retiro
  
  update cuenta
  set dec_cuensaldo = dec_cuensaldo - (p_importe + v_cargo),
      int_cuencontmov = int_cuencontmov + 2
  where chr_cuencodigo = p_cuenta1;

	v_cont1 := v_cont1 + 1;

  insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
    chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
  values(p_cuenta1,v_cont1,SYSDATE,p_empleado,'009',p_importe,p_cuenta2);

	v_cont1 := v_cont1 + 1;

	insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
		chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
	values(p_cuenta1,v_cont1,SYSDATE,p_empleado,'010',v_cargo,null);

	-- Registrar el deposito

  update cuenta
  set dec_cuensaldo = dec_cuensaldo + p_importe - v_cargo,
      int_cuencontmov = int_cuencontmov + 2
  where chr_cuencodigo = p_cuenta2;

	v_cont2 := v_cont2 + 1;

	insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
		chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
	values(p_cuenta2,v_cont2,SYSDATE,p_empleado,'008',p_importe,p_cuenta1);

	v_cont2 := v_cont2 + 1;

	insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
		chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
	values(p_cuenta2,v_cont2,SYSDATE,p_empleado,'010',v_cargo,null);

	commit;

exception

  when NO_DATA_FOUND then
    rollback;
    raise_application_error(-20001,'Alguna de las cuentas no existe.');
    
  when others then
    v_msg := sqlerrm; -- capturar mensaje de error
    rollback; -- cancelar transacción
    raise_application_error(-20001,v_msg);

END;
/

/*

select * from cuenta where chr_cuencodigo in ('00100001','00200001');

call usp_egcc_transferencia('00100001','00200008','123456',100,'0001');

select * from cuenta where chr_cuencodigo in ('00100001','00200001');



*/