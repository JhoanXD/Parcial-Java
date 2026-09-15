<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null) {
    response.sendRedirect("../login.jsp?error=acceso");
    return;
}
String matricula = request.getParameter("matricula");
String idPropiedad = request.getParameter("id_propiedad");
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement("INSERT IGNORE INTO favorito (id_usuario, id_propiedad) VALUES (?, ?)")) {
        sentencia.setInt(1, (Integer) session.getAttribute("usuarioId"));
        sentencia.setInt(2, Integer.parseInt(idPropiedad));
        sentencia.executeUpdate();
    }
    response.sendRedirect("../propiedades/propiedad.jsp?matricula=" + matricula + "&favorito=ok");
} catch (Exception exception) {
    response.sendRedirect("../propiedades/propiedad.jsp?matricula=" + matricula + "&favorito=error");
}
%>

