----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
----------------------------------------------------


create or replace view EUREKA.v_movimientos(
sucucodigo, sucunombre, cliecodigo, cliepaterno,
cliematerno, clienombre, cuencodigo, cuensaldo,
cuenestado, movinumero, movifecha, moviimporte,
cuenreferencia, tipocodigo, tiponombre, tipoaccion,
monecodigo, monenombre)
as
select 
  su.chr_sucucodigo  sucucodigo,
  su.vch_sucunombre  sucunombre,
  cl.chr_cliecodigo  cliecodigo,
  cl.vch_cliepaterno cliepaterno,
  cl.vch_cliematerno cliematerno,
  cl.vch_clienombre  clienombre,
  c.chr_cuencodigo  cuencodigo,
  c.dec_cuensaldo   cuensaldo,
  c.vch_cuenestado  cuenestado,
  m.int_movinumero  movinumero,
  m.dtt_movifecha   movifecha,
  m.dec_moviimporte moviimporte,
  m.chr_cuenreferencia cuenreferencia,
  tm.chr_tipocodigo  tipocodigo,
  tm.vch_tipodescripcion tiponombre,
  tm.vch_tipoaccion  tipoaccion,
  mo.chr_monecodigo  monecodigo,
  mo.vch_monedescripcion monenombre
from EUREKA.tipomovimiento tm
join EUREKA.movimiento m on tm.chr_tipocodigo = m.chr_tipocodigo
join EUREKA.cuenta c on m.chr_cuencodigo = c.chr_cuencodigo
join EUREKA.moneda mo on c.chr_monecodigo = mo.chr_monecodigo
join EUREKA.cliente cl on c.chr_cliecodigo = cl.chr_cliecodigo
join EUREKA.sucursal su on c.chr_sucucodigo = su.chr_sucucodigo;



select * from EUREKA.v_movimientos
where cuencodigo='00100001';


select 
cuencodigo,
monenombre,
cuensaldo,
cuenestado,
movinumero,
movifecha,
moviimporte,
tipocodigo,
tiponombre
from EUREKA.v_movimientos;



create or replace view EUREKA.v_resumen
as
select 
cuencodigo, cuensaldo,
sum(case when tipoaccion='INGRESO'
	then moviimporte else 0 end) ingresos,
sum(case when tipoaccion='SALIDA'
	then moviimporte else 0 end) salida,
sum(moviimporte * case when tipoaccion='SALIDA'
	then -1 else 1 end) saldo
from EUREKA.v_movimientos
group by cuencodigo, cuensaldo;



SELECT * FROM EUREKA.v_resumen;
