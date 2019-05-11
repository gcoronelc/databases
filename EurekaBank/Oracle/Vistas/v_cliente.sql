----------------------------------------------------
-- Autor:   Eric Gustavo Coronel Castillo
-- Blog:    gcoronelc.blogspot.com
-- Email:   gcoronelc@gmail.com
-- Youtube: https://goo.gl/9GFBaC
----------------------------------------------------

create or replace view eureka.v_cliente
(codigo,paterno,materno,nombre,dni,ciudad,direccion,telefono,email)
as
select
  chr_cliecodigo    codigo,
  vch_cliepaterno   paterno,
  vch_cliematerno   materno,
  vch_clienombre    nombre,
  chr_cliedni       dni,
  vch_clieciudad    ciudad,
  vch_cliedireccion direccion,
  vch_clietelefono  telefono,
  vch_clieemail     email
from cliente;


select 
codigo, paterno, materno, nombre, 
dni, ciudad, direccion, telefono, email
from eureka.v_cliente;


insert into EUREKA.cliente 
values( '00100', 'LIMACO', 'GARAY', 'MARTHA', '8954679', 'LIMA', 'LOS OLIVOS', '896534567', 'MLIMACO@GMAIL.COM' );


COMMIT;

