#!/bin/bash

find . -name .DS_Store -delete -exec echo removed: {} \;
aws \
    --profile xxx \
    s3 sync \
    --exclude "sass/*" \
    --delete \
    ./static/assets/ s3://lowply.net/lowply.github.io/assets/
