{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install

{% if grains['os_family'] == 'Debian' %}

supervisor:
  pkg:
    - installed

{% set supervisor_confdir = '/etc/supervisor/conf.d' %}

supervisor_confdir:
  file.directory:
    - name: {{ supervisor_confdir }}
    - require:
      - pkg: supervisor

{% else %}

supervisor:
  pip.installed:
    - bin_env: {{ ckan.venv_path }}
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - user: {{ ckan.ckan_user }}

{% set supervisor_confdir = [ckan.ckan_home, 'etc', 'supervisor']|join('/') %}

supervisor_confdir:
  file.directory:
    - name: {{ supervisor_confdir }}
    - user: {{ ckan.ckan_user }}
    - require:
      - file: {{ ckan.confdir }}
      - user: {{ ckan.ckan_user }}

{{ supervisor_confdir }}/supervisord.conf:
  file.managed:
    - source: salt://ckan/files/supervisord.conf
    - template: jinja
    - context:
        supervisor_confdir: {{ supervisor_confdir }}
    - user: {{ ckan.ckan_user }}
    - require:
      - file: supervisor_confdir

{% endif %}

{{ supervisor_confdir}}/celery.conf:
  file.managed:
    - source: salt://ckan/files/celery-supervisor.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir

{{ supervisor_confdir}}/ckan.conf:
  file.managed:
    - source: salt://ckan/files/ckan-supervisor.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir
