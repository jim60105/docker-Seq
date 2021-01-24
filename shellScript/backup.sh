#!/bin/bash

scriptFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Make or clean backup folder
mkdir -p ${BACKUP_FOLDER}
cd ${BACKUP_FOLDER}
rm -f *

echo -n "Backup start at $(curl -s http://ipv4.icanhazip.com) " > ${BACKUP_FOLDER}/log.txt
echo $(date +"%F %T") >> ${BACKUP_FOLDER}/log.txt

source ${scriptFolder}/stopContainer.sh

V=$(su - root -c "docker volume ls -f 'label=${BACKUP_LABEL}' -q")
for i in ${V}
do
    echo "Backup ${i}..." | tee -a ${BACKUP_FOLDER}/log.txt
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup backup -c gz ${i} | tee -a ${BACKUP_FOLDER}/log.txt"
done

echo "" >> ${BACKUP_FOLDER}/log.txt
echo "Done at: $(date +"%F %T")" >> ${BACKUP_FOLDER}/log.txt

source ${scriptFolder}/startContainer.sh
