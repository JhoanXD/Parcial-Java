USE inmobiliaria_db;

-- Datos adicionales para demostracion local. Contraseña: Inmoraiz123
INSERT IGNORE INTO ciudad (id_ciudad, nombre, departamento) VALUES
(7,'Piedecuesta','Santander'),(8,'Barrancabermeja','Santander'),(9,'Cartagena','Bolivar'),(10,'Armenia','Quindio');

INSERT IGNORE INTO caracteristica (id_caracteristica, nombre) VALUES
(7,'Vigilancia'),(8,'Jardin'),(9,'Terraza'),(10,'Aire acondicionado');

INSERT IGNORE INTO usuario (id_usuario, correo, clave_hash, estado) VALUES
(4,'agente2@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(5,'agente3@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(6,'agente4@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(7,'agente5@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(8,'agente6@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(9,'agente7@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(10,'agente8@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(11,'agente9@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO'),
(12,'agente10@inmoraiz.com','$2a$10$RNYO4bg8CT4glRz/oOVvCeeBxkraEh2zM0CDQjdRH0Vbqu4wlDdOC','ACTIVO');
INSERT IGNORE INTO usuario_rol (id_usuario,id_rol) VALUES (4,2),(5,2),(6,2),(7,2),(8,2),(9,2),(10,2),(11,2),(12,2);
INSERT IGNORE INTO perfil (id_usuario,nombres,apellidos,documento,telefono,direccion) VALUES
(4,'Ana','Gomez','1000000004','3000000004','Piedecuesta'),(5,'Luis','Rojas','1000000005','3000000005','Bucaramanga'),
(6,'Marta','Diaz','1000000006','3000000006','San Gil'),(7,'Pedro','Vega','1000000007','3000000007','Bogota'),
(8,'Diana','Leon','1000000008','3000000008','Medellin'),(9,'Jorge','Soto','1000000009','3000000009','Cali'),
(10,'Sara','Mora','1000000010','3000000010','Armenia'),(11,'Camilo','Gil','1000000011','3000000011','Cartagena'),
(12,'Laura','Ruiz','1000000012','3000000012','Barrancabermeja');
INSERT IGNORE INTO inmobiliaria (id_inmobiliaria,id_usuario,nombre,nit,telefono,direccion) VALUES
(2,4,'Inmobiliaria Oriente','900123456-2','3004000002','Piedecuesta'),(3,5,'Vivienda Rojas','900123456-3','3004000003','Bucaramanga'),
(4,6,'Casas Diaz','900123456-4','3004000004','San Gil'),(5,7,'Vega Bienes','900123456-5','3004000005','Bogota'),
(6,8,'Leon Propiedades','900123456-6','3004000006','Medellin'),(7,9,'Soto Inmuebles','900123456-7','3004000007','Cali'),
(8,10,'Mora Raices','900123456-8','3004000008','Armenia'),(9,11,'Gil Inversiones','900123456-9','3004000009','Cartagena'),
(10,12,'Ruiz Hogar','900123456-0','3004000010','Barrancabermeja');
INSERT IGNORE INTO propiedad (id_propiedad,id_inmobiliaria,id_ciudad,id_tipo,matricula_inmobiliaria,titulo,descripcion,modalidad,precio,area_m2,habitaciones,banos,estado) VALUES
(6,2,7,1,'MI-0006','Casa familiar Piedecuesta','Casa con jardin y vigilancia.','VENTA',280000000,120,3,2,'DISPONIBLE'),
(7,3,8,2,'MI-0007','Apartamento Barrancabermeja','Apartamento amplio con terraza.','VENTA',210000000,78,2,2,'DISPONIBLE'),
(8,4,9,3,'MI-0008','Local turistico Cartagena','Local comercial cerca al centro.','ARRIENDO',4500000,55,0,1,'DISPONIBLE'),
(9,5,10,4,'MI-0009','Oficina Armenia Norte','Oficina con aire acondicionado.','ARRIENDO',1800000,45,0,1,'DISPONIBLE'),
(10,6,1,5,'MI-0010','Terreno campestre','Lote con servicios disponibles.','VENTA',150000000,900,0,0,'DISPONIBLE');
INSERT IGNORE INTO imagen_propiedad (id_propiedad,url,texto_alternativo,orden_imagen) VALUES
(6,'img/casa-6.jpg','Casa familiar Piedecuesta',1),(7,'img/apartamento-7.jpg','Apartamento Barrancabermeja',1),
(8,'img/local-8.jpg','Local Cartagena',1),(9,'img/oficina-9.jpg','Oficina Armenia',1),(10,'img/terreno-10.jpg','Terreno campestre',1);
INSERT IGNORE INTO propiedad_caracteristica (id_propiedad,id_caracteristica,cantidad) VALUES
(6,7,1),(6,8,1),(7,3,1),(7,9,1),(8,7,1),(9,10,2),(10,8,1);
