---
title: Moving to Jekyll
aliases:
 - /blog/2020/10/moving-to-jekyll/
date: 2020-10-10T03:04:00+09:00
draft: false
---

## SSG, GitHub Pages and Jekyll 4

I changed the static site generator for this blog from [Hugo](https://gohugo.io/) to [Jekyll](https://jekyllrb.com/). Hugo is a fantastic tool and I still use it in my other projects, but it's not the perfect choice when used with [GitHub Pages](https://pages.github.com/).

The strongest pain point of the combination of static site generators like Hugo and GitHub Pages is that I had to commit and push the generated html files to [the repository](https://github.com/lowply/lowply.github.io/). Even a small fix to the template changes all files and the commit gets larger. Jekyll, however, is built into GitHub.com so I don't have to worry about it.

I know I could use a file hosting platform, such as Firebase or Netlify as a workaround. I even have created GitHub Actions to [build a Hugo site](https://github.com/lowply/build-hugo) and [deploy a site to Firebase](https://github.com/lowply/deploy-firebase). But I wanted to keep this domain. This is the main reason for me to switch.

In addition, Jekyll has become so much better than when I tried it last time. What I'm excited the most is the [switch to sassc](https://github.com/jekyll/jekyll-sass-converter/releases/tag/v2.0.0) in [Jekyll 4](https://github.com/jekyll/jekyll/blob/master/History.markdown#400--2019-08-19). Sass compilation is much faster.

GitHub releases [github/pages-gem](https://github.com/github/pages-gem), which is the [recommended way](https://jekyllrb.com/docs/github-pages/) to build GitHub Pages. [But it doesn't support Jekyll 4 yet](https://github.com/github/pages-gem/issues/651) so I didn't use it [^jekyll4]. Instead, I did `gem "jekyll"` like this:

```ruby
source "https://rubygems.org"

gem "jekyll", "~> 4.1.1"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem 'jekyll-compose'
end
```

## Images

I don't want to commit images and other binary files to the Git repository (even with [Git LFS](https://git-lfs.github.com/)!), so I decided to put every image on an S3 bucket. This isn't a bad idea, but uploading images only to preview the site is cumbersome.

Thankfully, Jekyll accepts [multiple configuration files](https://jekyllrb.com/docs/configuration/options/#build-command-options) to override variables. By doing the following, images are served by Jekyll when previewing the site locally while they are served by S3 when the site is published to the GitHub Pages host.

_\_config.yml_

```yaml
assets: https://lowply.s3-ap-northeast-1.amazonaws.com/lowply.github.io/assets
```

_\_config_local.yml_

```yaml
assets: /assets
```

_Makefile_

```make
watch: clean
	bundle exec jekyll server --watch --config _config.yml,_config_local.yml
```

_\_include/img.html_

```html
{% raw %}{% assign url = site.assets | append: page.id | append: "/" | append:
include.name %}

<a href="{{ url }}" title="{{ include.name }}">
 <img src="{{ url }}" width="{{ w }}" alt="{{ include.name }}" /> </a
>{% endraw %}
```

After making some adjustments to the code, I found myself being so fascinated by the flexibility of Jekyll and Liquid template engine. The full source is up at [lowply/lowply.github.io](https://github.com/lowply/lowply.github.io).

[^jekyll4]: This is because [GitHub Pages does not support Jekyll 4](https://pages.github.com/versions/). You can still use Jekyll 4 for local development like I do, but if you want to see the exact same output as GitHub Pages, you should use pages-gem.
