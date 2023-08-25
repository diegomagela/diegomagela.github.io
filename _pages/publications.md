---
layout: page
title: Publications
last-update: 2023-08-01
---

{% if site.data.publications.journal %}
<h3>Journal paper</h3>

{% for link in site.data.publications.journal %}


<div class="mb-5">

    <div class="mb-2 flex-none">
        {{ link.authors }}.
        <a href="{{ link.pdf }}">{{ link.title }}</a>,
        <em>{{ link.journal }}</em>,
        {{ link.year }}.
    </div>


    <div class="publications-link">

        {% if link.doi %}
        <a href="{{ link.doi }}">DOI</a>
        {% endif %}

        {% if link.pdf %}
        <a href="{{ link.pdf }}">PDF</a>
        {% endif %}

        {% if link.code %}
        <a href="{{ link.code }}">Code</a>
        {% endif %}

        {% if link.page %}
        <a href="{{ link.page }}">Project
            Page</a>
        {% endif %}

        {% if link.bibtex %}
        <a href="{{ link.bibtex }}">BibTeX</a>
        {% endif %}

        {% if link.notes %}
        <strong> <i style="color:#e74d3c">{{ link.notes }}</i></strong>
        {% endif %}

        {% if link.others %}
        {{ link.others }}
        {% endif %}

    </div>

</div>

{% endfor %}
{% endif %}

{% if site.data.publications.book %}
<h3>Book chapter</h3>

{% for link in site.data.publications.book %}

<div class="mb-5">

    <div class="mb-2 flex-none">
        {{ link.authors }}.
        <a href="{{ link.pdf }}">{{ link.title }}</a>,
        <em>{{ link.publisher }}</em>,
        {{ link.year }}.
    </div>

    <div class="publications-link">

        {% if link.doi %}
        <a href="{{ link.doi }}">DOI</a>
        {% endif %}

        {% if link.pdf %}
        <a href="{{ link.pdf }}">PDF</a>
        {% endif %}

        {% if link.code %}
        <a href="{{ link.code }}">Code</a>
        {% endif %}

        {% if link.page %}
        <a href="{{ link.page }}">Project
            Page</a>
        {% endif %}

        {% if link.bibtex %}
        <a href="{{ link.bibtex }}">BibTeX</a>
        {% endif %}

        {% if link.notes %}
        <strong> <i style="color:#e74d3c">{{ link.notes }}</i></strong>
        {% endif %}

        {% if link.others %}
        {{ link.others }}
        {% endif %}

    </div>

</div>

{% endfor %}
{% endif %}

{% if site.data.publications.proceedings %}
<h3>Proceedings</h3>

{% for link in site.data.publications.proceedings %}

<div class="mb-5">

    <div class="mb-2 flex-none">
        {{ link.authors }}.
        <a href="{{ link.pdf }}">{{ link.title }}</a>,
        <em>{{ link.conference }}</em>,
        {{ link.year }}.
    </div>

    <div class="publications-link mb-4">

        {% if link.doi %}
        <a href="{{ link.doi }}">DOI</a>
        {% endif %}

        {% if link.pdf %}
        <a href="{{ link.pdf }}">PDF</a>
        {% endif %}

        {% if link.code %}
        <a href="{{ link.code }}">Code</a>
        {% endif %}

        {% if link.page %}
        <a href="{{ link.page }}">Project
            Page</a>
        {% endif %}

        {% if link.bibtex %}
        <a href="{{ link.bibtex }}">BibTeX</a>
        {% endif %}

        {% if link.notes %}
        <strong> <i style="color:#e74d3c">{{ link.notes }}</i></strong>
        {% endif %}

        {% if link.others %}
        {{ link.others }}
        {% endif %}

    </div>

</div>

{% endfor %}
{% endif %}