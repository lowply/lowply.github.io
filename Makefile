build:
	hugo --cleanDestinationDir

local:
	hugo server --config config-local.yaml --minify
