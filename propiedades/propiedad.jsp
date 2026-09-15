<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%
String tituloPagina = "Detalle de propiedad | Inmoraiz";
String matricula = request.getParameter("matricula");
String mensajeFavorito = request.getParameter("favorito");
int idPropiedad = 0;
String titulo = null;
String descripcion = null;
String modalidad = null;
String ciudad = null;
String tipo = null;
String inmobiliaria = null;
String precio = null;
String area = null;
int habitaciones = 0;
int banos = 0;
List<String> caracteristicas = new ArrayList<>();
int imagenesCount = 0;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection conexion = abrirConexion()) {
        String propiedadSql = "SELECT p.id_propiedad, p.titulo, p.descripcion, p.modalidad, p.precio, p.area_m2, "
            + "p.habitaciones, p.banos, c.nombre AS ciudad, t.nombre AS tipo, i.nombre AS inmobiliaria "
            + "FROM propiedad p INNER JOIN ciudad c ON c.id_ciudad=p.id_ciudad "
            + "INNER JOIN tipo_propiedad t ON t.id_tipo=p.id_tipo "
            + "INNER JOIN inmobiliaria i ON i.id_inmobiliaria=p.id_inmobiliaria "
            + "WHERE p.matricula_inmobiliaria=? AND p.estado <> 'INACTIVA'";
        try (PreparedStatement sentencia = conexion.prepareStatement(propiedadSql)) {
            sentencia.setString(1, matricula);
            try (ResultSet resultado = sentencia.executeQuery()) {
                if (resultado.next()) {
                    idPropiedad = resultado.getInt("id_propiedad");
                    titulo = resultado.getString("titulo");
                    descripcion = resultado.getString("descripcion");
                    modalidad = resultado.getString("modalidad");
                    ciudad = resultado.getString("ciudad");
                    tipo = resultado.getString("tipo");
                    inmobiliaria = resultado.getString("inmobiliaria");
                    precio = NumberFormat.getCurrencyInstance(new Locale("es", "CO")).format(resultado.getBigDecimal("precio"));
                    area = resultado.getBigDecimal("area_m2").toString();
                    habitaciones = resultado.getInt("habitaciones");
                    banos = resultado.getInt("banos");
                }
            }
        }
        if (idPropiedad > 0) {
            try (PreparedStatement sentencia = conexion.prepareStatement(
                    "SELECT c.nombre FROM propiedad_caracteristica pc INNER JOIN caracteristica c ON c.id_caracteristica=pc.id_caracteristica WHERE pc.id_propiedad=? ORDER BY c.nombre")) {
                sentencia.setInt(1, idPropiedad);
                try (ResultSet resultado = sentencia.executeQuery()) {
                    while (resultado.next()) caracteristicas.add(resultado.getString("nombre"));
                }
            }
        }
    }
} catch (Exception exception) {
    response.sendError(500, "No fue posible consultar la propiedad");
    return;
}
if (idPropiedad == 0) {
    response.sendError(404, "Propiedad no encontrada");
    return;
}
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5">
  <a href="catalogo.jsp" class="link-dark text-decoration-none"><i class="bi bi-arrow-left me-1"></i>Volver al catálogo</a>
  <div class="row g-5 mt-2 align-items-start">
    <div class="col-lg-7"><div class="bg-light border rounded-3 p-3" style="min-height:420px;"><div class="row g-3"><% try { Class.forName("com.mysql.cj.jdbc.Driver"); try (Connection imagenesConexion = abrirConexion(); PreparedStatement imagenesSentencia = imagenesConexion.prepareStatement("SELECT url, texto_alternativo FROM imagen_propiedad WHERE id_propiedad=? ORDER BY orden_imagen")) { imagenesSentencia.setInt(1, idPropiedad); try (ResultSet imagenes = imagenesSentencia.executeQuery()) { while (imagenes.next()) { imagenesCount++; %><div class="col-md-6"><img src="<%= imagenes.getString("url") %>" alt="<%= imagenes.getString("texto_alternativo") %>" class="img-fluid rounded w-100" style="height:190px;object-fit:cover"></div><% } } } } catch (Exception ignored) { } %><% if (imagenesCount == 0) { %><div class="col-12 text-center py-5"><i class="bi bi-building text-primary" style="font-size:8rem;"></i></div><% } %></div></div><% if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) { %><a href="../imagenes/imagenes_propiedad.jsp?id=<%= idPropiedad %>" class="btn btn-sm btn-outline-primary mt-2">Gestionar imágenes</a><% } %></div>
    <div class="col-lg-5"><span class="badge <%= "VENTA".equals(modalidad) ? "text-bg-secondary" : "text-bg-dark" %> mb-3"><%= modalidad %></span><p class="text-muted small mb-2">Matrícula <%= matricula %> | <%= ciudad %> | <%= tipo %></p><h1 class="display-6 fw-bold"><%= titulo %></h1><p class="fs-3 fw-bold text-primary my-4"><%= precio %></p><div class="row g-3 border-top border-bottom py-3 mb-4"><div class="col-4"><strong class="d-block"><%= habitaciones %></strong><small class="text-muted">Habitaciones</small></div><div class="col-4"><strong class="d-block"><%= banos %></strong><small class="text-muted">Banos</small></div><div class="col-4"><strong class="d-block"><%= area %> m2</strong><small class="text-muted">Área</small></div></div><p class="text-muted"><%= descripcion %></p><p class="small text-muted mb-3">Publica: <%= inmobiliaria %></p><% if ("ok".equals(mensajeFavorito)) { %><div class="alert alert-success small">Propiedad guardada en favoritos.</div><% } else if ("error".equals(mensajeFavorito)) { %><div class="alert alert-danger small">No fue posible guardar el favorito.</div><% } %><form method="post" action="cliente/favorito.jsp" class="mb-2"><input type="hidden" name="id_propiedad" value="<%= idPropiedad %>"><input type="hidden" name="matricula" value="<%= matricula %>"><button class="btn btn-outline-primary btn-lg w-100" type="submit"><i class="bi bi-heart me-2"></i>Guardar en favoritos</button></form><div class="row g-2"><div class="col-6"><a href="cliente/cita.jsp?id_propiedad=<%= idPropiedad %>&matricula=<%= matricula %>" class="btn btn-primary w-100"><i class="bi bi-calendar-check me-1"></i>Agendar</a></div><div class="col-6"><a href="cliente/solicitud.jsp?id_propiedad=<%= idPropiedad %>&matricula=<%= matricula %>" class="btn btn-outline-dark w-100"><i class="bi bi-file-earmark-text me-1"></i>Solicitar</a></div></div></div>
  </div>
  <section class="mt-5"><h2 class="h4 fw-bold">Características</h2><div class="d-flex flex-wrap gap-2"><% if (caracteristicas.isEmpty()) { %><span class="text-muted">Sin características registradas.</span><% } for (String caracteristica : caracteristicas) { %><span class="badge text-bg-light border px-3 py-2"><i class="bi bi-check2 text-primary me-1"></i><%= caracteristica %></span><% } %></div></section>
</main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


