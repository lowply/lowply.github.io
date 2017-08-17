#!/bin/bash

hugo -v --cleanDestinationDir
cd ..
git add .
git commit -m "$(date)"
git push
