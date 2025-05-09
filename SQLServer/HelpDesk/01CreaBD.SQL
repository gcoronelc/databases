/*
Empresa          :  EGCC
Software         :  Sistema de Mesa de Ayuda (HelpDesk)
DBMS             :  SQL SERVER
Base de datos    :  HelpDeskDB
Script           :  Crea la base de datos con sus respectivas tablas.
Responsable      :  Dr. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Blog             :  http://gcoronelc.blogspot.com
Cursos virtuales :  https://gcoronelc.github.io/
Canal Youtube    :  https://www.youtube.com/DesarrollaSoftware
Creado el        :  09-MAY-2025
*/


-- =============================================
-- Base de Datos para Sistema de Mesa de Ayuda (Help Desk)
-- =============================================

USE master;
GO

-- Crear la base de datos
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HelpDeskDB')
BEGIN
    CREATE DATABASE HelpDeskDB;
END
GO


-- =============================================
-- Eliminar Tablas
-- =============================================

USE HelpDeskDB;
GO

DROP TABLE IF EXISTS SeguimientoTickets;
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS SLAs;
DROP TABLE IF EXISTS Prioridades;
DROP TABLE IF EXISTS Servicios;
DROP TABLE IF EXISTS TecnicoEspecialidades;
DROP TABLE IF EXISTS EspecialidadesTecnicos;
DROP TABLE IF EXISTS EstadosTicket;
DROP TABLE IF EXISTS Empleados;
DROP TABLE IF EXISTS CostosDepartamento;
DROP TABLE IF EXISTS Departamentos;
GO


-- =============================================
-- Tablas Catálogo
-- =============================================

-- Tabla de Departamentos
CREATE TABLE Departamentos (
    DepartamentoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255) NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    Activo INT DEFAULT 1
);
GO

-- Tabla de Estados de Tickets
CREATE TABLE EstadosTicket (
    EstadoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(255) NULL,
    ColorHexadecimal NVARCHAR(7) NULL, -- Para representación visual (ej: #FF0000 para rojo)
    Orden INT NOT NULL -- Para ordenar en la interfaz
);
GO

-- Tabla de Prioridades
CREATE TABLE Prioridades (
    PrioridadID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(255) NULL,
    TiempoRespuestaHoras INT NULL, -- Tiempo objetivo de respuesta
    ColorHexadecimal NVARCHAR(7) NULL -- Para representación visual
);
GO

-- Tabla de Servicios (Motivos de Tickets)
CREATE TABLE Servicios (
    ServicioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255) NULL,
    CostoEstimado DECIMAL(10, 2) NOT NULL, -- Costo asociado al servicio
    TiempoEstimadoHoras DECIMAL(5, 2) NULL, -- Tiempo estimado para resolver
    Activo INT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE()
);
GO

-- =============================================
-- Tablas Principales
-- =============================================

-- Tabla de Empleados (Usuarios del sistema)
CREATE TABLE Empleados (
    EmpleadoID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroEmpleado NVARCHAR(20) NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Apellidos NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    Telefono NVARCHAR(20) NULL,
    DepartamentoID INT NOT NULL,
    EsTecnico INT DEFAULT 0, -- Indica si es miembro del equipo de soporte
    FechaCreacion DATETIME DEFAULT GETDATE(),
    Activo INT DEFAULT 1,
    CONSTRAINT FK_Empleados_Departamento FOREIGN KEY (DepartamentoID) 
        REFERENCES Departamentos(DepartamentoID)
);
GO


-- Tabla de Especialidades de Técnicos
CREATE TABLE EspecialidadesTecnicos (
    EspecialidadID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255) NULL
);
GO

-- Tabla de relación muchos a muchos entre técnicos y especialidades
CREATE TABLE TecnicoEspecialidades (
    EmpleadoID INT NOT NULL,
    EspecialidadID INT NOT NULL,
    NivelExperiencia INT NULL, -- 1-5 donde 5 es experto
    FechaAsignacion DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (EmpleadoID, EspecialidadID),
    CONSTRAINT FK_TecnicoEspecialidades_Empleado FOREIGN KEY (EmpleadoID) 
        REFERENCES Empleados(EmpleadoID),
    CONSTRAINT FK_TecnicoEspecialidades_Especialidad FOREIGN KEY (EspecialidadID) 
        REFERENCES EspecialidadesTecnicos(EspecialidadID)
);
GO

-- Tabla de Tickets de Soporte
CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroTicket NVARCHAR(20) NOT NULL, -- Formato personalizable, ej: TK-2023-0001
    Titulo NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(MAX) NOT NULL,
    EmpleadoSolicitanteID INT NOT NULL, -- Quien genera el ticket
    DepartamentoSolicitanteID INT NOT NULL, -- Departamento del solicitante
    ServicioID INT NOT NULL, -- Motivo/Servicio solicitado
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    PrioridadID INT NOT NULL,
    EstadoID INT NOT NULL,
    TecnicoAsignadoID INT NULL, -- Técnico asignado (puede ser NULL inicialmente)
    ResponsableAsignacionID INT NULL, -- Quien asignó el ticket
    FechaAsignacion DATETIME NULL,
    FechaCierre DATETIME NULL,
    CostoFinal DECIMAL(10, 2) NULL, -- Puede diferir del costo estimado
    CalificacionServicio INT NULL, -- Valoración del 1-5
    ComentarioCalificacion NVARCHAR(500) NULL,
    CONSTRAINT FK_Tickets_EmpleadoSolicitante FOREIGN KEY (EmpleadoSolicitanteID) 
        REFERENCES Empleados(EmpleadoID),
    CONSTRAINT FK_Tickets_DepartamentoSolicitante FOREIGN KEY (DepartamentoSolicitanteID) 
        REFERENCES Departamentos(DepartamentoID),
    CONSTRAINT FK_Tickets_Servicio FOREIGN KEY (ServicioID) 
        REFERENCES Servicios(ServicioID),
    CONSTRAINT FK_Tickets_Prioridad FOREIGN KEY (PrioridadID) 
        REFERENCES Prioridades(PrioridadID),
    CONSTRAINT FK_Tickets_Estado FOREIGN KEY (EstadoID) 
        REFERENCES EstadosTicket(EstadoID),
    CONSTRAINT FK_Tickets_TecnicoAsignado FOREIGN KEY (TecnicoAsignadoID) 
        REFERENCES Empleados(EmpleadoID),
    CONSTRAINT FK_Tickets_ResponsableAsignacion FOREIGN KEY (ResponsableAsignacionID) 
        REFERENCES Empleados(EmpleadoID)
);
GO


-- Tabla de Seguimiento de Tickets (Historial)
CREATE TABLE SeguimientoTickets (
    SeguimientoID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL,
    EmpleadoID INT NOT NULL, -- Quién registró el seguimiento
    Comentario NVARCHAR(MAX) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    EstadoAnteriorID INT NULL,
    EstadoNuevoID INT NULL,
    TiempoInvertidoMinutos INT NULL, -- Tiempo dedicado a esta actividad
    Privado INT DEFAULT 0, -- Si es TRUE, solo visible para técnicos
    CONSTRAINT FK_SeguimientoTickets_Ticket FOREIGN KEY (TicketID) 
        REFERENCES Tickets(TicketID),
    CONSTRAINT FK_SeguimientoTickets_Empleado FOREIGN KEY (EmpleadoID) 
        REFERENCES Empleados(EmpleadoID),
    CONSTRAINT FK_SeguimientoTickets_EstadoAnterior FOREIGN KEY (EstadoAnteriorID) 
        REFERENCES EstadosTicket(EstadoID),
    CONSTRAINT FK_SeguimientoTickets_EstadoNuevo FOREIGN KEY (EstadoNuevoID) 
        REFERENCES EstadosTicket(EstadoID)
);
GO

-- =============================================
-- Tablas para Métricas y Análisis de Costos
-- =============================================

-- Tabla para SLAs (Acuerdos de Nivel de Servicio)
CREATE TABLE SLAs (
    SLAID INT IDENTITY(1,1) PRIMARY KEY,
    ServicioID INT NOT NULL,
    PrioridadID INT NOT NULL,
    TiempoRespuestaHoras INT NOT NULL,
    TiempoResolucionHoras INT NOT NULL,
    CONSTRAINT FK_SLAs_Servicio FOREIGN KEY (ServicioID) 
        REFERENCES Servicios(ServicioID),
    CONSTRAINT FK_SLAs_Prioridad FOREIGN KEY (PrioridadID) 
        REFERENCES Prioridades(PrioridadID),
    CONSTRAINT UQ_SLAs_ServicioPrioridad UNIQUE (ServicioID, PrioridadID)
);
GO

-- Tabla para Costos Mensuales por Departamento
CREATE TABLE CostosDepartamento (
    CostoID INT IDENTITY(1,1) PRIMARY KEY,
    DepartamentoID INT NOT NULL,
    Mes INT NOT NULL,
    Ano INT NOT NULL,
    CostoTotal DECIMAL(12, 2) NOT NULL,
    NumeroTickets INT NOT NULL,
    FechaCalculo DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_CostosDepartamento_Departamento FOREIGN KEY (DepartamentoID) 
        REFERENCES Departamentos(DepartamentoID),
    CONSTRAINT UQ_CostosDepartamento_MesAno UNIQUE (DepartamentoID, Mes, Ano)
);
GO


