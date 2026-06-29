# 🏛️ Visión General de Arquitectura del Homelab (Fases 1 y 2)

Este documento describe la arquitectura global, topología de componentes, matriz de contenedores y decisiones de diseño implementadas en la laptop personal convertida en servidor de desarrollo.

---

## 🗺️ Diagrama de Arquitectura Global

```text
                                Windows 10 Host (Navegador / VSCode Remote)
                                                     │
                                                     ▼ (WSL2 / Puertos Expuestos)
─────────────────────────────────────────────────────────────────────────────────────────────────────────
                                          Docker Engine (Ubuntu)
                                                     │
                                           Network: homelab-network (Bridge)
                                                     │
       ┌─────────────────┬─────────────────┬─────────┴───────┬─────────────────┬─────────────────┐
       │                 │                 │                 │                 │                 │
       ▼                 ▼                 ▼                 ▼                 ▼                 ▼
  Portainer         PostgreSQL          Adminer            Redis              NPM           Uptime Kuma
 (Mgmt 9000)        (DB 5432)         (UI 8081)        (Cache 6379)    (Proxy 80/81/443)   (Status 3001)
       │                 │                 │                 │                 │                 │
       └─────────────────┼─────────────────┼─────────────────┼─────────────────┼─────────────────┘
                         │                 │                 │                 │
                         ▼                 ▼                 ▼                 ▼
                     minio_data      postgres_data       redis_data        npm_data
```

---

## 📊 Matriz de Contenedores e Infraestructura

| Contenedor | Imagen | Puerto Host | Puerto Interno | Volumen Persistente | Dominio Local (NPM) | Estado |
| :--- | :--- | :---: | :---: | :--- | :--- | :---: |
| **portainer** | `portainer/portainer-ce:2.39.4` | `9000`, `9443` | `9000`, `9443` | `portainer_data` | `portainer.homelab.local` | Healthy |
| **postgres** | `postgres:17.5` | `5432` | `5432` | `postgres_data` | N/A (TCP Directo) | Healthy |
| **adminer** | `adminer:5.3.0` | `8081` | `8080` | Stateless (Sin estado) | `adminer.homelab.local` | Healthy |
| **redis** | `redis:7.4.2-alpine` | `6379` | `6379` | `redis_data` | N/A (TCP Directo) | Healthy |
| **nginx-proxy-manager**| `jc21/nginx-proxy-manager:2.12.1`| `80`, `81`, `443` | `80`, `81`, `443` | `npm_data`, `npm_letsencrypt` | N/A (Gestor Proxy) | Healthy |
| **uptime-kuma** | `louislam/uptime-kuma:1.23.13` | `3001` | `3001` | `uptime_kuma_data` | `kuma.homelab.local` | Healthy |
| **minio** | `minio/minio:latest` | `9000`, `9001` | `9000`, `9001` | `minio_data` | `minio.homelab.local` | Healthy |

---

## 🛡️ Principios Transversales de Arquitectura

1. **Aislamiento de Red**: Todos los contenedores se comunican internamente mediante la red bridge previa `homelab-network`, permitiendo la resolución de nombres por DNS de Docker (ej. `postgres`, `redis`, `adminer`).
2. **Principio de Mínimo Privilegio**: Las aplicaciones en desarrollo no se conectan usando superusuarios (`postgres` o `root`). Se crean bases de datos y usuarios dedicados por proyecto (ej. `carworkshop` / `carworkshop_user`).
3. **Persistencia Consciente**: Se diferencia estrictamente entre servicios Stateful con volúmenes dedicados y servicios Stateless.
4. **Proxy Inverso Único**: Nginx Proxy Manager gestiona las entradas web en los puertos 80/443, ofreciendo nombres de dominio limpios (`.homelab.local`) en lugar de puertos dispersos.
