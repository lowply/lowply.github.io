#!/bin/sh

set -eu

for path in assets/sass/main.scss package.json package-lock.json; do
    if [ -e "$path" ]; then
        echo "obsolete dependency file remains: $path" >&2
        exit 1
    fi
done

if git grep -nE 'css\.Sass|dartsass|bootstrap/scss|npm ci|setup-node' -- \
    . ':!content/**' ':!script/check-css-migration.sh'
then
    echo "obsolete CSS build reference remains" >&2
    exit 1
fi

main_links=$(
    tr '<' '\n' < public/index.html |
        grep -E '^link[[:space:]][^>]*href=[^>]*\/css\/main\.min\.[^>]*\.css[^>]*>' ||
        true
)

main_link_count=$(printf '%s\n' "$main_links" | awk 'NF { count++ } END { print count + 0 }')
if [ "$main_link_count" -ne 1 ]; then
    echo "expected exactly one main stylesheet link in public/index.html" >&2
    exit 1
fi

stylesheet_record=$(
    printf '%s\n' "$main_links" |
        sed -En '
            s|^link href="(/css/main\.min\.([0-9a-f]{64})\.css)" rel="stylesheet" integrity="(sha256-[A-Za-z0-9+/]+={0,2})"[[:space:]]*/?>$|\1 \2 \3|p
            s|^link href=(/css/main\.min\.([0-9a-f]{64})\.css) rel=stylesheet integrity="(sha256-[A-Za-z0-9+/]+={0,2})"[[:space:]]*>$|\1 \2 \3|p
        '
)

if [ -z "$stylesheet_record" ]; then
    echo "main stylesheet link has unsupported or malformed attributes" >&2
    exit 1
fi

set -- $stylesheet_record
stylesheet_path=$1
stylesheet_fingerprint=$2
stylesheet_integrity=$3

stylesheet_file="public${stylesheet_path}"
if [ ! -f "$stylesheet_file" ]; then
    echo "generated stylesheet not found: $stylesheet_file" >&2
    exit 1
fi

actual_fingerprint=$(openssl dgst -sha256 "$stylesheet_file" | awk '{ print $NF }')
if [ "$stylesheet_fingerprint" != "$actual_fingerprint" ]; then
    echo "stylesheet filename fingerprint does not match generated stylesheet" >&2
    exit 1
fi

actual_integrity="sha256-$(openssl dgst -sha256 -binary "$stylesheet_file" | openssl base64 -A)"
if [ "$stylesheet_integrity" != "$actual_integrity" ]; then
    echo "stylesheet integrity does not match generated stylesheet" >&2
    exit 1
fi

if grep -Eq '@use|@mixin|@include|\$[[:alnum:]_-]+' "$stylesheet_file"; then
    echo "generated stylesheet contains Sass syntax" >&2
    exit 1
fi
