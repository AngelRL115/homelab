# 📊 Servicio: Uptime Kuma (Monitoreo de Infraestructura)

## 1. 📖 ¿Qué es y Para qué sirve?

**Uptime Kuma** es una herramienta de monitoreo visual, ligera y autofilmada estilo *StatusPage*.

### Rol en el Homelab y tus Aplicaciones
Supervisa de manera continua (24/7) el estado de salud, disponibilidad y latencia de nuestras bases de datos, proxy e interfaces de administración. Enviar avisos automáticos si algún contenedor o API sufre una caída.

---

## 2. ⚙️ ¿Cómo funciona internamente?

- **Monitoreo de Red**: Realiza consultas TCP y peticiones HTTP periódicas directamente sobre los nombres de contenedores en `homelab-network`.
- **Puertos**: Expone el puerto `3001` para su interfaz gráfica.
- **Persistencia**: Guarda el historial de métricas, eventos de caídas y configuraciones de monitores en `uptime_kuma_data` (`/app/data`).

---

## 3. 🛠️ Estructura y Archivos del Servicio

Ubicación en el proyecto: `infrastructure/monitoring/uptime-kuma/`

### `compose.yaml`
```yaml
name: uptime-kuma

services:
  uptime-kuma:
    image: ${UPTIME_KUMA_IMAGE}
    container_name: uptime-kuma
    restart: unless-stopped

    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"

    ports:
      - "${UPTIME_KUMA_PORT}:3001"

    volumes:
      - uptime_kuma_data:/app/data

    networks:
      - homelab-network

    healthcheck:
      test: ["CMD-SHELL", "node extra/healthcheck.js || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

volumes:
  uptime_kuma_data:

networks:
  homelab-network:
    external: true
```

---

## 4. ▶️ Operación Día a Día (Iniciar, Detener, Reiniciar)

Ubicación: `infrastructure/monitoring/uptime-kuma/`

- **Iniciar servicio**: `docker compose up -d`
- **Verificar estado**: `docker ps`
- **Acceso Web**: `http://localhost:3001` o `http://kuma.homelab.local`
- **Detener servicio**: `docker compose stop`

---

## 5. 🔄 ¿Cómo Actualizar la Versión?

1. Modifica `UPTIME_KUMA_IMAGE` en `.env`.
2. Descarga la nueva imagen: `docker compose pull`.
3. Recrea el contenedor: `docker compose up -d`.

---

## 6. 🗑️ ¿Cómo Eliminar o Limpiar Completamente?

1. Detener servicio: `docker compose down`.
2. Eliminar historial de monitoreo: `docker volume rm uptime-kuma_uptime_kuma_data`.

---

## 7. ♻️ ¿Cómo Replicar o Reconfigurar en Otro Servidor desde Cero?

1. Navegar a `infrastructure/monitoring/uptime-kuma/`.
2. Ejecutar `docker compose up -d`.
3. Crear cuenta inicial de administrador y exportar/importar respaldo de monitores en JSON si existiera.
