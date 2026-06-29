# 📦 Servicio: MinIO (Almacenamiento de Objetos S3)

## 1. 📖 ¿Qué es y Para qué sirve?

**MinIO** es un servidor de almacenamiento de objetos (Object Storage) de código abierto y de alto rendimiento, 100% compatible con la API de Amazon S3.

### Rol en el Homelab y tus Aplicaciones
Proporciona almacenamiento en la nube privado dentro de tu laptop. Tus aplicaciones utilizarán librerías estándar como el SDK de AWS para subir, almacenar y servir archivos multimedia (imágenes, PDFs, avatares, facturas) sin guardarlos en el disco local del servidor.

---

## 2. ⚙️ ¿Cómo funciona internamente?

- **Puertos**: Expone el puerto `9000` para la API S3 (usado por aplicaciones) y el puerto `9001` para la consola de administración web.
- **Redes**: Conectado a `homelab-network`. Las aplicaciones se conectan internamente mediante `http://minio:9000`.
- **Persistencia**: Todos los buckets y archivos guardados residen en el volumen `minio_data` (`/data`).

---

## 3. 🛠️ Estructura y Archivos del Servicio

Ubicación en el proyecto: `infrastructure/storage/minio/`

### `compose.yaml`
```yaml
name: minio

services:
  minio:
    image: ${MINIO_IMAGE}
    container_name: minio
    restart: unless-stopped

    command: server /data --console-address ":9001"

    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"

    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD}
      TZ: ${TZ}

    ports:
      - "${MINIO_API_PORT}:9000"
      - "${MINIO_CONSOLE_PORT}:9001"

    volumes:
      - minio_data:/data

    networks:
      - homelab-network

    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:9000/minio/health/live || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

volumes:
  minio_data:

networks:
  homelab-network:
    external: true
```

---

## 4. ▶️ Operación Día a Día (Iniciar, Detener, Reiniciar)

Ubicación: `infrastructure/storage/minio/`

- **Iniciar servicio**: `docker compose up -d`
- **Verificar estado**: `docker ps`
- **Ver logs**: `docker compose logs -f`
- **Acceso a Consola Web**: `http://localhost:9001` o `http://minio.homelab.local`
- **Detener servicio**: `docker compose stop`

---

## 5. 🔄 ¿Cómo Actualizar la Versión?

1. Actualiza `MINIO_IMAGE` en `.env` (ej. `minio/minio:latest`).
2. Descarga imagen: `docker compose pull`.
3. Recrea el contenedor: `docker compose up -d`.

---

## 6. 🗑️ ¿Cómo Eliminar o Limpiar Completamente?

1. Detener servicio: `docker compose down`.
2. Eliminar todos los buckets y archivos persistidos: `docker volume rm minio_minio_data`.

---

## 7. ♻️ ¿Cómo Replicar o Reconfigurar en Otro Servidor desde Cero?

1. Navegar a `infrastructure/storage/minio/`.
2. Verificar variables en `.env`.
3. Ejecutar `docker compose up -d` y acceder al puerto 9001 para configurar buckets iniciales.
