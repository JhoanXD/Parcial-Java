package com.inmoraiz.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AccessFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }

        if (isPublicUri(uri) || isStaticAsset(uri)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(contextPath + "/login.jsp?error=acceso");
            return;
        }

        String rol = String.valueOf(session.getAttribute("usuarioRol"));
        if (rol != null) {
            rol = rol.trim();
        }

        if (!hasPermission(uri, rol)) {
            response.sendRedirect(contextPath + "/access_denied.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

    private boolean isPublicUri(String uri) {
        return uri == null
                || uri.isEmpty()
                || "/".equals(uri)
                || uri.equals("/index.jsp")
                || uri.equals("/inmo_index.jsp")
                || uri.equals("/login.jsp")
                || uri.equals("/registro.jsp")
                || uri.equals("/logout.jsp")
                || uri.equals("/access_denied.jsp")
                || uri.equals("/catalogo.jsp")
                || uri.equals("/propiedades/propiedad.jsp")
                || uri.equals("/cliente/cita.jsp")
                || uri.equals("/cliente/solicitud.jsp")
                || uri.startsWith("/WEB-INF/");
    }

    private boolean isStaticAsset(String uri) {
        return uri.endsWith(".css")
                || uri.endsWith(".js")
                || uri.endsWith(".png")
                || uri.endsWith(".jpg")
                || uri.endsWith(".jpeg")
                || uri.endsWith(".gif")
                || uri.endsWith(".svg")
                || uri.endsWith(".ico")
                || uri.startsWith("/uploads/")
                || uri.startsWith("/Css/");
    }

    private boolean hasPermission(String uri, String rol) {
        if ("ADMINISTRADOR".equals(rol)) {
            return true;
        }

        if (uri.startsWith("/admin/")) {
            return "ADMINISTRADOR".equals(rol);
        }

        if (uri.startsWith("/cliente/")) {
            return "CLIENTE".equals(rol);
        }

        if (uri.startsWith("/imagenes/")) {
            return "INMOBILIARIA".equals(rol) || "ADMINISTRADOR".equals(rol);
        }

        if (uri.startsWith("/propiedades/")) {
            return "INMOBILIARIA".equals(rol) || "ADMINISTRADOR".equals(rol);
        }

        if (uri.equals("/dashboard.jsp")
                || uri.equals("/citas_inmobiliaria.jsp")
                || uri.equals("/solicitudes_inmobiliaria.jsp")) {
            return true;
        }

        return true;
    }
}
