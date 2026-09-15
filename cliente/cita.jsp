<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
String tituloPagina = "Agendar visita | Inmoraiz";
if (session.getAttribute("usuarioId") == null) {
    response.sendRedirect("../login.jsp?error=acceso");
    return;
}
String idPropiedad = request.getParameter("id_propiedad");
String matricula = request.getParameter("matricula");
String error = request.getParameter("error");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String fechaHora = request.getParameter("fecha_hora");
    String observaciones = request.getParameter("observaciones");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement("INSERT INTO cita (id_propiedad, id_cliente, fecha_hora, observaciones) VALUES (?, ?, ?, ?)")) {
            sentencia.setInt(1, Integer.parseInt(idPropiedad));
            sentencia.setInt(2, (Integer) session.getAttribute("usuarioId"));
            sentencia.setString(3, fechaHora.replace("T", " ") + ":00");
            sentencia.setString(4, observaciones);
            sentencia.executeUpdate();
        }
        response.sendRedirect("../dashboard.jsp?cita=ok");
        return;
    } catch (SQLException exception) {
        error = "duplicada".equals(exception.getSQLState()) || "23000".equals(exception.getSQLState()) ? "horario" : "servidor";
    } catch (Exception exception) {
        error = "campos";
    }
}
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="row justify-content-center"><div class="col-lg-7"><div class="card border-0 shadow-sm"><div class="card-body p-4 p-lg-5"><a href="../propiedades/propiedad.jsp?matricula=<%= matricula %>" class="link-dark text-decoration-none"><i class="bi bi-arrow-left me-1"></i>Volver a la propiedad</a><h1 class="h3 fw-bold mt-4">Agenda tu visita</h1><p class="text-muted">Selecciona un horario disponible para conocer el inmueble.</p><% if ("horario".equals(error)) { %><div class="alert alert-warning">Ese horario ya está ocupado. Selecciona otro.</div><% } else if ("campos".equals(error)) { %><div class="alert alert-danger">Completa una fecha válida.</div><% } else if ("servidor".equals(error)) { %><div class="alert alert-danger">No fue posible registrar la cita.</div><% } %><form method="post" action="cita.jsp"><input type="hidden" name="id_propiedad" value="<%= idPropiedad %>"><input type="hidden" name="matricula" value="<%= matricula %>"><div class="mb-3"><label class="form-label" for="fecha_hora">Fecha y hora</label><input class="form-control" id="fecha_hora" name="fecha_hora" type="datetime-local" required></div><div class="mb-4"><label class="form-label" for="observaciones">Observaciones</label><textarea class="form-control" id="observaciones" name="observaciones" rows="3" maxlength="255" placeholder="¿Hay algo que debamos saber?"></textarea></div><button class="btn btn-primary" type="submit"><i class="bi bi-calendar-check me-2"></i>Solicitar visita</button></form></div></div></div></div></main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


