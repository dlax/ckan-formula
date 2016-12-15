{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

{% set ckan_conffile = [ckan.confdir, ckan.conffile]|join('/') %}

postgresql-client:
  pkg.installed:
    - name: {{ ckan.postgresql_client }}

init_databases:
  cmd.run:
    - name: {{ ckan.venv_path }}/bin/paster --plugin=ckan db init -c {{ ckan_conffile }}
    - runas: {{ ckan.ckan_user }}
    - require:
      - pip: ckan
      - virtualenv: ckan-venv
      - file: ckan-ini-file
      - pkg: postgresql-client

{% for extname in ckan.extensions %}
{{ extname }}-init-db:
  ckanext.init_db:
    - name: {{ extname }}
{% endfor %}
