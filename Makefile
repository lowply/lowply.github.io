clean:
	bundle exec jekyll clean

build: clean
	bundle exec jekyll build

watch: clean
	bundle exec jekyll server --watch --config _config.yml,_config_local.yml

new:
	bundle exec jekyll post "placeholder" --timestamp-format "%Y-%m-%d %H:%M:%S %z"
