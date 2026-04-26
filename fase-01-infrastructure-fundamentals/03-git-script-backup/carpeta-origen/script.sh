#!/bin/bash

# Lo hacemos sensible a todo fallo por lo cual va a cancelar cualquier cambio
set -euo pipefail

# No creamos variables para los directorios pero podríamos optimizarlo facilmente.

# Creamos variables para el nombre, empaquetamos y comprimimos el home que copiamos cada 5 min en carpeta-origen
sufijoTar=$(date +%Y-%m-%d_%H-%M)
nombreTar="home-backup-$sufijoTar"
tar -czf /home/rhazieh/Documents/devops-roadmap-labs/fase-1-linux/03-git-script-backup/carpeta-destino/$nombreTar.tar.gz /home/rhazieh/Documents/devops-roadmap-labs/fase-1-linux/03-git-script-backup/carpeta-origen/

# Nos movemos al repo y subimos a GitHub el backup.
cd /home/rhazieh/Documents/devops-roadmap-labs/fase-1-linux/03-git-script-backup/carpeta-destino && git add $nombreTar.tar.gz && git commit -m "Backup $nombreTar.tar.gz" && git push origin main

# Para buscar backups con más de 7 días.
find ./ -name "*.tar.gz" -type f -mtime +7 -delete


