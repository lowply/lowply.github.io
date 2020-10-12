---
layout: default
title: lowply.github.io
---

Hi, I'm [@lowply](https://twitter.com/lowply).

[I work at GitHub](https://github.com/lowply) as a Lead Support Engineer. [I sometimes write some code](https://github.com/lowply?tab=repositories), currently learning [Go](https://github.com/lowply?tab=repositories&q=&type=&language=go). [I take some photos](https://instagram.com/lowply) with various cameras. [I try to write a photo journal](/photo) when travelling. [I used to play Drum & Bass](https://www.mixcloud.com/lowply) at night clubs as a Good Looking Records' adovocate.

I'm based in Tokyo, Japan.

## Recent Posts

{% for post in site.categories.blog limit:5 %}

- <small class="date">{{ post.date | date: "%Y-%m-%d" }}</small> [{{ post.title }}]({{ post.url }})

{% endfor %}
