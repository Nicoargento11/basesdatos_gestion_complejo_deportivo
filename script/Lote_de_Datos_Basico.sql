--Lote de datos
INSERT INTO medio_pago (id_medio_pago, nombre_medio) VALUES
(1, 'Efectivo'),
(2, 'Tarjeta de Crédito'),
(3, 'Transferencia Bancaria');

INSERT INTO profesor (id_profesor, nombre_profesor, apellido_profesor, telefono) VALUES
(101, 'Martina', 'Gomez', 1155551010),
(102, 'Roberto', 'Diaz', 1155551020);

INSERT INTO instalacion (id_instalacion, nombre_instalacion, capacidad_personas, tipo_estado, tipo_instalacion) VALUES
(1, 'Sala de Cardio', 50, 'disponible', 'Gym'),
(2, 'Piscina Olímpica', 30, 'disponible', 'Pileta'),
(3, 'Cancha Principal', 20, 'disponible', 'Cancha');

INSERT INTO actividad (id_actividad, nombre_actividad, requiere_apto) VALUES
(10, 'Spinning', 'no'),
(11, 'Natación', 'si'),
(12, 'Funcional', 'no'),
(13, 'Yoga', 'no');

INSERT INTO Actividad_Instalacion (id_actividad, id_instalacion) VALUES
(10, 1), 
(11, 2), 
(12, 1); 

INSERT INTO clase (id_clase, hora_inicio, hora_fin, cupo_personas, estado_clase, id_profesor, id_actividad, id_instalacion) VALUES
(1001, '2025-11-20 18:00:00', '2025-11-20 19:00:00', 15, 'programada', 101, 10, 1), 
(1002, '2025-11-21 07:00:00', '2025-11-21 08:00:00', 25, 'programada', 102, 11, 2); 

INSERT INTO socio (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio) VALUES
(30111222, 'Ana', 'Perez', 'ana.perez@email.com', 1160001234, '2024-08-15', 'activo');

INSERT INTO apto_medico (id_apto_medico, emitido_en, vence_en, observacion, dni_socio) VALUES
(1, '2025-05-01', '2026-05-01', 'Sin observaciones.', 30111222);

INSERT INTO cuota (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio) VALUES
(5001, '2025-11-01', '2025-11-30', 5000.00, 'pagada', 30111222);

INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota, id_medio_pago) VALUES
(8001, '2025-11-05', 5000.00, 5001, 1);

INSERT INTO socio (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio) VALUES
(35333444, 'Carlos', 'Ruiz', 'carlos.ruiz@email.com', 1160005678, '2025-01-10', 'activo');

INSERT INTO apto_medico (id_apto_medico, emitido_en, vence_en, observacion, dni_socio) VALUES
(2, '2025-10-15', '2026-10-15', 'Apto para toda actividad.', 35333444);

INSERT INTO cuota (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio) VALUES
(5002, '2025-11-01', '2025-11-30', 5000.00, 'pagada', 35333444);

INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota, id_medio_pago) VALUES
(8002, '2025-11-03', 5000.00, 5002, 2);

INSERT INTO socio (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio) VALUES
(20555665, 'Laura', 'Gimenez', 'laura.gimenez@email.com', 1160009012, '2023-03-20', 'activo');

INSERT INTO apto_medico (id_apto_medico, emitido_en, vence_en, observacion, dni_socio) VALUES
(3, '2024-10-01', '2025-10-01', 'Apto por un año.', 20555666);

INSERT INTO cuota (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio) VALUES
(5003, '2025-11-01', '2025-11-30', 5000.00, 'pagada', 20555666);

INSERT INTO pago (id_pago, fecha_pago, monto, id_cuota, id_medio_pago) VALUES
(8003, '2025-11-01', 5000.00, 5003, 3);

INSERT INTO socio (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio) VALUES
(40777888, 'Diego', 'Mendez', 'diego.mendez@email.com', 1160003456, '2025-04-01', 'activo');

INSERT INTO apto_medico (id_apto_medico, emitido_en, vence_en, observacion, dni_socio) VALUES
(4, '2025-01-01', '2026-01-01', 'Apto sin restricciones.', 40777888);

INSERT INTO cuota (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio) VALUES
(5004, '2025-11-01', '2025-11-30', 5000.00, 'pendiente', 40777888);

INSERT INTO socio (dni_socio, nombre_socio, apellido, email, telefono, fecha_alta, estado_socio) VALUES
(25999000, 'Sofia', 'Torres', 'sofia.torres@email.com', 1160007890, '2022-12-01', 'activo');

INSERT INTO apto_medico (id_apto_medico, emitido_en, vence_en, observacion, dni_socio) VALUES
(5, '2024-01-01', '2025-01-01', 'Apto médico caduco.', 25999000);

INSERT INTO cuota (id_cuota, periodo_inicio, periodo_fin, importe, estado_cuota, dni_socio) VALUES
(5005, '2025-10-01', '2025-10-31', 5000.00, 'vencida', 25999000);

INSERT INTO acceso (id_acceso, fecha_hora, dni_socio) VALUES
(9001, '2025-11-16 08:30:00', 30111222);

INSERT INTO inscripcion (fecha_inscripcion, id_clase, dni_socio) VALUES
('2025-11-16', 1001, 30111222);

