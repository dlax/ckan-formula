{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

datapreview:
  ckanext.installed:
    - repourl: https://github.com/datagovuk/ckanext-datapreview
    - rev: '42e0d3e195e6a17e9f28ee8153d9d483bd91b4fd'
    - require:
      - virtualenv: {{ ckan.venv_path }}
