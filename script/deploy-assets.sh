#!/bin/bash

find . -name .DS_Store -delete -exec echo removed: {} \;

az storage blob sync \
    --account-name lowplynet \
    --source ./static/assets \
    --container '$web/lowply.github.io/assets' \
    --delete-destination true
