-- Script para la creación de usuarios de aplicación (evitando uso de superusuario 'postgres')
-- Reemplazar 'usuario_app' y 'contrasena_segura' con los valores deseados

CREATE USER usuario_app WITH PASSWORD 'contrasena_segura';
