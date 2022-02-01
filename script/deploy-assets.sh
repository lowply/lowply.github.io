#!/bin/bash

find . -name .DS_Store -delete -exec echo removed: {} \;
aws \
    --profile s3backup \
    s3 sync \
    --exclude "css/*" \
    --delete \
    ./assets/ s3://lowply.org/lowply.github.io/assets/
