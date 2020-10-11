---
layout: default
title: Blog Posts
---

{% for post in site.categories.blog %}
- <div class="date">{{ post.date | date: "%Y-%m-%d" }}</div> [{{ post.title }}]({{ post.url }})
{% endfor %}

