-- Empresa        :  EduTec
-- Producto       :  Cursos de Extensión Profesional                   (CEP)
-- Software       :  Administración de Cursos de Extensión Profesional (ACEP)
-- DBMS           :  SQL Server
-- Base de Datos  :  EduTec
-- Script         :  Crea los objetos de la base de datos y carga datos de prueba
-- Responsable    :  Eric Gustavo Coronel Castillo
--                   Email: gcoronelc@gmail.com
--                   blog: gcoronelc.blogspot.com
--                   Canal: www.youtube.com/DesarrollaSoftware
--                   Site: www.desarrollasoftware.com
-- Creado por     :  Club de los Jueves
--                   Guino Henostroza, Sergio Matsukawa, 
--                   Cesar Bustamante, Gustavo Coronel
--                   Enero 1999
-- Actualizaciones:  
--   Febrero, 2010 - Gustavo Coronel
--   Diciembre, 2012 - Gustavo Coronel  
--     Genera datos para muchos mas años
--   Enero, 2013 - Gustavo Coronel
--     La columna IdProfesor acepta valor nulos en la tabla CursoProgramado
--   Setiembre, 2013 - Gustavo Coronel
--     Se modifico la tabla Tarifa, se gregaron las columnas:
--        Horas: Horas de duración del curso
--        PagoHora: Pago por hora al profesor
--     Se modifico la columna PreTarifa x PrecioVenta

---------------------------------------------------------------------------------
-- Creación de la Base de Datos
---------------------------------------------------------------------------------

set nocount on
go

Use Master
go

If NOT Exists ( Select Name From sysDatabases Where Name = 'EduTec' )
	Create DataBase EduTec
go

Use EduTec
go


---------------------------------------------------------------------------------
-- Verificando la existencia de las tablas
---------------------------------------------------------------------------------

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'matricula' )
   DROP TABLE matricula

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'cursoprogramado' )
   DROP TABLE cursoprogramado

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'curso' )
   DROP TABLE curso

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'tarifa' )
   DROP TABLE tarifa

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'profesor' )
   DROP TABLE profesor

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'ciclo' )
   DROP TABLE ciclo

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'alumno' )
   DROP TABLE alumno

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'empleado' )
   DROP TABLE empleado

IF EXISTS ( SELECT name FROM sysobjects
   WHERE type = 'U' AND name = 'parametro' )
   DROP TABLE parametro

GO


---------------------------------------------------------------------------------
-- Creación de las Tablas y Claves Primarias
---------------------------------------------------------------------------------

CREATE TABLE dbo.Alumno (
       IdAlumno             char(5) NOT NULL,
       ApeAlumno            varchar(30) NOT NULL,
       NomAlumno            varchar(30) NOT NULL,
       DirAlumno            varchar(50) NULL,
       TelAlumno            varchar(20) NULL,
       EmailAlumno          varchar(40) NOT NULL UNIQUE,
       Clave                varchar(15) NOT NULL
)
go


ALTER TABLE dbo.Alumno
	ADD Constraint PK_Alumno
	PRIMARY KEY (IdAlumno)
go


CREATE TABLE dbo.Ciclo (
       IdCiclo              char(7) NOT NULL,
       FecInicio            datetime NULL,
       FecTermino           datetime NULL
)
go


ALTER TABLE dbo.Ciclo
	ADD Constraint PK_Ciclo
	PRIMARY KEY (IdCiclo)
go


CREATE TABLE dbo.Curso (
       IdCurso              char(4) NOT NULL,
       IdTarifa             char(1) NOT NULL,
       NomCurso             varchar(50) NOT NULL
)
go


ALTER TABLE dbo.Curso
	ADD Constraint PK_Curso
	PRIMARY KEY (IdCurso)
go


CREATE TABLE dbo.CursoProgramado (
       IdCursoProg          int IDENTITY,
       IdCurso              char(4) NOT NULL,
       IdCiclo              char(7) NOT NULL,
       IdProfesor           char(4) NULL,
       Vacantes             numeric(3) NOT NULL DEFAULT 20,
       Matriculados         numeric(3) NOT NULL DEFAULT 0,
       PreCursoProg         money NOT NULL,
       Horario              varchar(30) NOT NULL,
       Activo               numeric(1) NOT NULL DEFAULT 1
                                   CHECK (Activo IN (0, 1)),

)
go



ALTER TABLE dbo.CursoProgramado
	ADD Constraint PK_CursoProgramado
	PRIMARY KEY (IdCursoProg)
go


CREATE TABLE dbo.Empleado (
       IdEmpleado           char(6) NOT NULL,
       Clave                varchar(15) NOT NULL,
       ApeEmpleado          varchar(30) NOT NULL,
       NomEmpleado          varchar(30) NOT NULL,
       Cargo                varchar(25) NOT NULL,
       DirEmpleado          varchar(50) NULL,
       TelEmpleado          varchar(20) NULL,
       EmailEmpleado        varchar(40) NOT NULL UNIQUE
)
go


ALTER TABLE dbo.Empleado
	ADD Constraint PK_Empleado
	PRIMARY KEY (IdEmpleado)
go


CREATE TABLE dbo.Matricula (
       IdCursoProg          int NOT NULL,
       IdAlumno             char(5) NOT NULL,
       FecMatricula         datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
       ExaParcial           numeric(4,2) NULL,
       ExaFinal             numeric(4,2) NULL,
       Promedio             numeric(4,2) NULL,
       Subsanacion          numeric(1) NOT NULL DEFAULT 0
                                   CHECK (Subsanacion IN (0, 1)),
       ExaSub               numeric(4,2) NULL
)
go


ALTER TABLE dbo.Matricula
	ADD Constraint PK_Matricula
	PRIMARY KEY (IdCursoProg, IdAlumno)
go


CREATE TABLE dbo.Parametro (
       Campo                varchar(10) NOT NULL,
       Contador             int NOT NULL
)
go


ALTER TABLE dbo.Parametro
	ADD Constraint PK_Parametro
	PRIMARY KEY (Campo)
go


CREATE TABLE dbo.Profesor (
	IdProfesor           char(4) NOT NULL,
	ApeProfesor          varchar(30) NOT NULL,
	NomProfesor          varchar(30) NOT NULL,
	DirProfesor          varchar(50) NULL,
	TelProfesor          varchar(20) NULL,
	EmailProfesor        varchar(40) NULL UNIQUE,
	Clave                varchar(15) NOT NULL
)
go


ALTER TABLE dbo.Profesor
	ADD Constraint PK_Profesor
	PRIMARY KEY (IdProfesor)
go


CREATE TABLE dbo.Tarifa (
	IdTarifa             char(1)  NOT NULL ,
	PrecioVenta          money  NOT NULL ,
	Descripcion          varchar(50)  NOT NULL ,
	Horas                integer  NOT NULL ,
	PagoHora             money  NOT NULL 
)
go


ALTER TABLE dbo.Tarifa
	ADD Constraint PK_Tarifa
	PRIMARY KEY (IdTarifa)
go


---------------------------------------------------------------------------------
-- Creación de Claves Foráneas
---------------------------------------------------------------------------------

ALTER TABLE dbo.Curso
	ADD Constraint FK_Curso_Tarifa
	FOREIGN KEY (IdTarifa)
	REFERENCES Tarifa
go


ALTER TABLE dbo.CursoProgramado
	ADD Constraint FK_CursoProgramado_Ciclo
	FOREIGN KEY (IdCiclo)
	REFERENCES Ciclo
go


ALTER TABLE dbo.CursoProgramado
	ADD Constraint FK_CursoProgramado_Curso
	FOREIGN KEY (IdCurso)
	REFERENCES Curso
go


ALTER TABLE dbo.CursoProgramado
	ADD Constraint FK_CursoProgramado_Profesor
	FOREIGN KEY (IdProfesor)
	REFERENCES Profesor
go


ALTER TABLE dbo.Matricula
	ADD Constraint FK_Matricula_CursoProgramado
	FOREIGN KEY (IdCursoProg)
	REFERENCES CursoProgramado
go


ALTER TABLE dbo.Matricula
	ADD Constraint FK_Matricula_Alumno
	FOREIGN KEY (IdAlumno)
	REFERENCES Alumno
go


---------------------------------------------------------------------------------
-- Carga Datos de Prueba
---------------------------------------------------------------------------------


-- Determina los Años para el ingreso de datos

Declare @cAnno Char( 4 ), @iAnno Int, @iCantAnios Int
Create Table #Tabla ( Id Int, Anno Char(4) )

Set @iAnno = Year(getdate())
Set @iCantAnios = 40

while ( @iCantAnios > 0 )
begin

	Set @cAnno = Convert( VarChar(4), @iAnno )
	Insert Into #Tabla Values ( @iCantAnios, @cAnno )
	Set @iAnno = @iAnno - 1
	set @iCantAnios = @iCantAnios - 1

end;

select * from #tabla;
go

-- Agragar Datos a la Tabla Tarifa

Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('A',400,'Herramientas de Oficina',24,40)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('B',500,'SoftWare de Desarrollo - Basico',30,50)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('C',700,'SoftWare de Desarrollo - Intermedio/Avanzado',30,70)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('D',500,'Sistemas Operativos - Intermedio/Avanzado',24,50)
Insert Into Tarifa(IdTarifa,PrecioVenta,Descripcion,Horas,PagoHora) Values('E',700,'Administradores de Bases de Datos',30,60)
go

-- Agragar Datos a la Tabla Curso

Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C001','A','SO Windows')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C002','B','Visual Basic .NET - Fundamentos')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C003','C','Visual Basic .NET - Cliente/Servidor')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C004','C','Visual Basic .NET - Web')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C005','B','Java - POO')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C006','C','Java - Cliente/Servidor')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C007','C','Java - Web')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C008','C','Java - Frameworks')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C009','B','PHP - Fundamentos')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C010','C','PHP - POO')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C011','C','PHP - Frameworks')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C012','B','C# - POO')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C013','C','C# - Web Services')
Insert Into Curso(IdCurso,IdTarifa,NomCurso) Values('C014','C','Java - Web Services')

go

-- Agregar Datos a la Tabla Ciclo

Declare @cAnno Char(4), @k Int, @total_anios int;
select @total_anios = count(*) from #Tabla;
Set @k = 1;
While @k <= @total_anios
Begin
	Select @cAnno = Anno From #Tabla Where Id = @k
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-01', @cAnno + '0103', @cAnno + '0130')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-02', @cAnno + '0202', @cAnno + '0228')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-03', @cAnno + '0305', @cAnno + '0330')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-04', @cAnno + '0402', @cAnno + '0430')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-05', @cAnno + '0503', @cAnno + '0530')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-06', @cAnno + '0605', @cAnno + '0630')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-07', @cAnno + '0704', @cAnno + '0730')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-08', @cAnno + '0802', @cAnno + '0830')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-09', @cAnno + '0903', @cAnno + '0930')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-10', @cAnno + '1002', @cAnno + '1030')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-11', @cAnno + '1103', @cAnno + '1130')
	Insert Into Ciclo(IdCiclo,FecInicio,FecTermino) Values(@cAnno + '-12', @cAnno + '1201', @cAnno + '1230')
	Set @k = @k + 1
End
go


-- Agragar Datos a la Tabla Profesor

Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P001','Valencia Morales','Pedro Hugo','Magdalena','984567234','hugovm@terra.com.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P002','Coronel Castillo','Eric Gustavo','Los Olivos','None','gcoronel@uni.edu.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P003','Diaz Vilela','Pedro Pablo','Rimac','None','pdiaz@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P004','Matsukawa Maeda','Sergio','Bella Vista','None','smatsukawa@isil.edu.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P005','Bustamante Gutierrez','Cesar Augusto','Lince','None','cbustamente@ipeci.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P006','Henostroza Macedo','Guino','Los Olivos','934784092','guinoh@hotmail.com','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P007','Flores Manco','Julio Enrrique','Los Olivos','None','jflores@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P008','Bardon Mayta','Julio Cesar','SMP','None','jbardon@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P009','Allauca Paucar','Juan Jose','Los Olivos','None','jallauca@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P010','Serna Jherry','Jose Luis','SMP','None','jserna@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P011','Chuco Barrera','Raul','Rimac','None','rchuco@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P012','Alegre Mendoza','Jose','SMP','None','jalegre@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P013','Quispe Tineo','Cesar','SMP','None','cquispe@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P014','Ramirez Salvador','Julio','SMP','None','jramirez@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P015','Chuquin Espinoza','Willian','Lince','None','wchuquin@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P016','Rosas Ayala','Dario','Rimac','943761238','drosas@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P017','Rodriguez Villacorta','Manuel','Lima','None','mrodriguez@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P018','Zegarra Zavaleta','Tereza','SMP','None','tzegarra@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P019','Guzman Azcurra','Manuel','Rimac','None','mguzman@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P020','Zegarra Zavaleta','Daniel','SMP','None','dzagarra@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P021','Cueva Contreras','Martin','Rimac','984326934','mcueva@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P022','Lostaunau Navarro','Alberto','Lima','None','alostaunau@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P023','Condor Ortiz','Saul','SMP','None','scondor@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P024','Ganoza Zelada','David','Comas','None','dganoza@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P025','Fabian Avila','Dionicio','Comas','923567095','dfabian@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P026','Quintana Saenz','Jorge','Rimac','None','jquintana@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P027','Yupanqui Villegas','Juan','SMP','None','juan.yupanqui@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P028','Yupanqui Villegas','Julio','SMP','None','julio.yupanqui@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P029','Alcantara Cerna','Violeta','SMP','None','valcantara@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P030','Oceda Samaniego','Cesar Miguel','San Miguel','None','coceda@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P031','Becerra Flores','Ursula','San Miguel','978954222','ubecerra@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P032','Marcelo Villalobos','Marvin','Lince','None','mmarcelo@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P033','Narvaez Garcia','Victor','Lima','None','vnarcaez@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P034','Reynoso Zarate','Jose','Los Olivos','None','jreynoso@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P035','Suarez Valenzuela','Misael','Lima','None','msuarez@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P036','Carrasco Muñoz','Joel','Rimac','None','jcarrasco@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P037','Salcedo Martinez','Percy','Lima','939765232','psalcedo@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P038','Vasquez Valenzuela','Javier','Comas','None','jvasquez@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P039','Herrera Huanca','Javier','Comas','None','jherrera@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P040','Marcelo Villalobos','Ricardo','SMP','999777666','rmarcelo@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P041','Quiroz Villon','Edgar','Rimac','None','equiroz@edutec.pe','123456')
Insert Into Profesor(IdProfesor,ApeProfesor,NomProfesor,DirProfesor,TelProfesor,EmailProfesor,Clave) Values ('P042','Veliz','Fortumato','La Molina','None','fveliz@edutec.pe','123456')
go


-- Agregar Datos a la Tabla Alumno

Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0001','Donayre Mena','Christian','cdonayre@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0002','Ortiz Rodriguez','Freddy','fortiz@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0003','Silva Mejia','Ruth Ketty','ksilva@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0004','Melendez Noriega','Liliana','lmelendez@uni.edu.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0005','Huerta Leon','Silvia','shuerta@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0006','Carranza Fuentes','Maria Elena','ecarravza@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0007','Prado Castro','Gabriela','gprado@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0008','Atuncar Mesias','Juan','jatuncar@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0009','Aguilar Zavala','Patricia Elena','paguilar@yahoo.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0010','Rodriguez Trujillo','Rubén Eduardo','rrodriguez@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0011','Canales Ruiz','Gino Leonel','gcanales@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0012','Ruiz Quispe','Edgar','eruiz@terra.com.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0013','Panduro Terrazas','Omar','opanduro@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0014','Zita Padilla','Peter Wilmer','pzita@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0015','Ternero Ubillús','Luis','lternero@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0016','Rivera García','Raúl Joel','rrivera@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0017','Pomar García','Ana','apomar@terra.com.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0018','Palomares Venegas','Mercedes','mpalomares@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0019','Ruiz Venegaz','Luis Alberto','lruiz@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0020','Tejada Bernal','Janet','jtejada@uni.edu.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0021','Sotelo Canales','Juan Carlos','jsotelo@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0022','LLosa Montalvan','Karla','kllosa@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0023','Galarza Torres','Hugo','hgalarza@yahoo.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0024','Valverde Jaramillo','Saul','svalverde@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0025','Cipriano Avila','Roxana','rcipriano@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0026','Rodriguez Quispe','Luis Alberto','lrodriguez@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0027','Huerta Leon','Marco Antonio','mhuerta@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0028','Ortiz Fuentes','Ana María','aortiz@yahoo.es','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0029','Rivera Jaramillo','Martha','mrivera@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0030','Bustamante Campos','Guino','gbustamante@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0031','Barreto Rodríguez', 'Carlos Miguel','cbarreto@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0032','Borja Gutti', 'José Miguel','jborja@uni.edu.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0033','Espinoza De La Cruz', 'Ronny Cesar','respinoza@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0034','Gómez Cáceres', 'Pedro Pablo','pgomez@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0035','Gómez Manzano', 'José Alfonso','jgomez@elcomercio.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0036','Herrera Farfán', 'Carlos Alberto','cherrera@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0037','Huamanyauri Cuellar', 'David Roger','dhuamanyauri@ipae.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0038','La Pierre Gutiérrez', 'Nathalie Aurora','nlapierre@telefonica.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0039','Lema Gutiérrez', 'Katia','klema@ibm.com.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0040','Leon Castro', 'Cesar Rómulo','cleon@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0041','Manzanal Castro', 'Antonio Javier','amanzanal@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0042','Morí Pezantes', 'James Gustavo','jmori@elcomercio.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0043','Murillo Sánchez', 'Cesar Noe','cmurillo@ipae.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0044','Ramírez Molina', 'Patricia Roxana','pramirez@elcomercio.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0045','Sakamoto Ysla', 'David Augusto','dsakamoto@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0046','Torres Mejia', 'Maria Elsa','mtorres@elcomercio.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0047','Ubillus Claudet', 'Juan Eliécer','jubillus.ibm.com.pe','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0048','Val Del Carpio', 'Silvia Verónica','sval@gmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0049','Venturi Díaz', 'Ismael Martín','iventuri@peru.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0050','Vera Pozo', 'Iván José Luis','ivera@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0051','Arbieto Chavez', 'Julio César','jarbieto@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0052','Ramirez Linares', 'Max Alberto','mramirez@hotmail.com','123456')
Insert Into alumno(IdAlumno,ApeAlumno,NomAlumno,EmailAlumno,Clave) Values('A0053','Aquino Chero', 'Flor de Maria','faquino@hotmail.com','123456')
go

-- Agregar Datos a la Tabla Empleado

Insert Into Empleado(IdEmpleado,Clave,ApeEmpleado,NomEmpleado,Cargo,EmailEmpleado) Values('psalce','psalce','Salcedo Banderas','Percy','Gerente Ventas','psalcedo@edutec.pe')
Insert Into Empleado(IdEmpleado,Clave,ApeEmpleado,NomEmpleado,Cargo,EmailEmpleado) Values('lcastr','lcastr','Castro Escobar','Lidia Rosa','Secretaria General','lcastro@edutec.pe')
Insert Into Empleado(IdEmpleado,Clave,ApeEmpleado,NomEmpleado,Cargo,EmailEmpleado) Values('jmanrr','jmanrr','Manrique Diaz','José Luis','Coordinador Academico','jmanrique@edutec.pe')
Insert Into Empleado(IdEmpleado,Clave,ApeEmpleado,NomEmpleado,Cargo,EmailEmpleado) Values('jramir','jramir','Ramirez Salvador','Julio Cesar','Administrador General','jramirez@edutec.pe')
Insert Into Empleado(IdEmpleado,Clave,ApeEmpleado,NomEmpleado,Cargo,EmailEmpleado) Values('acampo','acampo','Campos Huapaya','Alberto','Jefe de Seguridad','acampos@edutec.pe')
Insert Into Empleado(IdEmpleado,Clave,ApeEmpleado,NomEmpleado,Cargo,EmailEmpleado) Values('beteta','beteta','Beteta Bustamante','Cesar','Gerente General','cbeteta@edutec.pe')
go

-- Agregar Datos a la Tabla Parametro

Declare @Cont Int
Insert Into Parametro(Campo,Contador) Values( 'Anio', Year( GetDate() ) )
Insert Into Parametro(Campo,Contador) Values( 'NroCiclo', 12 )
Select @Cont = Count(*) From Curso
Insert Into Parametro(Campo,Contador) Values( 'IdCurso', @Cont )
Select @Cont = Count(*) From Profesor
Insert Into Parametro(Campo,Contador) Values( 'IdProfesor', @Cont )
Select @Cont = Count(*) From Alumno
Insert Into Parametro(Campo,Contador) Values( 'IdAlumno',  @Cont )
go


-- Agregar Datos a la Tabla CursoProgramado

Declare @IdCiclo Char(7),   @NCursos    Int,      @NProfesores Int
Declare @IdCurso Char(4),   @IdProfesor Char(4),  @Precio      Money
Declare @Cont    Int,       @Id         Int,      @Horario     VarChar(24)

DECLARE cur_ciclos CURSOR FOR SELECT IdCiclo FROM Ciclo

Select @NCursos = Count(*) From Curso
Select @NProfesores = Count(*) From Profesor
OPEN cur_ciclos

FETCH NEXT FROM cur_Ciclos INTO @IdCiclo -- Lee el Primer Ciclo
WHILE @@FETCH_STATUS = 0 -- Mientras la lectura es correcta, procesar
BEGIN

	Set @Cont = Rand() * 15 + 10
	While ( @Cont > 0 )
	Begin
		-- Codigo del Curso
		Set @Id = Rand() * @NCursos + 1
		Set @IdCurso = 'C' + Right ( '000' + Convert( VarChar(3), @Id ), 3 )
		-- Precio del Curso
		Select @Precio = PrecioVenta From Tarifa 
			Where IdTarifa = ( Select IdTarifa From Curso Where IdCurso = @IdCurso )
		-- Codigo del Profesor
		Set @Id = Round( Rand() * @NProfesores, 0, 1) + 1
		Set @IdProfesor = 'P' + Right ( '000' + Convert( VarChar(3), @Id ), 3 )
		-- Horario
		Set @Id = Rand() * 4 + 1
		Set @Horario = Case @Id
			When 1 Then 'Lu y Mi 19-22'
			When 2 Then 'Ma y Ju 19-22'
			When 3 Then 'Vi y Sa 19-22'
			When 4 Then 'Ju 19-22 y Sa 08-11'
			Else 'Vi 19-22 y Sa 11-14'
		End
		-- Insertar el Registro
		Insert Into CursoProgramado( IdCiclo,IdCurso,IdProfesor,Horario,Vacantes,Matriculados,Activo,PreCursoProg )
			Values ( @IdCiclo, @IdCurso, @IdProfesor, @Horario, 20, 0, 1, @Precio )
		-- Disminuir el valor del contador
		Set @Cont = @Cont - 1
	End

   -- Lee el Siguiente Ciclo
	FETCH NEXT FROM cur_Ciclos INTO @IdCiclo
END

CLOSE cur_ciclos
DEALLOCATE cur_ciclos
GO

-- Matricular Alumnos

Declare @NAlumnos Int,       @Cont     Int,       @Id          Int
Declare @Parcial  Real,      @Final    Real,      @Prom        Real
Declare @Ok       Int,       @IdAlumno Char(5),   @IdCursoProg Int
Declare @Fecha    DateTime,  @FecMat   DateTime,  @IdCiclo     char(7)

Select @NAlumnos = Count(*) From Alumno
DECLARE cur_curso CURSOR FOR SELECT IdCursoProg, IdCiclo FROM dbo.CursoProgramado
OPEN cur_curso

FETCH NEXT FROM cur_Curso INTO @IdCursoProg, @IdCiclo -- Lee el Primer Curso Programado
WHILE @@FETCH_STATUS = 0 -- Mientras la lectura es correcta, procesar
BEGIN

	-- Estableciendo el limite de la fecha de matricula
	Select @Fecha = FecInicio from dbo.Ciclo where IdCiclo = @IdCiclo
	set @Fecha = @Fecha + 7

	-- Determina el número de matriculados
	Set @Cont = Rand() * 14 + 7 

	WHILE (@Cont > 0) 
	BEGIN
		-- Determina Código del Alumno
		Set @Ok = 0
		WHILE (@Ok = 0) -- Garantiza que el alumno aun no esta matriculado
		BEGIN
			Set @Id = Rand() * @NAlumnos + 1
			Set @IdAlumno = 'A' + Right( '0000' + Convert( VarChar(4), @Id ), 4 )
			If Not Exists ( Select 1 From Matricula Where IdCursoProg = @IdCursoProg And IdAlumno = @IdAlumno )
				Set @Ok = 1
		END
		-- Notas
		Set @Parcial = Rand() * 19 + 1
		Set @Final   = Rand() * 19 + 1
		Set @Prom    = ( @Parcial + @Final ) / 2
		-- Fecha de matricula
		set @FecMat = @Fecha - RAND() * 30
		-- Insertar Registro
		Insert Into Matricula ( IdCursoProg, IdAlumno, FecMatricula, ExaParcial, ExaFinal, Promedio ) 
		Values ( @IdCursoProg, @IdAlumno, @FecMat, @Parcial, @Final, @Prom )
		-- Disminuye Contador
		Set @Cont = @Cont - 1
	END
	FETCH NEXT FROM cur_Curso INTO @IdCursoProg, @IdCiclo -- Lee el Siguiente Curso Programado
END
CLOSE cur_curso       -- Cierra el cursor
DEALLOCATE cur_curso  -- Destruye el cursor
go

-- Actualizar Tabla CursoProgramado

Update CursoProgramado
	Set Matriculados = ( Select Count(*) From Matricula
		Where Matricula.IdCursoProg = CursoProgramado.IdCursoProg )
go

Update CursoProgramado
	Set Vacantes = Vacantes - Matriculados
go

-- Eliminar Tabla Temporal
Drop Table #Tabla
go


-- Mensaje Final
print 'Proceso Finalizado'
