FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-3.16

ENV PATH="/root/go/bin:/home/vscode/go/bin:$PATH"

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add build-base apk-tools go bubblewrap yq ruby ruby-bundler ruby-dev apko@testing \
  && gem install rubocop solargraph reek \
  && go install golang.org/x/tools/cmd/goimports@latest \
  && git clone https://github.com/chainguard-dev/melange.git \
  && cd melange && make melange install && cd .. && rm -rf melange
