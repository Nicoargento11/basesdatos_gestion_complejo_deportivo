CREATE TABLE Plan (
    id_plan           INT IDENTITY(1,1) PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL,
    precio_mensual    DECIMAL(12,2) NOT NULL CHECK (precio_mensual >= 0),
    requiere_apto     BIT NOT NULL DEFAULT 1
);

CREATE TABLE Estado_Socio (
    id_estado         VARCHAR(20) PRIMARY KEY,
    nombre_estado     VARCHAR(100) NOT NULL
);

CREATE TABLE Tipo_Estado (
    id_tipo_estado    VARCHAR(30) PRIMARY KEY,
    nombre_tipo_estado VARCHAR(100) NOT NULL
);

CREATE TABLE Tipo_Instalacion (
    id_tipo_instalacion VARCHAR(30) PRIMARY KEY,
    nombre_tipo       VARCHAR(100) NOT NULL
);

CREATE TABLE Estado_Reserva (
    id_estado_reserva VARCHAR(20) PRIMARY KEY,
    descripcion       VARCHAR(100) NULL
);

CREATE TABLE Estado_Cuota (
    id_estado_cuota   VARCHAR(20) PRIMARY KEY,
    nombre_estado     VARCHAR(100) NOT NULL
);

CREATE TABLE Medio_Pago (
    id_medio_pago     VARCHAR(20) PRIMARY KEY,
    nombre_medio      VARCHAR(100) NOT NULL
);

CREATE TABLE Estado_Clase (
    id_estado_clase   VARCHAR(20) PRIMARY KEY,
    nombre_estado     VARCHAR(100) NOT NULL
);

CREATE TABLE Socio (
    dni               BIGINT NOT NULL UNIQUE,
    id_socio          INT IDENTITY(1,1) PRIMARY KEY,
    nombre_socio      VARCHAR(120) NOT NULL,
    apellido          VARCHAR(120) NOT NULL,
    email             VARCHAR(200) NULL,
    telefono          VARCHAR(50) NULL,
    fecha_alta        DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    id_estado         VARCHAR(20) NOT NULL,
    id_plan           INT NOT NULL,

    CONSTRAINT FK_Socio_Estado FOREIGN KEY (id_estado) REFERENCES Estado_Socio(id_estado),
    CONSTRAINT FK_Socio_Plan FOREIGN KEY (id_plan) REFERENCES Plan(id_plan)
);

CREATE TABLE Apto_Medico (
    id_apto_medico    INT IDENTITY(1,1) PRIMARY KEY,
    dni_socio         BIGINT NOT NULL,
    emitido_en        DATE NOT NULL,
    vence_en          DATE NOT NULL,
    observacion       VARCHAR(300) NULL,

    CONSTRAINT FK_AptoMedico_Socio FOREIGN KEY (dni_socio) REFERENCES Socio(dni),
    CONSTRAINT CHK_Vence_Despues_Emitido CHECK (vence_en >= emitido_en)
);

CREATE TABLE Profesor (
    id_profesor       INT IDENTITY(1,1) PRIMARY KEY,
    nombre_profesor   VARCHAR(120) NOT NULL,
    apellido_profesor VARCHAR(120) NOT NULL,
    telefono          VARCHAR(50) NULL
);

CREATE TABLE Cuota (
    id_cuota          BIGINT IDENTITY(1,1) PRIMARY KEY,
    dni_socio         BIGINT NOT NULL,
    periodo_inicio    DATE NOT NULL,
    periodo_fin       DATE NOT NULL,
    importe           DECIMAL(12,2) NOT NULL CHECK (importe >= 0),
    id_estado         VARCHAR(20) NOT NULL,
    id_plan           INT NOT NULL,

    CONSTRAINT FK_Cuota_Socio FOREIGN KEY (dni_socio) REFERENCES Socio(dni),
    CONSTRAINT FK_Cuota_Estado FOREIGN KEY (id_estado) REFERENCES Estado_Cuota(id_estado_cuota),
    CONSTRAINT FK_Cuota_Plan FOREIGN KEY (id_plan) REFERENCES Plan(id_plan),
    CONSTRAINT UQ_Cuota_Socio_Periodo UNIQUE (dni_socio, periodo_inicio),
    CONSTRAINT CHK_Periodo_Valido CHECK (periodo_fin >= periodo_inicio)
);

CREATE TABLE Pago (
    id_pago           BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_cuota          BIGINT NOT NULL,
    fecha_pago        DATETIME2(0) NOT NULL DEFAULT GETDATE(),
    monto             DECIMAL(12,2) NOT NULL CHECK (monto > 0),
    id_medio_pago     VARCHAR(20) NOT NULL,
    referencia        VARCHAR(100) NULL,

    CONSTRAINT FK_Pago_Cuota FOREIGN KEY (id_cuota) REFERENCES Cuota(id_cuota),
    CONSTRAINT FK_Pago_Medio FOREIGN KEY (id_medio_pago) REFERENCES Medio_Pago(id_medio_pago)
);

CREATE TABLE Actividad (
    id_actividad      INT IDENTITY(1,1) PRIMARY KEY,
    nombre_actividad  VARCHAR(120) NOT NULL UNIQUE,
    requiere_apto     BIT NOT NULL DEFAULT 1
);

CREATE TABLE Instalacion (
    id_instalacion    INT IDENTITY(1,1) PRIMARY KEY,
    nombre_instalacion VARCHAR(100) NOT NULL UNIQUE,
    id_tipo_estado    VARCHAR(30) NOT NULL,
    id_tipo_instalacion VARCHAR(30) NOT NULL,

    CONSTRAINT FK_Instalacion_Estado FOREIGN KEY (id_tipo_estado) REFERENCES Tipo_Estado(id_tipo_estado),
    CONSTRAINT FK_Instalacion_Tipo FOREIGN KEY (id_tipo_instalacion) REFERENCES Tipo_Instalacion(id_tipo_instalacion)
);

CREATE TABLE Actividad_Instalacion (
    id_actividad      INT NOT NULL,
    id_instalacion    INT NOT NULL,

    PRIMARY KEY (id_actividad, id_instalacion),
    CONSTRAINT FK_AI_Actividad FOREIGN KEY (id_actividad) REFERENCES Actividad(id_actividad),
    CONSTRAINT FK_AI_Instalacion FOREIGN KEY (id_instalacion) REFERENCES Instalacion(id_instalacion)
);

CREATE TABLE Clase (
    id_clase          INT IDENTITY(1,1) PRIMARY KEY,
    id_actividad      INT NOT NULL,
    id_profesor       INT NOT NULL,
    id_instalacion    INT NOT NULL,
    hora_inicio       DATETIME2(0) NOT NULL,
    hora_fin          DATETIME2(0) NOT NULL,
    cupo_personas     INT NOT NULL CHECK (cupo_personas > 0),
    id_estado_clase   VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Clase_Actividad FOREIGN KEY (id_actividad) REFERENCES Actividad(id_actividad),
    CONSTRAINT FK_Clase_Profesor FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor),
    CONSTRAINT FK_Clase_Instalacion FOREIGN KEY (id_instalacion) REFERENCES Instalacion(id_instalacion),
    CONSTRAINT FK_Clase_Estado FOREIGN KEY (id_estado_clase) REFERENCES Estado_Clase(id_estado_clase),
    CONSTRAINT CHK_Hora_Fin_Mayor_Inicio CHECK (hora_fin > hora_inicio)
);

CREATE TABLE Inscripcion (
    id_inscripcion    BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_clase          INT NOT NULL,
    dni_socio         BIGINT NOT NULL,
    fecha_inscripcion DATETIME2(0) NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Inscripcion_Clase FOREIGN KEY (id_clase) REFERENCES Clase(id_clase),
    CONSTRAINT FK_Inscripcion_Socio FOREIGN KEY (dni_socio) REFERENCES Socio(dni),
    CONSTRAINT UQ_Inscripcion_Socio_Clase UNIQUE(id_clase, dni_socio)
);

CREATE TABLE Reserva (
    id_reserva        BIGINT IDENTITY(1,1) PRIMARY KEY,
    dni_socio         BIGINT NOT NULL,
    id_instalacion    INT NOT NULL,
    id_estado_reserva VARCHAR(20) NOT NULL,
    horario_inicio    DATETIME2(0) NOT NULL,
    horario_fin       DATETIME2(0) NOT NULL,

    CONSTRAINT FK_Reserva_Socio FOREIGN KEY (dni_socio) REFERENCES Socio(dni),
    CONSTRAINT FK_Reserva_Instalacion FOREIGN KEY (id_instalacion) REFERENCES Instalacion(id_instalacion),
    CONSTRAINT FK_Reserva_Estado FOREIGN KEY (id_estado_reserva) REFERENCES Estado_Reserva(id_estado_reserva),
    CONSTRAINT CHK_Horario_Reserva_Valido CHECK (horario_fin > horario_inicio)
);

CREATE TABLE Acceso (
    id_acceso         BIGINT IDENTITY(1,1) PRIMARY KEY,
    dni_socio         BIGINT NOT NULL,
    fecha_hora        DATETIME2(0) NOT NULL DEFAULT GETDATE(),
    tipo              VARCHAR(10) NOT NULL,

    CONSTRAINT FK_Acceso_Socio FOREIGN KEY (dni_socio) REFERENCES Socio(dni),
    CONSTRAINT CHK_Tipo_Acceso CHECK (tipo IN ('ENTRADA', 'SALIDA'))
);
