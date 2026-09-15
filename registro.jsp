<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
String tituloPagina = "Crear cuenta | Inmoraiz";
String error = request.getParameter("error");
if ("POST".equalsIgnoreCase(request.getMethod())) {
	String nombres = request.getParameter("nombres");
	String apellidos = request.getParameter("apellidos");
	String documento = request.getParameter("documento");
	String telefono = request.getParameter("telefono");
	String correo = request.getParameter("correo");
	String clave = request.getParameter("clave");
	String confirmar = request.getParameter("confirmar");
	if (nombres == null || apellidos == null || documento == null || telefono == null || correo == null
			|| clave == null || confirmar == null || nombres.isBlank() || apellidos.isBlank()
			|| documento.isBlank() || telefono.isBlank() || correo.isBlank()) {
		error = "campos";
	} else if (!clave.equals(confirmar) || clave.length() < 8) {
		error = "clave";
	} else {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			try (Connection conexion = abrirConexion()) {
				conexion.setAutoCommit(false);
				try {
					int idUsuario;
					try (PreparedStatement sentencia = conexion.prepareStatement(
							"INSERT INTO usuario (correo, clave_hash) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
						sentencia.setString(1, correo.trim());
						sentencia.setString(2, BCrypt.hashpw(clave, BCrypt.gensalt(12)));
						sentencia.executeUpdate();
						try (ResultSet claves = sentencia.getGeneratedKeys()) {
							claves.next();
							idUsuario = claves.getInt(1);
						}
					}
					try (PreparedStatement sentencia = conexion.prepareStatement(
							"INSERT INTO perfil (id_usuario, nombres, apellidos, documento, telefono) VALUES (?, ?, ?, ?, ?)")) {
						sentencia.setInt(1, idUsuario);
						sentencia.setString(2, nombres.trim());
						sentencia.setString(3, apellidos.trim());
						sentencia.setString(4, documento.trim());
						sentencia.setString(5, telefono.trim());
						sentencia.executeUpdate();
					}
					try (PreparedStatement sentencia = conexion.prepareStatement(
							"INSERT INTO usuario_rol (id_usuario, id_rol) SELECT ?, id_rol FROM rol WHERE nombre = 'CLIENTE'")) {
						sentencia.setInt(1, idUsuario);
						sentencia.executeUpdate();
					}
					conexion.commit();
					response.sendRedirect("login.jsp?registro=ok");
					return;
				} catch (SQLException exception) {
					conexion.rollback();
					if ("23000".equals(exception.getSQLState())) error = "duplicado";
					else error = "servidor";
				}
			}
		} catch (Exception exception) {
			error = "servidor";
		}
	}
}
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body class="bg-light">
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5"><div class="row justify-content-center"><div class="col-lg-8"><div class="card border-0 shadow-sm"><div class="card-body p-4 p-lg-5"><div class="mb-4"><p class="text-primary fw-semibold mb-1">INMORAIZ</p><h1 class="h3 fw-bold">Crea tu cuenta</h1><p class="text-muted mb-0">Guarda favoritos, agenda visitas y consulta tus solicitudes.</p></div><% if ("duplicado".equals(error)) { %><div class="alert alert-warning small">El correo o documento ya se encuentra registrado.</div><% } else if ("clave".equals(error)) { %><div class="alert alert-warning small">Las contraseñas deben coincidir y tener mínimo 8 caracteres.</div><% } else if ("campos".equals(error)) { %><div class="alert alert-danger small">Completa todos los campos obligatorios.</div><% } else if ("servidor".equals(error)) { %><div class="alert alert-danger small">No fue posible guardar la cuenta.</div><% } %><form method="post" action="registro.jsp"><div class="row g-3"><div class="col-md-6"><label for="nombres" class="form-label">Nombres</label><input id="nombres" name="nombres" class="form-control" required autocomplete="given-name"></div><div class="col-md-6"><label for="apellidos" class="form-label">Apellidos</label><input id="apellidos" name="apellidos" class="form-control" required autocomplete="family-name"></div><div class="col-md-6"><label for="documento" class="form-label">Documento</label><input id="documento" name="documento" class="form-control" required></div><div class="col-md-6"><label for="telefono" class="form-label">Teléfono</label><input id="telefono" name="telefono" type="tel" class="form-control" required autocomplete="tel"></div><div class="col-12"><label for="correo" class="form-label">Correo electrónico</label><input id="correo" name="correo" type="email" class="form-control" required autocomplete="email"></div><div class="col-md-6"><label for="clave" class="form-label">Contraseña</label><input id="clave" name="clave" type="password" class="form-control" minlength="8" required autocomplete="new-password"></div><div class="col-md-6"><label for="confirmar" class="form-label">Confirmar contraseña</label><input id="confirmar" name="confirmar" type="password" class="form-control" minlength="8" required autocomplete="new-password"></div><div class="col-12"><div class="form-check"><input id="terminos" class="form-check-input" type="checkbox" required><label for="terminos" class="form-check-label small">Acepto los términos y condiciones de uso.</label></div></div><div class="col-12"><button type="submit" class="btn btn-primary">Crear mi cuenta</button><a href="login.jsp" class="btn btn-link">Ya tengo una cuenta</a></div></div></form></div></div></div></div></main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


