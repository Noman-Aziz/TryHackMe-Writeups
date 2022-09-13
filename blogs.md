---
layout: default
---

<div class="blogs">
  {% for blog in site.blogs %}
    <article class="blog">

      <h1><a href="{{ site.baseurl }}{{ blog.url }}">{{ blog.title }}</a></h1>

      <div class="entry">
        {{ blog.excerpt }}
      </div>

    <a href="{{ site.baseurl }}{{ blog.url }}" class="read-more">Read More</a>
    </article>


    <!-- added by dummys */ -->
    <div class="line-separator"></div>


    {% endfor %}

</div>
