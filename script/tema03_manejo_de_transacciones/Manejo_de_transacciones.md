# Manejo de Transacciones y Transacciones Anidadas en SQL Server

## Introducción

Una **transacción** representa una unidad lógica de trabajo que agrupa una o más operaciones de base de datos que deben ejecutarse de manera atómica.
En el desarrollo de sistemas que manipulan grandes volúmenes de datos **las transacciones** son el mecanismo central para asegurar la confiabilidad de las operaciones.
Sin transacciones, cualquier error (como un corte de energía, una conexión interrumpida o una validación incorrecta) podría dejar los datos en un **estado inconsistente**, afectando la integridad del sistema y de la información almacenada.

---

## ¿Qué es una Transacción?

Una **transacción** representa **unidad lógica de trabajo** que agrupa una o más operaciones SQL (INSERT, UPDATE, DELETE, SELECT) que deben ejecutarse en conjunto de manera atomica.  
Su propósito es asegurar que la base de datos pase **de un estado consistente a otro estado consistente**, sin dejar resultados intermedios o parciales.

Las transacciones son esenciales para escenarios donde múltiples procesos pueden afectar la misma información simultáneamente, como:

- Transferencias bancarias (débito y crédito simultáneo).  
- Registro de inscripciones y pagos en sistemas deportivos.  
- Procesos de facturación o inventario en un ERP.  
- Actualización de múltiples tablas relacionadas en una misma operación.

Una transacción puede ser **explícita**, cuando el programador controla su inicio y fin, o **implícita**, cuando el motor de base de datos gestiona automáticamente la atomicidad de una instrucción.

### Características Principales:

- **Atomicidad**: Todas las operaciones se completan exitosamente o ninguna se aplica.
- **Indivisibilidad**: No se puede ejecutar parcialmente una transacción.
- **Control explícito**: El programador decide cuándo iniciar, confirmar o revertir una transacción.

---

## Propiedades ACID

Las transacciones deben cumplir con las propiedades **ACID**, que son el pilar fundamental de la confiabilidad en sistemas de bases de datos:

### 1. **Atomicidad (Atomicity)**

Todas las operaciones dentro de la transacción deben completarse correctamente; de lo contrario, ninguna se aplica.  
Un fallo intermedio genera un **rollback** automático o manual.

### 2. **Consistencia (Consistency)**

Garantiza que la base de datos respete todas las restricciones de integridad (claves, tipos de datos, reglas de negocio).
Una transacción nunca debe dejar la base en un estado inválido.

**Ejemplo:** Si existe una restricción de CHECK que indica que el saldo no puede ser negativo, la transacción no permitirá que se viole esta regla.

### 3. **Aislamiento (Isolation)**

Asegura que las transacciones concurrentes no interfieran entre sí.
Cada transacción debe comportarse como si fuera la única en ejecución.

### 4. **Durabilidad (Durability)**

Una vez que se ejecuta un COMMIT, los cambios se vuelven permanentes, incluso si ocurre un fallo de energía o del sistema.

---

## Comandos Básicos de Transacciones, con sus abrebiaturas

### 1. BEGIN TRANSACTION
Inicia una nueva transacción.

```sql
BEGIN TRANSACTION;
BEGIN TRAN;
```

### 2. COMMIT
Confirma todos los cambios realizados en la transacción.

```sql
COMMIT TRANSACTION;
COMMIT;
```

### 3. ROLLBACK
Revierte todos los cambios realizados desde el inicio de la transacción.

```sql
ROLLBACK TRANSACTION;
ROLLBACK;
```

### 4. SAVE TRANSACTION
Crea un punto de guardado dentro de una transacción para rollback parcial.

```sql
SAVE TRANSACTION nombre_punto;
```

### 5. ROLLBACK TO
Revierte la transacción hasta un punto de guardado específico.

```sql
ROLLBACK TRANSACTION nombre_punto;
```

### Ejemplo Básico Completo:

```sql
BEGIN TRANSACTION;
    INSERT INTO socio VALUES (12345678, 'Juan', 'Pérez', 'juan@mail.com', 1234567, GETDATE(), 'activo');
    
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK;
        PRINT 'Error: La transacción ha sido revertida';
    END
    ELSE
    BEGIN
        COMMIT;
        PRINT 'Transacción completada exitosamente';
    END
```

---

## Transacciones Anidadas

Las transacciones anidadas permiten ejecutar una transacción dentro de otra.
En SQL Server, el manejo es controlado mediante la variable del sistema @@TRANCOUNT.

### Características en SQL Server:



Cada COMMIT lo decrementa, pero solo el último COMMIT realmente confirma los cambios.

Un solo ROLLBACK revierte toda la cadena de transacciones.

Para rollback parciales se recomienda usar SAVE TRANSACTION.
1. **@@TRANCOUNT**: Variable global que indica el nivel de anidamiento de transacciones. Cada BEGIN TRANSACTION lo incrementa.
2. **COMMIT anidado**: Solo decrementa @@TRANCOUNT, no confirma realmente la transacción, pero el último COMMIT realmente confirma los cambios.
3. **ROLLBACK anidado**: Revierte TODA la transacción, sin importar el nivel de anidamiento.
4. **SAVE TRANSACTION**: La forma recomendada de simular transacciones anidadas reales.

### Estructura de Transacciones Anidadas:

```sql
BEGIN TRANSACTION; -- @@TRANCOUNT = 1
    -- Operaciones nivel 1
    
    BEGIN TRANSACTION; -- @@TRANCOUNT = 2
        -- Operaciones nivel 2
        
        BEGIN TRANSACTION; -- @@TRANCOUNT = 3
            -- Operaciones nivel 3
        COMMIT; -- @@TRANCOUNT = 2
        
    COMMIT; -- @@TRANCOUNT = 1
    
COMMIT; -- @@TRANCOUNT = 0 (se confirma realmente)
```

## Ventajas

### Ventajas Principales:

1. **Integridad de Datos**
   - Garantiza que los datos permanezcan consistentes
   - Previene estados intermedios inválidos

2. **Recuperación ante Fallos**
   - Permite revertir cambios en caso de error
   - Facilita la recuperación automática del sistema
   - Protege contra fallos de hardware o software

3. **Concurrencia Controlada**
   - Permite que múltiples usuarios trabajen simultáneamente
   - Evita conflictos entre operaciones concurrentes
   - Mantiene el aislamiento entre transacciones

4. **Auditabilidad**
   - Facilita el seguimiento de operaciones
   - Permite implementar logs de transacciones
   - Mejora la trazabilidad de cambios

5. **Simplicidad en el Código**
   - Código más limpio y mantenible
   - Menor probabilidad de errores lógicos
   - Facilita el testing y debugging


## Conclusiones

El manejo de transacciones es una herramienta esencial para garantizar la integridad y confiabilidad de los datos en sistemas complejos.
Las transacciones anidadas ofrecen una capa adicional de control que permite trabajar de manera modular, mejorando la robustez y trazabilidad de los procesos.

### Aspectos Clave del Manejo de Transacciones

1. **Las transacciones son fundamentales** para mantener la integridad y consistencia de los datos en sistemas de bases de datos.

2. **Las propiedades ACID** son el fundamento teórico que garantiza el comportamiento correcto de las transacciones.

3. **Las transacciones anidadas en SQL Server** requieren comprensión especial:
   - El COMMIT anidado solo decrementa @@TRANCOUNT
   - El ROLLBACK siempre revierte toda la transacción
   - Los SAVE TRANSACTION permiten rollback parcial

4. **El manejo de errores robusto** (TRY-CATCH) es esencial para transacciones confiables.

5. **Los bloqueos y niveles de aislamiento** son cruciales para manejar la concurrencia.

---