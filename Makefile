build:
	hugo --cleanDestinationDir

local:
	hugo server --config config.yaml,config-local.yaml
