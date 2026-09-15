<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null || !("INMOBILIARIA".equals(session.getAttribute("usuarioRol")) || "ADMINISTRADOR".equals(session.getAttribute("usuarioRol")))) { response.sendRedirect("../login.jsp?error=acceso"); return; }
String tituloPagina = "Gestionar propiedades | Inmoraiz";
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4"><div><p class="text-primary fw-semibold mb-1">INMOBILIARIA</p><h1 class="fw-bold mb-1">Mis propiedades</h1><p class="text-muted mb-0">Publica, consulta y desactiva tus inmuebles.</p></div><a href="propiedad_nueva.jsp" class="btn btn-primary"><i class="bi bi-plus-lg me-1"></i>Nueva propiedad</a></div><% if ("ok".equals(request.getParameter("estado"))) { %><div class="alert alert-success">La propiedad fue actualizada.</div><% } %><div class="table-responsive card border-0 shadow-sm"><table class="table align-middle mb-0"><thead><tr><th>Matrícula</th><th>Propiedad</th><th>Ciudad</th><th>Modalidad</th><th>Precio</th><th>Estado</th><th></th></tr></thead><tbody><% int resultados = 0; try { Class.forName("com.mysql.cj.jdbc.Driver"); String sql = "SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, c.nombre ciudad, p.modalidad, p.precio, p.estado FROM propiedad p INNER JOIN ciudad c ON c.id_ciudad=p.id_ciudad ORDER BY p.fecha_publicacion DESC"; if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sql = "SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, c.nombre ciudad, p.modalidad, p.precio, p.estado FROM propiedad p INNER JOIN ciudad c ON c.id_ciudad=p.id_ciudad INNER JOIN inmobiliaria i ON i.id_inmobiliaria=p.id_inmobiliaria WHERE i.id_usuario=? ORDER BY p.fecha_publicacion DESC"; try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement(sql)) { if ("INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) sentencia.setInt(1, (Integer) session.getAttribute("usuarioId")); try (ResultSet propiedades = sentencia.executeQuery()) { while (propiedades.next()) { resultados++; %><tr><td><%= propiedades.getString("matricula_inmobiliaria") %></td><td><%= propiedades.getString("titulo") %></td><td><%= propiedades.getString("ciudad") %></td><td><%= propiedades.getString("modalidad") %></td><td>$<%= propiedades.getBigDecimal("precio") %></td><td><span class="badge text-bg-secondary"><%= propiedades.getString("estado") %></span></td><td><a href="propiedad_estado.jsp?id=<%= propiedades.getInt("id_propiedad") %>&estado=INACTIVA" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Dar de baja esta propiedad?');">Dar de baja</a></td></tr><% } } } } catch (Exception exception) { %><tr><td colspan="7" class="text-danger">No fue posible consultar las propiedades.</td></tr><% } if (resultados == 0) { %><tr><td colspan="7" class="text-center text-muted py-5">No hay propiedades registradas.</td></tr><% } %></tbody></table></div></main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


