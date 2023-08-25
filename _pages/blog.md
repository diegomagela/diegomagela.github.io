---
layout: page
---

Music, movies, and some random thoughts about life.

<div class="archive">

    {% for post in site.categories["blog"] %}

    <!-- Calculate the reading time -->
    {% assign words = post.content | number_of_words %}
    {% assign time = words | divided_by: 150 | plus: 1 %}


    <div class="archive-item d-md-flex">
        <a href="{{ site.baseurl }}{{ post.url }}" class="flex-none">
            {{ post.title }}
        </a>

        <div class="spacer d-none d-md-block"></div>

        <div class="archive-date flex-none">
            {{ post.date | date: "%B %d, %Y" }}
            <!-- &middot;
                    {{ time }} min. read -->
        </div>

    </div>

    <div class="archive-description d-md-flex">
        {{ post.excerpt }}
    </div>

    {% endfor %}

</div>