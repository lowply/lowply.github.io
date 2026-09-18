.PHONY: build local check

node_modules/bootstrap/package.json: package.json package-lock.json
	npm ci

build: node_modules/bootstrap/package.json
	hugo --cleanDestinationDir

local: node_modules/bootstrap/package.json
	hugo server --config config.yaml,config-local.yaml

check: build
	./script/check-css-migration.sh

