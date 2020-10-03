clean:
	bundle exec jekyll clean

build: clean
	bundle exec jekyll build

server:
	bundle exec jekyll server

watch:
	bundle exec jekyll server --watch
