# TEMA 1:Funciones y Procedimientos Almacenados en SQL

### Procedimientos Almacenados (Stored Procedures)

Un Procedimiento Almacenado es un conjunto precompilado de sentencias SQL y lógica de negocio que se almacena en el servidor de la base de datos. Su principal objetivo es ejecutar una secuencia de operaciones en la base de datos de manera automatizada y optimizada. Estos se invocan explícitamente utilizando comandos como EXEC (en SQL Server) o CALL (en MySQL), en cuanto a su definición, un procedimiento puede recibir cero o muchos parámetros, los cuales pueden ser de entrada (IN), de salida (OUT), o de entrada/salida (INOUT). Su caracterísctica más importante características más importantes es su capacidad para modificar el estado de la base de datos, ya que pueden ejecutar cualquier operación de manipulación de datos, incluyendo SELECT, INSERT, UPDATE y DELETE. Además, pueden devolver cero, un valor único o múltiples conjuntos de resultados. 

El valor de retorno es opcional y a menudo se utiliza como un código de estado. Son fundamentales para la programación transaccional, ya que soportan 
transacciones (BEGIN TRANSACTION, COMMIT, ROLLBACK) para garantizar la atomicidad de las operaciones. También permiten el manejo de errores utilizando 
bloques como TRY CATCH. Un procedimiento almacenado puede llamar a otras Funciones definidas por el usuario o a otros Procedimientos Almacenados, y 
generalmente permite el uso de objetos temporales como tablas temporales (por ejemplo, #temp en SQL Server) y variables de tabla.

### Ventajas del Uso de Procedimientos

La utilización de procedimientos almacenados ofrecen los siguientes beneficios :

1- Rendimiento y Eficiencia: El código se compila una sola vez, y sus planes de ejecución se almacenan en caché y se reutilizan, lo que acelera las ejecuciones 
posteriores. Además, al encapsular varias sentencias en una sola llamada, se reduce el tráfico de red entre el cliente y el servidor.

2- Seguridad: Permiten implementar un control de acceso estricto, ya que se pueden otorgar permisos de ejecución sobre el procedimiento sin necesidad de dar acceso 
directo a las tablas subyacentes.

3- Mantenibilidad: Centralizan la lógica de negocio. Si esta lógica requiere un cambio, solo se modifica el procedimiento en el servidor, manteniendo la modularidad
y simplificando el mantenimiento.

4- Desacoplamiento de la lógica de negocios: Permiten desacoplar la lógica de negocios de la aplicación, lo que facilita la gestión de la base de datos y la aplicación de manera independiente. La aplicación puede centrarse solo en la presentación de los datos, mientras que la base de datos se encarga de la lógica.

### Funciones

Una Función Almacenada es un objeto de base de datos diseñado principalmente para realizar cálculos y devolver un valor. Se invocan dentro de una expresión SQL 
como si fueran parte de la sintaxis estándar del lenguaje.Estas se crean con la sentencia CREATE FUNCTION y se invocan directamente dentro de una expresión SQL, por ejemplo, dentro de una cláusula SELECT, WHERE o JOIN, actuando como un campo más de la consulta. Existen dos tipos principales: las Funciones Escalares, que retornan un único valor (como un número o una cadena), y las Funciones con Valores de Tabla (TVF), que retornan un conjunto de datos en formato de tabla.
Una diferencia crucial con los procedimientos es que las funciones siempre van y deben devolver un valor. Además, solo aceptan parámetros de entrada; no soportan parámetros de salida a diferencia de los procedimientos Almacenados. 

Por diseño, las funciones están destinadas a ser deterministicas y no se les permite modificar el estado de la base de datos, por lo tanto, solo pueden contener sentencias SELECT para recuperar o calcular datos; no pueden ejecutar INSERT, UPDATE o DELETE. Tampoco soportan transacciones ni bloques de manejo de errores como TRY CATCH. Además una función puede llamar a otras Funciones, pero no puede llamar a Procedimientos
Almacenados.

### Ventajas del Uso de Funciones

La utilización de funciones ofrecen los siguientes beneficios:

1-Optimización del Rendimiento: Cuando una función es determinística (es decir, devuelve el mismo resultado para las mismas entradas y no tiene efectos secundarios), SQL Server puede optimizar su ejecución. Las Funciones Escalares Multi-Statement o las Funciones con Valor de Tabla (TVFs) en línea a menudo son optimizadas de manera eficiente por el motor de consultas, aunque el rendimiento siempre debe ser monitoreado.

2-Validaciones de Solo Lectura: Como no pueden modificar datos (INSERT/UPDATE/DELETE), ofrecen una garantía de solo lectura. Esto las hace ideales para tareas de auditoría, cálculo, o validaciones que no deben tener efectos secundarios en el estado de las tablas, reforzando la integridad de la base de datos.

3-Reutilización del Código:Una vez definida, una función puede ser llamada repetidamente desde cualquier parte de la base de datos: desde consultas SELECT, otras Funciones, o Procedimientos Almacenados. Esto reduce la duplicación de código y simplifica el mantenimiento.

4-Encapsulamiento de Lógica: Permiten encapsular lógica de negocio compleja (como el cálculo de la antigüedad, tarifas especiales o la validación del apto médico en tu proyecto) en un solo lugar. Esto abstrae la complejidad de la consulta principal.

### Diferencias Clave: Procedimientos Almacenados vs. Funciones 

Para concluir, tenemos entonces las siguientes diferencias:

-Modificacion de datos:
Procedimientos Almacenados: Poseen plena autoridad para ejecutar sentencias de Lenguaje de Manipulación de Datos (DML), lo que incluye INSERT, UPDATE y DELETE. Esta capacidad es indispensable cuando la lógica de negocio requiere registrar un evento, modificar un estado o eliminar un registro, como ocurrió con la lógica de inscripción en "Vida Activa".
Funciones: Son inherentemente limitadas a la lectura de datos. Una función solo puede ejecutar sentencias SELECT y no tiene permitido realizar ninguna operación que modifique el estado de las tablas. Esto garantiza que las funciones se comporten como componentes puramente determinísticos o de solo lectura, ideales para cálculos o formateo de datos.

-Valor de Retorno:
Funciones: Siempre deben devolver un valor. Este retorno es obligatorio y puede ser un valor único (Función Escalar) o un conjunto de filas (Función con Valor de Tabla - TVF). Este resultado debe ser capturado o utilizado directamente en la sentencia SQL que la invoca.
Procedimientos Almacenados: El valor de retorno es opcional. Un SP puede devolver cero, uno o múltiples conjuntos de resultados (tables) a través de sentencias SELECT. Adicionalmente, puede devolver un valor entero (cero o diferente de cero) para indicar el estado de la ejecución (por ejemplo, 0 para éxito, y otros códigos para tipos específicos de fallos).

-Uso en Sentencias SQL:
Funciones: Pueden ser "embebidas" y utilizadas directamente como cualquier expresión dentro de una sentencia SQL. Esto significa que pueden aparecer en la lista de campos de un SELECT, dentro de una cláusula WHERE para filtrar datos, o incluso en una cláusula FROM o JOIN si son funciones de valor de tabla. Actúan como si fueran una columna o una tabla temporal.
Procedimientos Almacenados: No se pueden integrar en las consultas. Deben ser ejecutados como una sentencia independiente mediante el comando EXEC o, en otros lenguajes, su equivalente CALL. Esto subraya su rol como controladores de flujo y ejecutores de lógica de negocio en lugar de ser meras fuentes de datos.

-Manejo de Transacciones y Errores:
Procedimientos Almacenados: Tienen soporte completo para comandos transaccionales (BEGIN TRAN, COMMIT TRAN, ROLLBACK TRAN) y manejo de errores mediante bloques TRY CATCH. Esta capacidad es esencial para garantizar la atomicidad de operaciones complejas (como la inscripción en "Vida Activa"), asegurando que todas las sub-operaciones se completen exitosamente o ninguna lo haga.
Funciones: No tienen soporte para transacciones. Si ocurre un error, la ejecución falla, pero la función no puede revertir otras operaciones que hayan podido ocurrir antes en el mismo proceso. Tampoco permiten la implementación de bloques TRY...CATCH para un manejo de errores robusto.

-Parámetros:
Procedimientos Almacenados: Son la herramienta más flexible en el manejo de parámetros. Aceptan parámetros de Entrada (INPUT), Salida (OUTPUT) e incluso parámetros que funcionan como Entrada/Salida (INPUT/OUTPUT). Los parámetros de salida son muy útiles para devolver información de diagnóstico o valores generados por el SP, como un ID recién creado.
Funciones: Solo admiten parámetros de Entrada (INPUT). Todo el resultado de la función debe ser devuelto a través del valor de retorno obligatorio.

-Jerarquía de Llamadas:
Procedimientos Almacenados: Pueden llamar a otras Funciones y a otros Procedimientos Almacenados sin restricciones (excepto las limitaciones de anidamiento de SQL Server).
Funciones: Solo pueden llamar a otras Funciones. Una función tiene terminantemente prohibido llamar a un Procedimiento Almacenado, reforzando la regla de que las funciones no pueden tener efectos secundarios (modificar datos).

