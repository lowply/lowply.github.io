---
layout: default
title: Photo Journals
---

{% if site.url == "https://lowply.github.io" %}
    {% assign imgpath = site.imghost | append: "/lowply.github.io/images" %}
{% else %}
    {% assign imgpath = "/images" %}
{% endif %}

<ul class="photo">
{% for post in site.categories.photo %}
    <li>
        <a href="{{ post.url }}" style="background-image:url('{{ imgpath }}{{ post.id }}/{{ post.top }}');"></a>
        <div>{{ post.title }}<small>{{ post.location }}</small></div>
    </li>
{% endfor %}
</ul>
