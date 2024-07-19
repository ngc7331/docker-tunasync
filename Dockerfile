# Build tunasync
FROM --platform=${TARGETPLATFORM} golang:latest AS build
ARG TARGETARCH
COPY ./tunasync /tmp/tunasync
RUN cd /tmp/tunasync && \
    make ARCH=linux-${TARGETARCH}

# Build image
FROM --platform=${TARGETPLATFORM} lscr.io/linuxserver/baseimage-ubuntu:jammy
ARG TARGETARCH

# Install tunasync
COPY --from=build /tmp/tunasync/build-linux-${TARGETARCH}/tunasync /bin/tunasync
COPY --from=build /tmp/tunasync/build-linux-${TARGETARCH}/tunasynctl /bin/tunasynctl

# Install sync tools
RUN apt update && \
    apt install -y --no-install-recommends \
        rsync ftpsync \
        python3 python3-pyquery python3-socks python3-requests python3-yaml \
        && \
    apt clean
COPY ./tunasync-scripts /etc/tunasync/scripts
COPY ./custom-scripts /etc/tunasync/scripts

# Copy root filesystem
COPY root /

# Common Envs
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Shanghai
ENV HTTP_PORT=8080

VOLUME [ "/config", "/data" ]

EXPOSE ${HTTP_PORT}/tcp
