USE Vida_Activa;
GO

PRINT '=== CONFIGURACIÓN INICIAL ===';  
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
PRINT 'Caché limpiado para pruebas consistentes';  
GO

PRINT '=== PRUEBA 1: SIN ÍNDICES ===';  
PRINT 'Ejecutando consulta por período sin índices...';

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO 

SELECT 
    COUNT(*) as total_accesos,
    AVG(CAST(dni_socio AS FLOAT)) as promedio_dni,
    MIN(fecha_hora) as primera_fecha,
    MAX(fecha_hora) as ultima_fecha
FROM acceso
WHERE fecha_hora BETWEEN '20230601' AND '20230831'; 
GO 

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO  

PRINT '=== FIN PRUEBA 1 ==='; 
GO

PRINT '=== CREANDO ÍNDICE SIMPLE NONCLUSTERED ===';
CREATE NONCLUSTERED INDEX IX_acceso_fecha_hora 
ON acceso(fecha_hora);  
PRINT 'Índice simple NONCLUSTERED IX_acceso_fecha_hora creado'; 
GO

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

PRINT '=== PRUEBA 2: CON ÍNDICE SIMPLE NONCLUSTERED ===';  
PRINT 'Ejecutando misma consulta con índice simple nonclustered...';

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO  

SELECT 
    COUNT(*) as total_accesos,
    AVG(CAST(dni_socio AS FLOAT)) as promedio_dni,
    MIN(fecha_hora) as primera_fecha,
    MAX(fecha_hora) as ultima_fecha
FROM acceso
WHERE fecha_hora BETWEEN '20230601' AND '20230831';
GO  

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO  

PRINT '=== FIN PRUEBA 2 ==='; 
GO

PRINT '=== ELIMINANDO ÍNDICE SIMPLE ===';  
DROP INDEX IX_acceso_fecha_hora ON acceso;
PRINT 'Índice simple eliminado';  
GO

PRINT '=== VERIFICANDO EXISTENCIA DEL ÍNDICE COMPUESTO ===';
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_acceso_fecha_hora_dni' AND object_id = OBJECT_ID('acceso'))
BEGIN
    PRINT 'El índice IX_acceso_fecha_hora_dni ya existe. Eliminándolo...';
    DROP INDEX IX_acceso_fecha_hora_dni ON acceso;
    PRINT 'Índice existente eliminado';
END
GO

PRINT '=== CREANDO ÍNDICE COMPUESTO NONCLUSTERED ===';
CREATE NONCLUSTERED INDEX IX_acceso_fecha_hora_dni
ON acceso(fecha_hora, dni_socio);
PRINT 'Índice compuesto NONCLUSTERED creado'; 
GO

DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

PRINT '=== PRUEBA 3: CON ÍNDICE COMPUESTO ===';  
PRINT 'Ejecutando consulta con índice compuesto...';

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO  

SELECT 
    COUNT(*) as total_accesos,
    AVG(CAST(dni_socio AS FLOAT)) as promedio_dni,
    MIN(fecha_hora) as primera_fecha,
    MAX(fecha_hora) as ultima_fecha
FROM acceso
WHERE fecha_hora BETWEEN '20230601' AND '20230831';
GO  

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO  

PRINT '=== FIN PRUEBA 3 ==='; 
GO
