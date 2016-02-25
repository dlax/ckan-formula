{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

datastorer:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - branch: datalocale
    - rev: '8ff51edea08b321550f6d950ea99eee4394df57e'
    - require:
      - virtualenv: {{ ckan.venv_path }}
