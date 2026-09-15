# Inmoraíz — Sistema Web de Inmobiliaria

Proyecto académico de la asignatura **Programación Java** (UTS — Tecnología en Desarrollo de Sistemas Informáticos, docente Julian Barney Jaimes Rincón). Aplicación web para la gestión de una inmobiliaria: publicación de propiedades, autenticación por roles, agendamiento de citas y trámite de solicitudes de compra/arriendo.

## Tecnologías

- Java EE (JSP) + JDBC
- Apache Tomcat
- MySQL 8.x
- Bootstrap 5 + Bootstrap Icons
- jBCrypt (hash de contraseñas)

## Roles del sistema

| Rol | Puede hacer |
|---|---|
| **Visitante** | Ver landing page y catálogo público de propiedades |
| **Cliente** | Buscar propiedades, marcar favoritos, agendar citas, radicar solicitudes y documentos, ver su perfil |
| **Inmobiliaria** | Publicar/editar/dar de baja propiedades, gestionar imágenes, atender citas y solicitudes |
| **Administrador** | Gestión de usuarios y roles, revisión de documentos, reportes, auditoría |

## Estructura del proyecto

```
ParcialVerdadero/
├── admin/                      Páginas exclusivas del rol ADMINISTRADOR
├── cliente/                    Páginas exclusivas del rol CLIENTE
├── propiedades/                CRUD de propiedades (rol INMOBILIARIA/ADMINISTRADOR)
├── imagenes/                   CRUD de imagenes (subir, guardar imagenes nuevas)
├── Css/inmo_custom-theme.css   Tema visual (variables de Bootstrap)
├── database/
│   ├── 01_schema.sql           DDL — creación de la base de datos y tablas
│   ├── 02_data.sql             DML — catálogos y usuarios de prueba
│   ├── 03_queries.sql          Las 5 consultas obligatorias (JOIN, N:M, LEFT JOIN, GROUP BY)
│   ├── 04_datos_prueba.sql     Datos de prueba adicionales
│   └── 05_migracion_documentos.sql   Migración: estado de revisión en documento_solicitud
├── docs/                       Documentación Scrum y de base de datos (ver más abajo)
├── uploads/documentos/         Archivos radicados por los clientes
|── uploads/imagenes/           Imagenes de propiedades
├── WEB-INF/
│   ├── JSPF/                   Fragmentos reutilizables (conexión, head, navbar, footer)
│   ├── classes/com/inmoraiz/filter/AccessFilter.class
│   ├── lib/                    Drivers JDBC + jBCrypt
│   └── web.xml
├── index.jsp                   Redirige a inmo_index.jsp (landing page)
└── login.jsp / registro.jsp / logout.jsp
```

## Cómo ejecutar el proyecto en local

1. **Base de datos:** crea el esquema y carga los datos en este orden:
   ```
   mysql -u root -p < database/01_schema.sql
   mysql -u root -p < database/02_data.sql
   mysql -u root -p < database/04_datos_prueba.sql
   mysql -u root -p < database/05_migracion_documentos.sql
   ```
2. **Conexión:** revisa `WEB-INF/JSPF/inmo_db-conexion.jspf` y ajusta usuario/clave de tu MySQL local si es distinto a `root` sin clave.
3. **Despliegue:** copia la carpeta en `webapps/` de Tomcat (o despliega como proyecto dinámico desde tu IDE) y arranca el servidor.
4. **Acceso:** abre `http://localhost:8080/ParcialVerdadero/`.

### Usuarios de prueba (clave para los tres: `Inmoraiz123`)

| Correo | Rol |
|---|---|
| admin@inmoraiz.com | ADMINISTRADOR |
| agente@inmoraiz.com | INMOBILIARIA |
| cliente@correo.com | CLIENTE |

## Documentación

- [`docs/01_diccionario_datos.md`](docs/01_diccionario_datos.md) — modelo relacional y diccionario de datos completo
- [`docs/product_backlog.md`](docs/product_backlog.md) — historias de usuario priorizadas con criterios de aceptación
- [`docs/sprint1.md`](docs/sprint1.md), [`docs/sprint2.md`](docs/sprint2.md), [`docs/sprint3.md`](docs/sprint3.md) — Planning, Review y Retrospective de cada sprint

