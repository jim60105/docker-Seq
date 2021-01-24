#!/bin/bash
date +"%F %T"

scriptFolder="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Move to backup folder
mkdir -p ${BACKUP_FOLDER}
cd ${BACKUP_FOLDER}

source ${scriptFolder}/stopContainer.sh

V=$(su - root -c "docker volume ls -f 'label=${BACKUP_LABEL}' -q")
for i in ${V}
do
    echo "Restore ${i}..."
    su - root -c "docker run -v ${i}:/volume -v $PWD:/backup --rm loomchild/volume-backup restore -c gz ${i}"
done
