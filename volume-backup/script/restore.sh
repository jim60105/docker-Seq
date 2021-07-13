#!/bin/bash
date +"%F %T"

scriptFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Move to backup folder
mkdir -p /backup
cd /backup

source ${scriptFolder}/stopContainer.sh

V=$(su - root -c "docker volume ls -f 'label=${BACKUP_LABEL}' -q")
for i in ${V}
do
    echo "Restore ${i}..."

    # volume-backup.sh from base image
    # https://github.com/loomchild/volume-backup/blob/master/volume-backup.sh
    su - root -c "/volume-backup.sh restore -f -c gz ${i}"
done

source ${scriptFolder}/startContainer.sh
