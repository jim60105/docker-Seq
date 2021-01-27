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
    su - root -c "docker run -v ${i}:/volume -v '${BACKUP_FOLDER}':/backup --rm loomchild/volume-backup backup -c gz ${i} | tee -a /backup/log.txt"
done

echo "" >> /backup/log.txt
echo "Done at: $(date +"%F %T")" >> /backup/log.txt

source ${scriptFolder}/startContainer.sh
