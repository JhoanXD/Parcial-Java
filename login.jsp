<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
String tituloPagina = "Iniciar sesion | Inmoraiz";
String destino = request.getParameter("destino");
String error = request.getParameter("error");
if ("POST".equalsIgnoreCase(request.getMethod())) {
	String correoIngresado = request.getParameter("correo");
	String claveIngresada = request.getParameter("clave");
	String sql = "SELECT u.id_usuario, u.correo, u.clave_hash, "
		+ "(SELECT r.nombre FROM usuario_rol ur "
		+ "INNER JOIN rol r ON r.id_rol = ur.id_rol "
		+ "WHERE ur.id_usuario = u.id_usuario "
		+ "ORDER BY CASE r.nombre "
		+ "WHEN 'ADMINISTRADOR' THEN 1 "
		+ "WHEN 'INMOBILIARIA' THEN 2 "
		+ "WHEN 'CLIENTE' THEN 3 "
		+ "WHEN 'VISITANTE' THEN 4 ELSE 5 END, r.id_rol "
		+ "LIMIT 1) AS rol "
		+ "FROM usuario u "
		+ "WHERE u.correo = ? AND u.estado = 'ACTIVO'";
	boolean autenticado = false;
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		try (Connection conexion = abrirConexion();
			 PreparedStatement sentencia = conexion.prepareStatement(sql)) {
			sentencia.setString(1, correoIngresado == null ? "" : correoIngresado.trim());
			try (ResultSet resultado = sentencia.executeQuery()) {
				if (resultado.next() && claveIngresada != null && BCrypt.checkpw(claveIngresada, resultado.getString("clave_hash"))) {
					session.setAttribute("usuarioId", resultado.getInt("id_usuario"));
					session.setAttribute("usuarioCorreo", resultado.getString("correo"));
					session.setAttribute("usuarioRol", resultado.getString("rol"));
					autenticado = true;
				}
			}
		}
	} catch (Exception exception) {
		error = "servidor";
	}
	if (autenticado) {
		response.sendRedirect("dashboard.jsp");
		return;
	}
	if (error == null) error = "credenciales";
}
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body class="bg-light">
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="row justify-content-center"><div class="col-md-7 col-lg-5"><div class="card border-0 shadow-sm"><div class="card-body p-4 p-lg-5"><div class="text-center mb-4"><i class="bi bi-person-circle text-primary fs-1"></i><h1 class="h3 fw-bold mt-3">Bienvenido de nuevo</h1><p class="text-muted">Ingresa para gestionar tus visitas y solicitudes.</p></div><% if (destino != null) { %><div class="alert alert-info small">Inicia sesión para agendar tu visita.</div><% } %><% if ("credenciales".equals(error)) { %><div class="alert alert-danger small">El correo o la contraseña no son correctos.</div><% } else if ("campos".equals(error)) { %><div class="alert alert-warning small">Completa todos los campos.</div><% } else if ("acceso".equals(error)) { %><div class="alert alert-info small">Inicia sesión para acceder a esa sección.</div><% } else if ("servidor".equals(error)) { %><div class="alert alert-danger small">No fue posible conectar con la base de datos.</div><% } else if ("ok".equals(request.getParameter("registro"))) { %><div class="alert alert-success small">Cuenta creada. Ya puedes iniciar sesión.</div><% } %><form method="post" action="login.jsp"><div class="mb-3"><label for="correo" class="form-label">Correo electrónico</label><input id="correo" name="correo" type="email" class="form-control" required autocomplete="email"></div><div class="mb-3"><label for="clave" class="form-label">Contraseña</label><input id="clave" name="clave" type="password" class="form-control" required autocomplete="current-password"></div><div class="d-flex justify-content-between align-items-center mb-4"><div class="form-check"><input id="recordar" class="form-check-input" type="checkbox"><label for="recordar" class="form-check-label small">Recordarme</label></div><a href="#" class="small">¿Olvidaste tu contraseña?</a></div><button class="btn btn-primary w-100" type="submit">Iniciar sesión</button></form><p class="text-center text-muted small mt-4 mb-0">¿Aún no tienes cuenta? <a href="registro.jsp">Crear cuenta</a></p></div></div></div></div></main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


