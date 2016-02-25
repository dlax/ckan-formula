{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

dcat:
  ckanext.installed:
    - requirements_file: 'requirements.txt'
    - rev: '54f6366a5c6368e70cc136b32fe7b2006f30ee27'
    - require:
      - virtualenv: {{ ckan.venv_path }}
