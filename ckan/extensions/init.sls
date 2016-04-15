{% from "ckan/map.jinja" import ckan with context %}
{% if ckan.install_extensions %}
include:
{% for extname in ckan.install_extensions -%}
  - ckan.extensions.{{ extname }}
{% endfor %}
{% endif %}
