#!/bin/bash

echo "Stopping Container..."
su - root -c "docker stop  \$(docker ps -a -f 'label=${BACKUP_LABEL}' -q)"
