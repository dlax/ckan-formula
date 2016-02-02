{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config
  - ckan.extensions.archiver

qa:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: 'ca9aaaa6adc30c1295fc7786a5741bf6477ea5a7'
    - require:
      - virtualenv: {{ ckan.venv_path }}
