---
layout: default
title: Photo Journals
---

<ul class="photo">
{% for post in site.categories.photo %}
    <li>
        <a href="{{ post.url }}" style="background-image:url('{{ site.assets }}{{ post.id }}/{{ post.top }}');"></a>
        <div>{{ post.title }}<small>{{ post.location }}</small></div>
    </li>
{% endfor %}
</ul>
