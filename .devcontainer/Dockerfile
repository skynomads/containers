FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-3.16

RUN PATH="/home/vscode/go/bin:$PATH"

RUN apk add build-base apk-tools go bubblewrap yq \
  && git clone https://github.com/chainguard-dev/melange.git \
  && go install golang.org/x/tools/cmd/goimports@latest \
  && cd melange && make melange install && cd .. && rm -rf melange \
  && go install chainguard.dev/apko@latest
