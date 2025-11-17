-- =====================================================
-- CASOS PRÁCTICOS: MANEJO DE TRANSACCIONES
-- Sistema: Vida Activa - Gestión de Gimnasios
-- Tema: Transacciones y Transacciones Anidadas
-- =====================================================

-- =====================================================
-- DEMOSTRACIÓN: SIN TRANSACCIÓN vs CON TRANSACCIÓN
-- =====================================================

-- ==============================
-- ESCENARIO 1: SIN TRANSACCIÓN
-- ==============================

DELETE FROM cuota WHERE dni_socio = 99999999;
DELETE FROM socio WHERE dni_socio = 99999999;
GO

DECLARE @dni_test INT = 99999999;
DECLARE @id_cuota_test INT;

BEGIN TRY
    -- Paso 1: Insertar socio (éxito)
    INSERT INTO socio
    (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio)
VALUES
    (@dni_test, 'Pedro', 'Sin Transacción', 'pedro@email.com', 1122334455, GETDATE(), 'activo');
    
    -- Paso 2: Insertar cuota (error - NULL en periodo_fin)
    SET @id_cuota_test = (SELECT ISNULL(MAX(id_cuota), 0) + 1
FROM cuota);
    INSERT INTO cuota
    (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio)
VALUES
    (@id_cuota_test, GETDATE(), NULL, 15000.00, 'pagada', @dni_test);
    
END TRY
BEGIN CATCH
    PRINT 'ERROR: ' + ERROR_MESSAGE();
END CATCH;

-- Verificación: ¿Qué quedó en la BD?
IF EXISTS (SELECT 1
FROM socio
WHERE dni_socio = 99999999)
    PRINT 'PROBLEMA: Socio insertado pero cuota NO. DATOS INCONSISTENTES.'
ELSE
    PRINT 'OK: Datos consistentes';

SELECT *
FROM socio
WHERE dni_socio = 99999999;
GO

-- ==============================
-- ESCENARIO 2: CON TRANSACCIÓN
-- ==============================

DELETE FROM cuota WHERE dni_socio = 88888888;
DELETE FROM socio WHERE dni_socio = 88888888;
GO

DECLARE @dni_test2 INT = 88888888;
DECLARE @id_cuota_test2 INT;

BEGIN TRY
    BEGIN TRANSACTION;
        
        -- Paso 1: Insertar socio (éxito temporal)
        INSERT INTO socio
    (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio)
VALUES
    (@dni_test2, 'Juan', 'Con Transacción', 'juan@email.com', 1122334455, GETDATE(), 'activo');
        
        -- Paso 2: Insertar cuota (error - NULL en periodo_fin)
        SET @id_cuota_test2 = (SELECT ISNULL(MAX(id_cuota), 0) + 1
FROM cuota);
        INSERT INTO cuota
    (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio)
VALUES
    (@id_cuota_test2, GETDATE(), NULL, 15000.00, 'pagada', @dni_test2);
        
    COMMIT TRANSACTION;
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'ERROR: ' + ERROR_MESSAGE();
    PRINT 'ROLLBACK ejecutado - Todas las operaciones revertidas';
END CATCH;

-- Verificación: ¿Qué quedó en la BD?
IF EXISTS (SELECT 1
FROM socio
WHERE dni_socio = 88888888)
    PRINT 'PROBLEMA: No debería existir';
ELSE
    PRINT 'OK: NADA se guardó. Datos consistentes (ATOMICIDAD).';

SELECT *
FROM socio
WHERE dni_socio = 88888888;
GO

-- Comparación
SELECT
    CASE WHEN EXISTS (SELECT 1
    FROM socio
    WHERE dni_socio = 99999999) 
         THEN 'INCONSISTENTE' ELSE 'CONSISTENTE' END AS 'Sin Transacción',
    CASE WHEN EXISTS (SELECT 1
    FROM socio
    WHERE dni_socio = 88888888) 
         THEN 'INCONSISTENTE' ELSE 'CONSISTENTE' END AS 'Con Transacción';

-- Limpiar
DELETE FROM cuota WHERE dni_socio IN (99999999, 88888888);
DELETE FROM socio WHERE dni_socio IN (99999999, 88888888);
GO

-- =====================================================
-- CASO 1: INSCRIPCIÓN COMPLETA DE NUEVO SOCIO
-- =====================================================

DECLARE @dni_socio INT = 55555555;
DECLARE @nombre VARCHAR(200) = 'Carlos';
DECLARE @apellido VARCHAR(200) = 'Fernández';
DECLARE @email VARCHAR(100) = 'carlos.fernandez@email.com';
DECLARE @telefono INT = 1199887766;
DECLARE @importe_cuota FLOAT = 20000.00;
DECLARE @id_medio_pago INT = 1;
DECLARE @id_cuota INT;
DECLARE @id_pago INT;
DECLARE @id_apto INT;

BEGIN TRY
    BEGIN TRANSACTION inscripcion_completa;
        
        -- 1. Verificar que el DNI no existe
        IF EXISTS (SELECT 1
FROM socio
WHERE dni_socio = @dni_socio)
        BEGIN
    RAISERROR('El DNI ya está registrado en el sistema', 16, 1);
END        
        -- 2. Registrar nuevo socio
        INSERT INTO socio
    (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio)
VALUES
    (@dni_socio, @nombre, @apellido, @email, @telefono, GETDATE(), 'activo');
        
        SAVE TRANSACTION punto_socio;
        
        -- 3. Generar apto médico
        SET @id_apto = (SELECT ISNULL(MAX(id_apto_medico), 0) + 1
FROM apto_medico);
        
        INSERT INTO apto_medico
    (id_apto_medico, emitido_en, vence_en, observacion, dni_socio)
VALUES
    (
        @id_apto,
        GETDATE(),
        DATEADD(DAY, 30*12, GETDATE()),
        @dni_socio
        );

        
        SAVE TRANSACTION punto_apto;
        
        -- 4. Generar cuota mensual
        SET @id_cuota = (SELECT ISNULL(MAX(id_cuota), 0) + 1
FROM cuota);
        
        INSERT INTO cuota
    (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio)
VALUES
    (
        @id_cuota,
        GETDATE(),
        DATEADD(MONTH, 1, GETDATE()),
        @importe_cuota,
        'pagada',
        @dni_socio
        );
        
        SAVE TRANSACTION punto_cuota;
        
        -- 5. Registrar pago
        SET @id_pago = (SELECT ISNULL(MAX(id_pago), 0) + 1
FROM pago);
        
        INSERT INTO pago
    (id_pago, fecha_pago, monto, id_cuota, id_medio_pago)
VALUES
    (@id_pago, GETDATE(), @importe_cuota, @id_cuota, @id_medio_pago);
        
    COMMIT TRANSACTION inscripcion_completa;
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION inscripcion_completa;

END CATCH;

GO


GO

-- CASO PRÁCTICO 2: Alta de Socio con Cuota y Pago Inicial

PRINT '========================================';
PRINT 'CASO 2: ALTA DE SOCIO COMPLETA';
PRINT '========================================';
PRINT '';
GO
CREATE OR ALTER PROCEDURE sp_alta_socio_completa
    @dni_socio INT,
    @nombre VARCHAR(200),
    @apellido VARCHAR(200),
    @email VARCHAR(100),
    @telefono INT,
    @importe_cuota FLOAT,
    @id_medio_pago INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id_cuota INT = (SELECT ISNULL(MAX(id_cuota), 0) + 1
    FROM cuota);
    DECLARE @id_pago INT = (SELECT ISNULL(MAX(id_pago), 0) + 1
    FROM pago);
    DECLARE @error_msg VARCHAR(500);

    BEGIN TRY
        BEGIN TRANSACTION alta_socio;
            
            -- 1. Registrar nuevo socio
            INSERT INTO socio
        (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio)
    VALUES
        (@dni_socio, @nombre, @apellido, @email, @telefono, GETDATE(), 'activo');
                        
            SAVE TRANSACTION punto_socio;
            
            -- 2. Generar  cuota mensual
            INSERT INTO cuota
        (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio)
    VALUES
        (
            @id_cuota,
            GETDATE(),
            DATEADD(MONTH, 1, GETDATE()),
            @importe_cuota,
            'pagada',
            @dni_socio
            );
                        
            SAVE TRANSACTION punto_cuota;
            
            -- 3. Registrar pago inicial
            INSERT INTO pago
        (id_pago, fecha_pago, monto, id_cuota, id_medio_pago)
    VALUES
        (@id_pago, GETDATE(), @importe_cuota, @id_cuota, @id_medio_pago);
                        
        COMMIT TRANSACTION alta_socio;

        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION alta_socio;
            
        SET @error_msg = ERROR_MESSAGE();
        
        THROW;
    END CATCH
END;
GO

-- Prueba del Caso 2
EXEC sp_alta_socio_completa 
    @dni_socio = 45123456,
    @nombre = 'María',
    @apellido = 'González',
    @email = 'maria.gonzalez@email.com',
    @telefono = 1156789012,
    @importe_cuota = 15000.00,
    @id_medio_pago = 1;
GO

-- =====================================================
-- CASO PRÁCTICO 3: Inscripción a Clase con Validaciones
-- =====================================================

PRINT '========================================';
PRINT 'CASO 3: INSCRIPCIÓN A CLASE';
PRINT '========================================';
PRINT '';
GO
CREATE OR ALTER PROCEDURE sp_inscribir_clase
    @dni_socio INT,
    @id_clase INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @cupo_actual INT;
    DECLARE @cupo_maximo INT;
    DECLARE @requiere_apto VARCHAR(200);
    DECLARE @tiene_apto_vigente BIT = 0;
    DECLARE @id_actividad INT;
    DECLARE @nombre_actividad VARCHAR(100);

    BEGIN TRY
        BEGIN TRANSACTION inscripcion_clase;
            
            -- 1. Verificar que el socio existe y está activo
            IF NOT EXISTS (SELECT 1
    FROM socio
    WHERE dni_socio = @dni_socio AND estado_socio = 'activo')
            BEGIN
        RAISERROR('El socio no existe o no está activo', 16, 1);
    END
            
            -- 2. Obtener información de la clase
            SELECT
        @cupo_maximo = cupo_personas,
        @id_actividad = id_actividad
    FROM clase
    WHERE id_clase = @id_clase AND estado_clase = 'programada';
            
            IF @cupo_maximo IS NULL
            BEGIN
        RAISERROR('La clase no existe o no está programada', 16, 1);
    END
            
            -- 3. Contar inscripciones actuales
            SELECT @cupo_actual = COUNT(*)
    FROM inscripcion
    WHERE id_clase = @id_clase;
            
            -- 4. Verificar cupo disponible
            IF @cupo_actual >= @cupo_maximo
            BEGIN
        RAISERROR('La clase está completa. Cupo máximo alcanzado.', 16, 1);
    END
            
            SAVE TRANSACTION punto_validacion_cupo;
            
            -- 5. Verificar si la actividad requiere apto médico
            SELECT
        @requiere_apto = requiere_apto,
        @nombre_actividad = nombre_actividad
    FROM actividad
    WHERE id_actividad = @id_actividad;
            
            IF @requiere_apto = 'si'
            BEGIN
        IF EXISTS (
                    SELECT 1
        FROM apto_medico
        WHERE dni_socio = @dni_socio
            AND vence_en >= GETDATE()
            AND emitido_en <= GETDATE()
                )
                BEGIN
            SET @tiene_apto_vigente = 1;
        END
                ELSE
                BEGIN
            RAISERROR('El socio requiere apto médico vigente para esta actividad', 16, 1);
        END
    END
            
            SAVE TRANSACTION punto_validacion_apto;
            
            -- 6. Verificar que no esté ya inscrito
            IF EXISTS (SELECT 1
    FROM inscripcion
    WHERE id_clase = @id_clase AND dni_socio = @dni_socio)
            BEGIN
        RAISERROR('El socio ya está inscrito en esta clase', 16, 1);
    END
            
            -- 7. Realizar la inscripción
            INSERT INTO inscripcion
        (fecha_inscripcion, id_clase, dni_socio)
    VALUES
        (GETDATE(), @id_clase, @dni_socio);
            
        COMMIT TRANSACTION inscripcion_clase;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION inscripcion_clase;
            
        DECLARE @error_msg VARCHAR(500) = ERROR_MESSAGE();
        PRINT '';
        PRINT '❌ Error en la inscripción: ' + @error_msg;
        PRINT '';
        
        THROW;
    END CATCH
END;
GO

-- Prueba del Caso 3
EXEC sp_inscribir_clase 
    @dni_socio = 45123456,
    @id_clase = 101;
GO

-- EJEMPLO 4: TRANSFERENCIA DE SOCIO ENTRE CLASES

DECLARE @dni_socio INT = 12345678;
DECLARE @clase_actual INT = 101;
DECLARE @clase_nueva INT = 102;
DECLARE @cupo_actual INT;
DECLARE @cupo_maximo INT;

BEGIN TRY
    BEGIN TRANSACTION transferencia_clase;
        
        -- 1. Verificar que el socio existe y está inscrito en la clase actual
        IF NOT EXISTS (
            SELECT 1
FROM inscripcion
WHERE dni_socio = @dni_socio AND id_clase = @clase_actual
        )
        BEGIN
    RAISERROR('El socio no está inscrito en la clase de origen', 16, 1);
END
        
        -- 2. Verificar cupo disponible en la clase nueva
        SELECT @cupo_maximo = cupo_personas
FROM clase
WHERE id_clase = @clase_nueva;
        
        SELECT @cupo_actual = COUNT(*)
FROM inscripcion
WHERE id_clase = @clase_nueva;
        
        IF @cupo_actual >= @cupo_maximo
        BEGIN
    RAISERROR('No hay cupo disponible en la clase destino', 16, 1);
END
        
        SAVE TRANSACTION punto_validacion;
        
        -- 3. Eliminar inscripción de clase actual
        DELETE FROM inscripcion
        WHERE dni_socio = @dni_socio AND id_clase = @clase_actual;
        
        
        -- 4. Inscribir en clase nueva
        INSERT INTO inscripcion
    (fecha_inscripcion, id_clase, dni_socio)
VALUES
    (GETDATE(), @clase_nueva, @dni_socio);
        
        
    COMMIT TRANSACTION transferencia_clase;
    
    
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION transferencia_clase;
    
END CATCH;

GO