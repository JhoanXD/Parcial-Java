# Sprint 1 — Cimientos y acceso
**Duración:** 26 de agosto – 1 de septiembre de 2026 (7 días)
**Roles Scrum:** Product Owner: docente Julian Barney Jaimes Rincón · Scrum Master / Development Team: estudiante(s) del proyecto

---

## Sprint Planning

### Objetivo del sprint
Dejar lista la base de datos normalizada, la conexión JDBC centralizada, la landing page pública y el módulo de autenticación con contraseñas cifradas y control de acceso por rol.

### Historias de usuario abordadas
- **HU-01** — Página de aterrizaje atractiva con buscador rápido (Prioridad Alta)
- **HU-02** — Registro con correo único y validado (Prioridad Alta)
- **HU-03** — Inicio y cierre de sesión seguro con redirección por rol (Prioridad Alta)
- **HU-04** — Asignación y revocación de roles por el administrador (Prioridad Alta)

### Tareas técnicas planificadas
| Tarea | Estimación |
|---|---|
| Diseñar el MER y el modelo relacional en 3FN | 1 día |
| Escribir el script DDL (`01_schema.sql`) con PK, FK y restricciones UNIQUE | 1 día |
| Escribir el script DML de catálogos y usuarios de prueba (`02_data.sql`) | 0.5 día |
| Centralizar la conexión JDBC (`inmo_db-conexion.jspf`) | 0.5 día |
| Construir la landing page con Bootstrap (`inmo_index.jsp`, tema en `Css/inmo_custom-theme.css`) | 1.5 días |
| Implementar `registro.jsp` con hash BCrypt y manejo del error de correo/documento duplicado | 1 día |
| Implementar `login.jsp` con verificación de hash y creación de `HttpSession` | 1 día |
| Diseñar `access_denied.jsp` y la primera versión de control de acceso | 0.5 día |

**Total estimado:** 7 días

---

## Sprint Review

### Incrementos entregados
- Base de datos `inmobiliaria_db` creada con las 16 tablas normalizadas, relaciones 1:1 (`usuario`↔`perfil`, `usuario`↔`inmobiliaria`), 1:N y N:M (`usuario_rol`) ya operativas.
- `inmo_db-conexion.jspf` funcionando como único punto de conexión, reutilizado en todas las páginas.
- Landing page (`inmo_index.jsp`) responsiva, con buscador y accesos a registro/login.
- `registro.jsp` y `login.jsp` funcionando de punta a punta: un usuario puede crear su cuenta, cifrar su clave con BCrypt, iniciar sesión y quedar redirigido a `dashboard.jsp`.
- `dashboard.jsp` ya diferencia el contenido mostrado según `usuarioRol` en sesión.

### Demostración
Se hizo un recorrido en vivo: registro de un cliente nuevo → intento de registrar el mismo correo (mensaje de error controlado, sin stack trace) → login exitoso → redirección al panel correspondiente.

### Feedback del Product Owner
- Aprobado el modelo de datos y la separación de `perfil` como entidad 1:1, en vez de mezclar los datos personales en `usuario`.
- Se pidió reforzar el control de acceso para que también opere si alguien escribe la URL de una página privada directamente (no solo ocultar el menú).

---

## Sprint Retrospective

**Qué funcionó bien**
- Definir primero el modelo de datos evitó tener que migrar tablas a mitad de camino.
- Centralizar la conexión en un `.jspf` ahorró tiempo al construir las páginas siguientes.

**Qué se puede mejorar**
- El control de acceso quedó implementado como validaciones repetidas en cada JSP (`if session.getAttribute(...) == null`) en lugar de un único `Filter` de servlet. Se decidió dejarlo así por ahora y evaluar centralizarlo en un sprint posterior si el tiempo lo permite.
- Falta escribir aún el diccionario de datos formal (se hizo el DDL, pero no la documentación en Markdown).

**Acciones para el siguiente sprint**
- Iniciar el Sprint 2 con el CRUD de propiedades e imágenes.
- Evaluar si conviene esbozar un `AccessFilter` como prueba de concepto para centralizar el control de acceso.
