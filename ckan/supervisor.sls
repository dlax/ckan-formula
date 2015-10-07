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

{% else %}

supervisor:
  pip.installed:
    - bin_env: {{ ckan.venv_path }}
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - user: {{ ckan.ckan_user }}

{% set supervisor_confdir = [ckan.confdir, 'supervisor']|join('/') %}

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
