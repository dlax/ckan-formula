{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

issues:
  ckanext.installed:
    - require:
      - virtualenv: {{ ckan.venv_path }}
