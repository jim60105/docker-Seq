FROM blacklabelops/jobber:docker 

RUN apk add sshpass rsync openssh-client
COPY shellScript /script
ENV BACKUP_RSYNC_URI=rsync.domain.com
ENV BACKUP_RSYNC_PORT=22
