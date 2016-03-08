{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config
  - ckan.extensions.archiver

qa:
  ckanext.installed:
    - requirements_file: 'requirements.txt'
    - rev: '350b40221176cd140f1da04329e0427678c7bfcb'
    - require:
      - virtualenv: {{ ckan.venv_path }}
