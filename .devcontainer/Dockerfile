FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-3.16

USER vscode
ENV PATH="/home/vscode/go/bin:$PATH"
WORKDIR /home/vscode

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" | sudo tee -a /etc/apk/repositories \
  && sudo apk add build-base apk-tools go bubblewrap yq crystal shards yaml-dev sqlite-dev apko@testing \
  && go install golang.org/x/tools/cmd/goimports@latest \
  && go install github.com/skynomads/cob@main \
  && git clone https://github.com/chainguard-dev/melange.git \
  && cd melange && make melange && sudo make install && cd .. && rm -rf melange \
  && wget https://github.com/elbywan/crystalline/releases/latest/download/crystalline_x86_64-unknown-linux-gnu.gz -O crystalline.gz \
  && gzip -d crystalline.gz && chmod +x crystalline && sudo mv crystalline /usr/local/bin/crystalline