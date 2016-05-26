{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

datalocale:
  ckanext.installed:
    - requirements_file: 'requirements.txt'
    - require:
      - virtualenv: {{ ckan.venv_path }}
