build:
	hugo --cleanDestinationDir

local:
	hugo server --config config-local.yaml

# More accurate local server
localm:
	hugo server --config config-local.yaml --minify
