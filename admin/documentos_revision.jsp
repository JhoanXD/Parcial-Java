<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null || !("INMOBILIARIA".equals(session.getAttribute("usuarioRol")) || "ADMINISTRADOR".equals(session.getAttribute("usuarioRol")))) {
    response.sendRedirect("../login.jsp?error=acceso");
    return;
}
String mensaje = null;
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String sql = "UPDATE documento_solicitud d INNER JOIN solicitud s ON s.id_solicitud=d.id_solicitud INNER JOIN propiedad p ON p.id_propiedad=s.id_propiedad SET d.estado=?, d.revisado_por=? WHERE d.id_documento=?";
        if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sql += " AND p.id_inmobiliaria IN (SELECT id_inmobiliaria FROM inmobiliaria WHERE id_usuario=?)";
        try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement(sql)) {
            sentencia.setString(1, request.getParameter("estado"));
            sentencia.setInt(2, (Integer) session.getAttribute("usuarioId"));
            sentencia.setInt(3, Integer.parseInt(request.getParameter("id_documento")));
            if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sentencia.setInt(4, (Integer) session.getAttribute("usuarioId"));
            mensaje = sentencia.executeUpdate() == 1 ? "ok" : "error";
        }
    } catch (Exception exception) { mensaje = "error"; }
}
String tituloPagina = "Revisión de documentos | Inmoraiz";
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5">
  <div class="mb-4"><p class="text-primary fw-semibold mb-1">REVISIÓN</p><h1 class="fw-bold">Documentos de solicitudes</h1><p class="text-muted">Aprueba o rechaza cada documento radicado por los clientes.</p></div>
  <% if ("ok".equals(mensaje)) { %><div class="alert alert-success">Estado del documento actualizado.</div><% } else if ("error".equals(mensaje)) { %><div class="alert alert-danger">No fue posible actualizar el documento.</div><% } %>
  <div class="table-responsive card border-0 shadow-sm"><table class="table align-middle mb-0"><thead><tr><th>Documento</th><th>Cliente</th><th>Propiedad</th><th>Tipo</th><th>Estado</th><th>Archivo</th><th>Acción</th></tr></thead><tbody>
  <% try { Class.forName("com.mysql.cj.jdbc.Driver"); String sql = "SELECT d.id_documento,d.nombre_archivo,d.tipo_documento,d.estado,d.ruta_archivo,u.correo,p.titulo FROM documento_solicitud d INNER JOIN solicitud s ON s.id_solicitud=d.id_solicitud INNER JOIN usuario u ON u.id_usuario=s.id_cliente INNER JOIN propiedad p ON p.id_propiedad=s.id_propiedad"; if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sql += " INNER JOIN inmobiliaria i ON i.id_inmobiliaria=p.id_inmobiliaria WHERE i.id_usuario=?"; sql += " ORDER BY d.fecha_carga DESC"; try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement(sql)) { if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sentencia.setInt(1, (Integer) session.getAttribute("usuarioId")); try (ResultSet datos = sentencia.executeQuery()) { while (datos.next()) { %>
  <tr><td><%= datos.getString("nombre_archivo") %></td><td><%= datos.getString("correo") %></td><td><%= datos.getString("titulo") %></td><td><%= datos.getString("tipo_documento") %></td><td><span class="badge text-bg-secondary"><%= datos.getString("estado") %></span></td><td><a href="<%= datos.getString("ruta_archivo") %>" target="_blank" rel="noopener">Ver</a></td><td><form method="post" class="d-flex gap-2"><input type="hidden" name="id_documento" value="<%= datos.getInt("id_documento") %>"><select name="estado" class="form-select form-select-sm"><option value="APROBADO">Aprobar</option><option value="RECHAZADO">Rechazar</option><option value="PENDIENTE">Pendiente</option></select><button class="btn btn-sm btn-primary">Guardar</button></form></td></tr>
  <% } } } } catch (Exception exception) { %><tr><td colspan="7" class="text-danger">No fue posible consultar los documentos.</td></tr><% } %>
  </tbody></table></div>
</main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


