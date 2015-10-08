{% from "ckan/map.jinja" import ckan with context %}
include:
{% for extname in ckan.extensions -%}
  - ckan.extensions.{{ extname }}
{% endfor %}
