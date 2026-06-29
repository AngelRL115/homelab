# 🐳 Servicio: Portainer (Gestión de Contenedores)

## 1. 📖 ¿Qué es y Para qué sirve?

**Portainer CE** (Community Edition) es una interfaz de gestión gráfica ligera para administrar entornos Docker de forma visual.

### Rol en el Homelab y tus Aplicaciones
Permite monitorear el estado de salud, consultar logs en tiempo real, revisar el consumo de CPU/RAM de la laptop viejita e inspeccionar contenedores y volúmenes sin depender exclusivamente de la línea de comandos.

---

## 2. ⚙️ ¿Cómo funciona internamente?

- **Socket de Docker**: Se conecta directamente a `/var/run/docker.sock` para comunicarse con el demonio de Docker Engine.
- **Puertos**: Expone el puerto `9000` (HTTP) y `9443` (HTTPS).
- **Persistencia**: Guarda la configuración de usuarios y stacks en el volumen `portainer_data` (`/data`).

---

## 3. 🛠️ Estructura y Archivos del Servicio

Ubicación en el proyecto: `infrastructure/management/portainer/`

### `compose.yaml`
```yaml
name: portainer

services:
  portainer:
    image: ${PORTAINER_IMAGE}
    container_name: portainer
    restart: unless-stopped

    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"

    ports:
      - "${PORTAINER_HTTP_PORT}:9000"
      - "${PORTAINER_HTTPS_PORT}:9443"

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

    networks:
      - homelab-network

volumes:
  portainer_data:

networks:
  homelab-network:
    external: true
```

---

## 4. ▶️ Operación Día a Día (Iniciar, Detener, Reiniciar)

Ubicación: `infrastructure/management/portainer/`

- **Iniciar servicio**: `docker compose up -d`
- **Verificar estado**: `docker ps`
- **Acceso Web**: `http://localhost:9000` o `http://portainer.homelab.local`
- **Detener servicio**: `docker compose stop`

---

## 5. 🔄 ¿Cómo Actualizar la Versión?

1. Modifica `PORTAINER_IMAGE` en `.env`.
2. Descarga imagen: `docker compose pull`.
3. Recrea el contenedor: `docker compose up -d`.

---

## 6. 🗑️ ¿Cómo Eliminar o Limpiar Completamente?

1. Detener servicio: `docker compose down`.
2. Eliminar volumen de datos de Portainer: `docker volume rm portainer_portainer_data`.

---

## 7. ♻️ ¿Cómo Replicar o Reconfigurar en Otro Servidor desde Cero?

1. Navegar a `infrastructure/management/portainer/`.
2. Ejecutar `docker compose up -d` y crear el usuario administrador inicial en el primer ingreso.
