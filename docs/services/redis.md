# ⚡ Servicio: Redis (Caché y Almacén en Memoria)

## 1. 📖 ¿Qué es y Para qué sirve?

**Redis** (Remote Dictionary Server) es un almacén de estructura de datos en memoria de código abierto, ultrarrápido, utilizado como base de datos, caché y bróker de mensajería.

### Rol en el Homelab y tus Aplicaciones
Tus APIs en Node.js, Spring Boot o Python lo utilizarán para guardar en caché datos de consulta frecuente, gestionar sesiones de usuario activas y administrar colas de tareas en segundo plano (ej. envío de correos o procesamiento asíncrono).

---

## 2. ⚙️ ¿Cómo funciona internamente?

- **Redes y DNS**: Integrado en `homelab-network`. Los servicios se conectan vía `redis:6379`.
- **Persistencia AOF**: Configurado con `--appendonly yes`. Aunque guarda todo en la memoria RAM, escribe un registro de operaciones en el volumen `redis_data` (`/data`) para recuperar el estado tras un reinicio.
- **Autenticación**: Protegido con contraseña mediante el comando `--requirepass`.

---

## 3. 🛠️ Estructura y Archivos del Servicio

Ubicación en el proyecto: `infrastructure/databases/redis/`

### `compose.yaml`
```yaml
name: redis

services:
  redis:
    image: ${REDIS_IMAGE}
    container_name: redis
    restart: unless-stopped

    command: redis-server --requirepass ${REDIS_PASSWORD} --appendonly yes

    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"

    ports:
      - "${REDIS_PORT}:6379"

    volumes:
      - redis_data:/data

    networks:
      - homelab-network

    healthcheck:
      test: ["CMD-SHELL", "redis-cli -a ${REDIS_PASSWORD} ping | grep PONG || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 5s

volumes:
  redis_data:

networks:
  homelab-network:
    external: true
```

---

## 4. ▶️ Operación Día a Día (Iniciar, Detener, Reiniciar)

Ubicación: `infrastructure/databases/redis/`

- **Iniciar servicio**: `docker compose up -d`
- **Verificar estado y salud**: `docker ps`
- **Ver logs**: `docker compose logs -f`
- **Prueba de conexión CLI**:
  ```bash
  docker exec -it redis redis-cli -a homelab_redis_pass_2026 ping
  ```
- **Detener servicio**: `docker compose stop`

---

## 5. 🔄 ¿Cómo Actualizar la Versión?

1. Modifica `REDIS_IMAGE` en el archivo `.env`.
2. Descarga la nueva imagen: `docker compose pull`.
3. Recrea el contenedor: `docker compose up -d`.

---

## 6. 🗑️ ¿Cómo Eliminar o Limpiar Completamente?

1. Detener servicio: `docker compose down`.
2. Eliminar volumen de caché persistente: `docker volume rm redis_redis_data`.

---

## 7. ♻️ ¿Cómo Replicar o Reconfigurar en Otro Servidor desde Cero?

1. Navegar a `infrastructure/databases/redis/` en la nueva máquina.
2. Asegurar existencia de `homelab-network`.
3. Ejecutar `docker compose up -d`.
