#!/bin/bash
# First arg = old volume name
# Second arg = new volume name

if [ "" = "$(su - root -c "docker volume ls -f 'label=${BACKUP_LABEL}' -q")" ]
then
    su - root -c "docker volume create --name $2"
fi

su - root -c "docker run -v $1:/volume --rm loomchild/volume-backup backup -c none - | docker run -i -v $2:/volume --rm loomchild/volume-backup restore -c none -v -" && su - root -c "docker volume rm $1"
