#!/bin/bash

scriptFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Make or clean backup folder
mkdir -p /backup
cd /backup
rm -f *

echo -n "Backup start at $(curl -s http://ipv4.icanhazip.com) " > /backup/log.txt
echo $(date +"%F %T") >> /backup/log.txt

source ${scriptFolder}/stopContainer.sh

V=$(su - root -c "docker volume ls -f 'label=${BACKUP_LABEL}' -q")
for i in ${V}
do
    echo "Backup ${i}..." | tee -a /backup/log.txt

    # volume-backup.sh from base image
    # https://github.com/loomchild/volume-backup/blob/master/volume-backup.sh
    su - root -c "/volume-backup.sh backup -c gz ${i} | tee -a /backup/log.txt"
done

echo "" >> /backup/log.txt
echo "Done at: $(date +"%F %T")" >> /backup/log.txt

source ${scriptFolder}/startContainer.sh
