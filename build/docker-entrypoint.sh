#  Copyright (C) 2023 Intel Corporation. All rights reserved.
#  Licensed under the Apache License 2.0. See LICENSE in the project root for license information.
#  SPDX-License-Identifier: Apache-2.0

cd /webinizer

echo ">>> Setup environment"

export PATH=/usr/local/lib/nodejs/node-v16.17.1-linux-x64/bin:$PATH

NODE=$(which node)
sed -i'.old' "/^NODE_JS/s/= .*/= '${NODE//\//\\/}'/" emsdk/.emscripten
source emsdk/emsdk_env.sh

if [[ -f "/root/.webinizer/user-configs/gitconfig" ]]; then
  ln -s /root/.webinizer/user-configs/gitconfig /etc/gitconfig
fi

if [[ -f "/root/.webinizer/user-configs/npmrc" ]]; then
  ln -s /root/.webinizer/user-configs/npmrc /root/.npmrc
fi

cd /projects
for d in */ ; do
  [ -L "${d%/}" ] && continue
  cd $d
  git config --global --add safe.directory $PWD
  cd ..
done

cd /webinizer

echo ">>> Start backend"
cd webinizer
npm run serve &
sleep 6


echo 
echo
echo ">>> Start frontend"
cd ../client
npm run serve

