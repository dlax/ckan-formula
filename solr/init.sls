include:
  {% if grains['os'] == 'Debian' %}
  - solr.debian
  {% elif grains['os'] == 'RedHat' %}
  - solr.redhat
  {% endif %}
