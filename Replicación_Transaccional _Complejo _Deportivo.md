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

## Pasos para implementar la replicación transaccional

A continuación se detalla la implementación de una réplica transaccional en SQL Server Express utilizando la herramienta SQL Server Management Studio (SSMS) y servidores accesibles en red local o mediante servicios gratuitos como Microsoft Azure SQL Server (<https://azure.microsoft.com>) o Amazon RDS (<https://aws.amazon.com/rds/>):

1\. Instalar dos instancias de SQL Server (pueden ser locales o en la nube).  
2\. Crear una base de datos en la instancia principal (publicador) y una vacía en el suscriptor.  
3\. Configurar el SQL Server Agent en modo automático.  
4\. En SSMS: ir a 'Replication' > 'Local Publications' y crear una nueva publicación.  
5\. Elegir 'Transactional Publication'.  
6\. Seleccionar las tablas a replicar (ej: reservas, pagos, usuarios).  
7\. Crear un snapshot inicial.  
8\. Luego ir a 'Subscriptions' y crear una nueva suscripción apuntando a la instancia secundaria.  
9\. Validar la conexión y probar una modificación desde el publicador.  
10\. Verificar que el dato haya llegado correctamente al suscriptor.

Durante cada paso, se deberá documentar el comportamiento, errores encontrados y forma de validación, cumpliendo con los criterios de evaluación propuestos.