{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

report:
  ckanext.installed:
    - repourl: https://github.com/datagovuk/ckanext-report
    - require:
      - virtualenv: {{ ckan.venv_path }}
