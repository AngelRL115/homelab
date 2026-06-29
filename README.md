# 🏠 Homelab

## Objetivo

Este proyecto documenta la construcción de un servidor personal (Homelab) basado en Docker y Ubuntu sobre WSL2, orientado al despliegue y administración de aplicaciones modernas.

El objetivo no es únicamente alojar aplicaciones, sino construir una plataforma completa para desarrollo, aprendizaje y auto hospedaje (Self-hosting), siguiendo prácticas utilizadas en entornos profesionales.

---

# Hardware

Servidor físico

| Componente | Especificación       |
| ---------- | -------------------- |
| CPU        | Intel Core i5-6300HQ |
| RAM        | 24 GB DDR4 2133 MHz  |
| GPU        | NVIDIA GTX 960M 4GB  |
| SSD        | 500 GB               |
| HDD        | 1 TB                 |

---

# Sistema Operativo

Windows 10

Ubuntu 26.04 LTS sobre WSL2

Docker Engine

---

# Objetivos del proyecto

- Aprender Docker a profundidad.
- Aprender Linux.
- Aprender administración de servidores.
- Desplegar aplicaciones Node.js.
- Desplegar aplicaciones Java Spring Boot.
- Desplegar aplicaciones React.
- Desplegar aplicaciones Angular.
- Administrar bases de datos.
- Aprender redes Docker.
- Automatizar despliegues.
- Centralizar monitoreo.
- Implementar respaldos.
- Alojar servicios Open Source.

---

# Filosofía del proyecto

Cada servicio instalado debe cumplir con los siguientes principios:

- Docker Compose independiente.
- Variables de entorno.
- Versiones fijas.
- Persistencia de datos.
- Documentación completa.
- Fácil actualización.
- Fácil restauración.
- Fácil eliminación.

---

# Estado del proyecto

## Fase 1 y 2 — Infraestructura y Servicios Esenciales (Completadas)

- [x] Ubuntu sobre WSL2
- [x] Docker Engine & Docker Compose
- [x] Red Docker personalizada (`homelab-network`)
- [x] Portainer (Gestión de contenedores)
- [x] PostgreSQL (Base de datos relacional)
- [x] Adminer (Gestión de DB web)
- [x] Redis (Caché y almacén en memoria)
- [x] Nginx Proxy Manager (Reverse Proxy & dominios `.homelab.local`)
- [x] Uptime Kuma (Monitoreo de infraestructura 24/7)
- [x] MinIO (Almacenamiento de objetos S3)

## Fase 3 — Acondicionamiento de Plataforma PaaS (En Progreso)

- [ ] Galería de plantillas de arquitectura reutilizables (`templates/`)
- [ ] Acceso remoto seguro sin abrir puertos (Tailscale / Cloudflare Tunnel)
- [ ] Infraestructura base de automatización y CI/CD (Runner workspace)
- [ ] Librería de scripts operativos de mantenimiento y respaldos (`scripts/`)

## Fase 4 — Servicios de Observabilidad Avanzada y Aplicaciones

- [ ] Despliegue de Aplicaciones Propias o Herramientas Open Source
- [ ] Grafana (Dashboards avanzados)
- [ ] Prometheus (Métricas de sistema)
- [ ] Loki (Centralización de logs)

---

# Documentación

Toda la documentación del proyecto se encuentra dentro de la carpeta:

docs/

---

# Licencia

Proyecto personal de aprendizaje.