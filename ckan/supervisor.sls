{% from "ckan/map.jinja" import ckan with context %}

{% if grains['os_family'] == 'Debian' %}
supervisor:
  pkg:
    - installed

/etc/supervisor/conf.d:
  file:
    - directory
{% endif %}
