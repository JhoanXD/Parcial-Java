USE inmobiliaria_db;

-- 1. INNER JOIN de propiedades, ciudad, tipo e inmobiliaria.
SELECT p.matricula_inmobiliaria, p.titulo, c.nombre AS ciudad,
       t.nombre AS tipo, i.nombre AS inmobiliaria
FROM propiedad p
INNER JOIN ciudad c ON c.id_ciudad = p.id_ciudad
INNER JOIN tipo_propiedad t ON t.id_tipo = p.id_tipo
INNER JOIN inmobiliaria i ON i.id_inmobiliaria = p.id_inmobiliaria
WHERE p.estado = 'DISPONIBLE';

-- 2. INNER JOIN de solicitudes, cliente, propiedad e inmobiliaria.
SELECT s.id_solicitud, u.correo AS cliente, p.titulo,
       i.nombre AS inmobiliaria, s.estado
FROM solicitud s
INNER JOIN usuario u ON u.id_usuario = s.id_cliente
INNER JOIN propiedad p ON p.id_propiedad = s.id_propiedad
INNER JOIN inmobiliaria i ON i.id_inmobiliaria = p.id_inmobiliaria;

-- 3. Consulta N:M: características de cada propiedad.
SELECT p.titulo, c.nombre AS caracteristica, pc.cantidad
FROM propiedad p
INNER JOIN propiedad_caracteristica pc ON pc.id_propiedad = p.id_propiedad
INNER JOIN caracteristica c ON c.id_caracteristica = pc.id_caracteristica
ORDER BY p.titulo, c.nombre;

-- 4. LEFT JOIN: propiedades que aún no tienen citas.
SELECT p.id_propiedad, p.titulo, p.matricula_inmobiliaria
FROM propiedad p
LEFT JOIN cita c ON c.id_propiedad = p.id_propiedad
WHERE c.id_cita IS NULL AND p.estado = 'DISPONIBLE';

-- 5. GROUP BY y HAVING: propiedades disponibles por ciudad.
SELECT c.nombre AS ciudad, COUNT(p.id_propiedad) AS disponibles
FROM ciudad c
INNER JOIN propiedad p ON p.id_ciudad = c.id_ciudad
WHERE p.estado = 'DISPONIBLE'
GROUP BY c.id_ciudad, c.nombre
HAVING COUNT(p.id_propiedad) >= 1
ORDER BY disponibles DESC;

-- 6. Reporte de solicitudes agrupadas por inmobiliaria y estado.
SELECT i.nombre AS inmobiliaria, s.estado, COUNT(s.id_solicitud) AS total
FROM solicitud s
INNER JOIN propiedad p ON p.id_propiedad = s.id_propiedad
INNER JOIN inmobiliaria i ON i.id_inmobiliaria = p.id_inmobiliaria
GROUP BY i.id_inmobiliaria, i.nombre, s.estado
HAVING COUNT(s.id_solicitud) >= 1
ORDER BY i.nombre, s.estado;
