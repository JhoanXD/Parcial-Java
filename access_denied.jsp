<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5 text-center">
  <i class="bi bi-shield-lock text-danger" style="font-size: 4rem"></i>
  <h1 class="h3 fw-bold mt-3">Acceso denegado</h1>
  <p class="text-muted">No tienes permisos para consultar esta sección.</p>
  <a class="btn btn-primary" href="dashboard.jsp">Volver al panel</a>
</main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>

