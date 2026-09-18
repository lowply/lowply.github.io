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

stylesheet_path=$(
    sed -n 's/.*href="\([^"]*\/css\/main\.min\.[^"]*\.css\)".*/\1/p' public/index.html |
        head -n 1
)

case "$stylesheet_path" in
    /css/main.min.*.css) ;;
    *)
        echo "fingerprinted CSS link not found in public/index.html" >&2
        exit 1
        ;;
esac

if ! grep -Eq 'href="[^"]*/css/main\.min\.[^"]*\.css" rel="stylesheet" integrity="[^"]+"' public/index.html; then
    echo "stylesheet integrity attribute not found" >&2
    exit 1
fi

stylesheet_file="public${stylesheet_path}"
if [ ! -f "$stylesheet_file" ]; then
    echo "generated stylesheet not found: $stylesheet_file" >&2
    exit 1
fi

if grep -Eq '@use|@mixin|@include|\$[[:alnum:]_-]+' "$stylesheet_file"; then
    echo "generated stylesheet contains Sass syntax" >&2
    exit 1
fi
