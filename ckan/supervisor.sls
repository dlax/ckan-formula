{% from "ckan/map.jinja" import ckan, supervisor_confdir with context %}

include:
  - ckan.install

{% if grains['os_family'] == 'Debian' %}

supervisor:
  pkg:
    - installed

supervisor_confdir:
  file.directory:
    - name: {{ supervisor_confdir }}
    - require:
      - pkg: supervisor

{% elif grains['os_family'] == 'RedHat' %}

supervisor:
  pip.installed:
    - bin_env: {{ ckan.venv_path }}
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - user: {{ ckan.ckan_user }}

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

{{ supervisor_confdir }}/celery.conf:
  file.managed:
    - source: salt://ckan/files/celery-supervisor.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir

{{ supervisor_confdir }}/ckan.conf:
  file.managed:
    - source: salt://ckan/files/ckan-supervisor.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir
