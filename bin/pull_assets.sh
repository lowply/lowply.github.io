#!/bin/bash

aws --profile private s3 sync s3://lowply/lowply.github.io/assets/ $(pwd)/assets/ 
