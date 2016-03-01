{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.supervisor
  - ckan.config
  - ckan.redis_install


packages_deps:
  pkg.installed:
    - pkgs:
      - {{ ckan.libxml2_dev }}
      - {{ ckan.libxslt_dev }}

archiver:
  ckanext.installed:
    - rev: 'd570c348bfb4070ec178d4745edf8bec8d8e1810'
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: packages_deps

{% if grains['os_family'] == 'Debian' %}
{% set supervisor_confdir = '/etc/supervisor/conf.d/' %}
{% else %}
# XXX duplicate from ckan/supervisor.sls
{% set supervisor_confdir = [ckan.ckan_home, 'etc', 'supervisor']|join('/') %}
{% endif %}

{{ supervisor_confdir }}/ckanext-archiver.conf:
  file.managed:
    - source: salt://ckan/extensions/files/supervisor-archiver.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir
