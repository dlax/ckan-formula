{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

datastorer:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - require:
      - virtualenv: {{ ckan.venv_path }}
