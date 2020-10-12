#!/bin/bash

find . -name .DS_Store -delete -exec echo removed: {} \;
aws --profile private s3 sync \
    --exclude "$(pwd)/assets/css/*" \
    --delete \
    $(pwd)/assets/ s3://lowply/lowply.github.io/assets/
