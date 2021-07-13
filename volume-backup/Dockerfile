FROM loomchild/volume-backup

RUN apk update && apk add --no-cache bash docker curl sshpass rsync openssh-client

WORKDIR /script
COPY . /

ENV BACKUP_RSYNC_URI=rsync@rsync.domain.com::backup_seq/
ENV BACKUP_RSYNC_PORT=22

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]