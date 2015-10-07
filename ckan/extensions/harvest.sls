{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.supervisor

redis-server:
  pkg:
    - installed
    - name: {{ ckan.redis_pkg }}

harvest:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: 'master'
    - require:
      - virtualenv: {{ ckan.venv_path }}

{% if grains['os_family'] == 'Debian' %}
/etc/supervisor/conf.d/ckanext-harvest.conf:
  file.managed:
    - source: salt://ckan/extensions/files/supervisor-harvest.conf
    - template: jinja
    - require:
      - file: supervisor_confdir
{% endif %}
