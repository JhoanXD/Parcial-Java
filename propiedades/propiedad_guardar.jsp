<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%
if (session.getAttribute("usuarioId") == null || !("INMOBILIARIA".equals(session.getAttribute("usuarioRol")) || "ADMINISTRADOR".equals(session.getAttribute("usuarioRol")))) { response.sendRedirect("../login.jsp?error=acceso"); return; }
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection conexion = abrirConexion()) {
        int idInmobiliaria;
        if ("ADMINISTRADOR".equals(session.getAttribute("usuarioRol"))) {
            String inmobiliariaSeleccionada = request.getParameter("id_inmobiliaria");
            if (inmobiliariaSeleccionada == null || inmobiliariaSeleccionada.isBlank()) {
                try (PreparedStatement primera = conexion.prepareStatement("SELECT id_inmobiliaria FROM inmobiliaria ORDER BY id_inmobiliaria LIMIT 1"); ResultSet resultado = primera.executeQuery()) {
                    if (!resultado.next()) { response.sendRedirect("propiedad_nueva.jsp?error=sin_inmobiliaria"); return; }
                    idInmobiliaria = resultado.getInt(1);
                }
            } else {
                idInmobiliaria = Integer.parseInt(inmobiliariaSeleccionada);
            }
        } else {
            try (PreparedStatement buscar = conexion.prepareStatement("SELECT id_inmobiliaria FROM inmobiliaria WHERE id_usuario=?")) { buscar.setInt(1, (Integer) session.getAttribute("usuarioId")); try (ResultSet resultado = buscar.executeQuery()) { if (!resultado.next()) { response.sendRedirect("propiedad_nueva.jsp?error=sin_inmobiliaria"); return; } idInmobiliaria = resultado.getInt(1); } }
        }
        String sql = "INSERT INTO propiedad (id_inmobiliaria,id_ciudad,id_tipo,matricula_inmobiliaria,titulo,descripcion,modalidad,precio,area_m2,habitaciones,banos) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement sentencia = conexion.prepareStatement(sql)) { sentencia.setInt(1, idInmobiliaria); sentencia.setInt(2, Integer.parseInt(request.getParameter("id_ciudad"))); sentencia.setInt(3, Integer.parseInt(request.getParameter("id_tipo"))); sentencia.setString(4, request.getParameter("matricula")); sentencia.setString(5, request.getParameter("titulo")); sentencia.setString(6, request.getParameter("descripcion")); sentencia.setString(7, request.getParameter("modalidad")); sentencia.setBigDecimal(8, new java.math.BigDecimal(request.getParameter("precio"))); sentencia.setBigDecimal(9, new java.math.BigDecimal(request.getParameter("area_m2"))); sentencia.setInt(10, Integer.parseInt(request.getParameter("habitaciones"))); sentencia.setInt(11, Integer.parseInt(request.getParameter("banos"))); sentencia.executeUpdate(); }
    }
    response.sendRedirect("inmobiliaria_propiedades.jsp?estado=ok");
} catch (SQLException exception) { response.sendRedirect("propiedad_nueva.jsp?error=" + (exception.getErrorCode() == 1062 ? "duplicado" : (exception.getErrorCode() == 1452 ? "referencia" : "error"))); } catch (NumberFormatException exception) { response.sendRedirect("propiedad_nueva.jsp?error=campos"); } catch (Exception exception) { response.sendRedirect("propiedad_nueva.jsp?error=error"); }
%>

