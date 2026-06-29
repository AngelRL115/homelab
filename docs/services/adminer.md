# 🗄️ Servicio: Adminer (Gestión de Bases de Datos)

## 1. 📖 ¿Qué es y Para qué sirve?

**Adminer** es una herramienta de gestión de bases de datos completa basada en PHP contenida en un único archivo.

### Rol en el Homelab y tus Aplicaciones
Permite a los desarrolladores administrar visualmente las tablas, esquemas, registros y ejecutar comandos SQL en PostgreSQL sin necesidad de instalar clientes pesados en la máquina cliente.

---

## 2. ⚙️ ¿Cómo funciona internamente?

- **Redes y DNS**: Se conecta a la red `homelab-network`. Resuelve el servidor `postgres` mediante DNS de Docker.
- **Sin estado (Stateless)**: No requiere volumen de datos persistente.
- **Puerto**: Expone el puerto `8081` en el host mapeado al puerto `8080` interno.

---

## 3. 🛠️ Estructura y Archivos del Servicio

Ubicación en el proyecto: `infrastructure/databases/adminer/`

### `compose.yaml`
```yaml
name: adminer

services:
  adminer:
    image: ${ADMINER_IMAGE}
    container_name: adminer
    restart: unless-stopped

    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"

    ports:
      - "${ADMINER_PORT}:8080"

    networks:
      - homelab-network

networks:
  homelab-network:
    external: true
```

---

## 4. ▶️ Operación Día a Día (Iniciar, Detener, Reiniciar)

Ubicación: `infrastructure/databases/adminer/`

- **Iniciar servicio**: `docker compose up -d`
- **Verificar estado**: `docker ps`
- **Acceso Web**: `http://localhost:8081` o `http://adminer.homelab.local`
- **Detener servicio**: `docker compose stop`

---

## 5. 🔄 ¿Cómo Actualizar la Versión?

1. Modifica `ADMINER_IMAGE` en `.env`.
2. Actualiza la imagen: `docker compose pull`.
3. Recrea el contenedor: `docker compose up -d`.

---

## 6. 🗑️ ¿Cómo Eliminar o Limpiar Completamente?

1. Ejecutar `docker compose down`. Al ser Stateless, no deja residuos en disco.

---

## 7. ♻️ ¿Cómo Replicar o Reconfigurar en Otro Servidor desde Cero?

1. Navegar a `infrastructure/databases/adminer/`.
2. Ejecutar `docker compose up -d`.
