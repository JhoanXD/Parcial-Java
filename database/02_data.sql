USE inmobiliaria_db;

INSERT INTO rol (nombre, descripcion) VALUES
('ADMINISTRADOR', 'Acceso total al sistema'),
('INMOBILIARIA', 'Gestiona propiedades y solicitudes'),
('CLIENTE', 'Consulta propiedades y realiza tramites'),
('VISITANTE', 'Consulta el catalogo publico');

INSERT INTO ciudad (nombre, departamento) VALUES
('Bucaramanga', 'Santander'), ('Floridablanca', 'Santander'), ('San Gil', 'Santander'),
('Bogota', 'Cundinamarca'), ('Medellin', 'Antioquia'), ('Cali', 'Valle del Cauca');

INSERT INTO tipo_propiedad (nombre) VALUES
('Casa'), ('Apartamento'), ('Local'), ('Oficina'), ('Terreno');

INSERT INTO caracteristica (nombre) VALUES
('Parqueadero'), ('Piscina'), ('Ascensor'), ('Gimnasio'), ('Zona BBQ'), ('Balcón');

-- Contraseña temporal de desarrollo para los tres usuarios: Inmoraiz123
INSERT INTO usuario (correo, clave_hash, estado) VALUES
('admin@inmoraiz.com', '$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC', 'ACTIVO'),
('agente@inmoraiz.com', '$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC', 'ACTIVO'),
('cliente@correo.com', '$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC', 'ACTIVO');

INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(1, 1), (2, 2), (3, 3);

INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono, direccion) VALUES
(1, 'Administrador', 'Inmoraiz', '1000000001', '3000000001', 'Bucaramanga'),
(2, 'Laura', 'Agente', '1000000002', '3000000002', 'Bucaramanga'),
(3, 'Carlos', 'Cliente', '1000000003', '3000000003', 'Floridablanca');

INSERT INTO inmobiliaria (id_usuario, nombre, nit, telefono, direccion) VALUES
(2, 'Inmoraiz Santander', '900123456-1', '6076001111', 'Bucaramanga');

INSERT INTO propiedad (id_inmobiliaria, id_ciudad, id_tipo, matricula_inmobiliaria, titulo, descripcion, modalidad, precio, area_m2, habitaciones, banos) VALUES
(1, 1, 1, 'MI-0001', 'Casa campestre en Floridablanca', 'Casa amplia con zona verde y parqueadero.', 'VENTA', 480000000, 180, 3, 2),
(1, 1, 2, 'MI-0002', 'Apartamento en Cabecera', 'Apartamento iluminado cerca de comercio.', 'VENTA', 320000000, 86, 2, 2),
(1, 1, 3, 'MI-0003', 'Local comercial Centro', 'Local de primer piso con vitrina.', 'ARRIENDO', 2500000, 40, 0, 1),
(1, 1, 4, 'MI-0004', 'Oficina ejecutiva Sotomayor', 'Oficina con dos espacios de trabajo.', 'ARRIENDO', 3200000, 52, 0, 1),
(1, 3, 2, 'MI-0005', 'Apartamento San Gil centro', 'Apartamento central con acabados modernos.', 'VENTA', 260000000, 94, 3, 2);

INSERT INTO imagen_propiedad (id_propiedad, url, texto_alternativo, orden_imagen) VALUES
(1, 'img/propiedad-1.jpg', 'Casa campestre', 1), (2, 'img/propiedad-2.jpg', 'Apartamento Cabecera', 1),
(3, 'img/propiedad-3.jpg', 'Local comercial', 1), (4, 'img/propiedad-4.jpg', 'Oficina ejecutiva', 1),
(5, 'img/propiedad-5.jpg', 'Apartamento San Gil', 1);

INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica, cantidad) VALUES
(1, 1, 2), (1, 5, 1), (2, 1, 1), (2, 3, 1), (5, 1, 1), (5, 6, 1);
