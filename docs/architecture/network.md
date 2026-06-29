# 🌐 Redes y Resolución de Nombres en el Homelab

Este documento detalla la topología de red, el comportamiento del DNS interno de Docker y el esquema de resolución de nombres locales implementado entre Windows y WSL2.

---

## 🔌 Topología de Red Docker (`homelab-network`)

El Homelab utiliza una única red bridge externa personalizada creada previamente mediante:

```bash
docker network create homelab-network
```

### ¿Por qué una red personalizada externa?
En lugar de dejar que cada archivo `compose.yaml` cree su propia red aislada (lo que impediría que Adminer o Nginx Proxy Manager hablen con PostgreSQL), la red `external: true` actúa como un **Switch Virtual Único** donde todos los servicios coexisten y se descubren automáticamente por su nombre de contenedor (`container_name`).

---

## 🧠 Resolución DNS Interna vs Externa

### 1. Comunicación Inter-Contenedor (DNS Interno de Docker)
Dentro de la red `homelab-network`, Docker ejecuta un servidor DNS interno en la IP `127.0.0.11`.
- Cuando Adminer se conecta al servidor `postgres`, Docker DNS resuelve automáticamente la IP privada de red (ej. `172.18.0.3`).
- Cuando Uptime Kuma monitorea `http://adminer:8080`, no necesita conocer puertos del host ni direcciones IP dinámicas.

### 2. Peticiones desde el Navegador Host (Windows 10)
Cuando el usuario escribe en su navegador `http://adminer.homelab.local`:

```text
Navegador (Windows 10)
      │
      ▼ 1. Consulta archivo 'hosts' (C:\Windows\System32\drivers\etc\hosts)
Resuelve adminer.homelab.local -> 127.0.0.1 (Puerto 80)
      │
      ▼ 2. Petición entra al Host en Puerto 80
Contenedor Nginx Proxy Manager (Escuchando en 80)
      │
      ▼ 3. NPM revisa el Host header: "adminer.homelab.local"
Proxy Reenvía a -> http://adminer:8080 (Vía homelab-network)
      │
      ▼ 4. Respuesta devuelta al navegador
Contenedor Adminer
```

---

## 🛠️ Configuración de Archivo `hosts` en Windows

Para que el sistema operativo Windows resuelva los dominios locales `.homelab.local` hacia Nginx Proxy Manager (`127.0.0.1`), se mantienen registradas las siguientes entradas en `C:\Windows\System32\drivers\etc\hosts`:

```text
127.0.0.1   adminer.homelab.local
127.0.0.1   portainer.homelab.local
127.0.0.1   kuma.homelab.local
127.0.0.1   minio.homelab.local
```

### Comprobación de Diagnóstico (PowerShell vs Linux)
- **Linux (WSL2)**: `curl -H "Host: adminer.homelab.local" http://localhost` (Simula la petición al Proxy).
- **Windows PowerShell**: `curl.exe http://adminer.homelab.local` (Valida la resolución del archivo `hosts`).
- **Limpieza de Caché DNS (Windows)**: `ipconfig /flushdns`.
