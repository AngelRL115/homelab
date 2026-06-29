# 🐘 Servicio: PostgreSQL (Base de Datos Relacional)

## 1. 📖 ¿Qué es y Para qué sirve?

**PostgreSQL** es un sistema de gestión de bases de datos relacionales de código abierto, reconocido por su robustez, integridad de datos y soporte de consultas complejas.

### Rol en el Homelab y tus Aplicaciones
Es nuestro motor de base de datos primario. Aquí se almacenarán todas las tablas y datos estructurados de tus futuras aplicaciones en desarrollo (por ejemplo, clientes, vehículos, servicios, roles y usuarios en la API de un taller mecánico).

---

## 2. ⚙️ ¿Cómo funciona internamente?

- **Redes y DNS**: Corre en la red `homelab-network`. Los contenedores de tus aplicaciones se conectan a él mediante la dirección `postgres` y el puerto interno `5432`.
- **Persistencia**: Todos los datos, tablas e índices se almacenan fuera del contenedor en el volumen con nombre `postgres_data` (`/var/lib/postgresql/data`). Si el contenedor se destruye, los datos se conservan intactos.
- **Seguridad y Usuarios**: Mantiene un usuario administrativo superusuario (`postgres`). Siguiendo el principio de mínimo privilegio, tus aplicaciones se conectarán usando usuarios dedicados creados mediante los scripts de [scripts/postgres](file:///home/omen/homelab/scripts/postgres).

---

## 3. 🛠️ Estructura y Archivos del Servicio

Ubicación en el proyecto: `infrastructure/databases/postgres/`

### `compose.yaml`
```yaml
name: postgres

services:
  postgres:
    image: ${POSTGRES_IMAGE}
    container_name: postgres
    restart: unless-stopped

    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"

    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
      TZ: ${TZ}

    ports:
      - "${POSTGRES_PORT}:5432"

    volumes:
      - postgres_data:/var/lib/postgresql/data

    networks:
      - homelab-network

    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 15s

volumes:
  postgres_data:

networks:
  homelab-network:
    external: true
```

---

## 4. ▶️ Operación Día a Día (Iniciar, Detener, Reiniciar)

Todos los comandos se ejecutan dentro del directorio `infrastructure/databases/postgres/`:

- **Iniciar servicio**: `docker compose up -d`
- **Verificar estado**: `docker ps` o `docker compose ps`
- **Ver logs en tiempo real**: `docker compose logs -f`
- **Detener servicio (sin borrar datos)**: `docker compose stop`
- **Reiniciar servicio**: `docker compose restart`

---

## 5. 🔄 ¿Cómo Actualizar la Versión?

1. Abre el archivo `.env` y cambia el valor de `POSTGRES_IMAGE` a la nueva versión deseada (ej. `postgres:17.6`).
2. Descarga la nueva imagen:
   ```bash
   docker compose pull
   ```
3. Recrea el contenedor aplicando los cambios:
   ```bash
   docker compose up -d
   ```
*(Nota: Al estar los datos en el volumen `postgres_data`, el contenedor se recreará sin perder ninguna base de datos).*

---

## 6. 🗑️ ¿Cómo Eliminar o Limpiar Completamente?

Si deseas eliminar el servicio y hacer un reinicio total borrando todas las bases de datos:

1. Detener y eliminar contenedor y red local:
   ```bash
   docker compose down
   ```
2. Eliminar el volumen persistente de datos (⚠️ **Acción destructiva e irreversible**):
   ```bash
   docker volume rm postgres_postgres_data
   ```

---

## 7. ♻️ ¿Cómo Replicar o Reconfigurar en Otro Servidor desde Cero?

1. Clonar el repositorio en la nueva máquina.
2. Asegurarse de que la red global exista: `docker network create homelab-network`.
3. Navegar a `infrastructure/databases/postgres/`.
4. Copiar o verificar las variables en `.env`.
5. Ejecutar `docker compose up -d`.
