--1)Procedimiento para crear un registro a una clase o reservar una instalacion
CREATE PROCEDURE SP_ValidarEInscribir
    @DniSocio INT,
    @TipoAccion VARCHAR(20),
    @IdClase INT = NULL,      
    @IdInstalacion INT = NULL,
    @FechaReserva DATE = NULL,
    @HorarioInicio DATETIME = NULL, 
    @HorarioFin DATETIME = NULL
AS BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM apto_medico
    WHERE dni_socio = @DniSocio
    AND vence_en >= GETDATE() 
    )
BEGIN
    RAISERROR('Operación cancelada: El Apto Médico del socio no está vigente.', 16, 1);
    RETURN;
END

IF EXISTS (
    SELECT 1
    FROM cuota
    WHERE dni_socio = @DniSocio
    AND estado_cuota IN ('pendiente', 'vencida')
)
    
BEGIN
    RAISERROR('Operación cancelada: El socio tiene cuotas pendientes o vencidas.', 16, 1);
    RETURN;
END

IF @TipoAccion = 'CLASE'
BEGIN
IF @IdClase IS NULL
     BEGIN
     RAISERROR('Debe especificar un ID de Clase para la acción CLASE.', 16, 1);
     RETURN;
     END
     INSERT INTO inscripcion (fecha_inscripcion, id_clase, dni_socio)
     VALUES (CAST(GETDATE() AS DATE), @IdClase, @DniSocio);
     SELECT 'Éxito: Inscripción a la clase ' + CAST(@IdClase AS VARCHAR) + ' creada correctamente para el socio ' + CAST(@DniSocio AS VARCHAR) AS Resultado;
    END
ELSE IF @TipoAccion = 'RESERVA'
    BEGIN
    IF @IdInstalacion IS NULL OR @FechaReserva IS NULL OR @HorarioInicio IS NULL OR @HorarioFin IS NULL
    BEGIN
    RAISERROR('Debe especificar todos los parámetros de Reserva (Instalación, Fecha, Horarios).', 16, 1);
    RETURN;
    END
    DECLARE @NuevoIdReserva INT;
    SELECT @NuevoIdReserva = ISNULL(MAX(id_reserva), 0) + 1 FROM reserva;
    INSERT INTO reserva (id_reserva, fecha_reserva, horario_inicio, horario_fin, estado_reserva, dni_socio, id_instalacion)
    VALUES (@NuevoIdReserva, @FechaReserva, @HorarioInicio, @HorarioFin, 'Activa', @DniSocio, @IdInstalacion);
    SELECT 'Éxito: Reserva de la instalación ' + CAST(@IdInstalacion AS VARCHAR) + ' creada con ID ' + CAST(@NuevoIdReserva AS VARCHAR) AS Resultado;
END
ELSE
BEGIN
    RAISERROR('Tipo de acción no válido. Use "CLASE" o "RESERVA".', 16, 1);
    END
END
GO

--2)Proecedimiento para modificar el horario de una clase o de una reserva
CREATE PROCEDURE SP_ModificarHorario
    @TipoEntidad VARCHAR(10),
    @IdEntidad INT,         
    @NuevoHorarioInicio DATETIME,
    @NuevoHorarioFin DATETIME
AS
BEGIN
    SET NOCOUNT ON; 

    DECLARE @InstalacionId INT;
    DECLARE @Conflicto INT = 0;

    IF @TipoEntidad = 'CLASE'
    BEGIN
        SELECT @InstalacionId = id_instalacion
        FROM clase
        WHERE id_clase = @IdEntidad;

        IF @InstalacionId IS NULL
        BEGIN
            RAISERROR('Clase no encontrada.', 16, 1);
            RETURN;
        END
    END
    ELSE IF @TipoEntidad = 'RESERVA'
    BEGIN
        SELECT @InstalacionId = id_instalacion
        FROM reserva
        WHERE id_reserva = @IdEntidad;

        IF @InstalacionId IS NULL
        BEGIN
            RAISERROR('Reserva no encontrada.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
    RAISERROR('Tipo de entidad no válido. Use "CLASE" o "RESERVA".', 16, 1);
    RETURN;
END

SELECT @Conflicto = COUNT(id_clase)
    FROM clase
    WHERE id_instalacion = @InstalacionId
    AND id_clase <> CASE WHEN @TipoEntidad = 'CLASE' THEN @IdEntidad ELSE 0 END -- Ignorar la clase que se está modificando
    AND (
          @NuevoHorarioInicio < hora_fin
          AND @NuevoHorarioFin > hora_inicio
      );
    IF @Conflicto = 0
BEGIN
    SELECT @Conflicto = COUNT(id_reserva)
    FROM reserva
    WHERE id_instalacion = @InstalacionId
    AND id_reserva <> CASE WHEN @TipoEntidad = 'RESERVA' THEN @IdEntidad ELSE 0 END 
    AND estado_reserva = 'Activa'
    AND (@NuevoHorarioInicio < horario_fin AND @NuevoHorarioFin > horario_inicio);
END

IF @Conflicto > 0
   BEGIN
   RAISERROR('Operación cancelada: El nuevo horario tiene conflicto de superposición en esa instalación.', 16, 1);
   RETURN;
END

BEGIN TRANSACTION;
    BEGIN TRY
    IF @TipoEntidad = 'CLASE'
    BEGIN
    UPDATE clase
   SET hora_inicio = @NuevoHorarioInicio,
       hora_fin = @NuevoHorarioFin
   WHERE id_clase = @IdEntidad;
   END
   ELSE -- RESERVA
BEGIN
   UPDATE reserva
   SET horario_inicio = @NuevoHorarioInicio,
   horario_fin = @NuevoHorarioFin,
   fecha_reserva = CAST(@NuevoHorarioInicio AS DATE) -- Actualiza también la fecha_reserva
   WHERE id_reserva = @IdEntidad;
END

COMMIT TRANSACTION;
SELECT 'Éxito: Horario de ' + @TipoEntidad + ' ID ' + CAST(@IdEntidad AS VARCHAR) + ' modificado correctamente.' AS Resultado;

END TRY
BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
        RETURN;
    END CATCH
END
GO

--3) Procedimiento para dar de baja a un socio

IF OBJECT_ID('SP_DarBajaSocio') IS NOT NULL
    DROP PROCEDURE SP_DarBajaSocio;
GO

CREATE PROCEDURE SP_DarBajaSocio @DniSocio INT AS
BEGIN SET NOCOUNT ON;
 IF NOT EXISTS (SELECT 1 FROM socio WHERE dni_socio = @DniSocio)
 BEGIN
   RAISERROR('Error: El DNI de socio especificado no existe.', 16, 1);
   RETURN;
 END
 IF EXISTS (SELECT 1 FROM cuota
 WHERE dni_socio = @DniSocio
 AND estado_cuota IN ('pendiente', 'vencida'))
 BEGIN
    RAISERROR('Operación cancelada: El socio tiene cuotas pendientes o vencidas y no puede darse de baja.', 16, 1);
    RETURN;
 END
  BEGIN TRANSACTION;
  BEGIN TRY UPDATE socio SET estado_socio = 'baja'
  WHERE dni_socio = @DniSocio;
    COMMIT TRANSACTION;
    SELECT 'Éxito: El socio ' + CAST(@DniSocio AS VARCHAR) + ' ha sido dado de baja correctamente.' AS Resultado;
 END TRY
 BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;
    THROW;
    RETURN;
    END CATCH
END
GO
