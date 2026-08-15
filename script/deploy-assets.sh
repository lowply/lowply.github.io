#!/usr/bin/env bash

set -euo pipefail

STORAGE_ACCOUNT_NAME=lowplynet
SOURCE_DIR=$(cd ./static/assets && pwd -P)

find "${SOURCE_DIR}" -name .DS_Store -delete -print

azcopy sync "${SOURCE_DIR}" \
    "https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net/\$web/lowply.github.io/assets/" \
    --recursive \
    --delete-destination=true
