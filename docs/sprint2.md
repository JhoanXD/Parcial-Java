# Sprint 2 — Núcleo del negocio
**Duración:** 2 – 8 de septiembre de 2026 (7 días)
**Roles Scrum:** Product Owner: docente Julian Barney Jaimes Rincón · Scrum Master / Development Team: estudiante(s) del proyecto

---

## Sprint Planning

### Objetivo del sprint
Construir el CRUD completo de propiedades con su galería de imágenes (1:N) y características (N:M), el buscador con filtros, el perfil del usuario y los paneles diferenciados por rol.

### Historias de usuario abordadas
- **HU-05** — Completar perfil con documento, teléfono y dirección (Prioridad Media)
- **HU-06** — Registrar y editar propiedades con fotos, características y precio (Prioridad Alta)
- **HU-07** — Buscar y filtrar propiedades por ciudad, tipo, precio y características (Prioridad Alta)

### Tareas técnicas planificadas
| Tarea | Estimación |
|---|---|
| `propiedades/propiedad_nueva.jsp` + `propiedad_guardar.jsp` (alta con `matricula_inmobiliaria` UNIQUE) | 1.5 días |
| `propiedades/propiedad_editar.jsp` + `propiedad_actualizar.jsp` | 1 día |
| `propiedades/propiedad_estado.jsp` (baja lógica cambiando `estado` a INACTIVA) | 0.5 día |
| Módulo `imagenes/` completo (subir, guardar, listar galería) | 1.5 días |
| Selector de características (N:M) en el formulario de propiedad (`propiedad_caracteristica`) | 1 día |
| `catalogo.jsp` con filtros combinados (ciudad, tipo, modalidad, precio) | 1 día |
| `cliente/perfil.jsp` (actualizar datos de `perfil`) | 0.5 día |

**Total estimado:** 7 días

---

## Sprint Review

### Incrementos entregados
- CRUD de propiedades operativo: un agente de la inmobiliaria (`INMOBILIARIA`) puede publicar, editar y dar de baja (baja lógica vía `estado = 'INACTIVA'`) sus propiedades.
- Galería de imágenes por propiedad funcionando (`imagen_propiedad`, relación 1:N con `ON DELETE CASCADE`).
- Selección de características con cantidad (ej. número de parqueaderos) resolviendo la relación N:M `propiedad_caracteristica`.
- `catalogo.jsp` permite a cualquier visitante filtrar el catálogo público por ciudad, tipo de inmueble, modalidad (venta/arriendo) y rango de precio.
- `cliente/perfil.jsp` permite actualizar los datos de la relación 1:1 `usuario`↔`perfil`.
- `dashboard.jsp` ya muestra tarjetas de acceso distintas para CLIENTE, INMOBILIARIA y ADMINISTRADOR.

### Demostración
Se publicó una propiedad de prueba con 2 imágenes y 3 características, se buscó desde el catálogo aplicando filtros combinados, y se verificó que la baja lógica oculta la propiedad del catálogo público sin borrar el registro (ni sus citas/solicitudes históricas).

### Feedback del Product Owner
- Aprobado el uso de baja lógica (`estado`) en vez de `DELETE` físico, ya que preserva el historial de citas y solicitudes asociadas.
- Se solicitó que la ficha de detalle de la propiedad (`propiedad.jsp`) sea accesible para visitantes no autenticados, mostrando solo el botón de "Gestionar imágenes" a los agentes — quedó implementado así.

---

## Sprint Retrospective

**Qué funcionó bien**
- Resolver primero el CRUD de propiedades permitió que el catálogo y las citas/solicitudes del Sprint 3 tuvieran datos reales sobre los cuales trabajar.
- La restricción `matricula_inmobiliaria UNIQUE` evitó desde el diseño la duplicación de inmuebles.

**Qué se puede mejorar**
- El formulario de nueva propiedad creció bastante (título, descripción, precio, área, habitaciones, baños, características, imágenes); se podría dividir en pasos en una futura iteración.
- Aún no se ha escrito el diccionario de datos ni el modelo relacional en Markdown — queda pendiente para el cierre del Sprint 3.

**Acciones para el siguiente sprint**
- Implementar citas, solicitudes, documentos y favoritos.
- Escribir los reportes con consultas de agregación.
- Dejar tiempo al final del sprint para la documentación completa (MER, diccionario de datos, consultas documentadas).
