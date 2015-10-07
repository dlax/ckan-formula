{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install

archiver:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: 'master'
    - require:
      - virtualenv: {{ ckan.venv_path }}
