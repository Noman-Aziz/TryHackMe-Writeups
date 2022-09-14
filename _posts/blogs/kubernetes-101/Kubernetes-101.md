---
layout: post
title: "Kubernetes 101"
category: blogs
---

_K8 is an open source container orchestration tool developed by Google which helps you manage containerized applications in different deployment environments like physical, virtual, cloud or hybrid etc._

<!--more-->

<div class="posts">
  {% for post in site.posts %}
    {% if post.categories contains 'k8-blogs' %}

    <article class="post">

      <h1><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></h1>

      <div class="entry">
        {{ post.excerpt }}
      </div>

    <a href="{{ site.baseurl }}{{ post.url }}" class="read-more">Read More</a>
    </article>


    <!-- added by dummys */ -->
    <div class="line-separator"></div>

    {% endif %}
    {% endfor %}

</div>
