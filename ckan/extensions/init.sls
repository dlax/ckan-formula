{% from "ckan/map.jinja" import ckan with context %}
{% if ckan.extensions %}
include:
{% for extname in ckan.extensions -%}
  - ckan.extensions.{{ extname }}
{% endfor %}
{% endif %}
