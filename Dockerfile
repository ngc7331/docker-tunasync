# Build tunasync
FROM golang:alpine AS build
ARG TARGETARCH
COPY . /tmp
RUN apk add make git && \
    cd /tmp/tunasync && \
    make ARCH=linux-${TARGETARCH}

# Build image
FROM ghcr.io/ngc7331/linuxserver-baseimage-alpine:3.21
ARG TARGETARCH

# Install tunasync
COPY --from=build /tmp/tunasync/build-linux-${TARGETARCH}/tunasync /bin/tunasync
COPY --from=build /tmp/tunasync/build-linux-${TARGETARCH}/tunasynctl /bin/tunasynctl

# Install sync tools
RUN apk add --no-cache \
      xz patch unzip jq ack \
      wget curl rsync git lftp aria2 \
      python3 py3-requests py3-yaml py3-pip py3-lxml \
      && \
    python3 -m pip install --no-cache-dir --break-system-packages \
      pyquery \
      pytz
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
