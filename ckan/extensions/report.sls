{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.supervisor
  - ckan.config
  - ckan.redis_install

report:
  ckanext.installed:
    - require:
      - virtualenv: {{ ckan.venv_path }}

report_crontab:
  file.managed:
    - name: {{ ckan.ckan_home }}/bin/ckanext-report-run.sh
    - source: salt://ckan/extensions/files/ckanext-report-run.sh
    - user: {{ ckan.ckan_user }}
    - mode: 0755
    - template: jinja
  pkg.installed:
    - name: {{ ckan.cron_pkg }}
  cron.present:
    - name: {{ ckan.ckan_home }}/bin/ckanext-report-run.sh
    - hour: '6'
    - user: {{ ckan.ckan_user }}
