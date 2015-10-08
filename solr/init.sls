{% if grains['os_family'] == 'Debian' %}
include:
  - solr.debian
{% endif %}
