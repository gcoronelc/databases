----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
-- Código fuente: https://goo.gl/GRaOQg
----------------------------------------------------

create view v_usuario(codigo,empleado,usuario,clave,estado)
as
select 
  e.chr_emplcodigo codigo,
  concat(e.vch_emplpaterno,' ',e.vch_emplmaterno,' ',e.vch_emplnombre) empleado,
  ifnull(u.vch_emplusuario,'NONE') usuario,
  if(isnull(u.vch_emplclave),'NONE','secreto') clave,
  ifnull(u.vch_emplestado,'NONE') estado
from empleado e
left join usuario u on e.chr_emplcodigo = u.chr_emplcodigo;



select * from v_usuario;


