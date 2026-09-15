<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null) { response.sendRedirect("../login.jsp?error=acceso"); return; }
String tituloPagina = "Mis solicitudes | Inmoraiz";
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="d-flex justify-content-between align-items-end mb-4"><div><p class="text-primary fw-semibold mb-1">CLIENTE</p><h1 class="fw-bold mb-1">Mis solicitudes</h1><p class="text-muted mb-0">Consulta el estado de tus compras y arriendos.</p></div><a href="../catalogo.jsp" class="btn btn-primary"><i class="bi bi-search me-1"></i>Buscar propiedades</a></div><div class="table-responsive card border-0 shadow-sm"><table class="table align-middle mb-0"><thead><tr><th>Propiedad</th><th>Tipo</th><th>Fecha</th><th>Estado</th><th>Acciones</th></tr></thead><tbody><% int resultados = 0; try { Class.forName("com.mysql.cj.jdbc.Driver"); try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement("SELECT s.id_solicitud, p.titulo, s.tipo, s.fecha_solicitud, s.estado FROM solicitud s INNER JOIN propiedad p ON p.id_propiedad=s.id_propiedad WHERE s.id_cliente=? ORDER BY s.fecha_solicitud DESC")) { sentencia.setInt(1, (Integer) session.getAttribute("usuarioId")); try (ResultSet solicitudes = sentencia.executeQuery()) { while (solicitudes.next()) { resultados++; %><tr><td><%= solicitudes.getString("titulo") %></td><td><%= solicitudes.getString("tipo") %></td><td><%= solicitudes.getTimestamp("fecha_solicitud") %></td><td><span class="badge text-bg-secondary"><%= solicitudes.getString("estado") %></span></td><td class="d-flex gap-2"><a href="documento_subir.jsp?id_solicitud=<%= solicitudes.getInt("id_solicitud") %>" class="btn btn-sm btn-primary">Subir documento</a><a href="documentos.jsp?id_solicitud=<%= solicitudes.getInt("id_solicitud") %>" class="btn btn-sm btn-outline-primary">Ver documentos</a></td></tr><% } } } } catch (Exception exception) { %><tr><td colspan="5" class="text-danger">No fue posible consultar las solicitudes.</td></tr><% } if (resultados == 0) { %><tr><td colspan="5" class="text-center text-muted py-5">Aún no tienes solicitudes registradas.</td></tr><% } %></tbody></table></div></main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


