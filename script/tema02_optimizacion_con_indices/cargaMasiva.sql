-- SCRIPT 2: CARGA MASIVA COMPLETAMENTE FUNCIONAL
-- Base: Vida_Activa
-- Objetivo: Insertar 1,000,000 registros en tabla acceso
USE Vida_Activa;
GO

SET NOCOUNT ON;

PRINT '=================================================================';
PRINT 'INICIANDO CARGA MASIVA - 1,000,000 REGISTROS';
PRINT 'Hora inicio: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '=================================================================';
PRINT '';

-- ========== PASO 1: VERIFICAR Y CARGAR SOCIOS ==========
PRINT 'PASO 1: Verificando datos de socios...';

IF NOT EXISTS (SELECT 1 FROM socio)
BEGIN
    PRINT ' - No hay socios, creando 50,000 socios...';
    
    INSERT INTO socio (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio)
    SELECT 
        10000000 + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as dni_socio,
        'Nombre_' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR) as nombre_socio,
        'Apellido_' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR) as apellido,
        'email' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR) + '@test.com' as email,
        1100000000 + (ABS(CHECKSUM(NEWID())) % 89999999) as telefono,
        DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE()) as fecha_alta,
        'activo' as estado_socio
    FROM (
        SELECT TOP 50000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as n
        FROM sys.objects a, sys.objects b
    ) t;
    
    PRINT ' - 50,000 socios creados exitosamente';
END
ELSE
BEGIN
    PRINT ' - Socios ya existen en la base de datos';
END

-- Obtener rango de DNIs disponibles
DECLARE @min_dni INT, @max_dni INT, @total_socios INT;
SELECT 
    @min_dni = MIN(dni_socio),
    @max_dni = MAX(dni_socio), 
    @total_socios = COUNT(*)
FROM socio;

PRINT ' - Socios disponibles: ' + CAST(@total_socios AS VARCHAR);
PRINT ' - Rango DNIs: ' + CAST(@min_dni AS VARCHAR) + ' - ' + CAST(@max_dni AS VARCHAR);
PRINT '';

-- ========== PASO 2: LIMPIAR TABLA ACCESO ==========
PRINT 'PASO 2: Preparando tabla acceso...';

IF EXISTS (SELECT 1 FROM acceso)
BEGIN
    PRINT ' - Limpiando tabla acceso existente...';
    DELETE FROM acceso;
    PRINT ' - Tabla acceso limpiada';
END
ELSE
BEGIN
    PRINT ' - Tabla acceso está vacía, lista para carga';
END
PRINT '';

-- ========== PASO 3: CONFIGURACIÓN CARGA MASIVA ==========
PRINT 'PASO 3: Configurando carga masiva...';

DECLARE @meta_total INT = 1000000;     -- 1 millón de registros
DECLARE @lote_tamaño INT = 100000;     -- 100,000 por lote
DECLARE @total_insertado INT = 0;
DECLARE @siguiente_id INT = 1;
DECLARE @contador_lotes INT = 0;
DECLARE @inicio_tiempo DATETIME = GETDATE();

PRINT ' - Meta: ' + CAST(@meta_total AS VARCHAR) + ' registros';
PRINT ' - Tamaño de lote: ' + CAST(@lote_tamaño AS VARCHAR);
PRINT ' - Iniciando carga...';
PRINT '';

-- ========== PASO 4: CARGA EN LOTES ==========
WHILE @total_insertado < @meta_total
BEGIN
    DECLARE @registros_a_insertar INT = 
        CASE WHEN (@total_insertado + @lote_tamaño) > @meta_total 
             THEN @meta_total - @total_insertado
             ELSE @lote_tamaño
        END;

    BEGIN TRY
        PRINT ' - Insertando lote ' + CAST((@contador_lotes + 1) AS VARCHAR) + 
              ' [' + CAST(@registros_a_insertar AS VARCHAR) + ' registros]...';
        
        INSERT INTO acceso (id_acceso, fecha_hora, dni_socio)
        SELECT 
            @siguiente_id + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1,
            DATEADD(SECOND, -ABS(CHECKSUM(NEWID())) % 31536000, GETDATE()),
            @min_dni + (ABS(CHECKSUM(NEWID())) % (@max_dni - @min_dni + 1))
        FROM (
            SELECT TOP (@registros_a_insertar) 1 as n
            FROM sys.objects a 
            CROSS JOIN sys.objects b 
            CROSS JOIN sys.objects c
        ) t;

        SET @contador_lotes = @contador_lotes + 1;
        SET @total_insertado = @total_insertado + @registros_a_insertar;
        SET @siguiente_id = @siguiente_id + @registros_a_insertar;
        
        -- Mostrar progreso
        DECLARE @progreso DECIMAL(5,2) = (@total_insertado * 100.0) / @meta_total;
        DECLARE @transcurrido INT = DATEDIFF(SECOND, @inicio_tiempo, GETDATE());
        DECLARE @velocidad DECIMAL(10,2) = @total_insertado / NULLIF(@transcurrido, 0);
        
        PRINT '   ✓ Lote completado: ' + CAST(@progreso AS VARCHAR) + '%' +
              ' | Total: ' + CAST(@total_insertado AS VARCHAR) +
              ' | Velocidad: ' + CAST(@velocidad AS VARCHAR) + ' reg/seg';
        
        -- Pequeña pausa cada 2 lotes
        IF @contador_lotes % 2 = 0
            WAITFOR DELAY '00:00:01';
            
    END TRY
    BEGIN CATCH
        PRINT '   ✗ Error en lote: ' + ERROR_MESSAGE();
        PRINT '   - Reduciendo tamaño de lote...';
        
        IF @lote_tamaño > 10000
            SET @lote_tamaño = 10000;
            
        WAITFOR DELAY '00:00:02';
        CONTINUE;
    END CATCH
END;

-- ========== PASO 5: VERIFICACIÓN FINAL ==========
PRINT '';
PRINT 'PASO 4: Verificando carga...';

DECLARE @conteo_final INT, @socios_unicos INT;
SELECT 
    @conteo_final = COUNT(*),
    @socios_unicos = COUNT(DISTINCT dni_socio)
FROM acceso;

DECLARE @fin_tiempo DATETIME = GETDATE();
DECLARE @tiempo_total INT = DATEDIFF(SECOND, @inicio_tiempo, @fin_tiempo);
DECLARE @velocidad_promedio DECIMAL(10,2) = @conteo_final / NULLIF(@tiempo_total, 0);

PRINT ' - Registros insertados: ' + CAST(@conteo_final AS VARCHAR);
PRINT ' - Socios únicos en accesos: ' + CAST(@socios_unicos AS VARCHAR);
PRINT ' - Lotres procesados: ' + CAST(@contador_lotes AS VARCHAR);
PRINT ' - Tiempo total: ' + CAST(@tiempo_total AS VARCHAR) + ' segundos';
PRINT ' - Velocidad promedio: ' + CAST(@velocidad_promedio AS VARCHAR) + ' registros/segundo';
PRINT '';

-- ========== PASO 6: MUESTRA DE DATOS ==========
PRINT 'PASO 5: Muestra de datos insertados...';
PRINT ' - Primeros 3 registros:';
SELECT TOP 3 
    id_acceso,
    CONVERT(VARCHAR, fecha_hora, 120) as fecha_hora,
    dni_socio
FROM acceso 
ORDER BY id_acceso;

PRINT ' - Últimos 3 registros:';
SELECT TOP 3 
    id_acceso,
    CONVERT(VARCHAR, fecha_hora, 120) as fecha_hora,
    dni_socio
FROM acceso 
ORDER BY id_acceso DESC;

-- ========== INFORME FINAL ==========
PRINT '';
PRINT '=================================================================';
PRINT 'CARGA MASIVA COMPLETADA';
PRINT '=================================================================';
PRINT 'RESUMEN:';
PRINT ' - Inicio: ' + CONVERT(VARCHAR, @inicio_tiempo, 120);
PRINT ' - Fin: ' + CONVERT(VARCHAR, @fin_tiempo, 120);
PRINT ' - Duración: ' + CAST(@tiempo_total AS VARCHAR) + ' segundos';
PRINT ' - Registros: ' + CAST(@conteo_final AS VARCHAR) + '/1,000,000';

IF @conteo_final = 1000000
    PRINT ' - ESTADO: CARGA EXITOSA - 1,000,000 REGISTROS INSERTADOS';
ELSE
    PRINT ' - ESTADO: CARGA PARCIAL - ' + CAST(@conteo_final AS VARCHAR) + ' REGISTROS';

PRINT '=================================================================';