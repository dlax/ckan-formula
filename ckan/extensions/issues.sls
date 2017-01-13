{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

issues:
  ckanext.installed:
    - rev: '1a91e25bff2d10b320d55332a721106190069aae'
    - require:
      - virtualenv: {{ ckan.venv_path }}
