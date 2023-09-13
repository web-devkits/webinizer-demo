#!/bin/bash

#  Copyright (C) 2023 Intel Corporation. All rights reserved.
#  Licensed under the Apache License 2.0. See LICENSE in the project root for license information.
#  SPDX-License-Identifier: Apache-2.0

function replaceLine() {
  local LINE_PATTERN=$1
  local NEW_LINE=$2
  local FILE=$3
  local NEW=$(echo "${NEW_LINE}" | sed 's/\//\\\//g')
  touch "${FILE}"
  sed -i '/'"${LINE_PATTERN}"'/s/.*/'"${NEW}"'/' "${FILE}"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd webinizer-code/emsdk
# Prefer the default system-installed version of Node.js
NODE=$(which node)
sed -i'.old' "/^NODE_JS/s/= .*/= '${NODE//\//\\/}'/" .emscripten
# Activate PATH and other environment variables in the current terminal
source ./emsdk_env.sh

cd ../webinizer
SERVER_DIR=`pwd`
# update projectPool, UPLOAD_PROJECT_REPO_PATH and WEBINIZER_HOME in src/constants.ts at first
replaceLine "export const projectPool =" "export const projectPool = \"${SCRIPT_DIR}/native_projects\";" src/constants.ts
replaceLine "export const UPLOAD_PROJECT_REPO_PATH =" "export const UPLOAD_PROJECT_REPO_PATH = \"${SERVER_DIR}/uploaded_proj\";" src/constants.ts
replaceLine "export const WEBINIZER_HOME =" "export const WEBINIZER_HOME = \"${SERVER_DIR}\";" src/constants.ts
# launch the server
npm run serve