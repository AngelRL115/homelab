# 🛠️ Cheatsheet de Comandos Útiles del Homelab

Una referencia rápida con los comandos bash y Docker más utilizados en el día a día para la administración de la plataforma.

---

## 🐳 Comandos Frecuentes de Docker & Compose

### Gestión de Servicios
- **Levantar servicio en 2º plano**: `docker compose up -d`
- **Validar sintaxis de compose**: `docker compose config`
- **Ver contenedores activos**: `docker ps`
- **Ver todos los contenedores (incluyendo detenidos)**: `docker ps -a`
- **Detener servicio**: `docker compose stop`
- **Reiniciar servicio**: `docker compose restart`
- **Eliminar contenedor y red local**: `docker compose down`

### Inspección y Diagnóstico
- **Ver logs en tiempo real**: `docker logs -f <nombre_contenedor>`
- **Entrar a la terminal de un contenedor**: `docker exec -it <nombre_contenedor> bash` (o `sh`)
- **Ver uso de recursos (CPU/RAM)**: `docker stats`

---

## 🌐 Comandos de Redes y DNS
- **Listar redes Docker**: `docker network ls`
- **Inspeccionar contenedores en la red**: `docker network inspect homelab-network`
- **Limpiar caché DNS en Windows (PowerShell Admin)**: `ipconfig /flushdns`
- **Probar resolución con Host Header en Linux**: `curl -H "Host: adminer.homelab.local" http://localhost`
