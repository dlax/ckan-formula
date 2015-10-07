{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install

redis-server:
  pkg:
    - installed
    - name: {{ ckan.redis_pkg }}

harvest:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: 'master'
    - require:
      - virtualenv: {{ ckan.venv_path }}
