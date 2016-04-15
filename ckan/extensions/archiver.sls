{% from "ckan/map.jinja" import ckan, supervisor_confdir with context %}

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
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: packages_deps


{{ supervisor_confdir }}/ckanext-archiver.conf:
  file.managed:
    - source: salt://ckan/extensions/files/supervisor-archiver.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir

{{ supervisor_confdir }}/archive-server.conf:
  file.managed:
    - source: salt://ckan/extensions/files/archive-server.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir
