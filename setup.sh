#!/bin/sh

#  Copyright (C) 2023 Intel Corporation. All rights reserved.
#  Licensed under the Apache License 2.0. See LICENSE in the project root for license information.
#  SPDX-License-Identifier: Apache-2.0

mkdir -p webinizer-code

cd webinizer-code


echo
echo
echo ">>>>>> Install Emscripten"
if [ -d "emsdk" ]; then
  cd emsdk
  git pull
  cd ..
else
  git clone https://github.com/emscripten-core/emsdk.git
fi
# config emsdk
cd emsdk
if [ ! -d "upstream" ]; then
  ./emsdk install 3.1.31
  ./emsdk activate 3.1.31
fi
chmod +x emsdk_env.sh
cd ..

echo
echo
echo ">>>>>> Install webinizer Backend"
if [ -d "webinizer" ]; then
  cd webinizer
  git pull
  cd ..
else
  git clone https://github.com/intel/webinizer.git webinizer
fi

cd webinizer
npm install
cd ..

echo
echo
echo ">>>>>> Install webinizer UI"
if [ -d "webclient" ]; then
  cd webclient
  git pull
  cd ..
else
  git clone https://github.com/intel/webinizer-webclient.git webclient
fi

cd webclient
npm install
cd ..

cd ..
# download demo projects to native_projects folder
./download-demo-projects.sh
