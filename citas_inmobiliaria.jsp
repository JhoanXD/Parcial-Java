<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null || !("INMOBILIARIA".equals(session.getAttribute("usuarioRol")) || "ADMINISTRADOR".equals(session.getAttribute("usuarioRol")))) { response.sendRedirect("login.jsp?error=acceso"); return; }
String tituloPagina = "Citas | Inmoraiz";
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conexion = abrirConexion()) {
            String sqlActualizar = "UPDATE cita SET estado=? WHERE id_cita=?";
            if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sqlActualizar += " AND id_propiedad IN (SELECT p.id_propiedad FROM propiedad p INNER JOIN inmobiliaria i ON i.id_inmobiliaria=p.id_inmobiliaria WHERE i.id_usuario=?)";
            try (PreparedStatement actualizar = conexion.prepareStatement(sqlActualizar)) {
                actualizar.setString(1, request.getParameter("estado"));
                actualizar.setInt(2, Integer.parseInt(request.getParameter("id_cita")));
                if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) actualizar.setInt(3, (Integer) session.getAttribute("usuarioId"));
                actualizar.executeUpdate();
            }
            try (PreparedStatement auditoria = conexion.prepareStatement("INSERT INTO auditoria (id_usuario, accion, tabla_afectada, id_registro, detalle) VALUES (?, ?, 'cita', ?, ?)")) {
                auditoria.setInt(1, (Integer) session.getAttribute("usuarioId"));
                auditoria.setString(2, "ACTUALIZAR_CITA");
                auditoria.setString(3, request.getParameter("id_cita"));
                auditoria.setString(4, "Estado cambiado a " + request.getParameter("estado"));
                auditoria.executeUpdate();
            }
        }
    } catch (Exception ignored) { }
}
%>
<!DOCTYPE html>
<html lang="es"><head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head><body><%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="mb-4"><p class="text-primary fw-semibold mb-1">INMOBILIARIA</p><h1 class="fw-bold">Citas solicitadas</h1><p class="text-muted">Confirma, atiende o cancela las visitas de tus propiedades.</p></div><div class="table-responsive card border-0 shadow-sm"><table class="table align-middle mb-0"><thead><tr><th>Propiedad</th><th>Cliente</th><th>Fecha</th><th>Estado</th><th>Acción</th></tr></thead><tbody>
<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    String sql = "SELECT c.id_cita,p.titulo,u.correo,c.fecha_hora,c.estado FROM cita c INNER JOIN propiedad p ON p.id_propiedad=c.id_propiedad INNER JOIN usuario u ON u.id_usuario=c.id_cliente ORDER BY c.fecha_hora";
    if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sql = "SELECT c.id_cita,p.titulo,u.correo,c.fecha_hora,c.estado FROM cita c INNER JOIN propiedad p ON p.id_propiedad=c.id_propiedad INNER JOIN usuario u ON u.id_usuario=c.id_cliente INNER JOIN inmobiliaria i ON i.id_inmobiliaria=p.id_inmobiliaria WHERE i.id_usuario=? ORDER BY c.fecha_hora";
    try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement(sql)) {
        if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sentencia.setInt(1, (Integer) session.getAttribute("usuarioId"));
        try (ResultSet datos = sentencia.executeQuery()) {
            while (datos.next()) {
%><tr><td><%= datos.getString("titulo") %></td><td><%= datos.getString("correo") %></td><td><%= datos.getTimestamp("fecha_hora") %></td><td><span class="badge text-bg-secondary"><%= datos.getString("estado") %></span></td><td><form method="post" class="d-flex gap-2"><input type="hidden" name="id_cita" value="<%= datos.getInt("id_cita") %>"><select name="estado" class="form-select form-select-sm"><option value="CONFIRMADA">Confirmar</option><option value="ATENDIDA">Atendida</option><option value="CANCELADA">Cancelar</option></select><button class="btn btn-sm btn-primary">Guardar</button></form></td></tr><%
            }
        }
    }
} catch (Exception exception) {
%><tr><td colspan="5" class="text-danger">No fue posible consultar las citas.</td></tr><% } %>
</tbody></table></div></main><%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %></body></html>


