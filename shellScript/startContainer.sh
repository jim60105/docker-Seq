#!/bin/bash

echo "Starting Container..."
su - root -c "docker start \$(docker ps -a -f 'label=${BACKUP_LABEL}' -q)"
