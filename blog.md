---
layout: default
title: Blog Posts
---

{% for post in site.categories.blog %}
- <small class="date">{{ post.date | date: "%Y-%m-%d" }}</small> [{{ post.title }}]({{ post.url }})
{% endfor %}

