#!/bin/bash

usage(){
	echo "Usage: ./new.sh <blog|photo> file-name-of-the-document"
	echo "Subject will be capitalized and de-hyphened.";
	exit 1;
}

type hugo > /dev/null 2>&1 || { echo "hugo not found"; exit 1; }
[ ${#} -ne 2 ] && usage

TYPE="${1}"
FILENAME="${2}"
TITLE=$(echo ${FILENAME} | sed 's/[^ _-]*/\u&/g' | sed 's/-/ /g')

[ "${TYPE}" = "blog" -o "${TYPE}" = "photo" ] || usage

hugo new ${TYPE}/${FILENAME}.md
perl -i -pe "s|title = \".*\"|title = \"${TITLE}\"|g" content/${TYPE}/${FILENAME}.md
vim content/${TYPE}/${FILENAME}.md
