---
layout: default
title: CTF Writeups
category: writeups
---

<body>
  <header>
    <div class="container">
      <h3><center><script src="https://tryhackme.com/badge/514120"></script></center></h3>
    </div>
  </header>
</body>

<div class="posts">
  {% for post in site.posts %}
    {% if post.categories contains 'writeups' %}

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
