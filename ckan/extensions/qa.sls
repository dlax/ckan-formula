{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config
  - ckan.extensions.archiver

qa:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - require:
      - virtualenv: {{ ckan.venv_path }}
