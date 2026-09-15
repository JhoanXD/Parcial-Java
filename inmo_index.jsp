<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<% String tituloPagina = "Inmoraiz - Inmobiliaria"; %>
<!DOCTYPE html>
<html lang="es">
<head>
<%@ include file="/WEB-INF/JSPF/inmo_head.jspf" %>
</head>
<body>
<% request.setAttribute("paginaActiva", "inicio"); %>
<%@ include file="/WEB-INF/JSPF/inmo_navbar.jspf" %>

<!-- ======================= HERO ======================= -->
<section class="py-5 border-bottom text-center" id="inicio">
  <div class="container py-4">
    <div class="row justify-content-center">
      <div class="col-lg-9">
        <p class="text-primary fw-semibold mb-2">Mas de 6 sucursales en Santander y el pais</p>
        <h1 class="display-4 fw-bold mb-3">Encuentra el lugar donde vas a echar raices</h1>
        <p class="lead mb-4 mx-auto" style="max-width:56ch;">Casas, apartamentos, locales y oficinas en venta y arriendo, con visitas agendadas en linea y tramites sin filas.</p>

        <form class="mx-auto mb-4" style="max-width:750px;" action="catalogo.jsp" method="get">
          <div class="input-group input-group-lg shadow-sm">
            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
            <input type="text" name="q" class="form-control" placeholder="Buscar por ciudad o barrio...">
            <select name="tipo" class="form-select" style="max-width:180px;">
              <option value="">Tipo</option>
              <option value="Casa">Casa</option>
              <option value="Apartamento">Apartamento</option>
              <option value="Local">Local</option>
              <option value="Oficina">Oficina</option>
              <option value="Terreno">Terreno</option>
            </select>
            <select name="modalidad" class="form-select" style="max-width:160px;">
              <option value="">Venta o arriendo</option>
              <option value="venta">Venta</option>
              <option value="arriendo">Arriendo</option>
            </select>
            <button type="submit" class="btn btn-primary">Buscar</button>
          </div>
        </form>

        <div class="d-flex flex-wrap gap-3 justify-content-center">
          <a href="catalogo.jsp" class="btn btn-primary btn-lg">Ver todas las propiedades</a>
          <a href="registro.jsp" class="btn btn-link btn-lg text-decoration-none">Crear una cuenta</a>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ======================= DESTACADAS ======================= -->
<section class="py-5" id="destacadas">
  <div class="container">
    <h2 class="fw-bold mb-1">Propiedades destacadas</h2>
    <p class="text-muted mb-4">Una seleccion de inmuebles recien publicados por nuestras sucursales.</p>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-4">

      <div class="col">
        <div class="card h-100 shadow-sm">
          <div class="card-body">
            <span class="badge text-bg-secondary mb-2">Venta</span>
            <i class="bi bi-house-door-fill text-primary mb-2 d-block" style="font-size:2.2rem;"></i>
            <h5 class="card-title mb-1">Casa campestre en Floridablanca</h5>
            <p class="card-subtitle text-muted small mb-3">Bucaramanga &middot; 3 habitaciones</p>
            <p class="fs-5 fw-bold text-primary mb-3">$480.000.000</p>
            <div class="d-flex justify-content-between align-items-center">
              <a href="propiedades/propiedad.jsp?matricula=MI-0001" class="btn btn-sm btn-outline-dark">Ver detalle</a>
              <button class="btn btn-sm btn-outline-primary rounded-circle" title="Marcar como favorito">
                <i class="bi bi-heart"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="col">
        <div class="card h-100 shadow-sm">
          <div class="card-body">
            <span class="badge text-bg-secondary mb-2">Venta</span>
            <i class="bi bi-building text-primary mb-2 d-block" style="font-size:2.2rem;"></i>
            <h5 class="card-title mb-1">Apartamento en Cabecera</h5>
            <p class="card-subtitle text-muted small mb-3">Bucaramanga &middot; 2 habitaciones</p>
            <p class="fs-5 fw-bold text-primary mb-3">$320.000.000</p>
            <div class="d-flex justify-content-between align-items-center">
              <a href="propiedades/propiedad.jsp?matricula=MI-0002" class="btn btn-sm btn-outline-dark">Ver detalle</a>
              <button class="btn btn-sm btn-outline-primary rounded-circle" title="Marcar como favorito">
                <i class="bi bi-heart"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="col">
        <div class="card h-100 shadow-sm">
          <div class="card-body">
            <span class="badge text-bg-dark mb-2">Arriendo</span>
            <i class="bi bi-shop text-primary mb-2 d-block" style="font-size:2.2rem;"></i>
            <h5 class="card-title mb-1">Local comercial Centro</h5>
            <p class="card-subtitle text-muted small mb-3">Bucaramanga &middot; 40 m2</p>
            <p class="fs-5 fw-bold text-primary mb-3">$2.500.000 / mes</p>
            <div class="d-flex justify-content-between align-items-center">
              <a href="propiedades/propiedad.jsp?matricula=MI-0003" class="btn btn-sm btn-outline-dark">Ver detalle</a>
              <button class="btn btn-sm btn-outline-primary rounded-circle" title="Marcar como favorito">
                <i class="bi bi-heart"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="col">
        <div class="card h-100 shadow-sm">
          <div class="card-body">
            <span class="badge text-bg-secondary mb-2">Venta</span>
            <i class="bi bi-building-fill text-primary mb-2 d-block" style="font-size:2.2rem;"></i>
            <h5 class="card-title mb-1">Apartamento San Gil centro</h5>
            <p class="card-subtitle text-muted small mb-3">San Gil &middot; 3 habitaciones</p>
            <p class="fs-5 fw-bold text-primary mb-3">$260.000.000</p>
            <div class="d-flex justify-content-between align-items-center">
              <a href="propiedades/propiedad.jsp?matricula=MI-0005" class="btn btn-sm btn-outline-dark">Ver detalle</a>
              <button class="btn btn-sm btn-outline-primary rounded-circle" title="Marcar como favorito">
                <i class="bi bi-heart"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</section>

<!-- ======================= COMO FUNCIONA ======================= -->
<section class="py-5 bg-white border-top border-bottom" id="como-funciona">
  <div class="container">
    <h2 class="fw-bold mb-1">Encuentra y visita tu proximo inmueble en tres pasos</h2>
    <p class="text-muted mb-4">Pensado para que agendar una visita o radicar una solicitud tome minutos, no dias.</p>

    <div class="row g-4 text-center">
      <div class="col-md-4">
        <i class="bi bi-search text-primary mb-3" style="font-size:2.5rem;"></i>
        <h5>Explora el catalogo</h5>
        <p class="text-muted small">Filtra por ciudad, tipo de inmueble, precio y caracteristicas.</p>
      </div>
      <div class="col-md-4">
        <i class="bi bi-calendar-check text-primary mb-3" style="font-size:2.5rem;"></i>
        <h5>Agenda una visita</h5>
        <p class="text-muted small">Reserva el horario que prefieras para conocer la propiedad en persona.</p>
      </div>
      <div class="col-md-4">
        <i class="bi bi-file-earmark-check-fill text-primary mb-3" style="font-size:2.5rem;"></i>
        <h5>Radica tu solicitud</h5>
        <p class="text-muted small">Sube tus documentos y haz seguimiento al estado de tu tramite de compra o arriendo.</p>
      </div>
    </div>
  </div>
</section>

<!-- ======================= CIUDADES ======================= -->
<section class="py-5 bg-dark text-white" id="ciudades">
  <div class="container">
    <h2 class="fw-bold mb-1">Nos encuentras en</h2>
    <p class="text-white-50 mb-4">Seis sucursales activas y creciendo cada trimestre.</p>
    <div class="d-flex flex-wrap gap-2">
      <span class="badge text-bg-light fs-6 fw-normal px-3 py-2"><i class="bi bi-geo-alt-fill text-primary me-1"></i>Bucaramanga</span>
      <span class="badge text-bg-light fs-6 fw-normal px-3 py-2"><i class="bi bi-geo-alt-fill text-primary me-1"></i>San Gil</span>
      <span class="badge text-bg-light fs-6 fw-normal px-3 py-2"><i class="bi bi-geo-alt-fill text-primary me-1"></i>Bogota</span>
      <span class="badge text-bg-light fs-6 fw-normal px-3 py-2"><i class="bi bi-geo-alt-fill text-primary me-1"></i>Medellin</span>
      <span class="badge text-bg-light fs-6 fw-normal px-3 py-2"><i class="bi bi-geo-alt-fill text-primary me-1"></i>Cali</span>
    </div>
  </div>
</section>

<%@ include file="/WEB-INF/JSPF/inmo_footer.jspf" %>
</body>
</html>
