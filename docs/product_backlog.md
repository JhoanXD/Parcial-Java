# Product Backlog — Inmoraíz

Historias de usuario priorizadas por el Product Owner (docente), adaptadas a las entidades reales del proyecto (`propiedad`, `cita`, `solicitud`, `inmobiliaria`, etc.). Estado actualizado al cierre del Sprint 3.

| # | Historia | Prioridad | Estado | Criterios de aceptación (DoD) |
|---|---|---|---|---|
| 1 | Como visitante, quiero una página de aterrizaje atractiva para conocer la inmobiliaria y buscar propiedades rápidamente. | Alta | ✅ Hecho | `inmo_index.jsp` responsivo, con buscador por ciudad/tipo/modalidad y propiedades destacadas. |
| 2 | Como usuario, quiero registrarme con un correo único y validado para crear mi cuenta sin duplicados. | Alta | ✅ Hecho | `registro.jsp` valida campos, cifra la clave con BCrypt, y captura el error de correo/documento duplicado con mensaje claro (no stack trace). |
| 3 | Como usuario registrado, quiero iniciar y cerrar sesión de forma segura para que el sistema me lleve al panel de mi rol. | Alta | ✅ Hecho | `login.jsp` valida contra `clave_hash` con `BCrypt.checkpw`, guarda `usuarioId`/`usuarioRol` en `HttpSession`, redirige a `dashboard.jsp`. `logout.jsp` invalida la sesión. |
| 4 | Como administrador, quiero asignar y revocar roles a los usuarios para controlar los permisos. | Alta | ✅ Hecho | `admin/admin_usuarios.jsp` gestiona `usuario_rol`. |
| 5 | Como cliente, quiero completar mi perfil con documento, teléfono y dirección. | Media | ✅ Hecho | `cliente/perfil.jsp` actualiza la tabla `perfil` (relación 1:1). |
| 6 | Como agente de la inmobiliaria, quiero registrar y editar propiedades con fotos, características y precio. | Alta | ✅ Hecho | `propiedades/propiedad_nueva.jsp`, `propiedad_editar.jsp`, `propiedad_guardar.jsp`, `propiedad_actualizar.jsp` + `imagenes/imagen_subir.jsp` (1:N) y selección de `caracteristica` (N:M). |
| 7 | Como cliente, quiero buscar y filtrar propiedades por ciudad, tipo, precio y características. | Alta | ✅ Hecho | `catalogo.jsp` con filtros por `ciudad`, `tipo_propiedad`, `modalidad`, rango de precio. |
| 8 | Como cliente, quiero marcar propiedades como favoritas para consultarlas después. | Media | ✅ Hecho | `cliente/favorito.jsp` (marcar) y `cliente/favoritos.jsp` (listar), tabla `favorito` N:M. |
| 9 | Como cliente, quiero solicitar una cita en un horario disponible sin que se crucen las agendas. | Media | ✅ Hecho | `cliente/cita.jsp`, restricción `UNIQUE(id_propiedad, fecha_hora)` en tabla `cita`, mensaje claro si el horario ya está tomado. |
| 10 | Como cliente, quiero radicar documentos de compra/arriendo y consultar el estado de mi solicitud. | Media | ✅ Hecho | `cliente/solicitud.jsp`, `cliente/documento_subir.jsp`, `cliente/solicitudes.jsp`/`documentos.jsp` muestran el `estado` en tiempo real. |
| 11 | Como agente, quiero aprobar o rechazar solicitudes y sus documentos. | Media | ✅ Hecho | `solicitudes_inmobiliaria.jsp` y `admin/documentos_revision.jsp` actualizan `estado` en `solicitud`/`documento_solicitud` y registran `revisado_por`. |
| 12 | Como administrador, quiero un reporte de propiedades por ciudad y estado con consultas de agregación. | Media | ✅ Hecho | `admin/reportes.jsp` + consultas 5 y 6 de `03_queries.sql` (`GROUP BY`/`HAVING`). |
| 13 | Como administrador, quiero consultar la auditoría de accesos y cambios. | Baja | ✅ Hecho | `admin/auditoria.jsp` consulta la tabla `auditoria`. |
| 14 | (Propuesta propia) Como agente, quiero gestionar la galería de imágenes de cada propiedad de forma independiente. | Media | ✅ Hecho | Módulo `imagenes/` (`imagen_subir.jsp`, `imagen_guardar.jsp`, `imagenes_propiedad.jsp`). |

## Historias pendientes / deuda técnica declarada

| # | Historia | Prioridad | Estado | Nota |
|---|---|---|---|---|
| 15 | Como desarrollador, quiero centralizar el control de acceso en un `Filter` de servlet en vez de repetir la validación en cada JSP. | Alta | ⚠️ Pendiente | Existe `AccessFilter.class` compilado pero no está registrado (`@WebFilter` ausente y sin `<filter>` en `web.xml`). Cada página valida `usuarioId`/`usuarioRol` manualmente, lo cual funciona pero no cumple literalmente el requisito de "un filtro de servlet" centralizado. |
| 16 | Como administrador, quiero recuperar mi contraseña por correo. | Baja (valor agregado opcional) | ⛔ No implementado | Mencionado como opcional en el enunciado. |
