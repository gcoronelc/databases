/*
Empresa          :  EGCC
Software         :  Sistema de Mesa de Ayuda (HelpDesk)
DBMS             :  SQL SERVER
Base de datos    :  HelpDeskDB
Script           :  Carga datos de prueba
Responsable      :  Dr. Eric Gustavo Coronel Castillo
Email            :  gcoronelc@gmail.com
Blog             :  http://gcoronelc.blogspot.com
Cursos virtuales :  https://gcoronelc.github.io/
Canal Youtube    :  https://www.youtube.com/DesarrollaSoftware
Creado el        :  09-MAY-2025
*/

-- =====================================================================
-- Script de Generación de Datos de Prueba para Sistema de Mesa de Ayuda
-- =====================================================================

USE HelpDeskDB;
GO

-- Limpiar datos existentes (si se ejecuta varias veces)
DELETE FROM SeguimientoTickets;
DELETE FROM Tickets;
DELETE FROM TecnicoEspecialidades;
DELETE FROM CostosDepartamento;
DELETE FROM Empleados;
DELETE FROM EspecialidadesTecnicos;
DELETE FROM SLAs;
DELETE FROM Prioridades;
DELETE FROM Servicios;
DELETE FROM EstadosTicket;
DELETE FROM Departamentos;
GO


-- Restablecer los identity
DBCC CHECKIDENT ('SeguimientoTickets', RESEED, 0);
DBCC CHECKIDENT ('Tickets', RESEED, 0);
DBCC CHECKIDENT ('Empleados', RESEED, 0);
DBCC CHECKIDENT ('EspecialidadesTecnicos', RESEED, 0);
DBCC CHECKIDENT ('CostosDepartamento', RESEED, 0);
DBCC CHECKIDENT ('SLAs', RESEED, 0);
DBCC CHECKIDENT ('Prioridades', RESEED, 0);
DBCC CHECKIDENT ('Servicios', RESEED, 0);
DBCC CHECKIDENT ('EstadosTicket', RESEED, 0);
DBCC CHECKIDENT ('Departamentos', RESEED, 0);
GO

-- =============================================
-- Inserción de Datos de Catálogo Iniciales
-- =============================================

-- Insertar estados de ticket
INSERT INTO EstadosTicket (Nombre, Descripcion, ColorHexadecimal, Orden)
VALUES 
('Nuevo', 'Ticket recién creado, pendiente de asignación', '#3498db', 1),
('Asignado', 'Ticket asignado a un técnico', '#f39c12', 2),
('En Progreso', 'El técnico está trabajando en el ticket', '#9b59b6', 3),
('En Espera', 'Esperando respuesta del usuario o terceros', '#e67e22', 4),
('Resuelto', 'La solución ha sido implementada', '#2ecc71', 5),
('Cerrado', 'Ticket finalizado y aceptado por el usuario', '#27ae60', 6),
('Cancelado', 'El ticket ha sido cancelado', '#95a5a6', 7);
GO


-- Insertar prioridades
INSERT INTO Prioridades (Nombre, Descripcion, TiempoRespuestaHoras, ColorHexadecimal)
VALUES 
('Crítica', 'Afecta a toda la organización o detiene procesos críticos', 1, '#e74c3c'),
('Alta', 'Afecta a múltiples usuarios o un departamento completo', 4, '#e67e22'),
('Media', 'Afecta a un usuario o proceso pero tiene alternativa', 8, '#f1c40f'),
('Baja', 'No es urgente, puede esperar', 24, '#3498db');
GO

-- Insertar departamentos (incluyendo el de sistemas)
INSERT INTO Departamentos (Nombre, Descripcion)
VALUES 
('Sistemas', 'Departamento de TI y Soporte Técnico'),
('Recursos Humanos', 'Gestión de personal y contrataciones'),
('Contabilidad', 'Finanzas y contabilidad'),
('Ventas', 'Equipo comercial y ventas'),
('Operaciones', 'Operaciones diarias y logística'),
('Marketing', 'Publicidad y promoción'),
('Dirección', 'Gerencia y directivos');
GO

-- Insertar servicios con sus costos
INSERT INTO Servicios (Nombre, Descripcion, CostoEstimado, TiempoEstimadoHoras)
VALUES 
('Soporte Hardware', 'Problemas con equipos físicos', 75.00, 2.0),
('Soporte Software', 'Problemas con aplicaciones', 50.00, 1.5),
('Instalación de Software', 'Instalación de programas solicitados', 30.00, 1.0),
('Configuración de Red', 'Problemas de conectividad', 60.00, 2.0),
('Recuperación de Datos', 'Recuperar archivos perdidos', 150.00, 4.0),
('Creación de Cuentas', 'Nuevas cuentas de sistema', 25.00, 0.5),
('Cambio de Contraseña', 'Reset de credenciales', 15.00, 0.25),
('Mantenimiento Preventivo', 'Revisión y limpieza de equipos', 90.00, 3.0),
('Gestión de Permisos', 'Modificación de accesos', 20.00, 0.5),
('Capacitación', 'Entrenamiento en herramientas', 120.00, 4.0);
GO


-- ========================================================
-- Insertar datos de SLAs (Acuerdos de Nivel de Servicio)
-- ========================================================

INSERT INTO SLAs (ServicioID, PrioridadID, TiempoRespuestaHoras, TiempoResolucionHoras)
VALUES 
    (1, 1, 1, 4),    -- Soporte Hardware, Crítica: 1h respuesta, 4h resolución
    (1, 2, 2, 8),    -- Soporte Hardware, Alta: 2h respuesta, 8h resolución
    (1, 3, 4, 24),   -- Soporte Hardware, Media: 4h respuesta, 24h resolución
    (1, 4, 8, 48),   -- Soporte Hardware, Baja: 8h respuesta, 48h resolución
 
    (2, 1, 1, 4),    -- Soporte Software, Crítica
    (2, 2, 2, 8),    -- Soporte Software, Alta
    (2, 3, 4, 24),   -- Soporte Software, Media
    (2, 4, 8, 48),   -- Soporte Software, Baja
    
    (3, 1, 2, 8),    -- Instalación Software, Crítica
    (3, 2, 4, 12),   -- Instalación Software, Alta
    (3, 3, 8, 24),   -- Instalación Software, Media
    (3, 4, 12, 72),  -- Instalación Software, Baja
    
    (4, 1, 1, 4),    -- Configuración Red, Crítica
    (4, 2, 2, 8),    -- Configuración Red, Alta
    (4, 3, 4, 24),   -- Configuración Red, Media
    (4, 4, 8, 48),   -- Configuración Red, Baja
    
    (5, 1, 2, 12),   -- Recuperación Datos, Crítica
    (5, 2, 4, 24),   -- Recuperación Datos, Alta
    (5, 3, 8, 48),   -- Recuperación Datos, Media
    (5, 4, 24, 96),  -- Recuperación Datos, Baja
    
    (6, 1, 2, 4),    -- Creación Cuentas, Crítica
    (6, 2, 4, 8),    -- Creación Cuentas, Alta
    (6, 3, 8, 24),   -- Creación Cuentas, Media
    (6, 4, 24, 48),  -- Creación Cuentas, Baja
    
    (7, 1, 1, 2),    -- Cambio Contraseña, Crítica
    (7, 2, 2, 4),    -- Cambio Contraseña, Alta
    (7, 3, 4, 8),    -- Cambio Contraseña, Media
    (7, 4, 8, 24),   -- Cambio Contraseña, Baja
    
    (8, 1, 4, 24),   -- Mantenimiento Preventivo, Crítica
    (8, 2, 8, 48),   -- Mantenimiento Preventivo, Alta
    (8, 3, 24, 72),  -- Mantenimiento Preventivo, Media
    (8, 4, 48, 120), -- Mantenimiento Preventivo, Baja
    
    (9, 1, 1, 4),    -- Gestión Permisos, Crítica
    (9, 2, 2, 8),    -- Gestión Permisos, Alta
    (9, 3, 4, 24),   -- Gestión Permisos, Media
    (9, 4, 8, 48),   -- Gestión Permisos, Baja
    
    (10, 1, 24, 48), -- Capacitación, Crítica
    (10, 2, 48, 72), -- Capacitación, Alta
    (10, 3, 72, 120),-- Capacitación, Media
    (10, 4, 120, 168);-- Capacitación, Baja
GO


-- =============================================
-- Insertar especialidades de técnicos
-- =============================================

INSERT INTO EspecialidadesTecnicos (Nombre, Descripcion)
VALUES 
('Hardware', 'Especialista en reparación y mantenimiento de equipos físicos'),
('Software', 'Especialista en resolución de problemas de aplicaciones'),
('Redes', 'Especialista en configuración y solución de problemas de red'),
('Seguridad', 'Especialista en seguridad informática y gestión de accesos'),
('Bases de Datos', 'Especialista en gestión y solución de problemas en bases de datos'),
('Sistemas Operativos', 'Especialista en configuración y solución de problemas de SO'),
('Capacitación', 'Especialista en formación y capacitación de usuarios');
GO

-- =============================================
-- Insertar empleados
-- =============================================

-- Empleados del departamento de Sistemas (EsTecnico = 1)
INSERT INTO Empleados (NumeroEmpleado, Nombre, Apellidos, Email, Telefono, DepartamentoID, EsTecnico, Activo)
VALUES 
('SIS001', 'Carlos', 'Méndez', 'carlos.mendez@empresa.com', '555-1001', 1, 1, 1),
('SIS002', 'Ana', 'Vázquez', 'ana.vazquez@empresa.com', '555-1002', 1, 1, 1),
('SIS003', 'Miguel', 'Torres', 'miguel.torres@empresa.com', '555-1003', 1, 1, 1),
('SIS004', 'Laura', 'García', 'laura.garcia@empresa.com', '555-1004', 1, 1, 1),
('SIS005', 'Roberto', 'Fernández', 'roberto.fernandez@empresa.com', '555-1005', 1, 1, 1),
('SIS006', 'Elena', 'Martínez', 'elena.martinez@empresa.com', '555-1006', 1, 0, 1), -- Administrativo de Sistemas
('SIS007', 'Javier', 'López', 'javier.lopez@empresa.com', '555-1007', 1, 0, 1),     -- Administrativo de Sistemas
('SIS008', 'Sofía', 'Rodríguez', 'sofia.rodriguez@empresa.com', '555-1008', 1, 1, 1);
GO

-- Empleados de otros departamentos (EsTecnico = 0)
INSERT INTO Empleados (NumeroEmpleado, Nombre, Apellidos, Email, Telefono, DepartamentoID, EsTecnico, Activo)
VALUES 
-- Recursos Humanos
('RH001', 'María', 'Gómez', 'maria.gomez@empresa.com', '555-2001', 2, 0, 1),
('RH002', 'Juan', 'Pérez', 'juan.perez@empresa.com', '555-2002', 2, 0, 1),
('RH003', 'Luisa', 'Sánchez', 'luisa.sanchez@empresa.com', '555-2003', 2, 0, 1),
    
-- Contabilidad
('CON001', 'Pedro', 'Ramírez', 'pedro.ramirez@empresa.com', '555-3001', 3, 0, 1),
('CON002', 'Isabel', 'Díaz', 'isabel.diaz@empresa.com', '555-3002', 3, 0, 1),
('CON003', 'Andrés', 'Ruiz', 'andres.ruiz@empresa.com', '555-3003', 3, 0, 1),
('CON004', 'Carmen', 'Flores', 'carmen.flores@empresa.com', '555-3004', 3, 0, 1),
    
-- Ventas
('VEN001', 'Jorge', 'Hernández', 'jorge.hernandez@empresa.com', '555-4001', 4, 0, 1),
('VEN002', 'Eva', 'Jiménez', 'eva.jimenez@empresa.com', '555-4002', 4, 0, 1),
('VEN003', 'Ricardo', 'Moreno', 'ricardo.moreno@empresa.com', '555-4003', 4, 0, 1),
('VEN004', 'Natalia', 'Vargas', 'natalia.vargas@empresa.com', '555-4004', 4, 0, 1),
    
-- Operaciones
('OPE001', 'Daniel', 'Castro', 'daniel.castro@empresa.com', '555-5001', 5, 0, 1),
('OPE002', 'Beatriz', 'Ortega', 'beatriz.ortega@empresa.com', '555-5002', 5, 0, 1),
('OPE003', 'Fernando', 'Navarro', 'fernando.navarro@empresa.com', '555-5003', 5, 0, 1),
    
-- Marketing
('MKT001', 'Silvia', 'Romero', 'silvia.romero@empresa.com', '555-6001', 6, 0, 1),
('MKT002', 'Héctor', 'Molina', 'hector.molina@empresa.com', '555-6002', 6, 0, 1),
    
-- Dirección
('DIR001', 'Alejandro', 'González', 'alejandro.gonzalez@empresa.com', '555-7001', 7, 0, 1),
('DIR002', 'Raquel', 'Serrano', 'raquel.serrano@empresa.com', '555-7002', 7, 0, 1);
GO


-- =============================================
-- Asignar especialidades a los técnicos
-- =============================================

-- Carlos Méndez - Hardware y Sistemas Operativos
INSERT INTO TecnicoEspecialidades (EmpleadoID, EspecialidadID, NivelExperiencia)
VALUES 
(1, 1, 5), -- Hardware (experto)
(1, 6, 4); -- Sistemas Operativos (avanzado)
GO


-- Ana Vázquez - Software y Bases de Datos
INSERT INTO TecnicoEspecialidades (EmpleadoID, EspecialidadID, NivelExperiencia)
VALUES 
(2, 2, 5), -- Software (experto)
(2, 5, 4); -- Bases de Datos (avanzado)
GO

-- Miguel Torres - Redes y Seguridad
INSERT INTO TecnicoEspecialidades (EmpleadoID, EspecialidadID, NivelExperiencia)
VALUES 
(3, 3, 5), -- Redes (experto)
(3, 4, 4); -- Seguridad (avanzado)
GO

-- Laura García - Software y Capacitación
INSERT INTO TecnicoEspecialidades (EmpleadoID, EspecialidadID, NivelExperiencia)
VALUES 
(4, 2, 4), -- Software (avanzado)
(4, 7, 5); -- Capacitación (experto)
GO

-- Roberto Fernández - Hardware y Redes
INSERT INTO TecnicoEspecialidades (EmpleadoID, EspecialidadID, NivelExperiencia)
VALUES 
(5, 1, 3), -- Hardware (intermedio)
(5, 3, 3); -- Redes (intermedio)
GO

-- Sofía Rodríguez - Bases de Datos y Seguridad
INSERT INTO TecnicoEspecialidades (EmpleadoID, EspecialidadID, NivelExperiencia)
VALUES 
(8, 5, 5), -- Bases de Datos (experto)
(8, 4, 5); -- Seguridad (experto)
GO

-- =======================================================
-- Generar tickets con diferentes estados y antigüedad
-- ========================================================


-- Variables para configurar la cantidad de registros
DECLARE @NumTickets INT = 500; -- Número total de tickets a generar
DECLARE @MaxSeguimientosPorTicket INT = 8; -- Máximo número de seguimientos por ticket
DECLARE @FechaInicio DATETIME = DATEADD(YEAR, -2, GETDATE()); -- 2 años atrás desde hoy
DECLARE @FechaActual DATETIME = GETDATE(); -- Fecha actual

-- Declaramos variables para los IDs de referencia
DECLARE @MaxEmpleadoID INT;
DECLARE @MaxTecnicoID INT;
DECLARE @MaxServicioID INT;
DECLARE @MaxPrioridadID INT;
DECLARE @MaxEstadoID INT;

-- Obtenemos los valores máximos de IDs
SELECT @MaxEmpleadoID = MAX(EmpleadoID) FROM Empleados;
SELECT @MaxTecnicoID = MAX(EmpleadoID) FROM Empleados WHERE EsTecnico = 1;
SELECT @MaxServicioID = MAX(ServicioID) FROM Servicios;
SELECT @MaxPrioridadID = MAX(PrioridadID) FROM Prioridades;
SELECT @MaxEstadoID = MAX(EstadoID) FROM EstadosTicket;

-- Tabla temporal para guardar los tickets generados

DROP TABLE IF EXISTS #TempTickets;

CREATE TABLE #TempTickets (
    TicketID INT,
    FechaCreacion DATETIME,
    FechaCierre DATETIME,
    EstadoID INT
);

-- Desactivamos la verificación de claves foráneas temporalmente para acelerar la inserción
ALTER TABLE Tickets NOCHECK CONSTRAINT ALL;
ALTER TABLE SeguimientoTickets NOCHECK CONSTRAINT ALL;

-- =============================================
-- Generar Tickets
-- =============================================
PRINT 'Generando tickets de prueba...';

-- Creamos una secuencia temporal para los números de ticket
DECLARE @TicketCounter INT = 1;

-- Loop para generar tickets
WHILE @TicketCounter <= @NumTickets
BEGIN
    -- Variables para cada ticket
    DECLARE @EmpleadoSolicitanteID INT = FLOOR(RAND() * @MaxEmpleadoID) + 1;
    DECLARE @DepartamentoSolicitanteID INT;
    DECLARE @ServicioID INT = FLOOR(RAND() * @MaxServicioID) + 1;
    DECLARE @PrioridadID INT = FLOOR(RAND() * @MaxPrioridadID) + 1;
    DECLARE @EstadoID INT = FLOOR(RAND() * @MaxEstadoID) + 1;
    DECLARE @TecnicoAsignadoID INT = CASE 
                                         WHEN @EstadoID > 1 THEN FLOOR(RAND() * @MaxTecnicoID) + 1 
                                         ELSE NULL 
                                     END;
    DECLARE @ResponsableAsignacionID INT = CASE 
                                              WHEN @TecnicoAsignadoID IS NOT NULL THEN FLOOR(RAND() * @MaxTecnicoID) + 1 
                                              ELSE NULL 
                                          END;
    DECLARE @FechaTicket DATETIME = DATEADD(SECOND, RAND() * DATEDIFF(SECOND, @FechaInicio, @FechaActual), @FechaInicio);
    DECLARE @FechaAsignacion DATETIME = CASE 
                                            WHEN @EstadoID > 1 THEN DATEADD(HOUR, RAND() * 24, @FechaTicket)
                                            ELSE NULL 
                                        END;
    DECLARE @FechaCierre DATETIME = CASE 
                                        WHEN @EstadoID IN (5, 6, 7) THEN DATEADD(DAY, RAND() * 14, COALESCE(@FechaAsignacion, @FechaTicket))
                                        ELSE NULL 
                                    END;
    DECLARE @CalificacionServicio INT = CASE 
                                            WHEN @EstadoID = 6 THEN FLOOR(RAND() * 5) + 1
                                            ELSE NULL 
                                        END;
    DECLARE @CostoFinal DECIMAL(10, 2) = CASE 
                                             WHEN @EstadoID IN (5, 6) THEN (SELECT CostoEstimado FROM Servicios WHERE ServicioID = @ServicioID) * (0.8 + (RAND() * 0.4))
                                             ELSE NULL 
                                         END;
    
    -- Obtenemos el departamento del empleado solicitante
    SELECT @DepartamentoSolicitanteID = DepartamentoID 
    FROM Empleados 
    WHERE EmpleadoID = @EmpleadoSolicitanteID;
    
    -- Generamos número de ticket (TK-YYYYMM-####)
    DECLARE @NumeroTicket NVARCHAR(20) = 'TK-' + 
                                        CONVERT(VARCHAR(4), YEAR(@FechaTicket)) + 
                                        RIGHT('0' + CONVERT(VARCHAR(2), MONTH(@FechaTicket)), 2) + '-' + 
                                        RIGHT('0000' + CONVERT(VARCHAR(4), @TicketCounter), 4);
    
    -- Títulos aleatorios comunes para tickets de soporte
    DECLARE @TitulosTicket TABLE (Titulo NVARCHAR(200));
    INSERT INTO @TitulosTicket VALUES 
        ('Problema al iniciar sesión'), 
        ('Error en la impresora'), 
        ('Equipo lento'), 
        ('No puedo acceder a mi correo'),
        ('Software no responde'), 
        ('Necesito actualizar programa'), 
        ('Pantalla en azul'), 
        ('No tengo acceso a internet'),
        ('Necesito restablecer contraseña'), 
        ('Error al guardar documentos'), 
        ('Problema con red WiFi'), 
        ('Instalar programa nuevo'),
        ('Equipo no enciende'), 
        ('Actualización de sistema operativo'), 
        ('Problema con micrófono en reuniones'), 
        ('Solicitud de nuevo equipo'),
        ('Configuración de cuenta nueva'), 
        ('Error en aplicación de contabilidad'), 
        ('Problema con permisos de acceso'), 
        ('Capacitación en herramienta');
    
    -- Seleccionamos un título aleatorio
    DECLARE @TituloTicket NVARCHAR(200);
    SELECT TOP 1 @TituloTicket = Titulo FROM @TitulosTicket ORDER BY NEWID();
    
    -- Insertamos el ticket
    INSERT INTO Tickets (
        NumeroTicket, 
        Titulo, 
        Descripcion, 
        EmpleadoSolicitanteID, 
        DepartamentoSolicitanteID, 
        ServicioID, 
        FechaCreacion, 
        FechaActualizacion, 
        PrioridadID, 
        EstadoID, 
        TecnicoAsignadoID, 
        ResponsableAsignacionID, 
        FechaAsignacion, 
        FechaCierre, 
        CostoFinal, 
        CalificacionServicio, 
        ComentarioCalificacion
    )
    VALUES (
        @NumeroTicket, 
        @TituloTicket, 
        'Descripción detallada del problema: ' + @TituloTicket + '. El usuario necesita ayuda para resolver este inconveniente.', 
        @EmpleadoSolicitanteID, 
        @DepartamentoSolicitanteID, 
        @ServicioID, 
        @FechaTicket, 
        CASE WHEN @FechaCierre IS NOT NULL THEN @FechaCierre ELSE @FechaTicket END, 
        @PrioridadID, 
        @EstadoID, 
        @TecnicoAsignadoID, 
        @ResponsableAsignacionID, 
        @FechaAsignacion, 
        @FechaCierre, 
        @CostoFinal, 
        @CalificacionServicio, 
        CASE 
            WHEN @CalificacionServicio IS NOT NULL THEN 
                CASE 
                    WHEN @CalificacionServicio >= 4 THEN 'Buen servicio, problema resuelto satisfactoriamente.'
                    WHEN @CalificacionServicio = 3 THEN 'Servicio aceptable, pero tomó más tiempo del esperado.'
                    ELSE 'El problema no se resolvió completamente.'
                END
            ELSE NULL
        END
    );
    
    -- Guardamos el ID del ticket generado
    DECLARE @CurrentTicketIDx INT = SCOPE_IDENTITY();
    
    -- Guardamos en tabla temporal para los seguimientos
    INSERT INTO #TempTickets (TicketID, FechaCreacion, FechaCierre, EstadoID) 
    VALUES (@CurrentTicketIDx, @FechaTicket, @FechaCierre, @EstadoID);
    
    SET @TicketCounter = @TicketCounter + 1;
END


-- =============================================
-- Generar Seguimientos
-- =============================================
PRINT 'Generando seguimientos de tickets...';

-- Procesamos cada ticket para crear sus seguimientos
DECLARE @CurrentTicketID INT;
DECLARE @TicketFechaCreacion DATETIME;
DECLARE @TicketFechaCierre DATETIME;
DECLARE @TicketEstadoID INT;

DECLARE TicketCursor CURSOR FOR 
SELECT TicketID, FechaCreacion, FechaCierre, EstadoID 
FROM #TempTickets;

OPEN TicketCursor;
FETCH NEXT FROM TicketCursor INTO @CurrentTicketID, @TicketFechaCreacion, @TicketFechaCierre, @TicketEstadoID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Determinamos cuántos seguimientos generaremos para este ticket
    DECLARE @NumSeguimientos INT = FLOOR(RAND() * @MaxSeguimientosPorTicket) + 1;
    
    -- Si el estado es 1 (Nuevo), solo generamos 1 seguimiento de creación
    IF @TicketEstadoID = 1
        SET @NumSeguimientos = 1;
    
    -- Calcular los estados que debe pasar este ticket según su estado final
    DECLARE @EstadosTicket TABLE (Orden INT IDENTITY(1,1), EstadoID INT);
    
    -- Estado inicial siempre es 1 (Nuevo)
    INSERT INTO @EstadosTicket (EstadoID) VALUES (1);
    
    -- Añadimos estados intermedios según el estado final
    IF @TicketEstadoID >= 2 -- Si al menos llegó a Asignado
        INSERT INTO @EstadosTicket (EstadoID) VALUES (2);
        
    IF @TicketEstadoID >= 3 -- Si al menos llegó a En Progreso
        INSERT INTO @EstadosTicket (EstadoID) VALUES (3);
        
    IF @TicketEstadoID IN (4, 5, 6) -- Estados que pueden pasar por En Espera
        INSERT INTO @EstadosTicket (EstadoID) VALUES (4);
        
    IF @TicketEstadoID IN (5, 6) -- Si llegó a Resuelto o Cerrado
        INSERT INTO @EstadosTicket (EstadoID) VALUES (5);
        
    IF @TicketEstadoID = 6 -- Si llegó a Cerrado
        INSERT INTO @EstadosTicket (EstadoID) VALUES (6);
        
    IF @TicketEstadoID = 7 -- Si fue Cancelado
        INSERT INTO @EstadosTicket (EstadoID) VALUES (7);
    
    -- Verificamos que tengamos suficientes seguimientos
    IF @NumSeguimientos < (SELECT COUNT(*) FROM @EstadosTicket)
        SET @NumSeguimientos = (SELECT COUNT(*) FROM @EstadosTicket);
    
    -- Generamos los seguimientos
    DECLARE @SeguimientoCount INT = 1;
    DECLARE @FechaInicioSeguimiento DATETIME = @TicketFechaCreacion;
    DECLARE @FechaFinSeguimiento DATETIME = COALESCE(@TicketFechaCierre, @FechaActual);
    
    WHILE @SeguimientoCount <= @NumSeguimientos
    BEGIN
        -- Calculamos una fecha para este seguimiento
        DECLARE @FechaSeguimiento DATETIME = DATEADD(
            SECOND, 
            RAND() * DATEDIFF(SECOND, @FechaInicioSeguimiento, @FechaFinSeguimiento), 
            @FechaInicioSeguimiento
        );
        
        -- Determinamos los estados para este seguimiento
        DECLARE @EstadoAnteriorID INT = NULL;
        DECLARE @EstadoNuevoID INT = NULL;
        
        -- Si tenemos cambio de estado en este seguimiento
        IF @SeguimientoCount <= (SELECT COUNT(*) FROM @EstadosTicket)
        BEGIN
            -- Para el primer seguimiento (creación), no hay estado anterior
            IF @SeguimientoCount = 1
                SET @EstadoNuevoID = 1; -- Nuevo
            ELSE
            BEGIN
                SELECT @EstadoAnteriorID = EstadoID FROM @EstadosTicket WHERE Orden = @SeguimientoCount - 1;
                SELECT @EstadoNuevoID = EstadoID FROM @EstadosTicket WHERE Orden = @SeguimientoCount;
            END
        END
        
        -- Determinamos quién hace el seguimiento (solicitante o técnico)
        DECLARE @EmpleadoSeguimientoID INT;
        DECLARE @EsSolicitante BIT = CASE WHEN RAND() > 0.7 THEN 1 ELSE 0 END;
        
        -- Para estados técnicos, debe ser un técnico
        IF @EstadoNuevoID IN (2, 3, 5)
            SET @EsSolicitante = 0;
            
        -- Para cierre final, debe ser el solicitante
        IF @EstadoNuevoID = 6
            SET @EsSolicitante = 1;
        
        -- Obtenemos el ID del solicitante o un técnico aleatorio
        IF @EsSolicitante = 1
            SELECT @EmpleadoSeguimientoID = EmpleadoSolicitanteID FROM Tickets WHERE TicketID = @CurrentTicketID;
        ELSE
            SELECT @EmpleadoSeguimientoID = COALESCE(TecnicoAsignadoID, 
                (SELECT TOP 1 EmpleadoID FROM Empleados WHERE EsTecnico = 1 ORDER BY NEWID()))
            FROM Tickets WHERE TicketID = @CurrentTicketID;
        
        -- Generamos comentario según el tipo de seguimiento
        DECLARE @Comentario NVARCHAR(MAX);
        
        IF @EstadoNuevoID = 1
            SET @Comentario = 'Ticket creado. El usuario reporta: ' + (SELECT Titulo FROM Tickets WHERE TicketID = @CurrentTicketID);
        ELSE IF @EstadoNuevoID = 2
            SET @Comentario = 'Ticket asignado a técnico para su resolución.';
        ELSE IF @EstadoNuevoID = 3
            SET @Comentario = 'Iniciando el diagnóstico del problema reportado.';
        ELSE IF @EstadoNuevoID = 4
            SET @Comentario = 'Esperando respuesta del usuario para continuar con la solución.';
        ELSE IF @EstadoNuevoID = 5
            SET @Comentario = 'Problema resuelto, esperando confirmación del usuario.';
        ELSE IF @EstadoNuevoID = 6
            SET @Comentario = 'Confirmo que el problema ha sido resuelto correctamente. Gracias.';
        ELSE IF @EstadoNuevoID = 7
            SET @Comentario = 'Ticket cancelado a petición del usuario.';
        ELSE -- Seguimiento sin cambio de estado
            SET @Comentario = CASE 
                WHEN @EsSolicitante = 1 THEN 'Solicito información sobre el estado de mi ticket.'
                ELSE 'Continuamos trabajando en la solución. Se ha avanzado en el diagnóstico.'
            END;
        
        -- Determinamos si es comentario privado (solo para técnicos)
        DECLARE @EsPrivado INT = CASE WHEN @EsSolicitante = 0 AND RAND() > 0.7 THEN 1 ELSE 0 END;
        
        -- Tiempo invertido (solo para técnicos)
        DECLARE @TiempoInvertido INT = CASE 
                                        WHEN @EsSolicitante = 0 THEN FLOOR(RAND() * 120) + 5 -- 5 a 125 minutos
                                        ELSE NULL 
                                     END;
        
        -- Insertamos el seguimiento
        INSERT INTO SeguimientoTickets (
            TicketID,
            EmpleadoID,
            Comentario,
            FechaRegistro,
            EstadoAnteriorID,
            EstadoNuevoID,
            TiempoInvertidoMinutos,
            Privado
        )
        VALUES (
            @CurrentTicketID,
            @EmpleadoSeguimientoID,
            @Comentario,
            @FechaSeguimiento,
            @EstadoAnteriorID,
            @EstadoNuevoID,
            @TiempoInvertido,
            @EsPrivado
        );
        
        -- Avanzamos al siguiente seguimiento
        SET @SeguimientoCount = @SeguimientoCount + 1;
        
        -- Actualizamos la fecha de inicio para el próximo seguimiento
        SET @FechaInicioSeguimiento = @FechaSeguimiento;
    END
    
    -- Limpiamos la tabla temporal de estados para el próximo ticket
    DELETE FROM @EstadosTicket;
    
    FETCH NEXT FROM TicketCursor INTO @CurrentTicketID, @TicketFechaCreacion, @TicketFechaCierre, @TicketEstadoID;
END

CLOSE TicketCursor;
DEALLOCATE TicketCursor;

-- Limpiamos la tabla temporal
DROP TABLE #TempTickets;

-- Reactivamos las restricciones de clave foránea
ALTER TABLE Tickets CHECK CONSTRAINT ALL;
ALTER TABLE SeguimientoTickets CHECK CONSTRAINT ALL;

-- =============================================
-- Estadísticas de los datos generados
-- =============================================
PRINT 'Estadísticas de los datos generados:';

-- Número total de tickets
SELECT 'Total de tickets generados' AS Descripcion, COUNT(*) AS Total FROM Tickets;

-- Tickets por estado
SELECT 
    e.Nombre AS Estado, 
    COUNT(*) AS Total 
FROM 
    Tickets t
    JOIN EstadosTicket e ON t.EstadoID = e.EstadoID
GROUP BY 
    e.Nombre, e.Orden
ORDER BY 
    e.Orden;

-- Tickets por prioridad
SELECT 
    p.Nombre AS Prioridad, 
    COUNT(*) AS Total 
FROM 
    Tickets t
    JOIN Prioridades p ON t.PrioridadID = p.PrioridadID
GROUP BY 
    p.Nombre, p.PrioridadID
ORDER BY 
    p.PrioridadID;

-- Tickets por departamento
SELECT 
    d.Nombre AS Departamento, 
    COUNT(*) AS Total 
FROM 
    Tickets t
    JOIN Departamentos d ON t.DepartamentoSolicitanteID = d.DepartamentoID
GROUP BY 
    d.Nombre
ORDER BY 
    Total DESC;

-- Tickets por servicio
SELECT 
    s.Nombre AS Servicio, 
    COUNT(*) AS Total 
FROM 
    Tickets t
    JOIN Servicios s ON t.ServicioID = s.ServicioID
GROUP BY 
    s.Nombre
ORDER BY 
    Total DESC;

-- Total de seguimientos generados
SELECT 'Total de seguimientos generados' AS Descripcion, COUNT(*) AS Total FROM SeguimientoTickets;

-- Promedio de seguimientos por ticket
SELECT 
    'Promedio de seguimientos por ticket' AS Descripcion, 
    CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM Tickets) AS Promedio 
FROM 
    SeguimientoTickets;

-- =============================================
-- Actualizar costos del departamento
-- =============================================
PRINT 'Actualizando tabla CostosDepartamento...';

-- Limpiamos la tabla de costos antes de actualizar
DELETE FROM CostosDepartamento;

-- Calculamos los costos por departamento y mes
INSERT INTO CostosDepartamento (DepartamentoID, Mes, Ano, CostoTotal, NumeroTickets)
SELECT 
    t.DepartamentoSolicitanteID,
    MONTH(t.FechaCreacion) AS Mes,
    YEAR(t.FechaCreacion) AS Ano,
    SUM(COALESCE(t.CostoFinal, s.CostoEstimado)) AS CostoTotal,
    COUNT(*) AS NumeroTickets
FROM 
    Tickets t
    JOIN Servicios s ON t.ServicioID = s.ServicioID
WHERE 
    YEAR(t.FechaCreacion) >= YEAR(DATEADD(YEAR, -2, GETDATE()))
GROUP BY 
    t.DepartamentoSolicitanteID,
    MONTH(t.FechaCreacion),
    YEAR(t.FechaCreacion);

-- Mostrar los costos generados
SELECT 
    d.Nombre AS Departamento,
    c.Ano,
    c.Mes,
    c.NumeroTickets,
    c.CostoTotal
FROM 
    CostosDepartamento c
    JOIN Departamentos d ON c.DepartamentoID = d.DepartamentoID
ORDER BY 
    c.Ano DESC,
    c.Mes DESC,
    c.CostoTotal DESC;

PRINT 'Generación de datos de prueba completada exitosamente.';

