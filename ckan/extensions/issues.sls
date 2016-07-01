{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

issues:
  ckanext.installed:
    - rev: '120aa0f0f963a80b9374fe0cbd5a26a21037e4c6'
    - require:
      - virtualenv: {{ ckan.venv_path }}
