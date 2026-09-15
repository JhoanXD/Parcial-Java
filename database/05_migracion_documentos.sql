USE inmobiliaria_db;

ALTER TABLE documento_solicitud
  ADD COLUMN estado ENUM('PENDIENTE','APROBADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE' AFTER tipo_documento,
  ADD COLUMN revisado_por INT NULL AFTER estado,
  ADD CONSTRAINT fk_documento_revisor FOREIGN KEY (revisado_por)
    REFERENCES usuario(id_usuario)
    ON DELETE SET NULL ON UPDATE CASCADE;
