----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
----------------------------------------------------

create or replace view EUREKA.v_cuenta(
  sucucodigo, sucunombre, cliecodigo, 
  cliepaterno, cliematerno, clienombre, 
  cuencodigo, cuensaldo, cuenestado, 
  monecodigo, monenombre 
)
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
  mo.chr_monecodigo  monecodigo,
  mo.vch_monedescripcion monenombre
from cuenta c 
join moneda mo on c.chr_monecodigo = mo.chr_monecodigo
join cliente cl on c.chr_cliecodigo = cl.chr_cliecodigo
join sucursal su on c.chr_sucucodigo = su.chr_sucucodigo; 



select * from EUREKA.v_cuenta
where cuencodigo='00100002';


select cuencodigo, monenombre, cuensaldo, cuenestado
from EUREKA.v_cuenta;



SELECT * FROM EUREKA.CUENTA;






