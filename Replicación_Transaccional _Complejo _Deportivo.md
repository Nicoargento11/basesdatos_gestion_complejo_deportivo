# Replicación Transaccional Aplicada a un Complejo Deportivo

En sistemas distribuidos, la replicación de bases de datos permite copiar datos desde una instancia central a otras instancias remotas para mejorar la disponibilidad, rendimiento y seguridad. Entre los tipos de replicación más usados se encuentran la transaccional, la de mezcla y el modelo maestro-esclavo. En este documento nos enfocaremos en la replicación transaccional, que será aplicada como solución tecnológica para un complejo deportivo con necesidades operativas específicas.

## ¿Qué es la replicación transaccional?

La replicación transaccional es una técnica de sincronización de datos utilizada principalmente en SQL Server. Consiste en propagar en tiempo casi real los cambios que ocurren en una base de datos origen (denominada publicador) hacia otra base de datos destino (denominada suscriptor). Esta propagación incluye las transacciones INSERT, UPDATE y DELETE ejecutadas sobre las tablas seleccionadas.  
<br/>El modelo es unidireccional: los datos solo se modifican en el publicador. El suscriptor actúa como una copia de solo lectura, ideal para consultas, análisis o respaldo. Esta solución está pensada para entornos donde se requiere alta disponibilidad de datos sin comprometer la consistencia del origen.

## Aplicación al Complejo Deportivo

El complejo deportivo en estudio cuenta con múltiples áreas operativas como reservas de canchas, pagos de socios, registro de asistencia y clases programadas. Estos datos son sensibles y requieren disponibilidad constante.  
<br/>Imaginemos que el complejo tiene:  
\- Un servidor principal en la sede administrativa (oficina central), donde se realizan todas las operaciones de registro de datos: reservas, pagos, altas de usuarios, etc.  
\- Un segundo servidor (o instancia SQL) ubicado en otra dependencia o red de soporte (como un centro de monitoreo o de reportes), que necesita tener acceso actualizado a esos datos para generar estadísticas o supervisar la actividad operativa.  
<br/>Mediante la replicación transaccional, cada modificación que se realice en el servidor principal se replica automáticamente en la base secundaria. Por ejemplo, cuando un usuario reserva una cancha o paga su cuota, ese registro se envía al suscriptor y queda disponible allí para ser consultado por el equipo de administración o por sistemas complementarios.

## Ventajas en el escenario propuesto

\- Alta disponibilidad: Si la instancia principal se cae, los datos siguen accesibles para consulta.  
\- Desacoplamiento de cargas: Las consultas pesadas o reportes pueden hacerse sobre el suscriptor sin afectar el rendimiento del servidor principal.  
\- Copia de respaldo: El suscriptor puede actuar como respaldo casi en tiempo real, útil ante errores o caídas.  
\- Seguridad: Permite acceso limitado a información sin dar permisos de escritura sobre la base real.

## Justificación frente a otras opciones

A diferencia de la replicación de mezcla, que permite escritura en todos los nodos y requiere mecanismos de resolución de conflictos, la replicación transaccional es más simple de administrar, más segura y suficiente para el contexto del complejo deportivo, donde hay un único origen confiable de datos y varios lectores.

### Pasos para implementar la replicación transaccional 

1. **Instalar SQL Server con el componente de replicación en ambas instancias.**  
   Esto se hace desde el SQL Server Installation Center, modificando la instalación existente y activando 'SQL Server Replication'.

2. **Crear dos instancias de SQL Server en la misma computadora:**  
   Una actuará como publicador y otra como suscriptor.

3. **Crear una carpeta en `C:\` con permisos compartidos** (ej: `C:\replicacion\`)  
   Esta carpeta se usa para almacenar los archivos de snapshot de replicación.

4. **Crear los usuarios SQL con autenticación y rol `sysadmin`,**  
   necesarios para los agentes de replicación.

5. **Conectarse a la instancia publicadora, ir a `Replication` > `Configure Distribution`**  
   y configurar el distribuidor local usando la carpeta compartida.

6. **Crear una nueva publicación en `Local Publications`.**  
   Seleccionar la base de datos, tipo 'Transactional Publication' y las tablas a replicar.

7. **Configurar el snapshot inicial y los credenciales del agente de snapshot.**

8. **Nombrar y finalizar la publicación.**

9. **Conectarse a la instancia suscriptora y crear una base de datos vacía**  
   que recibirá los datos replicados.

10. **Desde la instancia publicadora, ir a `Local Publications` > clic derecho > `New Subscription`.**  
    Seleccionar la publicación creada.

11. **Elegir `Push Subscription`, seleccionar la instancia del suscriptor,**  
    base de datos de destino y usuario SQL configurado.

12. **Finalizar el asistente y validar que los datos se replique automáticamente**  
    desde el publicador al suscriptor.

### Conclusión

La réplica transaccional entre dos instancias en una misma PC funcionó correctamente, cumpliendo los objetivos de sincronización de datos.  
Se han replicado los cambios en tiempo real desde el publicador al suscriptor, y se documentaron todos los pasos.  
Este modelo permite separar cargas de lectura y escritura, mejora la disponibilidad y asegura consistencia.  
La práctica permitió comprender cómo aplicar este enfoque a contextos reales como un complejo deportivo.
