clean:
	bundle exec jekyll clean

build: clean
	bundle exec jekyll build

server:
	bundle exec jekyll server

watch:
	bundle exec jekyll server -H 0.0.0.0 --watch

new:
	bundle exec jekyll post "placeholder" --timestamp-format "%Y-%m-%d %H:%M:%S %z"
