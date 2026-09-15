<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="javax.servlet.http.Part" %>
<%
if (session.getAttribute("usuarioId") == null || !"INMOBILIARIA".equals(session.getAttribute("usuarioRol"))) { response.sendRedirect("../login.jsp?error=acceso"); return; }
String tituloPagina = "Subir imagen | Inmoraiz";
String id = request.getParameter("id_propiedad");
String mensaje = request.getParameter("mensaje");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        Part archivo = request.getPart("archivo");
        if (archivo == null || archivo.getSize() == 0) throw new IllegalArgumentException("Archivo vacio");
        String nombreOriginal = Paths.get(archivo.getSubmittedFileName()).getFileName().toString();
        String extension = nombreOriginal.contains(".") ? nombreOriginal.substring(nombreOriginal.lastIndexOf('.')).toLowerCase() : "";
        if (!(".jpg".equals(extension) || ".jpeg".equals(extension) || ".png".equals(extension) || ".webp".equals(extension))) throw new IllegalArgumentException("Formato no permitido");
        String nombreSeguro = "propiedad-" + id + "-" + System.currentTimeMillis() + extension;
        Path carpeta = Paths.get(application.getRealPath("/uploads"));
        Files.createDirectories(carpeta);
        archivo.write(carpeta.resolve(nombreSeguro).toString());
        String url = request.getContextPath() + "/uploads/" + nombreSeguro;
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement("INSERT INTO imagen_propiedad (id_propiedad,url,texto_alternativo,orden_imagen) SELECT p.id_propiedad,?,?,COALESCE((SELECT MAX(orden_imagen)+1 FROM imagen_propiedad i WHERE i.id_propiedad=p.id_propiedad),1) FROM propiedad p INNER JOIN inmobiliaria i ON i.id_inmobiliaria=p.id_inmobiliaria WHERE p.id_propiedad=? AND i.id_usuario=?")) {
            sentencia.setString(1, url);
            sentencia.setString(2, nombreOriginal);
            sentencia.setInt(3, Integer.parseInt(id));
            sentencia.setInt(4, (Integer) session.getAttribute("usuarioId"));
            sentencia.executeUpdate();
        }
        response.sendRedirect("imagenes_propiedad.jsp?id=" + id + "&mensaje=ok");
        return;
    } catch (Exception exception) {
        mensaje = "error";
    }
}
%>
<!DOCTYPE html>
<html lang="es"><head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head><body><%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="row justify-content-center"><div class="col-lg-7"><div class="card border-0 shadow-sm"><div class="card-body p-4 p-lg-5"><a href="imagenes_propiedad.jsp?id=<%= id %>" class="link-dark">Volver a la galería</a><h1 class="h3 fw-bold mt-4">Subir imagen</h1><p class="text-muted">Formatos permitidos: JPG, JPEG, PNG y WEBP. Tamaño máximo: 5 MB.</p><% if ("error".equals(mensaje)) { %><div class="alert alert-danger">No fue posible subir la imagen o el formato no está permitido.</div><% } %><form method="post" enctype="multipart/form-data"><input type="file" name="archivo" class="form-control mb-4" accept="image/jpeg,image/png,image/webp" required><button class="btn btn-primary" type="submit"><i class="bi bi-upload me-1"></i>Subir imagen</button></form></div></div></div></div></main><%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %></body></html>


