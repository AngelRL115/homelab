# 🌐 Servicio: Nginx Proxy Manager (Reverse Proxy)

## 1. 📖 ¿Qué es y Para qué sirve?

**Nginx Proxy Manager** (NPM) es un sistema de gestión de reverse proxy con interfaz web integrada que facilita el enrutamiento de peticiones HTTP/HTTPS hacia contenedores internos y la gestión automática de certificados SSL de Let's Encrypt.

### Rol en el Homelab y tus Aplicaciones
Actúa como la puerta de entrada única a nuestro servidor personal. Elimina la necesidad de recordar números de puertos (ej. 9000, 8081, 3001) permitiendo acceder a los servicios mediante nombres de dominios locales limpios (ej. `adminer.homelab.local`, `portainer.homelab.local`).

---

## 2. ⚙️ ¿Cómo funciona internamente?

- **Puertos de Entrada**: Escucha en el puerto `80` (HTTP), `443` (HTTPS) y `81` (Panel de administración Web).
- **Enrutamiento Interno**: Recibe las peticiones en el puerto 80/443, lee el encabezado `Host` enviado por el navegador y redirige la petición al contenedor correspondiente en `homelab-network` usando su puerto interno.
- **Persistencia**: Guarda la base de datos de configuración y certificados SSL en `npm_data` (`/data`) y `npm_letsencrypt` (`/etc/letsencrypt`).

---

## 3. 🛠️ Estructura y Archivos del Servicio

Ubicación en el proyecto: `infrastructure/networking/nginx-proxy-manager/`

### `compose.yaml`
```yaml
name: nginx-proxy-manager

services:
  app:
    image: ${NPM_IMAGE}
    container_name: nginx-proxy-manager
    restart: unless-stopped

    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"

    ports:
      - "${NPM_HTTP_PORT}:80"
      - "${NPM_ADMIN_PORT}:81"
      - "${NPM_HTTPS_PORT}:443"

    environment:
      TZ: ${TZ}

    volumes:
      - npm_data:/data
      - npm_letsencrypt:/etc/letsencrypt

    networks:
      - homelab-network

    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:81/ || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 15s

volumes:
  npm_data:
  npm_letsencrypt:

networks:
  homelab-network:
    external: true
```

---

## 4. ▶️ Operación Día a Día (Iniciar, Detener, Reiniciar)

Ubicación: `infrastructure/networking/nginx-proxy-manager/`

- **Iniciar servicio**: `docker compose up -d`
- **Verificar estado**: `docker ps`
- **Acceso al Panel Admin**: `http://localhost:81`
- **Ver logs**: `docker compose logs -f`
- **Detener servicio**: `docker compose stop`

---

## 5. 🔄 ¿Cómo Actualizar la Versión?

1. Modifica `NPM_IMAGE` en `.env`.
2. Descarga imagen: `docker compose pull`.
3. Recrea contenedor: `docker compose up -d`.

---

## 6. 🗑️ ¿Cómo Eliminar o Limpiar Completamente?

1. Detener servicio: `docker compose down`.
2. Eliminar certificados y configuración proxy: `docker volume rm nginx-proxy-manager_npm_data nginx-proxy-manager_npm_letsencrypt`.

---

## 7. ♻️ ¿Cómo Replicar o Reconfigurar en Otro Servidor desde Cero?

1. Navegar a `infrastructure/networking/nginx-proxy-manager/`.
2. Ejecutar `docker compose up -d`.
3. Iniciar sesión con credenciales por defecto (`admin@example.com` / `changeme`) y configurar usuarios e ips de destino.
