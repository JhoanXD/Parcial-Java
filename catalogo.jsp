<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ include file="/WEB-INF/JSPF/inmo_db-conexion.jspf" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%
String tituloPagina = "Propiedades | Inmoraiz";
String busqueda = request.getParameter("q");
String tipo = request.getParameter("tipo");
String modalidad = request.getParameter("modalidad");
String ciudad = request.getParameter("ciudad");
String precioMinimo = request.getParameter("precio_minimo");
String precioMaximo = request.getParameter("precio_maximo");
String caracteristica = request.getParameter("caracteristica");
StringBuilder sql = new StringBuilder(
    "SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, p.descripcion, "
    + "p.modalidad, p.precio, p.area_m2, p.habitaciones, p.banos, "
    + "c.nombre AS ciudad, t.nombre AS tipo "
    + "FROM propiedad p INNER JOIN ciudad c ON c.id_ciudad = p.id_ciudad "
    + "INNER JOIN tipo_propiedad t ON t.id_tipo = p.id_tipo "
    + "WHERE p.estado = 'DISPONIBLE'");
List<String> parametros = new ArrayList<>();
if (busqueda != null && !busqueda.trim().isEmpty()) {
    sql.append(" AND (p.titulo LIKE ? OR p.descripcion LIKE ? OR c.nombre LIKE ?)");
    String filtro = "%" + busqueda.trim() + "%";
    parametros.add(filtro);
    parametros.add(filtro);
    parametros.add(filtro);
}
if (tipo != null && !tipo.trim().isEmpty()) {
    sql.append(" AND t.nombre = ?");
    parametros.add(tipo);
}
if (modalidad != null && !modalidad.trim().isEmpty()) {
    sql.append(" AND p.modalidad = ?");
    parametros.add(modalidad.toUpperCase());
}
if (ciudad != null && !ciudad.trim().isEmpty()) {
    sql.append(" AND c.nombre = ?");
    parametros.add(ciudad);
}
if (precioMinimo != null && !precioMinimo.trim().isEmpty()) {
  sql.append(" AND p.precio >= ?");
  parametros.add(precioMinimo);
}
if (precioMaximo != null && !precioMaximo.trim().isEmpty()) {
  sql.append(" AND p.precio <= ?");
  parametros.add(precioMaximo);
}
if (caracteristica != null && !caracteristica.trim().isEmpty()) {
  sql.append(" AND EXISTS (SELECT 1 FROM propiedad_caracteristica pc INNER JOIN caracteristica ca ON ca.id_caracteristica=pc.id_caracteristica WHERE pc.id_propiedad=p.id_propiedad AND ca.nombre=?)");
  parametros.add(caracteristica);
}
sql.append(" ORDER BY p.fecha_publicacion DESC");
NumberFormat moneda = NumberFormat.getCurrencyInstance(new Locale("es", "CO"));
%>
<!DOCTYPE html>
<html lang="es">
<head><%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %></head>
<body>
<% request.setAttribute("paginaActiva", "catalogo"); %>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>
<main class="container py-5">
  <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
    <div><p class="text-primary fw-semibold mb-1">INMORAIZ</p><h1 class="fw-bold mb-1">Encuentra tu proximo inmueble</h1><p class="text-muted mb-0">Resultados consultados desde la base de datos.</p></div>
  </div>
  <form class="card border-0 shadow-sm p-3 mb-5" method="get" action="catalogo.jsp">
    <div class="row g-3 align-items-end">
      <div class="col-lg-4"><label class="form-label" for="q">Buscar</label><input id="q" name="q" class="form-control" value="<%= busqueda == null ? "" : busqueda %>" placeholder="Ciudad o nombre"></div>
      <div class="col-md-3 col-lg-2"><label class="form-label" for="tipo">Tipo</label><select id="tipo" name="tipo" class="form-select"><option value="">Todos</option><% try { Class.forName("com.mysql.cj.jdbc.Driver"); try (Connection catalogoConexion = abrirConexion(); PreparedStatement tipos = catalogoConexion.prepareStatement("SELECT nombre FROM tipo_propiedad ORDER BY nombre"); ResultSet tiposResultado = tipos.executeQuery()) { while (tiposResultado.next()) { String nombreTipo = tiposResultado.getString("nombre"); %><option value="<%= nombreTipo %>" <%= nombreTipo.equals(tipo) ? "selected" : "" %>><%= nombreTipo %></option><% } } } catch (Exception ignored) { } %></select></div>
      <div class="col-md-3 col-lg-2"><label class="form-label" for="modalidad">Modalidad</label><select id="modalidad" name="modalidad" class="form-select"><option value="">Todas</option><option value="VENTA" <%= "VENTA".equalsIgnoreCase(modalidad) ? "selected" : "" %>>Venta</option><option value="ARRIENDO" <%= "ARRIENDO".equalsIgnoreCase(modalidad) ? "selected" : "" %>>Arriendo</option></select></div>
      <div class="col-md-3 col-lg-2"><label class="form-label" for="ciudad">Ciudad</label><select id="ciudad" name="ciudad" class="form-select"><option value="">Todas</option><% try { Class.forName("com.mysql.cj.jdbc.Driver"); try (Connection ciudadesConexion = abrirConexion(); PreparedStatement ciudades = ciudadesConexion.prepareStatement("SELECT nombre FROM ciudad ORDER BY nombre"); ResultSet ciudadesResultado = ciudades.executeQuery()) { while (ciudadesResultado.next()) { String nombreCiudad = ciudadesResultado.getString("nombre"); %><option value="<%= nombreCiudad %>" <%= nombreCiudad.equals(ciudad) ? "selected" : "" %>><%= nombreCiudad %></option><% } } } catch (Exception ignored) { } %></select></div>
      <div class="col-md-3 col-lg-2"><label class="form-label" for="precio_minimo">Precio mínimo</label><input id="precio_minimo" name="precio_minimo" type="number" min="0" step="0.01" class="form-control" value="<%= precioMinimo == null ? "" : precioMinimo %>"></div>
      <div class="col-md-3 col-lg-2"><label class="form-label" for="precio_maximo">Precio máximo</label><input id="precio_maximo" name="precio_maximo" type="number" min="0" step="0.01" class="form-control" value="<%= precioMaximo == null ? "" : precioMaximo %>"></div>
      <div class="col-md-3 col-lg-2"><label class="form-label" for="caracteristica">Característica</label><select id="caracteristica" name="caracteristica" class="form-select"><option value="">Todas</option><% try { Class.forName("com.mysql.cj.jdbc.Driver"); try (Connection caracteristicasConexion = abrirConexion(); PreparedStatement caracteristicas = caracteristicasConexion.prepareStatement("SELECT nombre FROM caracteristica ORDER BY nombre"); ResultSet caracteristicasResultado = caracteristicas.executeQuery()) { while (caracteristicasResultado.next()) { String nombreCaracteristica = caracteristicasResultado.getString("nombre"); %><option value="<%= nombreCaracteristica %>" <%= nombreCaracteristica.equals(caracteristica) ? "selected" : "" %>><%= nombreCaracteristica %></option><% } } } catch (Exception ignored) { } %></select></div>
      <div class="col-md-3 col-lg-2"><button class="btn btn-primary w-100" type="submit"><i class="bi bi-search me-1"></i>Filtrar</button></div>
    </div>
  </form>
  <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
  <% int resultados = 0; try { Class.forName("com.mysql.cj.jdbc.Driver"); try (Connection conexion = abrirConexion(); PreparedStatement sentencia = conexion.prepareStatement(sql.toString())) { for (int indice = 0; indice < parametros.size(); indice++) sentencia.setString(indice + 1, parametros.get(indice)); try (ResultSet propiedades = sentencia.executeQuery()) { while (propiedades.next()) { resultados++; String modalidadTexto = propiedades.getString("modalidad"); %>
    <div class="col"><article class="card h-100 shadow-sm"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between"><span class="badge <%= "VENTA".equals(modalidadTexto) ? "text-bg-secondary" : "text-bg-dark" %>"><%= modalidadTexto %></span><i class="bi bi-building text-primary fs-2"></i></div><p class="text-muted small mt-3 mb-1"><%= propiedades.getString("ciudad") %> | <%= propiedades.getString("tipo") %></p><h2 class="h5"><%= propiedades.getString("titulo") %></h2><p class="text-muted small"><%= propiedades.getInt("habitaciones") %> habitaciones | <%= propiedades.getInt("banos") %> banos | <%= propiedades.getBigDecimal("area_m2") %> m2</p><p class="fs-5 fw-bold text-primary mt-auto mb-3"><%= moneda.format(propiedades.getBigDecimal("precio")) %></p><a class="btn btn-outline-dark" href="propiedades/propiedad.jsp?matricula=<%= propiedades.getString("matricula_inmobiliaria") %>">Ver detalle <i class="bi bi-arrow-right ms-1"></i></a></div></article></div>
  <% } } } } catch (Exception exception) { %><div class="col-12"><div class="alert alert-danger">No fue posible consultar las propiedades.</div></div><% } if (resultados == 0) { %><div class="col-12"><div class="alert alert-light border text-center py-5"><i class="bi bi-search fs-1 d-block mb-3"></i><h2 class="h5">No encontramos propiedades</h2><p class="mb-0">Prueba con otros filtros.</p></div></div><% } %>
  </div>
</main>
<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>


