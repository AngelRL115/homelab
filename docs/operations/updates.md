# 🔄 Guía Global de Actualización del Homelab

Este documento describe el procedimiento estándar para mantener actualizados las imágenes Docker y componentes de infraestructura de manera segura y sin pérdida de datos.

---

## 📋 Estrategia de Actualización por Servicio

Dado que en nuestro Homelab utilizamos versiones fijas en los archivos `.env` (en lugar de tags flotantes como `latest` impredecibles), el proceso de actualización sigue siempre estos 4 pasos:

### Paso 1: Cambiar la versión en el `.env`
Navega a la carpeta del servicio correspondiente y edita el archivo `.env` con la nueva versión fija deseada.

### Paso 2: Descargar la nueva imagen Docker
```bash
docker compose pull
```

### Paso 3: Recrear el contenedor
```bash
docker compose up -d
```
*Docker Compose detectará automáticamente que la imagen cambió y recreará únicamente el contenedor necesario, manteniendo intactos los volúmenes de datos con nombre.*

### Paso 4: Comprobación de Salud
```bash
docker ps
docker compose logs -f
```

---

## 🧹 Limpieza de Imágenes Antiguas Obsoletas
Tras actualizar varios servicios, las imágenes viejas quedan almacenadas en disco. Para liberar espacio en la laptop:

```bash
docker image prune -f
```
