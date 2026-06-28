# Portainer

## Descripción

Portainer Community Edition es la interfaz web utilizada para administrar Docker dentro del homelab.

## Acceso

https://localhost:9443

## Stack

Management

## Imagen

portainer/portainer-ce:2.39.4

## Volumen

portainer_data

## Red

homelab-network

## Comandos útiles

Iniciar:

```bash
docker compose up -d
```

Detener:

```bash
docker compose down
```

Actualizar:

```bash
docker compose pull
docker compose up -d
```

Ver logs:

```bash
docker logs portainer
```