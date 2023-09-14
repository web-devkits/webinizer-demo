#  Copyright (C) 2023 Intel Corporation. All rights reserved.
#  Licensed under the Apache License 2.0. See LICENSE in the project root for license information.
#  SPDX-License-Identifier: Apache-2.0

FROM ubuntu:20.04

WORKDIR /webinizer

# Set this to avoid hang due to installing tzdata
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC


RUN \
  apt-get update && \
  apt-get -y upgrade --fix-missing && \
  apt-get install -y --no-install-recommends \
  git=1:2.25.1-1ubuntu3 \
  python3=3.8.2-0ubuntu2 \
  cmake=3.16.3-1ubuntu1.20.04.1 \
  curl=7.68.0-1ubuntu2.19 \
  build-essential=12.8ubuntu1 \
  ca-certificates=20190110ubuntu1 \
  file=1:5.38-4 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# setup node - do NOT use apt-get install nodejs npm
# The one from apt is too old
RUN \
  echo "Downloading node.js 16" && \
  curl -O https://nodejs.org/dist/v16.17.1/node-v16.17.1-linux-x64.tar.xz && \
  echo "Installing node.js 16" && \
  mkdir -p /usr/local/lib/nodejs && \
  tar -xJvf node-v16.17.1-linux-x64.tar.xz -C /usr/local/lib/nodejs && \
  rm node-v16.17.1-linux-x64.tar.xz

ENV PATH="/usr/local/lib/nodejs/node-v16.17.1-linux-x64/bin:$PATH"

# config emsdk
RUN \
  git clone https://github.com/emscripten-core/emsdk.git emsdk 
WORKDIR /webinizer/emsdk
RUN \
  ./emsdk install 3.1.31 && \
  ./emsdk activate 3.1.31 && \
  chmod +x emsdk_env.sh

COPY webinizer /webinizer/webinizer
COPY client /webinizer/client

COPY demo/build/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/bin/bash", "docker-entrypoint.sh"]  
EXPOSE 18888 16666
