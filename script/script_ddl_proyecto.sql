CREATE TABLE socio
(
    dni_socio INT NOT NULL,
    nombre_socio VARCHAR(200) NOT NULL,
    apellido VARCHAR(200) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono INT NOT NULL,
    fecha_alta DATE NOT NULL,
    estado_socio VARCHAR(200) NOT NULL,
    
    CONSTRAINT PK_Socio PRIMARY KEY (dni_socio)

    CONSTRAINT CHK_EstadoSocio CHECK (estado_reserva IN ('activo', 'suspendido', 'baja'))
);

CREATE TABLE apto_medico
(
    id_apto_medico INT NOT NULL,
    emitido_en DATE NOT NULL,
    vence_en DATE NOT NULL,
    observacion VARCHAR(400) NOT NULL,
    dni_socio INT NOT NULL,
    
    CONSTRAINT PK_AptoMedico PRIMARY KEY (id_apto_medico),
    CONSTRAINT FK_AptoMedico_Socio FOREIGN KEY (dni_socio) REFERENCES socio(dni_socio)
);

CREATE TABLE actividad
(
    id_actividad INT NOT NULL,
    nombre_actividad VARCHAR(100) NOT NULL,
    requiere_apto VARCHAR(200) NOT NULL,
    
    CONSTRAINT PK_Actividad PRIMARY KEY (id_actividad)
    CONSTRAINT CHK_RequiereApto CHECK (estado_reserva IN ('abierta', 'cerrada', 'cancelada'))
);

CREATE TABLE cuota
(
    id_cuota INT NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,
    importe FLOAT NOT NULL,
    estado_cuota VARCHAR(200) NOT NULL,
    dni_socio INT NOT NULL,
    
    CONSTRAINT PK_Cuota PRIMARY KEY (id_cuota),
    CONSTRAINT FK_Cuota_Socio FOREIGN KEY (dni_socio) REFERENCES socio(dni_socio)
);

CREATE TABLE profesor
(
    id_profesor INT NOT NULL,
    nombre_profesor VARCHAR(200) NOT NULL,
    apellido_profesor VARCHAR(200) NOT NULL,
    telefono INT NOT NULL,
    
    CONSTRAINT PK_Profesor PRIMARY KEY (id_profesor)
);

CREATE TABLE acceso
(
    id_acceso INT NOT NULL,
    fecha_hora DATE NOT NULL,
    dni_socio INT NOT NULL,
    
    CONSTRAINT PK_Acceso PRIMARY KEY (id_acceso),
    CONSTRAINT FK_Acceso_Socio FOREIGN KEY (dni_socio) REFERENCES socio(dni_socio)
);

CREATE TABLE instalacion
(
    id_instalacion INT NOT NULL,
    nombre_instalacion VARCHAR(200) NOT NULL,
    capacidad_personas INT NOT NULL,
    tipo_estado VARCHAR(200) NOT NULL,
    tipo_instalacion VARCHAR(200) NOT NULL,
    
    CONSTRAINT PK_Instalacion PRIMARY KEY (id_instalacion)

    CONSTRAINT CHK_TipoEstado CHECK (estado_reserva IN ('disponible', 'En mantenimiento'))
    CONSTRAINT CHK_TipoInstalacion CHECK (estado_reserva IN ('Cancha', 'Pileta', 'Gym'))
);

CREATE TABLE reserva
(
    fecha_reserva DATE NOT NULL,
    id_reserva INT NOT NULL,
    horario_inicio DATE NOT NULL,
    horario_fin DATE NOT NULL,
    estado_reserva VARCHAR(200) NOT NULL,
    dni_socio INT NOT NULL,
    id_instalacion INT NOT NULL,
    
    CONSTRAINT PK_Reserva PRIMARY KEY (id_reserva),
    CONSTRAINT FK_Reserva_Socio FOREIGN KEY (dni_socio) REFERENCES socio(dni_socio),
    CONSTRAINT FK_Reserva_Instalacion FOREIGN KEY (id_instalacion) REFERENCES instalacion(id_instalacion),

    CONSTRAINT CHK_EstadoReserva CHECK (estado_reserva IN ('Activa', 'Cancelada', 'Cumplida'))
);

CREATE TABLE medio_pago
(
    id_medio_pago INT NOT NULL,
    nombre_medio VARCHAR(100) NOT NULL,
    
    CONSTRAINT PK_MedioPago PRIMARY KEY (id_medio_pago)
);

CREATE TABLE Actividad_Instalacion
(
    id_actividad INT NOT NULL,
    id_instalacion INT NOT NULL,
    
    CONSTRAINT PK_ActInst PRIMARY KEY (id_actividad, id_instalacion),
    CONSTRAINT FK_ActInst_Actividad FOREIGN KEY (id_actividad) REFERENCES actividad(id_actividad),
    CONSTRAINT FK_ActInst_Instalacion FOREIGN KEY (id_instalacion) REFERENCES instalacion(id_instalacion)
);

CREATE TABLE pago
(
    id_pago INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto FLOAT NOT NULL,
    id_cuota INT NOT NULL,
    id_medio_pago INT NOT NULL,
    
    CONSTRAINT PK_Pago PRIMARY KEY (id_pago),
    CONSTRAINT FK_Pago_Cuota FOREIGN KEY (id_cuota) REFERENCES cuota(id_cuota),
    CONSTRAINT FK_Pago_MedioPago FOREIGN KEY (id_medio_pago) REFERENCES medio_pago(id_medio_pago)
);

CREATE TABLE clase
(
    id_clase INT NOT NULL,
    hora_inicio DATE NOT NULL,
    hora_fin DATE NOT NULL,
    cupo_personas INT NOT NULL,
    estado_clase VARCHAR(200) NOT NULL,
    id_profesor INT NOT NULL,
    id_actividad INT NOT NULL,
    id_instalacion INT NOT NULL,
    
    CONSTRAINT PK_Clase PRIMARY KEY (id_clase),
    CONSTRAINT FK_Clase_Profesor FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    CONSTRAINT FK_Clase_ActInst FOREIGN KEY (id_actividad, id_instalacion) REFERENCES Actividad_Instalacion(id_actividad, id_instalacion)
);

CREATE TABLE inscripcion
(
    fecha_inscripcion DATE NOT NULL,
    id_clase INT NOT NULL,
    dni_socio INT NOT NULL,
    
    CONSTRAINT PK_Inscripcion PRIMARY KEY (id_clase, dni_socio),
    CONSTRAINT FK_Inscripcion_Clase FOREIGN KEY (id_clase) REFERENCES clase(id_clase),
    CONSTRAINT FK_Inscripcion_Socio FOREIGN KEY (dni_socio) REFERENCES socio(dni_socio)
);
