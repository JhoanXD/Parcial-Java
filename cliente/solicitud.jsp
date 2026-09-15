<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null) {
    response.sendRedirect("../login.jsp?error=acceso");
    return;
}
String tituloPagina = "Solicitar inmueble | Inmoraiz";
String idPropiedad = request.getParameter("id_propiedad");
String matricula = request.getParameter("matricula");
String error = request.getParameter("error");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String tipo = request.getParameter("tipo");
    String observaciones = request.getParameter("observaciones");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement("INSERT INTO solicitud (id_propiedad, id_cliente, tipo, observaciones) VALUES (?, ?, ?, ?)")) {
            sentencia.setInt(1, Integer.parseInt(idPropiedad));
            sentencia.setInt(2, (Integer) session.getAttribute("usuarioId"));
            sentencia.setString(3, tipo);
            sentencia.setString(4, observaciones);
            sentencia.executeUpdate();
        }
        response.sendRedirect("../dashboard.jsp?solicitud=ok");
        return;
    } catch (SQLException exception) {
        error = "duplicada";
    } catch (Exception exception) {
        error = "servidor";
    }
}
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="row justify-content-center"><div class="col-lg-7"><div class="card border-0 shadow-sm"><div class="card-body p-4 p-lg-5"><a href="../propiedades/propiedad.jsp?matricula=<%= matricula %>" class="link-dark text-decoration-none"><i class="bi bi-arrow-left me-1"></i>Volver a la propiedad</a><h1 class="h3 fw-bold mt-4">Iniciar solicitud</h1><p class="text-muted">Radica tu intención de compra o arriendo para que la inmobiliaria pueda revisarla.</p><% if ("duplicada".equals(error)) { %><div class="alert alert-warning">No fue posible registrar la solicitud.</div><% } else if ("servidor".equals(error)) { %><div class="alert alert-danger">No fue posible conectar con la base de datos.</div><% } %><form method="post" action="solicitud.jsp"><input type="hidden" name="id_propiedad" value="<%= idPropiedad %>"><input type="hidden" name="matricula" value="<%= matricula %>"><div class="mb-3"><label class="form-label" for="tipo">Tipo de solicitud</label><select class="form-select" id="tipo" name="tipo" required><option value="">Selecciona una opción</option><option value="COMPRA">Compra</option><option value="ARRIENDO">Arriendo</option></select></div><div class="mb-4"><label class="form-label" for="observaciones">Observaciones</label><textarea class="form-control" id="observaciones" name="observaciones" rows="4" maxlength="500" placeholder="Cuéntanos sobre tu solicitud"></textarea></div><button class="btn btn-primary" type="submit"><i class="bi bi-send me-2"></i>Radicar solicitud</button></form></div></div></div></div></main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


