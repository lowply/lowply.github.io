.PHONY: build check local

build:
	hugo --cleanDestinationDir

check: build
	./script/check-css-migration.sh
	./script/test-check-css-migration.sh

local:
	hugo server --config config.yaml,config-local.yaml
