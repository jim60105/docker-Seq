FROM loomchild/volume-backup

RUN apk update && apk add --no-cache bash docker curl

WORKDIR /script
COPY . /

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]