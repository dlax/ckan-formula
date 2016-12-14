{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

issues:
  ckanext.installed:
    - rev: '61db215d9a51a635162654a12055cd9bcd51e7de'
    - require:
      - virtualenv: {{ ckan.venv_path }}
