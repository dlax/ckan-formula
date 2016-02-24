{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

report:
  ckanext.installed:
    - repourl: https://github.com/datagovuk/ckanext-report
    - rev: '3156c9db68bd663a08357cabf03eb01667e969e9'
    - require:
      - virtualenv: {{ ckan.venv_path }}
