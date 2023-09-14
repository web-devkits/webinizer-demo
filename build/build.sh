#!/bin/sh

#  Copyright (C) 2023 Intel Corporation. All rights reserved.
#  Licensed under the Apache License 2.0. See LICENSE in the project root for license information.
#  SPDX-License-Identifier: Apache-2.0

help_msg() {
  echo "Build Webinizer Container Image"
  echo "Usage: $0 temp_dir"
  echo "It will create temp_dir and put all temporary files under it"
}

START_DIR=`pwd`

if [ $# -ne 1 ]; then
  help_msg
  exit 1
fi

TMP_DIR=$1

if [ -e $TMP_DIR ]; then
  echo $TMP_DIR " should NOT already exist! It should be created by the script!"
  exit 1
fi

mkdir -p $TMP_DIR

cd $TMP_DIR


download_projects() {
  echo
  echo ">>>>>> Download webinizer Backend"
  git clone https://github.com/intel/webinizer.git webinizer

  cd webinizer
  npm install
  cd ..

  echo
  echo
  echo ">>>>>> Download webinizer UI"
  git clone https://github.com/intel/webinizer-webclient.git client
  cd client
  npm install
  cd ..


  echo
  echo
  echo ">>>>>> Download native projects to demo"
  git clone https://github.com/intel/webinizer-demo.git demo
  cd demo
  # download demo projects from remote and initialize
  ./download-demo-projects.sh
  cd ..

}


build_docker_img() {
  echo
  echo ">>>>>> Build the docker image"
  # use the $TMP_DIR as the context to build
  docker build -t webinizer -f demo/build/Dockerfile .
}

# copy everything out
package() {

  echo
  echo ">>>>>> Package"

  mkdir -p release

  cp demo/build/README.md release/.

  echo "... dump container image"
  docker save webinizer > release/webinizer_img.tar


  echo "... copy native projects for demo"
  mkdir -p release/webinizer_demo
  cp -r demo/native_projects release/webinizer_demo/.

  cp demo/build/run.sh release/webinizer_demo/.
  chmod +x release/webinizer_demo/run.sh

  echo "... copy demo files"
  cp -r demo/demos release/webinizer_demo/.

}

download_projects
build_docker_img
package


cd ..
echo
echo "Build Succeed! Please check the ${TMP_DIR}/release for the result!"