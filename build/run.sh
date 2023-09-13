#!/bin/bash

#  Copyright (C) 2023 Intel Corporation. All rights reserved.
#  Licensed under the Apache License 2.0. See LICENSE in the project root for license information.
#  SPDX-License-Identifier: Apache-2.0

help_msg() {
  echo "Run Webinizer Container"
  echo "Usage: $0 dir_of_native_projects port_of_web"
  echo "    dir_of_native_projects   The directory holding all native projects to be processed by Webinizer. It will be mapped into the container."
  echo "    port_of_web              The port to access the webclient. "
}

get_user_gitconfig() {
  read -p "User name: " uservar
  read -p "User email: " emailvar
  cat > gitconfig << EOF

[user]
    name = $uservar
    email = $emailvar

EOF
  echo "Configuration for git is added."
  cat gitconfig
}

get_user_npmrc() {
  read -p "Please enter the registry URL address: " registryAddr
  echo "Running 'npm adduser' to login to the registry ..."
  npm adduser --registry $registryAddr
  if [[ -f "${HOME}/.npmrc" ]]; then
    registryUrl=$registryAddr
    if [[ ("$registryAddr" == *"http://"*)  ||  ("$registryAddr" == *"https://"*) ]]; then
      # extract the protocol
      proto="$(echo $registryAddr | grep :// | sed -e's,^\(.*://\).*,\1,g')"
      # remove the protocol
      registryUrl=$(echo $registryAddr | sed -e s,$proto,,g)
    fi

    # find the autoToken line for the registry from the system npmrc file and save for webinizer
    while IFS= read -r line; do
      if [[ ("$line" == *"${registryUrl}"*)  &&  ("$line" == *"authToken"*) ]]; then
        cat > npmrc << EOF
$line

EOF
        echo "Configuration for registry $registryAddr is added."
        break
      fi
    done < "${HOME}/.npmrc"

  fi

  # set the $registryAddr to settings.json file as well
  if [[ ! -f "${HOME}/.webinizer/settings.json" ]]; then
    # settings.json file doesn't exist, create a new one
    cat > ${HOME}/.webinizer/settings.json << EOF
{
  "registry": "${registryAddr}"
}

EOF
  else
     # settings.json file exists, update the registry field with the new value
     node -p "JSON.stringify(Object.assign(require('${HOME}/.webinizer/settings.json'), { registry: '${registryAddr}' }), undefined, 2)" > settings_updated.json
     mv settings_updated.json ${HOME}/.webinizer/settings.json
  fi
}

if [[ $# -ne 2 ]]; then
  help_msg
  exit 1
fi

PROJ_DIR=$1
PORT=$2
START_DIR=`pwd`

echo ">>> Initializing Webinizer ..."

# create folders and files for Webinizer configuration
if [[ ! -d "${HOME}/.webinizer/logs" ]]; then
  mkdir -p ${HOME}/.webinizer/logs
fi

if [[ ! -f "${HOME}/.webinizer/settings.json" ]]; then
  cat > ${HOME}/.webinizer/settings.json << EOF
{}
EOF
fi

if [[ ! -d "${HOME}/.webinizer/user-configs" ]]; then
  mkdir -p ${HOME}/.webinizer/user-configs
fi

cd ${HOME}/.webinizer/user-configs

echo
echo
if [[ ! -f "gitconfig" ]]; then
  echo "Git configuration file is not found, please create one for Webinizer."
  get_user_gitconfig
else
  echo "Git configuration file is found as below."
  cat gitconfig
  read -p "Do you want to create a new one? (Y/N): " confirm
  if [[ $confirm == [yY]  ||  $confirm == [yY][eE][sS] ]]; then
    get_user_gitconfig
  fi
fi

echo
echo
if [[ ! -f "npmrc" ]]; then
  echo "Webinizer supports publish a project to a registry that is npm compatible."
  echo "As this is an experimental feature, we recommend you to setup a private registry locally using tools such as verdaccio (https://github.com/verdaccio/verdaccio) instead of using a public registry."
  read -p "Would you like to create a configuration file for the registry? (Y/N): " confirm
  if [[ $confirm == [yY]  ||  $confirm == [yY][eE][sS] ]]; then
    get_user_npmrc
  else
    echo "You can still set the registry configuration after the container is up running."
    echo "Run 'docker exec -it webinizer bash' to attach to the container process and run 'npm adduser --registry \$\{REGISTRY_URL\}' to login to the registry."
  fi
else
  echo "Registry configuration file is found as below."
  cat npmrc
  read -p "Do you want to create a new one? (Y/N): " confirm
  if [[ $confirm == [yY]  ||  $confirm == [yY][eE][sS] ]]; then
    get_user_npmrc
  fi

fi

cd ${START_DIR}

echo
echo
echo ">>> Running Webinizer container ..."

docker run -it --rm --name webinizer \
           -v ${PROJ_DIR}:/projects \
           -v ${HOME}/.webinizer:/root/.webinizer \
           -p ${PORT}:18888/tcp \
           -p 16666:16666 webinizer
