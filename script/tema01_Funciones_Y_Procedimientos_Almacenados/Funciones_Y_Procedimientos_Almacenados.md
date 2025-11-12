*Funciones y Procedimientos Almacenados en SQL*

Este documento describe la funcionalidad y las diferencias esenciales entre los Procedimientos Almacenados y las Funciones definidas por el usuario 
en los sistemas de gestión de bases de datos (DBMS).

*Procedimientos Almacenados (Stored Procedures)*

Un Procedimiento Almacenado es un conjunto precompilado de sentencias SQL y lógica de negocio que se almacena en el servidor de la base de datos. 
Su principal objetivo es ejecutar una secuencia de operaciones en la base de datos de manera automatizada y optimizada.

*Descripción y Uso*

Los procedimientos almacenados se invocan explícitamente utilizando comandos como EXEC (en SQL Server) o CALL (en MySQL). En cuanto a su definición, 
un procedimiento puede recibir cero o muchos parámetros, los cuales pueden ser de entrada (IN), de salida (OUT), o de entrada/salida (INOUT).
Una de sus características más importantes es su capacidad para modificar el estado de la base de datos, ya que pueden ejecutar cualquier operación de
manipulación de datos, incluyendo SELECT, INSERT, UPDATE y DELETE. Además, pueden devolver cero, un valor único o múltiples conjuntos de resultados. El
valor de retorno es opcional y a menudo se utiliza como un código de estado. Son fundamentales para la programación transaccional, ya que soportan 
transacciones (BEGIN TRANSACTION, COMMIT, ROLLBACK) para garantizar la atomicidad de las operaciones. También permiten el manejo de errores utilizando 
bloques como TRY CATCH. Un procedimiento almacenado puede llamar a otras Funciones definidas por el usuario o a otros Procedimientos Almacenados, y 
generalmente permite el uso de objetos temporales como tablas temporales (por ejemplo, #temp en SQL Server) y variables de tabla.

*Ventajas del Uso de Procedimientos*

La utilización de procedimientos almacenados ofrece beneficios significativos en varias áreas:

Rendimiento y Eficiencia: El código se compila una sola vez, y sus planes de ejecución se almacenan en caché y se reutilizan, lo que acelera las ejecuciones 
posteriores. Además, al encapsular varias sentencias en una sola llamada, se reduce el tráfico de red entre el cliente y el servidor.

Seguridad: Permiten implementar un control de acceso estricto, ya que se pueden otorgar permisos de ejecución sobre el procedimiento sin necesidad de dar acceso 
directo a las tablas subyacentes.

Mantenibilidad: Centralizan la lógica de negocio. Si esta lógica requiere un cambio, solo se modifica el procedimiento en el servidor, manteniendo la modularidad
y simplificando el mantenimiento.

*Funciones (User-Defined Functions - UDF)*

Una Función Almacenada es un objeto de base de datos diseñado principalmente para realizar cálculos y devolver un valor. Se invocan dentro de una expresión SQL 
como si fueran parte de la sintaxis estándar del lenguaje.

*Descripción y Uso*

Las funciones se crean con la sentencia CREATE FUNCTION y se invocan directamente dentro de una expresión SQL, por ejemplo, dentro de una cláusula SELECT, WHERE
o JOIN, actuando como un campo más de la consulta. Existen dos tipos principales: las Funciones Escalares, que retornan un único valor (como un número o una cadena), y las Funciones con Valores de Tabla (TVF), que retornan un conjunto de datos en formato de tabla.
Una diferencia crucial con los procedimientos es que las funciones siempre deben devolver un valor (es obligatorio), ya sea un escalar o una tabla. Además, solo
aceptan parámetros de entrada; no soportan parámetros de salida. Por diseño, las funciones están destinadas a ser deterministicas y no se les permite modificar el 
estado de la base de datos. Por lo tanto, solo pueden contener sentencias SELECT para recuperar o calcular datos; no pueden ejecutar INSERT, UPDATE o DELETE. 
Tampoco soportan transacciones ni bloques de manejo de errores como TRY...CATCH. Una función puede llamar a otras Funciones, pero no puede llamar a Procedimientos
Almacenados.

*Diferencias Clave entre Procedimientos y Funciones*

Para resumir la distinción entre estas dos rutinas de base de datos:

Modificación de Datos: El Procedimiento Almacenado puede modificar datos (INSERT/UPDATE/DELETE), mientras que la Función no puede (solo SELECT).

Valor de Retorno: La Función siempre devuelve un valor único o una tabla (es obligatorio). El Procedimiento Almacenado puede devolver cero, uno o 
múltiples conjuntos de resultados, y el valor de retorno es opcional.

Uso en Sentencias SQL: La Función se puede embeber directamente en una sentencia SELECT, WHERE o JOIN. El Procedimiento Almacenado debe ser ejecutado 
por separado mediante EXEC o CALL.

Parámetros: El Procedimiento Almacenado admite parámetros de entrada, salida y entrada/salida. La Función solo acepta parámetros de entrada.

Jerarquía de Llamadas: Un Procedimiento Almacenado puede llamar a una Función, pero una Función no puede llamar a un Procedimiento Almacenado.

Transacciones y Errores: El Procedimiento Almacenado permite el manejo de transacciones y bloques TRY...CATCH; la Función no lo permite.
