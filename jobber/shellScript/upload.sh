#!/bin/bash

echo "Starting Transfer to backup server..."
su - root -c "mkdir -p ~/.ssh"
su - root -c "ssh-keyscan -p ${BACKUP_RSYNC_PORT} ${BACKUP_RSYNC_URI} >> ~/.ssh/known_hosts"
su - root -c "sshpass -f /run/secrets/rsyncpass rsync -e 'ssh -p ${BACKUP_RSYNC_PORT}' -avz --no-p --no-g /backup/ rsync@${BACKUP_RSYNC_URI}::NetBackup/backup_seq/"
