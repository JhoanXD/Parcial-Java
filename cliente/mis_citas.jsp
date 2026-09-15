<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null || !"CLIENTE".equals(session.getAttribute("usuarioRol"))) {
    response.sendRedirect("../login.jsp?error=acceso");
    return;
}
String tituloPagina = "Mis citas | Inmoraiz";
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5">
  <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
    <div><p class="text-primary fw-semibold mb-1">CLIENTE</p><h1 class="fw-bold mb-1">Mis citas</h1><p class="text-muted mb-0">Consulta las visitas que has agendado.</p></div>
    <a href="../catalogo.jsp" class="btn btn-primary"><i class="bi bi-search me-1"></i>Buscar propiedades</a>
  </div>
  <div class="table-responsive card border-0 shadow-sm"><table class="table align-middle mb-0">
    <thead><tr><th>Propiedad</th><th>Ciudad</th><th>Fecha y hora</th><th>Estado</th><th>Observaciones</th></tr></thead>
    <tbody>
    <% int resultados = 0; try { try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement("SELECT p.titulo, c.nombre AS ciudad, ci.fecha_hora, ci.estado, ci.observaciones FROM cita ci INNER JOIN propiedad p ON p.id_propiedad=ci.id_propiedad INNER JOIN ciudad c ON c.id_ciudad=p.id_ciudad WHERE ci.id_cliente=? ORDER BY ci.fecha_hora DESC")) { sentencia.setInt(1, (Integer) session.getAttribute("usuarioId")); try (ResultSet citas = sentencia.executeQuery()) { while (citas.next()) { resultados++; %>
      <tr><td><%= citas.getString("titulo") %></td><td><%= citas.getString("ciudad") %></td><td><%= citas.getTimestamp("fecha_hora") %></td><td><span class="badge text-bg-secondary"><%= citas.getString("estado") %></span></td><td><%= citas.getString("observaciones") == null ? "-" : citas.getString("observaciones") %></td></tr>
    <% } } } } catch (Exception exception) { %><tr><td colspan="5" class="text-danger">No fue posible consultar tus citas.</td></tr><% } if (resultados == 0) { %><tr><td colspan="5" class="text-center text-muted py-5">Aún no tienes citas agendadas.</td></tr><% } %>
    </tbody>
  </table></div>
</main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>
