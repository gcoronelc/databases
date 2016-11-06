----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
----------------------------------------------------

-- Procedimiento

create or replace procedure usp_egcc_saldo_sucursal
( 
	p_sucursal varchar2, 
	p_saldo_soles out number,
	p_saldo_dolares out number	
)
is
begin

	select sum(dec_cuensaldo) into p_saldo_soles
	from cuenta
	where chr_sucucodigo = p_sucursal
	and chr_monecodigo = '01';

	select sum(dec_cuensaldo) into p_saldo_dolares
	from cuenta
	where chr_sucucodigo = p_sucursal
	and chr_monecodigo = '02';
	
end;
/

-- Prueba

set serveroutput on

declare
	v_saldo number;
begin
	usp_egcc_saldo_cuenta('00100001',v_saldo);
	dbms_output.put_line('Saldo: ' || v_saldo);
end;
/

declare
	v_saldo number;
	v_cuenta char(8);
begin
	usp_egcc_saldo_cuenta(&v_cuenta,v_saldo);
	dbms_output.put_line('Saldo: ' || v_saldo);
end;
/

