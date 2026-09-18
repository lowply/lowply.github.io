#!/bin/sh

set -eu

test_dir=.css-migration-test
index_backup="$test_dir/index.html"
failures=0
wrong_stylesheet=

mkdir -p "$test_dir"
cp public/index.html "$index_backup"

stylesheet_file=$(find public/css -type f -name 'main.min.*.css' | head -n 1)
stylesheet_path=${stylesheet_file#public}
fingerprint=$(openssl dgst -sha256 "$stylesheet_file" | awk '{ print $NF }')
integrity="sha256-$(openssl dgst -sha256 -binary "$stylesheet_file" | openssl base64 -A)"

cleanup() {
    cp "$index_backup" public/index.html
    if [ -n "$wrong_stylesheet" ]; then
        rm -f "$wrong_stylesheet"
    fi
    rm -rf "$test_dir"
}
trap cleanup EXIT HUP INT TERM

expect_pass() {
    name=$1
    if ! output=$(./script/check-css-migration.sh 2>&1); then
        echo "FAIL: $name: $output" >&2
        failures=$((failures + 1))
    fi
}

expect_fail() {
    name=$1
    if output=$(./script/check-css-migration.sh 2>&1); then
        echo "FAIL: $name: check unexpectedly passed" >&2
        failures=$((failures + 1))
    fi
}

printf '<link href="%s" rel="stylesheet" integrity="%s" />\n' \
    "$stylesheet_path" "$integrity" > public/index.html
expect_pass "fully quoted stylesheet link"

printf '<link href=%s rel=stylesheet integrity="%s">\n' \
    "$stylesheet_path" "$integrity" > public/index.html
expect_pass "Hugo-minified stylesheet link"

printf '<link href=%s rel=stylesheet integrity="%s">\n<link href=%s rel=stylesheet integrity="%s">\n' \
    "$stylesheet_path" "$integrity" "$stylesheet_path" "$integrity" > public/index.html
expect_fail "duplicate stylesheet links"

printf '<link href="%s" rel=stylesheet integrity="%s">\n' \
    "$stylesheet_path" "$integrity" > public/index.html
expect_fail "mixed stylesheet link quoting"

wrong_path="/css/main.min.$(printf '%064d' 0).css"
wrong_stylesheet="public$wrong_path"
cp "$stylesheet_file" "$wrong_stylesheet"
printf '<link href=%s rel=stylesheet integrity="%s">\n' \
    "$wrong_path" "$integrity" > public/index.html
expect_fail "wrong filename fingerprint"

printf '<link href=%s rel=stylesheet integrity="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=">\n' \
    "$stylesheet_path" > public/index.html
expect_fail "wrong stylesheet integrity"

if [ "$failures" -ne 0 ]; then
    echo "$failures CSS migration checker test(s) failed" >&2
    exit 1
fi

echo "CSS migration checker tests passed ($fingerprint)"
