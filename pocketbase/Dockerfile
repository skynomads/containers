FROM docker.io/bitnami/minideb:bullseye

LABEL org.opencontainers.image.title="pocketbase" \
      org.opencontainers.image.version="0.7.3"

ARG POCKETBASE_VERSION=0.7.3
ARG LITESTREAM_VERSION=0.3.9

RUN install_packages curl ca-certificates unzip && \
    mkdir -p /var/pocketbase && \
    curl -SsLf https://github.com/pocketbase/pocketbase/releases/download/v${POCKETBASE_VERSION}/pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip -O && \
    unzip pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -rf pocketbase_${POCKETBASE_VERSION}_linux_amd64.zip && \
    curl -SsLf https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM_VERSION}/litestream-v${LITESTREAM_VERSION}-linux-amd64-static.tar.gz -O && \
    tar -zxf litestream-v${LITESTREAM_VERSION}-linux-amd64-static.tar.gz -C /usr/local/bin && \
    rm -rf litestream-v${LITESTREAM_VERSION}-linux-amd64-static.tar.gz && \
    chmod +x /usr/local/bin/*

EXPOSE 8080

COPY litestream.yml /etc/litestream.yml
COPY entrypoint.sh /entrypoint.sh

USER 1001

ENTRYPOINT /entrypoint.sh