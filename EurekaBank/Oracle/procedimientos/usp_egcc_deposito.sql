----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
----------------------------------------------------

-- Procedimiento

create or replace procedure eureka.usp_egcc_deposito
(p_cuenta varchar2, p_importe number, p_empleado varchar2)
as
  v_msg varchar2(1000);
  v_cont number(5,0);
  v_estado varchar2(15);
begin
  -- Actualizar la cuenta
  update cuenta
		set dec_cuensaldo = dec_cuensaldo + p_importe,
		int_cuencontmov = int_cuencontmov + 1
		where chr_cuencodigo = p_cuenta;  
  -- Consultar contador y estado
	select int_cuencontmov, vch_cuenestado
    into v_cont, v_estado
    from cuenta
    where chr_cuencodigo = p_cuenta;
  -- Verificar estado
	if v_estado != 'ACTIVO' then
		raise_application_error(-20001,'Cuenta no esta activa.');
	end if;
  -- Registrar Movimiento
	insert into movimiento(chr_cuencodigo,int_movinumero,dtt_movifecha,
		chr_emplcodigo,chr_tipocodigo,dec_moviimporte,chr_cuenreferencia)
		values(p_cuenta,v_cont,sysdate,p_empleado,'003',p_importe,null);
	-- Confirmar la Tx
	commit;
exception
  when others then
    v_msg := sqlerrm; -- capturar mensaje de error
    rollback; -- cancelar transacción
    raise_application_error(-20001,v_msg);
end;
/

-- Habilitar las salidas

set SERVEROUTPUT ON;

-- Prueba

declare
  v_cuenta varchar2(8) := '00100001';
  v_importe number(12,2) := 100;
  v_saldo number(12,2);  
begin
  select dec_cuensaldo into v_saldo 
    from cuenta where chr_cuencodigo = v_cuenta;
  dbms_output.put_line('Saldo inicial: ' || v_saldo);
  eureka.usp_egcc_deposito(v_cuenta,v_importe,'0001');
  select dec_cuensaldo into v_saldo 
    from cuenta where chr_cuencodigo = v_cuenta;
  dbms_output.put_line('Saldo final: ' || v_saldo);
end;
/  

