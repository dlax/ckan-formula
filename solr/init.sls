include:
{% if grains['os_family'] == 'Debian' %}
  - solr.debian
{% elif grains['os_family'] == 'RedHat' %}
  - solr.redhat
{% endif %}
