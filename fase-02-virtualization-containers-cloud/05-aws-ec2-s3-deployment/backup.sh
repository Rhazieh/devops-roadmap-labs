#!/bin/bash

# Script de backup automático (Postgres a S3)


CONTAINER_NAME="db-produccion"
DB_USER="postgres"
DB_NAME="postgres"
BUCKET_NAME="db-backups-maxi-tandil-2026"

# Fecha para el nombre del archivo
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVO_BACKUP="backup_${FECHA}.sql.gz"
RUTA_TEMPORAL="/tmp/${ARCHIVO_BACKUP}"

echo "1/3 Extrayendo y comprimiendo DB..."
# Ejecutamos pg_dump dentro del contenedor y comprimimos en ruta temporal"
docker exec $CONTAINER_NAME pg_dump -U $DB_USER -d $DB_NAME | gzip > $RUTA_TEMPORAL

echo "2/3 Subiendo backup a Amazon S3..."
# Copiamos el archivo al bucket
aws s3 cp $RUTA_TEMPORAL s3://${BUCKET_NAME}/${ARCHIVO_BACKUP}}

echo "3/3 Limpiando archivos temporales..."
# Borramos el archivo del disco de EC2
rm $RUTA_TEMPORAL

echo "¡Backup completado con éxito!"

