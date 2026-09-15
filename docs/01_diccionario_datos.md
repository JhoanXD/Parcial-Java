# Modelo Relacional (3FN) y Diccionario de Datos
## Proyecto: Inmoraíz — Sistema Web de Inmobiliaria

Documentado a partir del script real `database/01_schema.sql`. Motor: **MySQL 8.x**.

---

## 1. Justificación de Normalización (hasta 3FN)

- **1FN:** todos los campos son atómicos (ej. `nombres`/`apellidos` separados en `perfil`, en vez de un solo campo "nombre completo").
- **2FN:** en las tablas con llave compuesta (`usuario_rol`, `propiedad_caracteristica`, `favorito`) ningún atributo depende de solo una parte de la llave — por ejemplo, `propiedad_caracteristica.cantidad` depende de la combinación `(id_propiedad, id_caracteristica)`, no de una sola.
- **3FN:** no hay dependencias transitivas. `propiedad.precio` depende únicamente de `id_propiedad`; los datos de la inmobiliaria (nit, teléfono) no se repiten en cada propiedad, se referencian por `id_inmobiliaria`.

---

## 2. Modelo relacional (tabla(PK, atributos, FK))

```
rol(id_rol PK, nombre UNIQUE, descripcion)

usuario(id_usuario PK, correo UNIQUE, clave_hash, estado, fecha_registro)

usuario_rol(id_usuario PK FK→usuario, id_rol PK FK→rol, fecha_asignacion)

perfil(id_perfil PK, id_usuario FK→usuario UNIQUE, nombres, apellidos,
       documento UNIQUE, telefono, direccion, foto)

inmobiliaria(id_inmobiliaria PK, id_usuario FK→usuario UNIQUE, nombre,
             nit UNIQUE, telefono, direccion)

ciudad(id_ciudad PK, nombre UNIQUE, departamento)

tipo_propiedad(id_tipo PK, nombre UNIQUE)

propiedad(id_propiedad PK, id_inmobiliaria FK→inmobiliaria, id_ciudad FK→ciudad,
          id_tipo FK→tipo_propiedad, matricula_inmobiliaria UNIQUE, titulo,
          descripcion, modalidad, precio, area_m2, habitaciones, banos,
          estado, fecha_publicacion)

imagen_propiedad(id_imagen PK, id_propiedad FK→propiedad, url,
                  texto_alternativo, orden_imagen)

caracteristica(id_caracteristica PK, nombre UNIQUE)

propiedad_caracteristica(id_propiedad PK FK→propiedad,
                          id_caracteristica PK FK→caracteristica, cantidad)

cita(id_cita PK, id_propiedad FK→propiedad, id_cliente FK→usuario,
     fecha_hora, estado, observaciones)  -- UNIQUE(id_propiedad, fecha_hora)

solicitud(id_solicitud PK, id_propiedad FK→propiedad, id_cliente FK→usuario,
          tipo, estado, fecha_solicitud, observaciones)

documento_solicitud(id_documento PK, id_solicitud FK→solicitud, nombre_archivo,
                     ruta_archivo, tipo_documento, estado, revisado_por FK→usuario,
                     fecha_carga)

favorito(id_usuario PK FK→usuario, id_propiedad PK FK→propiedad, fecha_marcado)

auditoria(id_auditoria PK, id_usuario FK→usuario, accion, tabla_afectada,
          id_registro, detalle, fecha_evento)
```

### Relaciones exigidas por el enunciado

- **1:1** →
  - `usuario` ↔ `perfil` (FK `perfil.id_usuario` UNIQUE)
  - `usuario` ↔ `inmobiliaria` (FK `inmobiliaria.id_usuario` UNIQUE): cada cuenta con rol INMOBILIARIA está ligada a **una** agencia — este es el segundo par 1:1 del modelo, adicional al pedido por el enunciado.
- **1:N** → `inmobiliaria→propiedad`, `ciudad→propiedad`, `tipo_propiedad→propiedad`, `propiedad→imagen_propiedad`, `usuario(cliente)→cita`, `usuario(cliente)→solicitud`, `solicitud→documento_solicitud`
- **N:M** → `usuario_rol` (usuario↔rol), `propiedad_caracteristica` (propiedad↔característica), `favorito` (usuario↔propiedad)

---

## 3. Diccionario de datos

### 3.1 `rol`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_rol | INT | NO | PK | Identificador |
| nombre | VARCHAR(30) | NO | UNIQUE | ADMINISTRADOR, INMOBILIARIA, CLIENTE, VISITANTE |
| descripcion | VARCHAR(150) | NO | | Descripción del rol |

### 3.2 `usuario`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_usuario | INT | NO | PK | Identificador |
| correo | VARCHAR(120) | NO | **UNIQUE** | Credencial de ingreso |
| clave_hash | VARCHAR(100) | NO | | Hash BCrypt de la contraseña |
| estado | ENUM('ACTIVO','INACTIVO','BLOQUEADO') | NO | | Controla el acceso al login |
| fecha_registro | TIMESTAMP | NO | | Fecha de creación |

### 3.3 `usuario_rol`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_usuario | INT | NO | PK, FK→usuario | Usuario |
| id_rol | INT | NO | PK, FK→rol | Rol asignado |
| fecha_asignacion | TIMESTAMP | NO | | Cuándo se otorgó |

### 3.4 `perfil`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_perfil | INT | NO | PK | Identificador |
| id_usuario | INT | NO | **UNIQUE**, FK→usuario | Garantiza el 1:1 |
| nombres | VARCHAR(60) | NO | | Nombres |
| apellidos | VARCHAR(60) | NO | | Apellidos |
| documento | VARCHAR(30) | NO | **UNIQUE** | Documento de identidad |
| telefono | VARCHAR(25) | NO | | Teléfono |
| direccion | VARCHAR(180) | SÍ | | Dirección |
| foto | VARCHAR(255) | SÍ | | Ruta de la foto |

### 3.5 `inmobiliaria`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_inmobiliaria | INT | NO | PK | Identificador |
| id_usuario | INT | NO | **UNIQUE**, FK→usuario | Cuenta (rol INMOBILIARIA) dueña de la agencia |
| nombre | VARCHAR(120) | NO | | Nombre comercial |
| nit | VARCHAR(30) | NO | **UNIQUE** | NIT de la agencia |
| telefono | VARCHAR(25) | NO | | Teléfono |
| direccion | VARCHAR(180) | NO | | Dirección |

### 3.6 `ciudad`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_ciudad | INT | NO | PK | Identificador |
| nombre | VARCHAR(80) | NO | UNIQUE | Nombre de la ciudad |
| departamento | VARCHAR(80) | NO | | Departamento |

### 3.7 `tipo_propiedad`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_tipo | INT | NO | PK | Identificador |
| nombre | VARCHAR(40) | NO | UNIQUE | Casa, Apartamento, Local, Oficina, Terreno |

### 3.8 `propiedad`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_propiedad | INT | NO | PK | Identificador |
| id_inmobiliaria | INT | NO | FK→inmobiliaria | Agencia publicadora |
| id_ciudad | INT | NO | FK→ciudad | Ubicación |
| id_tipo | INT | NO | FK→tipo_propiedad | Tipo de inmueble |
| matricula_inmobiliaria | VARCHAR(40) | NO | **UNIQUE** | Identificador irrepetible del inmueble |
| titulo | VARCHAR(160) | NO | | Título de la publicación |
| descripcion | TEXT | NO | | Descripción completa |
| modalidad | ENUM('VENTA','ARRIENDO') | NO | | Tipo de negociación |
| precio | DECIMAL(15,2) | NO | | Precio (`CHECK precio > 0`) |
| area_m2 | DECIMAL(10,2) | NO | | Área en m² (`CHECK area_m2 > 0`) |
| habitaciones | TINYINT UNSIGNED | NO | | Número de habitaciones |
| banos | TINYINT UNSIGNED | NO | | Número de baños |
| estado | ENUM('DISPONIBLE','RESERVADA','NEGOCIADA','INACTIVA') | NO | | Estado comercial / baja lógica |
| fecha_publicacion | TIMESTAMP | NO | | Fecha de alta |

### 3.9 `imagen_propiedad`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_imagen | INT | NO | PK | Identificador |
| id_propiedad | INT | NO | FK→propiedad | Propiedad asociada |
| url | VARCHAR(255) | NO | | Ruta de la imagen |
| texto_alternativo | VARCHAR(160) | SÍ | | Texto `alt` de accesibilidad |
| orden_imagen | INT | NO | | Orden en la galería |

### 3.10 `caracteristica`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_caracteristica | INT | NO | PK | Identificador |
| nombre | VARCHAR(60) | NO | UNIQUE | Parqueadero, Piscina, Ascensor, etc. |

### 3.11 `propiedad_caracteristica`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_propiedad | INT | NO | PK, FK→propiedad | Propiedad |
| id_caracteristica | INT | NO | PK, FK→caracteristica | Característica |
| cantidad | INT | NO | | Ej. número de parqueaderos (default 1) |

### 3.12 `cita`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_cita | INT | NO | PK | Identificador |
| id_propiedad | INT | NO | FK→propiedad | Propiedad a visitar |
| id_cliente | INT | NO | FK→usuario | Cliente que agenda |
| fecha_hora | DATETIME | NO | **UNIQUE (con id_propiedad)** | Fecha/hora de la visita |
| estado | ENUM('PENDIENTE','CONFIRMADA','CANCELADA','ATENDIDA') | NO | | Estado de la cita |
| observaciones | VARCHAR(255) | SÍ | | Notas adicionales |

### 3.13 `solicitud`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_solicitud | INT | NO | PK | Identificador |
| id_propiedad | INT | NO | FK→propiedad | Propiedad de interés |
| id_cliente | INT | NO | FK→usuario | Cliente solicitante |
| tipo | ENUM('COMPRA','ARRIENDO') | NO | | Tipo de trámite |
| estado | ENUM('RADICADA','EN_REVISION','APROBADA','RECHAZADA') | NO | | Estado del trámite |
| fecha_solicitud | TIMESTAMP | NO | | Fecha de radicación |
| observaciones | VARCHAR(500) | SÍ | | Notas del trámite |

### 3.14 `documento_solicitud`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_documento | INT | NO | PK | Identificador |
| id_solicitud | INT | NO | FK→solicitud | Solicitud asociada |
| nombre_archivo | VARCHAR(160) | NO | | Nombre original del archivo |
| ruta_archivo | VARCHAR(255) | NO | | Ruta física en `uploads/documentos/` |
| tipo_documento | VARCHAR(60) | NO | | Cédula, certificado laboral, etc. |
| estado | ENUM('PENDIENTE','APROBADO','RECHAZADO') | NO | | Resultado de la revisión |
| revisado_por | INT | SÍ | FK→usuario | Administrador que lo revisó |
| fecha_carga | TIMESTAMP | NO | | Fecha de subida |

### 3.15 `favorito`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_usuario | INT | NO | PK, FK→usuario | Cliente |
| id_propiedad | INT | NO | PK, FK→propiedad | Propiedad marcada |
| fecha_marcado | TIMESTAMP | NO | | Cuándo se marcó |

### 3.16 `auditoria`
| Campo | Tipo | Null | Key | Descripción |
|---|---|---|---|---|
| id_auditoria | BIGINT | NO | PK | Identificador |
| id_usuario | INT | SÍ | FK→usuario | Usuario que ejecutó la acción |
| accion | VARCHAR(80) | NO | | Ej. "LOGIN", "APROBAR_SOLICITUD" |
| tabla_afectada | VARCHAR(80) | NO | | Tabla sobre la que se actuó |
| id_registro | VARCHAR(40) | SÍ | | PK del registro afectado |
| detalle | VARCHAR(500) | SÍ | | Detalle adicional |
| fecha_evento | TIMESTAMP | NO | | Momento del evento |

---

## 4. Restricciones UNIQUE (mínimo 3 exigidas — el proyecto implementa 6)

1. `usuario.correo`
2. `perfil.documento`
3. `perfil.id_usuario` (sostiene el 1:1 con `usuario`)
4. `inmobiliaria.nit`
5. `inmobiliaria.id_usuario` (sostiene el segundo 1:1)
6. `propiedad.matricula_inmobiliaria`
7. `cita(id_propiedad, fecha_hora)` — evita doble agendamiento
8. `usuario_rol(id_usuario, id_rol)` — PK compuesta, evita roles repetidos

Todas se manejan capturando `SQLIntegrityConstraintViolationException` en las páginas de registro/creación y mostrando un mensaje claro al usuario (ver `registro.jsp`), nunca el stack trace de Java.

## 5. Las 5 consultas obligatorias

Ya documentadas y probadas en `database/03_queries.sql`:
1. INNER JOIN — propiedad + ciudad + tipo_propiedad + inmobiliaria
2. INNER JOIN — solicitud + usuario + propiedad + inmobiliaria
3. Relación N:M — propiedad_caracteristica + propiedad + caracteristica
4. LEFT JOIN — propiedades disponibles sin ninguna cita agendada
5. GROUP BY + HAVING — propiedades disponibles por ciudad (más una sexta consulta extra: solicitudes por inmobiliaria y estado)
