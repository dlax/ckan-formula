{% from "ckan/map.jinja" import ckan with context %}
include:
{% for extname in ckan.get('extensions', []) -%}
  - ckan.extensions.{{ extname }}
{% endfor %}
