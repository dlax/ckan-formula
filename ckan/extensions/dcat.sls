{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

dcat:
  ckanext.installed:
    - requirements_file: 'requirements.txt'
    - rev: 'master'
    - require:
      - virtualenv: {{ ckan.venv_path }}
