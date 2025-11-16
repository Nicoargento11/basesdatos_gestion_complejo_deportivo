-- Función 1: Verificar vigencia del apto médico
CREATE FUNCTION FN_AptoMedicoVigente (@DNI_Socio INT)
RETURNS BIT
AS
BEGIN
    DECLARE @EsVigente BIT = 0;

    -- Cuenta cuántos aptos médicos están vigentes hoy para el socio
    IF EXISTS (
        SELECT 1
        FROM apto_medico
        WHERE dni_socio = @DNI_Socio
          AND vence_en >= CAST(GETDATE() AS DATE) -- Comparar solo la fecha
    )
    BEGIN
        SET @EsVigente = 1;
    END

    RETURN @EsVigente;
END
GO

-- Función 2: Verificar si la cuota está al día
CREATE FUNCTION FN_CuotaAlDia (@DNI_Socio INT)
RETURNS BIT
AS
BEGIN
    DECLARE @AlDia BIT = 0;

    -- Busca el último registro de cuota y verifica su estado
    IF EXISTS (
        SELECT TOP 1 1
        FROM cuota
        WHERE dni_socio = @DNI_Socio
          AND estado_cuota = 'al dia' -- Usamos el valor 'al dia' (sin tilde para consistencia)
        ORDER BY periodo_fin DESC -- Busca la cuota más reciente
    )
    BEGIN
        SET @AlDia = 1;
    END
    -- NOTA: Una validación más robusta podría verificar si la fecha actual es anterior a periodo_fin
    
    RETURN @AlDia;
END
GO

-- Procedimiento Almacenado Principal: Registra la inscripción con validaciones
CREATE PROCEDURE SP_RegistrarInscripcion
    @DNI_Socio INT,
    @ID_Clase INT
AS
BEGIN
    -- 1. Verificar existencia del Socio
    IF NOT EXISTS (SELECT 1 FROM socio WHERE dni_socio = @DNI_Socio)
    BEGIN
        RAISERROR('El DNI del socio no existe en el sistema.', 16, 1);
        RETURN;
    END

    -- 2. Validar Apto Médico Vigente (Regla 1)
    IF dbo.FN_AptoMedicoVigente(@DNI_Socio) = 0
    BEGIN
        RAISERROR('ERROR: La inscripción no puede realizarse. El apto médico del socio está vencido o no existe.', 16, 1);
        RETURN;
    END

    -- 3. Validar Cuota al Día (Regla 2)
    IF dbo.FN_CuotaAlDia(@DNI_Socio) = 0
    BEGIN
        RAISERROR('ERROR: La inscripción no puede realizarse. La cuota del socio no está al día.', 16, 1);
        RETURN;
    END
    
    -- 4. Validar Cupo de Clase (Regla 3: Máximo 25 alumnos)
    DECLARE @CupoMaximo INT;
    DECLARE @InscritosActuales INT;
    
    -- Obtener el cupo máximo de la clase (lo tienes en cupo_personas)
    SELECT @CupoMaximo = cupo_personas
    FROM clase
    WHERE id_clase = @ID_Clase;

    IF @CupoMaximo IS NULL
    BEGIN
        RAISERROR('ERROR: El ID de la clase no es válido o no existe.', 16, 1);
        RETURN;
    END
    
    -- Contar el número actual de inscripciones para esa clase
    SELECT @InscritosActuales = COUNT(*)
    FROM inscripcion
    WHERE id_clase = @ID_Clase;

    -- La regla de negocio es 25 (usamos 25 como límite si es menor que el cupo_personas de la tabla)
    -- Si el cupo_personas es 30, pero la regla es 25, se aplica 25. Usaremos 25 como límite duro.
    IF @InscritosActuales >= 25 -- Usando el límite de 25 solicitado
    BEGIN
        RAISERROR('ERROR: La inscripción no puede realizarse. El cupo (límite de 25) ha sido superado en esta clase.', 16, 1);
        RETURN;
    END

    -- ******************************************************
    -- 5. Ejecución Transaccional (Si todas las reglas cumplen)
    -- ******************************************************
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Insertar el registro de inscripción
        INSERT INTO inscripcion (fecha_inscripcion, id_clase, dni_socio)
        VALUES (GETDATE(), @ID_Clase, @DNI_Socio);
        
        COMMIT TRANSACTION;
        
        SELECT 'INSCRIPCIÓN EXITOSA: El socio ha sido inscrito a la clase.' AS Resultado;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Lanzar el error para notificar al cliente/aplicación
        THROW; 
    END CATCH
    
END
GO

--Aplicacion:
-- Ejemplo 1: Ejecución exitosa (asumiendo que el socio 123 tiene apto, cuota y la clase 5 tiene cupo)
EXEC SP_RegistrarInscripcion @DNI_Socio = 12345678, @ID_Clase = 5;

-- Ejemplo 2: Ejecución fallida por validación de regla de negocio
-- Si el socio 987 no tiene la cuota al día, el procedimiento detendrá la operación 
-- y devolverá el error.
EXEC SP_RegistrarInscripcion @DNI_Socio = 98765432, @ID_Clase = 5;

--Procedimiento Principal:
CREATE PROCEDURE SP_GenerarCuotasMensuales
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Definir los parámetros del nuevo periodo (Mes actual)
    DECLARE @FechaActual DATE = GETDATE();
    -- Calcular el primer día del mes actual
    DECLARE @NuevoPeriodoInicio DATE = DATEADD(day, 1, EOMONTH(@FechaActual, -1));
    -- Calcular el último día del mes actual
    DECLARE @NuevoPeriodoFin DATE = EOMONTH(@FechaActual);                       
    -- Importe por defecto. ¡IMPORTANTE: AJUSTA ESTE VALOR según el club!
    DECLARE @ImporteFijo FLOAT = 1500.00;                                      

    -- 2. Determinar la fecha de inicio del último periodo de cuota creado
    DECLARE @UltimoMesCuota DATE;
    SELECT @UltimoMesCuota = MAX(periodo_inicio) FROM cuota;

    -- 3. Condición de Control: Verificar si ya se crearon las cuotas para este mes.
    -- Se verifica si el último registro es de un mes/año anterior o si es el primer registro (NULL).
    IF @UltimoMesCuota IS NULL OR 
       (@NuevoPeriodoInicio > DATEADD(month, 1, @UltimoMesCuota)) -- Asegura que solo se haga una vez por mes
    BEGIN
        
        BEGIN TRANSACTION;

        BEGIN TRY
            -- 4. Insertar la nueva cuota para TODOS los socios activos
            INSERT INTO cuota (
                periodo_inicio, 
                periodo_fin, 
                importe, 
                estado_cuota, 
                dni_socio
            )
            SELECT
                @NuevoPeriodoInicio AS periodo_inicio,
                @NuevoPeriodoFin AS periodo_fin,
                @ImporteFijo AS importe,
                'Pendiente' AS estado_cuota, -- Estado inicial de la cuota
                s.dni_socio
            FROM socio s
            WHERE s.estado_socio = 'activo'; -- Solo para socios con estado 'activo'

            -- Devolver el número de cuotas creadas
            DECLARE @FilasAfectadas INT = @@ROWCOUNT;
            COMMIT TRANSACTION;

            -- Mensaje de Éxito
            SELECT 'EXITO: Se han generado ' + CAST(@FilasAfectadas AS VARCHAR) + ' nuevas cuotas para el periodo: ' + 
                   FORMAT(@NuevoPeriodoInicio, 'dd/MM/yyyy') + ' al ' + FORMAT(@NuevoPeriodoFin, 'dd/MM/yyyy') AS Resultado;

        END TRY
        BEGIN CATCH
            -- Si algo falla (ej. error de clave, integridad), se revierte todo
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            
            THROW; 
            SELECT 'ERROR: Falló la generación de cuotas debido a un error de base de datos.' AS Resultado;

        END CATCH
    END
    ELSE
    BEGIN
        -- Mensaje Informativo
        SELECT 'INFORMATIVO: Las cuotas para el mes de ' + DATENAME(month, @NuevoPeriodoInicio) + ' ya fueron creadas (último periodo: ' + FORMAT(@UltimoMesCuota, 'dd/MM/yyyy') + '). No se requiere acción.' AS Resultado;
    END

END
GO

--Ejecucion Manual
EXEC SP_GenerarCuotasMensuales;
