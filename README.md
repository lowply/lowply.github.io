# lowply.github.io

[lowply.github.io](https://lowply.github.io) - A blog and photo journal by @lowply

### Setup

Clone and install furniture theme as a submodule

```bash
$ git clone https://github.com/lowply/lowply.github.io.git
$ cd lowply.github.io
$ git submodule update -i
$ cd .hugo/themes/furniture/
$ make install
$ make build
```

### Run dev server for preview

```bash
$ cd /path/to/lowply.github.io/.hugo
$ make watch
```

### Build and deploy

```bash
$ cd /path/to/lowply.github.io/.hugo
$ make build
$ cd ..
```

Then push changes to the master branch.

### Start writing a new post

New post

```bash
$ ./new.sh a-sample-post
```

### Author

Sho Mizutani
