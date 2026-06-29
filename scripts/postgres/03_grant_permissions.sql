-- Script para asignar privilegios de un usuario sobre una base de datos específica
-- Reemplazar 'nombre_base_datos' y 'usuario_app' según corresponda

GRANT ALL PRIVILEGES ON DATABASE nombre_base_datos TO usuario_app;

-- Nota para PostgreSQL 15+: Asignar permisos sobre el esquema público si es necesario
-- \c nombre_base_datos
-- GRANT ALL ON SCHEMA public TO usuario_app;
