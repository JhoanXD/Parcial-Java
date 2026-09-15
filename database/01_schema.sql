CREATE DATABASE IF NOT EXISTS inmobiliaria_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE inmobiliaria_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS auditoria, favorito, documento_solicitud, solicitud, cita,
  propiedad_caracteristica, imagen_propiedad, propiedad, caracteristica,
  tipo_propiedad, ciudad, inmobiliaria, usuario_rol, perfil, rol, usuario;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE rol (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL UNIQUE,
  descripcion VARCHAR(150) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  correo VARCHAR(120) NOT NULL UNIQUE,
  clave_hash VARCHAR(100) NOT NULL,
  estado ENUM('ACTIVO','INACTIVO','BLOQUEADO') NOT NULL DEFAULT 'ACTIVO',
  fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE usuario_rol (
  id_usuario INT NOT NULL,
  id_rol INT NOT NULL,
  fecha_asignacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_rol),
  CONSTRAINT fk_usuario_rol_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_usuario_rol_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE perfil (
  id_perfil INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  nombres VARCHAR(60) NOT NULL,
  apellidos VARCHAR(60) NOT NULL,
  documento VARCHAR(30) NOT NULL UNIQUE,
  telefono VARCHAR(25) NOT NULL,
  direccion VARCHAR(180),
  foto VARCHAR(255),
  CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE inmobiliaria (
  id_inmobiliaria INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL UNIQUE,
  nombre VARCHAR(120) NOT NULL,
  nit VARCHAR(30) NOT NULL UNIQUE,
  telefono VARCHAR(25) NOT NULL,
  direccion VARCHAR(180) NOT NULL,
  CONSTRAINT fk_inmobiliaria_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ciudad (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  departamento VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tipo_propiedad (
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(40) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE propiedad (
  id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
  id_inmobiliaria INT NOT NULL,
  id_ciudad INT NOT NULL,
  id_tipo INT NOT NULL,
  matricula_inmobiliaria VARCHAR(40) NOT NULL UNIQUE,
  titulo VARCHAR(160) NOT NULL,
  descripcion TEXT NOT NULL,
  modalidad ENUM('VENTA','ARRIENDO') NOT NULL,
  precio DECIMAL(15,2) NOT NULL,
  area_m2 DECIMAL(10,2) NOT NULL,
  habitaciones TINYINT UNSIGNED NOT NULL DEFAULT 0,
  banos TINYINT UNSIGNED NOT NULL DEFAULT 0,
  estado ENUM('DISPONIBLE','RESERVADA','NEGOCIADA','INACTIVA') NOT NULL DEFAULT 'DISPONIBLE',
  fecha_publicacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_propiedad_inmobiliaria FOREIGN KEY (id_inmobiliaria) REFERENCES inmobiliaria(id_inmobiliaria)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_propiedad_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_propiedad_tipo FOREIGN KEY (id_tipo) REFERENCES tipo_propiedad(id_tipo)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_propiedad_precio CHECK (precio > 0),
  CONSTRAINT chk_propiedad_area CHECK (area_m2 > 0)
) ENGINE=InnoDB;

CREATE TABLE imagen_propiedad (
  id_imagen INT AUTO_INCREMENT PRIMARY KEY,
  id_propiedad INT NOT NULL,
  url VARCHAR(255) NOT NULL,
  texto_alternativo VARCHAR(160),
  orden_imagen INT NOT NULL DEFAULT 1,
  CONSTRAINT fk_imagen_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE caracteristica (
  id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE propiedad_caracteristica (
  id_propiedad INT NOT NULL,
  id_caracteristica INT NOT NULL,
  cantidad INT NOT NULL DEFAULT 1,
  PRIMARY KEY (id_propiedad, id_caracteristica),
  CONSTRAINT fk_pc_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pc_caracteristica FOREIGN KEY (id_caracteristica) REFERENCES caracteristica(id_caracteristica)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cita (
  id_cita INT AUTO_INCREMENT PRIMARY KEY,
  id_propiedad INT NOT NULL,
  id_cliente INT NOT NULL,
  fecha_hora DATETIME NOT NULL,
  estado ENUM('PENDIENTE','CONFIRMADA','CANCELADA','ATENDIDA') NOT NULL DEFAULT 'PENDIENTE',
  observaciones VARCHAR(255),
  UNIQUE KEY uq_cita_horario (id_propiedad, fecha_hora),
  CONSTRAINT fk_cita_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_cita_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE solicitud (
  id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
  id_propiedad INT NOT NULL,
  id_cliente INT NOT NULL,
  tipo ENUM('COMPRA','ARRIENDO') NOT NULL,
  estado ENUM('RADICADA','EN_REVISION','APROBADA','RECHAZADA') NOT NULL DEFAULT 'RADICADA',
  fecha_solicitud TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  observaciones VARCHAR(500),
  CONSTRAINT fk_solicitud_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE documento_solicitud (
  id_documento INT AUTO_INCREMENT PRIMARY KEY,
  id_solicitud INT NOT NULL,
  nombre_archivo VARCHAR(160) NOT NULL,
  ruta_archivo VARCHAR(255) NOT NULL,
  tipo_documento VARCHAR(60) NOT NULL,
  estado ENUM('PENDIENTE','APROBADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
  revisado_por INT NULL,
  fecha_carga TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_documento_solicitud FOREIGN KEY (id_solicitud) REFERENCES solicitud(id_solicitud)
    ON DELETE CASCADE ON UPDATE CASCADE
  ,CONSTRAINT fk_documento_revisor FOREIGN KEY (revisado_por) REFERENCES usuario(id_usuario)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE favorito (
  id_usuario INT NOT NULL,
  id_propiedad INT NOT NULL,
  fecha_marcado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_propiedad),
  CONSTRAINT fk_favorito_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_favorito_propiedad FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE auditoria (
  id_auditoria BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NULL,
  accion VARCHAR(80) NOT NULL,
  tabla_afectada VARCHAR(80) NOT NULL,
  id_registro VARCHAR(40),
  detalle VARCHAR(500),
  fecha_evento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;
