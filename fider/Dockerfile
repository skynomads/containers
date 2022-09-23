ARG VERSION=0.21.1

FROM getfider/fider:${VERSION} AS origin

FROM docker.io/bitnami/minideb:bullseye

LABEL org.opencontainers.image.title="fider" \
      org.opencontainers.image.version="${VERSION}"

COPY --from=origin /app /opt/fider
COPY entrypoint.sh /entrypoint.sh

WORKDIR /opt/fider

RUN install_packages curl ca-certificates

USER 1001
EXPOSE 3000

ENTRYPOINT /entrypoint.sh