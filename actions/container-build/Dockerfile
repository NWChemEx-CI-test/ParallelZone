FROM alpine:latest

COPY docker-action /docker-action
COPY entrypoint.sh /entrypoint.sh

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
