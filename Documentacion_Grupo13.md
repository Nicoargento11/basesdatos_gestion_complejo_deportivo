# PROYECTO DE ESTUDIO: VIDA ACTIVA

**Asignatura**: Bases de Datos I (FaCENA-UNNE)

**Grupo**: 13

**Integrantes**:
 - Sosa Diana Abril 
 - Valdes Nicolas 
 - Villordo Luciano
 - Romero Francisco Ignacio

**Año**: 2025

## CAPÍTULO I: INTRODUCCIÓN

### 1.1 Caso de Estudio 
El tema central de este proyecto se enfoca en el desarrollo de un sistema de base de datos funcional de un Club Deportivo llamado “Vida Activa” a partir de los conceptos teóricos aprendidos de la misma, logrando una correcta automatización, centralización y gestión de los socios, las inscripciones, pagos y demás del sistema planteado. En este ámbito también se buscará asegurar que los aspectos de seguridad, consistencia y manipulación de la información ingresada en cumplan con los estándares esperados de un sistema de base de datos. 

### 1.2 Planteamiento del Problema 

El Club Deportivo “Vida Activa” requiere que se valide tanto el estado de un socio (Cuota al dia y apta medica vigente) como el de la actividad a la que desea inscribirse (Capacidad de la clase, por ejemplo) antes de permitirles realizar dicha acción. Estas validaciones además deben cumplir con los siguientes estándares:  
•Optimización de la gestión de datos del Club Deportivo “Vida Activa” 
• Garantizar la integridad de las operaciones CRUD (en la gestión de Socios)  
• Cumplir con las complejas reglas de negocio (aptos, cuotas y cupos) de manera más eficiente y segura 

###1.3 Objetivo General 

Demostrar la utilidad de un sistema de base de datos por medio  y su impacto positivo a la hora de actuar como herramienta para almacenar, consultar y modificar datos mediante la correcta identificación de las entidades y los atributos que los representan de manera inequívoca. 

###1.3.1 Objetivos Específicos 
1. Identificar y documentar formalmente todas las Entidades y sus Atributos principales presentes en el sistema del Club Deportivo “Vida Activa” (Socios, Actividades, Pagos, etc.).

2. Determinar y describir las Relaciones que existen entre las entidades, especificando la cardinalidad y el grado de dependencia de cada una.

3. Elaborar un Diccionario de Datos completo que especifique, para cada atributo identificado, su tipo de dato, la longitud de almacenamiento, las restricciones de integridad (claves primarias y foráneas), y cualquier regla de negocio asociada.

4. Diseñar el Diagrama de Entidad-Relación (DER) que represente visualmente el modelo lógico de la base de datos, sirviendo como plano para la posterior construcción del modelo físico.

5. Establecer las bases de seguridad y consistencia al identificar los campos únicos y obligatorios que aseguren la integridad de la información sensible del club, como el DNI de los socios y las referencias entre las tablas de Cuotas y Pagos. 

###1.4 Alcance del Trabajo 
Se buscará definir correctamente todos los elementos que ayuden en la creación del modelo físico de la base de datos del escenario planteado, lo que incluirá por lo tanto la identificación de entidades, el tipo de relaciones que se forman entre ellas, sus atributos individuales y la forma en que estos mismos pueden almacenarse, todo esto especificados mediante el uso de un Diccionario de datos y un Diagrama de Entidad.
Una vez creada, la informacion almacenada estara especifica diseñada para comprobar la utilidad y eficacia de los temas previstos a desarrollar para el proyecto

## CAPITULO II: MARCO CONCEPTUAL O REFERENCIAL

**TEMA 1 " Procedimientos y Funciones Almacenadas"** 
![Acceder a la siguiente carpeta para ver el desarrollo del temal]()

**TEMA 2 " Optimización de consultas a través de índices"** 
![Acceder a la siguiente carpeta para ver el desarrollo del temal]()

**TEMA 3 " Manejo de transacciones y transacciones anidadas "** 
![Acceder a la siguiente carpeta para ver el desarrollo del temal]()

**TEMA 4 " Replica de Bases de Datos "** 
![Acceder a la siguiente carpeta para ver el desarrollo del temal]()


## CAPÍTULO III: METODOLOGÍA SEGUIDA 

 a) Primeramente se realizo una entrega que sentaba las bases del proyecto: Objetivos, temas a tratar, alcance, etc. En dicha sentencia se establecía bajo que contexto iba a funcionar la base de datos, eligiendose el de un club deportivo debido a que se podian plantear situaciones en las que seria necesrio establecer restriciones antes del ingreso de cual quier tipo de dato. Una vez definido con que tema trabajariamos, seguimos el procedimiento estandar al momento de desarrollar una base de datos funcional, empezando por la creacion de Sistema Entidad Relación el cual serviría para el diseño del diseño fisico de nuestra base de datos.

Tras habar completado la primera entrega, se repartieron los temas por integrante:

-Procedmientos y Funciones Almacenados
-Optimización de consultas a través de índices
-Manejo de transacciones y transacciones anidadas
-Replica de Bases de Datos

Cada integrante trabajo su tema de forma independiente en su maquina de trabajo y una vez que cada uno concluyera su parte, se llevo a cabo una puesta en comun para trabajar en una sola version del base de datos en el cual se le aplicarían todo los temas investigados
 
b) Herramientas (Instrumentos y procedimientos)
-ERD Plus: Herramienta intuitiva y efectiva para el modelado de bases de datos, que permite crear diagramas relacionales y conceptuales, además de generar código SQL. Con ERD Plus, logramos diseñar el esquema conceptual de nuestro proyecto.

-SQL Server Management Studio 22: Software de administración de bases de datos creado por Microsoft, diseñado principalmente para trabajar con SQL Server y otros lenguajes de consulta, allí desarrollamos las consultas para los temas individuales y carga de datos.

-Discord: aplicación de comunicación gratuita y versátil que permite a usuarios de todo el mundo conectarse a través de texto, voz y video Con ella fue posible realizar encuentros virtuales que ayudaron en la organizacion del trabajo

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS 

### Diagrama Relacional:
<img width="916" height="437" alt="image" src="https://github.com/user-attachments/assets/e42971f2-582f-4ef9-9ed6-00093ecafed4" />

### Diccionario de datos

Acceso al documento [PDF](doc/Diccionario_de_Datos.pdf) del diccionario de datos.

### Desarrollo TEMA 1 "Procedimientos y funciones almacenadas"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema_1](script/tema01_nombre_tema)

### Desarrollo TEMA 2 "Optimización de consultas a través de índices"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema_2](script/tema02_nombre_tema)

### Desarrollo TEMA 3 "Manejo de transacciones y transacciones anidadas"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema_3](script/tema02_nombre_tema)

### Desarrollo TEMA 4 "Replica Base de Datos"

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema_4](script/tema02_nombre_tema)

## CAPÍTULO V: CONCLUSIONES

Este trabajo práctico facilitó la compresion de la relevancia de una arquitectura de bases de datos robusta y un diseño apropiado en SQL Server para la administración eficiente y segura de la información crítica. En el transcurso de este proyecto, se logro alcanzar los objetivos establecidos para el Club Deportivo “Vida Activa”, destacando la implementación de herramientas avanzadas que garantizan la integridad de las operaciones y optimizan la gestión de datos.

La implementación de Procedimientos y Funciones Almacenadas resultó sirvieron para validar las reglas de negocio un club deportivo, como la verificación simultánea del estado de la cuota, la vigencia del apto médico del socio y la capacidad disponible de la actividad. Esto posibilitó la modularización de tareas recurrentes, asegurando la aplicación de las reglas de manera centralizada y segura.

El Manejo de Transacciones y su aplicación en procesos complejos (incluyendo transacciones anidadas) garantizó el estándar ACID en todas las operaciones de gestión de datos de los Socios e, indispensablemente, en el proceso de inscripción. Al envolver múltiples validaciones y actualizaciones en una única unidad de trabajo, manteniendo la consistencia de la base de datos ante cualquier fallo.

La Optimización de Consultas a través de Índices incrementó de manera notable el desempeño del sistema. La correcta indexación se aplicó estratégicamente para acelerar los tiempos de respuesta durante las consultas de validación en tiempo real (aptos y cuotas), minimizando la latencia y mejorando significativamente la eficiencia operativa del club.

Por ultimo, la Réplica de Bases de Datos (Replicación Transaccional Unidireccional) se estableció como una solución estratégica para la disponibilidad y el rendimiento al designar al Suscriptor como una fuente de datos de solo lectura, se permitió descargar la carga de trabajo de consulta y generación de informes del servidor principal (Publicador), asegurando que el servidor transaccional primario pueda dedicarse exclusivamente a las operaciones de alta demanda sin comprometer su velocidad ni la integridad de los datos.

De esta manera, la aplicación estratégica de estos temas en SQL Server facilitó la obtención de una solución eficaz y segura, en concordancia con los objetivos de optimización y cumplimiento de reglas de negocio. Este proyecto no solo consolidó los conocimientos teóricos, sino que también demostró la importancia crítica de una gestión meticulosa y organizada de las bases de datos en un contexto del mundo real.

## BIBLIOGRAFÍA DE CONSULTA



 1. > Microsoft. (n.d.). *Transactional replication*. Microsoft Learn.  
    > https://learn.microsoft.com/en-us/sql/relational-databases/replication/transactional/transactional-replication
 2. List item
 3. List item
 4. List item
 5. List item

