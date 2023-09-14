#!/usr/bin/env bash

SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"

cd $SCRIPT_DIR

cp ../../native_projects/2048/_build/2048* .

npx http-server
