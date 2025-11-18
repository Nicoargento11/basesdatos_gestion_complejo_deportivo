# 🏋️ Vida Activa - Sistema de Gestión de Club Deportivo

**Asignatura**: Bases de Datos I  
**Institución**: FaCENA - UNNE  
**Grupo**: 13  
**Año**: 2025

---

## 📋 Descripción del Proyecto

Sistema de base de datos completo para la gestión integral de un club deportivo, implementando conceptos avanzados de bases de datos relacionales en SQL Server 2022.

### 🎯 Objetivo General

Demostrar la utilidad y eficiencia de un sistema de base de datos robusto mediante la implementación de técnicas avanzadas de gestión, optimización y automatización para el manejo de socios, actividades, pagos e inscripciones del Club Deportivo "Vida Activa".

---

## 👥 Integrantes del Equipo

- **Sosa Diana Abril**
- **Valdes Nicolas**
- **Villordo Luciano**
- **Romero Francisco Ignacio**

---

## 🗂️ Estructura del Repositorio

```
basesdatos_gamebox/
├── doc/                          # Documentación e imágenes
├── script/                       # Scripts SQL del proyecto
│   ├── vidaActiva.sql           # Script principal de la BD
│   ├── tema01_Funciones_Y_Procedimientos_Almacenados/
│   │   ├── Funciones_Procedimientos.sql
│   │   └── Funciones_Y_Procedimientos_Almacenados.md
│   ├── tema02_optimizacion_con_indices/
│   │   ├── cargaMasiva.sql
│   │   ├── optimizacionConIndices.sql
│   │   ├── optimizacionConIndicesII.sql
│   │   └── optimizacionConIndices.md
│   ├── tema03_manejo_de_transacciones/
│   │   ├── casos_practicos_transacciones.sql
│   │   ├── datos_prueba.sql
│   │   └── Manejo_de_transacciones.md
│   └── tema04_replica_transaccional/
│       └── Replicación_Transaccional_Complejo_Deportivo.md
├── Documentacion_Grupo13.md     # Documento principal del proyecto
├── LICENSE
└── README.md
```

---

## 🗄️ Modelo de Datos

### Entidades Principales

El sistema gestiona las siguientes entidades:

- **Socio**: Información personal y estado de membresía
- **Cuota**: Control de pagos mensuales
- **Pago**: Registro de transacciones
- **Actividad**: Disciplinas deportivas ofrecidas
- **Clase**: Programación de horarios y profesores
- **Inscripción**: Relación socio-clase
- **Reserva**: Agendamiento de instalaciones
- **Instalación**: Espacios físicos del club
- **Apto Médico**: Control de certificados médicos
- **Profesor**: Instructores de actividades
- **Medio de Pago**: Métodos de pago disponibles

---

## 📚 Temas Desarrollados

### 1️⃣ Funciones y Procedimientos Almacenados

**Ubicación**: `script/tema01_Funciones_Y_Procedimientos_Almacenados/`

**Contenido**:
- Procedimientos almacenados para operaciones CRUD
- Funciones para cálculos y validaciones
- Automatización de procesos de negocio
- Validaciones complejas (aptos médicos, cuotas, cupos)

**Archivo principal**: `Funciones_Y_Procedimientos_Almacenados.md`

---

### 2️⃣ Optimización con Índices

**Ubicación**: `script/tema02_optimizacion_con_indices/`

**Contenido**:
- Análisis de rendimiento de consultas
- Implementación de índices clustered y non-clustered
- Carga masiva de datos para pruebas
- Comparación de tiempos de ejecución
- Mejores prácticas de indexación

**Archivos clave**:
- `cargaMasiva.sql`: Generación de datos de prueba
- `optimizacionConIndices.sql`: Implementación de índices
- `optimizacionConIndicesII.sql`: Casos avanzados
- `optimizacionConIndices.md`: Documentación completa

---

### 3️⃣ Manejo de Transacciones

**Ubicación**: `script/tema03_manejo_de_transacciones/`

**Contenido**:
- Propiedades ACID
- Transacciones explícitas e implícitas
- Transacciones anidadas
- Manejo de errores con TRY-CATCH
- SAVEPOINT y control de rollback
- Casos prácticos de uso

**Archivos clave**:
- `casos_practicos_transacciones.sql`: Ejemplos completos
- `datos_prueba.sql`: Datos para testing
- `Manejo_de_transacciones.md`: Marco teórico y referencial
- `trabajo_practico_transacciones.sql`: Trabajo práctico evaluable

**Casos implementados**:
1. Demostración sin transacción vs con transacción
2. Inscripción completa de nuevo socio
3. Alta de socio con cuota y pago inicial
4. Inscripción a clase con validaciones
5. Transferencia de socio entre clases
6. Pago de cuota atrasada

---

### 4️⃣ Replicación Transaccional

**Ubicación**: `script/tema04_replica_transaccional/`

**Contenido**:
- Configuración de replicación transaccional en SQL Server
- Arquitectura distribuidor-publicador-suscriptor
- Sincronización de datos en tiempo real
- Casos de uso y mejores prácticas

**Archivo principal**: `Replicación_Transaccional_Complejo_Deportivo.md`

---

## 🚀 Cómo Ejecutar el Proyecto

### Requisitos Previos

- SQL Server 2019 o superior
- SQL Server Management Studio (SSMS)
- Permisos de administrador para crear bases de datos

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/Nicoargento11/basesdatos_gamebox.git
cd basesdatos_gamebox
```

2. **Crear la base de datos principal**
```sql
-- Ejecutar en SSMS
USE master;
GO
-- Abrir y ejecutar: script/vidaActiva.sql
```

3. **Ejecutar scripts por tema** (en orden)
```sql
-- Tema 1: Funciones y Procedimientos
USE Vida_Activa;
GO
-- Ejecutar: script/tema01_Funciones_Y_Procedimientos_Almacenados/Funciones_Procedimientos.sql

-- Tema 2: Optimización con Índices
-- Ejecutar: script/tema02_optimizacion_con_indices/cargaMasiva.sql
-- Ejecutar: script/tema02_optimizacion_con_indices/optimizacionConIndices.sql

-- Tema 3: Manejo de Transacciones
-- Ejecutar: script/tema03_manejo_de_transacciones/casos_practicos_transacciones.sql

-- Tema 4: Consultar documentación de replicación
```

---

## 📖 Documentación

### Documento Principal

**[Documentacion_Grupo13.md](Documentacion_Grupo13.md)**

Contiene:
- Introducción y caso de estudio
- Planteamiento del problema
- Objetivos específicos
- Marco conceptual
- Desarrollo de cada tema
- Conclusiones y referencias

### Documentación por Tema

Cada carpeta de tema contiene su archivo `.md` específico con:
- Marco teórico
- Ejemplos prácticos
- Casos de uso
- Mejores prácticas
- Bibliografía

---

## 🔧 Tecnologías Utilizadas

- **SGBD**: Microsoft SQL Server 2022
- **Lenguaje**: T-SQL (Transact-SQL)
- **Herramientas**: SQL Server Management Studio (SSMS)
- **Control de versiones**: Git/GitHub
- **Documentación**: Markdown

---

## 📊 Funcionalidades Clave

### Gestión de Socios
- Alta, baja y modificación de socios
- Control de estado (activo/inactivo/suspendido)
- Validación de aptos médicos

### Sistema de Pagos
- Registro de cuotas mensuales
- Múltiples medios de pago
- Control de cuotas vencidas
- Generación automática de cuotas

### Inscripciones y Reservas
- Inscripción a clases con validación de cupo
- Verificación de requisitos (apto médico)
- Sistema de reservas de instalaciones
- Control de conflictos de horarios

### Optimización
- Índices para consultas frecuentes
- Procedimientos almacenados optimizados
- Transacciones para integridad de datos

---

**Universidad Nacional del Nordeste**  
**Facultad de Ciencias Exactas y Naturales y Agrimensura**  
**Licenciatura en Sistemas de Información**  
**2025**
