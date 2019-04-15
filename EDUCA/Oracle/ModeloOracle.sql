/**
 *
 * DBMS           :  ORACLE
 * Esquema        :  EDUCA
 * Descripción    :  Modelo de Base de Datos de control académico sencillo
 * Script         :  Crea el esquema y sus respectivas tablas
 * Creao por      :  Ing. Eric Gustavo Coronel Castillo
 * Email          :  gcoronelc@gmail.com
 * Sitio Web      :  www.desarrollasoftware.com
 * Blog           :  http://gcoronelc.blogspot.com
 * Fecha          :  22-NOV-2017
 * 
**/


-- =============================================
-- CRACIÓN DEL USUARIO
-- =============================================

DECLARE
	N INT;
	COMMAND VARCHAR2(200);
BEGIN
	COMMAND := 'DROP USER EDUCA CASCADE';
	SELECT COUNT(*) INTO N
	FROM DBA_USERS
	WHERE USERNAME = 'EDUCA';
	IF ( N = 1 ) THEN
		EXECUTE IMMEDIATE COMMAND;
	END IF;
END;
/


CREATE USER EDUCA IDENTIFIED BY admin;

GRANT CONNECT, RESOURCE TO EDUCA;

ALTER USER EDUCA
QUOTA UNLIMITED ON USERS;

GRANT CREATE VIEW TO EDUCA;



-- =============================================
-- CONECTARSE A LA APLICACIÓN
-- =============================================

CONNECT EDUCA/admin



-- ======================================================
-- TABLA ALUMNO
-- ======================================================

CREATE TABLE ALUMNO
( 
	alu_id               INT  NOT NULL ,
	alu_nombre           varchar2(100)  NOT NULL ,
	alu_direccion        varchar2(100)  NOT NULL ,
	alu_telefono         varchar2(20)  NULL ,
	alu_email            varchar2(50)  NULL 	
);


-- ======================================================
-- TABLA CURSO
-- ======================================================

CREATE TABLE CURSO
( 
	cur_id               INT NOT NULL ,
	cur_nombre           varchar2(100)  NOT NULL ,
	cur_vacantes         int  NOT NULL ,
	cur_matriculados     int  NOT NULL ,
	cur_profesor         varchar2(100)  NULL ,
	cur_precio           decimal(10,2)  NOT NULL 
);



-- ======================================================
-- TABLA MATRICULA
-- ======================================================


CREATE TABLE MATRICULA
( 
	cur_id               INT  NOT NULL ,
	alu_id               INT  NOT NULL ,
	mat_fecha            date  NOT NULL ,
	mat_precio           decimal(10,2)  NOT NULL ,
	mat_cuotas           int  NOT NULL ,
	mat_nota             int  NULL 
);


-- ======================================================
-- TABLA PAGO
-- ======================================================

CREATE TABLE PAGO
( 
	cur_id               INT  NOT NULL ,
	alu_id               INT  NOT NULL ,
	pag_cuota            int  NOT NULL ,
	pag_fecha            date  NOT NULL ,
	pag_importe          decimal(10,2)  NOT NULL 
);


-- ======================================================
-- RESTRICCIONES DE LA TABLA ALUMNO
-- ======================================================

ALTER TABLE ALUMNO
	ADD CONSTRAINT PK_ALUMNO 
	PRIMARY KEY (alu_id);


ALTER TABLE ALUMNO
	ADD CONSTRAINT U_ALUMNO_EMAIL 
	UNIQUE (alu_email);


ALTER TABLE ALUMNO
	ADD CONSTRAINT U_ALUMNO_NOMBRE 
	UNIQUE (alu_nombre);


INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 1,'YESENIA VIRHUEZ','LOS OLIVOS','986412345','yesenia@hotmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 2,'OSCAR ALVARADO FERNANDEZ','MIRAFLORES',NULL,'oscar@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 3,'GLADYS REYES CORTIJO','SAN BORJA','875643562','gladys@hotmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 4,'SARA RIEGA FRIAS','SAN ISIDRO',NULL,'sara@yahoo.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 5,'JHON VELASQUEZ DEL CASTILLO','LOS OLIVOS','78645345','jhon@movistar.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 6,'RODRIGUEZ ROJAS, RENZO ROBERT','SURCO','673465235','rrodrigiez@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 7,'CALERO MORALES, EMELYN DALILA','LA MOLINA','896754652','ecalero@peru.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 8,'KAREN FUENTES','San Isidro','555-5555','KAFUENTES@HOTMAIL.COM');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES( 9,'Yamina Ruiz','San Isidro','965-4521','yami_ruiz@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES(10,'MARIA EULALIA VELASQUEZ TORVISCO','SURCO','6573456','mvelasques@gmail.com');

INSERT INTO ALUMNO (alu_id, alu_nombre, alu_direccion, alu_telefono, alu_email )
VALUES(11,'FIORELLA LIZET VITELLA REYES','SAN BORJA','5468790','fvitela@outlook.com');

commit;


-- ======================================================
-- RESTRICCIONES DE LA TABLA CURSO
-- ======================================================

-- CLAVE PRIMARIA

ALTER TABLE CURSO
	ADD CONSTRAINT pk_curso 
	PRIMARY KEY (cur_id);


-- El nombre del curso es único

ALTER TABLE CURSO
	ADD CONSTRAINT u_curso_nombre 
	UNIQUE (cur_nombre);


-- Vacantes mayor que cero

ALTER TABLE CURSO
	ADD CONSTRAINT  chk_curso_vacantes
	CHECK  ( cur_vacantes > 0 ); 


-- Matriculados mayor o igual que cero, y menor o igual que las vacantes

ALTER TABLE CURSO
	ADD CONSTRAINT  chk_curso_matriculados
	CHECK  ( cur_matriculados >= 0 AND cur_matriculados <= cur_vacantes ) ;


-- Precio mayor que cero
ALTER TABLE CURSO
	ADD CONSTRAINT  chk_curso_precio
	CHECK  ( cur_precio > 0 );



-- Matriculados por defecto es CERO

ALTER TABLE CURSO
  MODIFY cur_matriculados default 0;


-- Insertar Datos

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(1,'SQL Server Implementación',24,1000.0,'Gustavo coronel');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(2,'SQL Server Administración',24,1000.0,' ');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(3,'Inteligencia de Negocios',24,1500.0,'Sergio Matsukawa');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(4,'Programación Transact-SQL',24,1200.0,NULL);

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(5,'Java Fundamentos',24,1600.0,'Gustavo Coronel');

INSERT INTO CURSO(cur_id,cur_nombre,cur_vacantes,cur_precio,cur_profesor)
VALUES(6,'Java Cliente-Servidor',24,1600.0,'Gustavo Coronel');

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(7,'GESTION DE PROYECTOS',24,2200.0,'RICARDO MARCELO');

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(8,'ORACLE DATABASE SQL',24,2600.0,'GUSTAVO CORONEL');

INSERT INTO CURSO(CUR_ID,CUR_NOMBRE,CUR_VACANTES,CUR_PRECIO,CUR_PROFESOR)
VALUES(9,'ORACLE DATABASE PL-SQL',24,2600.0,'GUSTAVO CORONEL');

commit;


-- ======================================================
-- RESTRICCIONES DE LA TABLA MATRICULA
-- ======================================================

ALTER TABLE MATRICULA
	ADD CONSTRAINT PK_MATRICULA 
	PRIMARY KEY (cur_id,alu_id);


ALTER TABLE MATRICULA
	ADD CONSTRAINT FK_MATRICULA_CURSO 
	FOREIGN KEY (cur_id) 
	REFERENCES CURSO(cur_id);


ALTER TABLE MATRICULA
	ADD CONSTRAINT FK_MATRICULA_ALUMNO 
	FOREIGN KEY (alu_id) 
	REFERENCES ALUMNO(alu_id);


ALTER TABLE MATRICULA
	ADD CONSTRAINT  CHK_MATRICULA_PRECIO
	CHECK  ( MAT_PRECIO > 0.0 );


ALTER TABLE MATRICULA
	ADD CONSTRAINT  CHK_MATRICULA_CUOTAS
	CHECK  ( MAT_CUOTAS > 0 );


ALTER TABLE MATRICULA
	ADD CONSTRAINT  CHK_MATRICULA_NOTA
	CHECK  ( (MAT_NOTA = NULL) OR (MAT_NOTA BETWEEN 0 AND 20) );


DECLARE 

   anio VARCHAR(10);
   
BEGIN

  anio :=  to_char(sysdate, 'YYYY');

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(1, 5, to_date( anio || '0415 10:30','YYYYMMDD HH24:MI'), 800.0, 1, 15);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(1, 3, to_date( anio || '0416 11:45','YYYYMMDD HH24:MI'), 1000.0, 2, 18);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(1, 4, to_date( anio || '0418 08:33','YYYYMMDD HH24:MI'), 1200.0, 3, 12);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(2, 1, to_date( anio || '0415 12:33','YYYYMMDD HH24:MI'),800.0,1,16);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(2, 2, to_date( anio || '0501 15:34','YYYYMMDD HH24:MI'),1000.0,2,10);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(2, 3, to_date( anio || '0503 16:55','YYYYMMDD HH24:MI'), 1300.0, 3, 14);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(2, 4, to_date( anio || '0504 17:00','YYYYMMDD HH24:MI'), 400.0, 1, 18);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(2, 5, to_date( anio || '0506 13:12','YYYYMMDD HH24:MI'), 750.0, 1, 17);

  INSERT INTO MATRICULA ( cur_id, alu_id, mat_fecha, mat_precio, mat_cuotas, mat_nota ) 
  VALUES(3, 7, to_date( anio || '0602 13:12','YYYYMMDD HH24:MI'), 950.0, 2, 15);

END;
/


commit;

-- ======================================================
-- Actualizar la columna matriculados en la tabla curso
-- ======================================================

UPDATE CURSO
SET cur_matriculados = (
	SELECT COUNT(*) FROM MATRICULA
	WHERE MATRICULA.cur_id = CURSO.cur_id );

commit;	

-- ======================================================
-- RESTRICCIONES EN LA TABLA PAGO
-- ======================================================

-- Clave Primaria

ALTER TABLE PAGO
	ADD CONSTRAINT PK_PAGO 
	PRIMARY KEY (cur_id,alu_id,pag_cuota);


-- Clave Foránea

ALTER TABLE PAGO
	ADD CONSTRAINT FK_PAGO_MATRICULA 
	FOREIGN KEY (cur_id,alu_id) 
	REFERENCES MATRICULA(cur_id,alu_id);


-- Cargar Datos


DECLARE 

  anio VARCHAR(10);
   
BEGIN

  anio :=  to_char(sysdate, 'YYYY');
  
  insert into PAGO values(1,3,1,to_date( anio || '0406','YYYYMMDD'),500);
  insert into PAGO values(1,3,2,to_date( anio || '0516','YYYYMMDD'),500);
  insert into PAGO values(1,4,1,to_date( anio || '0418','YYYYMMDD'),400);
  insert into PAGO values(1,4,2,to_date( anio || '0518','YYYYMMDD'),400);
  insert into PAGO values(2,1,1,to_date( anio || '0415','YYYYMMDD'),800);
  insert into PAGO values(2,2,1,to_date( anio || '0501','YYYYMMDD'),500);
  insert into PAGO values(2,3,1,to_date( anio || '0503','YYYYMMDD'),430);
  insert into PAGO values(2,3,2,to_date( anio || '0603','YYYYMMDD'),430);
  insert into PAGO values(2,4,1,to_date( anio || '0504','YYYYMMDD'),400);
  insert into PAGO values(2,5,1,to_date( anio || '0506','YYYYMMDD'),750);

END;
/

commit;


-- ======================================================
-- FIN
-- ======================================================

select * from ALUMNO;
select * from CURSO;
select * from MATRICULA;
select * from PAGO;

