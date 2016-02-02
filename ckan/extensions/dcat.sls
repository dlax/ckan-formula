{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

dcat:
  ckanext.installed:
    - requirements_file: 'requirements.txt'
    - rev: '2899a42e83de0971d80b6bcc51fbfc40c93b7018'
    - require:
      - virtualenv: {{ ckan.venv_path }}
