# Sprint 3 — Operación y cierre
**Duración:** 9 – 15 de septiembre de 2026 (7 días)
**Roles Scrum:** Product Owner: docente Julian Barney Jaimes Rincón · Scrum Master / Development Team: estudiante(s) del proyecto

---

## Sprint Planning

### Objetivo del sprint
Completar citas, solicitudes y documentos, favoritos, los reportes con consultas de agregación, y cerrar con la documentación final del proyecto (Scrum + base de datos).

### Historias de usuario abordadas
- **HU-08** — Marcar propiedades como favoritas (Prioridad Media)
- **HU-09** — Solicitar una cita sin cruce de horarios (Prioridad Media)
- **HU-10** — Radicar documentos y consultar el estado de la solicitud (Prioridad Media)
- **HU-11** — Aprobar o rechazar solicitudes y documentos (Prioridad Media)
- **HU-12** — Reporte de propiedades por ciudad y estado (Prioridad Media)
- **HU-13** — Consultar la auditoría de accesos y cambios (Prioridad Baja)
- **HU-14** (propuesta propia) — Gestión independiente de la galería de imágenes

### Tareas técnicas planificadas
| Tarea | Estimación |
|---|---|
| `cliente/favorito.jsp` / `favoritos.jsp` | 0.5 día |
| `cliente/cita.jsp` + `mis_citas.jsp`, con `UNIQUE(id_propiedad, fecha_hora)` | 1 día |
| `citas_inmobiliaria.jsp` (confirmar/cancelar citas desde el rol INMOBILIARIA) | 0.5 día |
| `cliente/solicitud.jsp` + `documento_subir.jsp` + `solicitudes.jsp`/`documentos.jsp` | 1.5 días |
| `solicitudes_inmobiliaria.jsp` y `admin/documentos_revision.jsp` (aprobar/rechazar) | 1 día |
| Migración `05_migracion_documentos.sql` (estado y `revisado_por` en `documento_solicitud`) | 0.5 día |
| `admin/reportes.jsp` + consultas 5 y 6 (`GROUP BY`/`HAVING`) en `03_queries.sql` | 1 día |
| `admin/auditoria.jsp` y `admin/admin_usuarios.jsp` | 0.5 día |
| Documentación final: diccionario de datos, MER exportado, Scrum, README | 0.5 día |

**Total estimado:** 7 días

---

## Sprint Review

### Incrementos entregados
- Flujo completo de citas: un cliente agenda, la inmobiliaria confirma/cancela desde `citas_inmobiliaria.jsp`, y la restricción `UNIQUE(id_propiedad, fecha_hora)` impide doble agendamiento sobre el mismo inmueble y horario.
- Flujo completo de solicitudes: radicación (`solicitud.jsp`), carga de documentos (`documento_subir.jsp`), revisión por parte de la inmobiliaria y del administrador (`documentos_revision.jsp`), con trazabilidad de quién revisó cada documento (`revisado_por`).
- Favoritos (N:M) operativos entre `usuario` y `propiedad`.
- Reportes de administrador con las 5 consultas obligatorias (2 INNER JOIN, 1 relación N:M, 1 LEFT JOIN, 1 GROUP BY/HAVING) más una consulta adicional de solicitudes por inmobiliaria y estado.
- Módulo de auditoría (`admin/auditoria.jsp`) y gestión de usuarios/roles (`admin/admin_usuarios.jsp`).
- Documentación de base de datos y Scrum completada.

### Demostración
Se hizo el recorrido end-to-end de un trámite: cliente agenda cita → inmobiliaria la confirma → cliente radica solicitud de compra con un documento PDF → administrador revisa y aprueba el documento → el reporte de "solicitudes por inmobiliaria y estado" refleja el cambio inmediatamente.

### Feedback del Product Owner
- Aprobado el flujo de solicitudes y documentos.
- Se observó que existe una clase `AccessFilter` compilada pero no registrada en `web.xml` ni anotada con `@WebFilter`, por lo que el control de acceso, aunque funciona correctamente, está distribuido en cada JSP en vez de centralizado en un único Filter como pide el enunciado. **Queda registrado como pendiente antes de la sustentación final** (ver Retrospective).

---

## Sprint Retrospective

**Qué funcionó bien**
- Reutilizar la conexión centralizada y las restricciones UNIQUE definidas desde el Sprint 1 hizo que los flujos de citas y solicitudes casi no necesitaran manejo especial de errores adicionales.
- Las consultas de agregación fueron sencillas de escribir gracias a que el modelo quedó bien normalizado desde el inicio.

**Qué se puede mejorar / deuda técnica**
- **Pendiente crítico:** activar `AccessFilter` (agregar `@WebFilter("/*")` en el código fuente o declarar `<filter>`/`<filter-mapping>` en `web.xml`) para que el control de acceso quede centralizado como exige el enunciado, en vez de depender únicamente de los `if` repetidos en cada página.
- No se implementó el valor agregado opcional de recuperación de contraseña por correo ni el bloqueo temporal tras varios intentos fallidos.
- El despliegue en línea (aplicación + base de datos) quedó pendiente de decidir la plataforma a usar.

**Acciones antes de la sustentación**
- Registrar el `Filter` en `web.xml` y volver a probar que las rutas privadas sigan bloqueadas.
- Exportar el diagrama MER como imagen para anexarlo a la entrega.
- Repasar el modelo de datos y la justificación de cada relación (1:1, 1:N, N:M) de memoria, ya que la sustentación es individual/en pareja y presencial.
