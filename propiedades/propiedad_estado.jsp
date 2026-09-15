<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null || !("INMOBILIARIA".equals(session.getAttribute("usuarioRol")) || "ADMINISTRADOR".equals(session.getAttribute("usuarioRol")))) { response.sendRedirect("../login.jsp?error=acceso"); return; }
try { Class.forName("com.mysql.cj.jdbc.Driver"); try (Connection conexion = abrirConexion()) { String sql = "UPDATE propiedad SET estado=? WHERE id_propiedad=?"; boolean administrador = "ADMINISTRADOR".equals(session.getAttribute("usuarioRol")); if (!administrador) sql += " AND id_inmobiliaria IN (SELECT id_inmobiliaria FROM inmobiliaria WHERE id_usuario=?)"; try (PreparedStatement sentencia = conexion.prepareStatement(sql)) { sentencia.setString(1, request.getParameter("estado")); sentencia.setInt(2, Integer.parseInt(request.getParameter("id"))); if (!administrador) sentencia.setInt(3, (Integer) session.getAttribute("usuarioId")); sentencia.executeUpdate(); } } } catch (Exception ignored) { }
response.sendRedirect("inmobiliaria_propiedades.jsp?estado=ok");
%>

