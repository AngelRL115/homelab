# Scripts Útiles para PostgreSQL

Colección de scripts SQL reutilizables para la administración y aprovisionamiento de bases de datos en el homelab.

## Archivos
- `01_create_database.sql`: Plantilla para crear nuevas bases de datos aisladas.
- `02_create_user.sql`: Plantilla para crear usuarios de aplicación (siguiendo el principio de mínimo privilegio).
- `03_grant_permissions.sql`: Asignación de permisos entre usuario y base de datos.

## Uso en Adminer o psql
Puedes copiar el contenido de estos scripts y ejecutarlo directamente desde la interfaz web de Adminer o mediante `docker exec -it postgres psql -U postgres`.
