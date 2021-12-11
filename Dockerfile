# syntax=docker/dockerfile:1
# Inspired by https://github.com/mumoshu/dcind
ARG DOCKER_VERSION=20.10.9
ARG DOCKER_COMPOSE_VERSION=1.29.2
ARG ALPINE_BASE=alpine:3.15

FROM docker/compose:alpine-${DOCKER_COMPOSE_VERSION} as docker-compose-image

FROM ${ALPINE_BASE}
LABEL maintainer="Dmitry Matrosov <amidos@amidos.me>"
# use shared DOCKER_VERSION
ARG DOCKER_VERSION
# Copy  and Docker Compose from official image
COPY --from=docker-compose-image /usr/local/bin/docker-compose /usr/local/bin/docker-compose
# Install Docker
RUN true \
    && apk --no-cache add bash curl util-linux device-mapper iptables \
    && curl -#RL https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx \
    && mv /docker/* /bin/

# Include functions to start/stop docker daemon
COPY docker-lib.sh /docker-lib.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
