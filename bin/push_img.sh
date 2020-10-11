#!/bin/bash

find . -name .DS_Store -delete -exec echo removed: {} \;
aws --profile private s3 sync --delete --exclude .keep $(pwd)/images/ s3://lowply/lowply.github.io/images/
