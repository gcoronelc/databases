----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
-- Código fuente: https://goo.gl/GRaOQg
----------------------------------------------------

create view v_log(id,codigo,empleado,inicio,fin,tiempo)
as
select 
  l.id id, 
  e.chr_emplcodigo codigo,
  concat(e.vch_emplpaterno,' ',e.vch_emplmaterno,' ',e.vch_emplnombre) empleado, 
  CAST(l.fec_ingreso AS CHAR) inicio,
  IF(ISNULL(l.fec_salida),'NONE',CAST(l.fec_salida AS CHAR)) fin,
  IF(ISNULL(l.fec_salida),'NONE',CAST(TIMEDIFF(l.fec_salida,l.fec_ingreso) AS CHAR)) tiempo 
from empleado e 
join logsession l on e.chr_emplcodigo = l.chr_emplcodigo;


select * from v_log;

