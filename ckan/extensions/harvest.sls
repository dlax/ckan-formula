{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.supervisor
  - ckan.config
  - ckan.redis_install

harvest:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: '89b6ad2ce1ef08c15886e989ff09beaf86f6ba0d'
    - require:
      - virtualenv: {{ ckan.venv_path }}

{% if grains['os_family'] == 'Debian' %}
{% set supervisor_confdir = '/etc/supervisor/conf.d/' %}
{% else %}
# XXX duplicate from ckan/supervisor.sls
{% set supervisor_confdir = [ckan.ckan_home, 'etc', 'supervisor']|join('/') %}
{% endif %}

{{ supervisor_confdir }}/ckanext-harvest.conf:
  file.managed:
    - source: salt://ckan/extensions/files/supervisor-harvest.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir

harvest_crontab:
  file.managed:
    - name: {{ ckan.ckan_home }}/bin/ckanext-harvest-run.sh
    - source: salt://ckan/extensions/files/ckanext-harvest-run.sh
    - user: {{ ckan.ckan_user }}
    - mode: 0755
    - template: jinja
  pkg.installed:
    - name: {{ ckan.cron_pkg }}
  cron.present:
    - name: {{ ckan.ckan_home }}/bin/ckanext-harvest-run.sh
    - minute: '*/15'
    - user: {{ ckan.ckan_user }}
