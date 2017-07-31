----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
-- Código fuente: https://goo.gl/GRaOQg
----------------------------------------------------

create view v_permiso(codigo,nombre,idmodulo,modulo,estado)
as
select 
  e.chr_emplcodigo codigo,
  concat(e.vch_emplnombre,', ',e.vch_emplpaterno,' ',e.vch_emplmaterno) nombre,
  m.int_moducodigo idmodulo,
  m.vch_modunombre modulo,
  p.vch_permestado 
from modulo m
join permiso p on m.int_moducodigo = p.int_moducodigo
join empleado e on p.chr_emplcodigo = e.chr_emplcodigo
UNION 
select 
  e.chr_emplcodigo codigo,
  concat(e.vch_emplnombre,', ',e.vch_emplpaterno,' ',e.vch_emplmaterno) nombre,
  m.int_moducodigo idmodulo,
  m.vch_modunombre modulo,
  'CANCELADO' estado
from modulo m cross join empleado e
where e.chr_emplcodigo not in (select chr_emplcodigo from permiso); 


select * from v_permiso;


