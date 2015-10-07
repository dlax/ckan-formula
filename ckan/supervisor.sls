{% from "ckan/map.jinja" import ckan with context %}

{% if grains['os_family'] == 'Debian' %}
supervisor:
  pkg:
    - installed

supervisor_confdir:
  file.directory:
    - name: /etc/supervisor/conf.d
    - require:
      - pkg: supervisor
{% endif %}
