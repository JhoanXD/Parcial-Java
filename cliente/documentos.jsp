<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null) { response.sendRedirect("../login.jsp?error=acceso"); return; }
String tituloPagina = "Documentos de solicitud | Inmoraiz";
String solicitud = request.getParameter("id_solicitud");
if (solicitud == null || solicitud.isBlank()) {
    response.sendRedirect("solicitudes.jsp");
    return;
}
%>
<!DOCTYPE html><html lang="es"><head><%@include file="/WEB-INF/JSPF/inmo_head.jspf"%></head><body><%@include file="/WEB-INF/JSPF/inmo_navbar.jspf"%><main class="container py-5"><div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4"><div><p class="text-primary fw-semibold mb-1">CLIENTE</p><h1 class="fw-bold mb-1">Documentos de la solicitud</h1><p class="text-muted mb-0">Consulta y gestiona los archivos asociados a este trámite.</p></div><a href="documento_subir.jsp?id_solicitud=<%= solicitud %>" class="btn btn-primary"><i class="bi bi-upload me-1"></i>Subir documento</a></div><div class="table-responsive card border-0 shadow-sm"><table class="table mb-0"><thead><tr><th>Archivo</th><th>Tipo</th><th>Ruta</th><th>Fecha</th></tr></thead><tbody><%try{Class.forName("com.mysql.cj.jdbc.Driver");try(Connection c=abrirConexion();PreparedStatement p=c.prepareStatement("SELECT nombre_archivo,tipo_documento,ruta_archivo,fecha_carga FROM documento_solicitud WHERE id_solicitud=? ORDER BY fecha_carga DESC")){p.setInt(1,Integer.parseInt(solicitud));try(ResultSet r=p.executeQuery()){while(r.next()){%><tr><td><%=r.getString(1)%></td><td><%=r.getString(2)%></td><td><a href="<%=r.getString(3)%>" target="_blank" rel="noopener">Ver archivo</a></td><td><%=r.getTimestamp(4)%></td></tr><%}}}}catch(Exception e){%><tr><td colspan="4" class="text-danger">No fue posible consultar los documentos.</td></tr><%}%></tbody></table></div></main><%@include file="/WEB-INF/JSPF/inmo_footer.jspf"%></body></html>


