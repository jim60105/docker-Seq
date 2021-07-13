#!/bin/bash

echo "Starting Transfer to backup server..."
URL=$(echo "${BACKUP_RSYNC_URI}" | sed -r 's/.*@(.*)::.*/\1/')

su - root -c "mkdir -p ~/.ssh"
su - root -c "ssh-keyscan -p ${BACKUP_RSYNC_PORT} ${URL} >> ~/.ssh/known_hosts"
su - root -c "sshpass -f /run/secrets/rsyncpass rsync -e 'ssh -p ${BACKUP_RSYNC_PORT}' -avz --no-p --no-g /backup/ ${BACKUP_RSYNC_URI}"
