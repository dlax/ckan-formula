{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

datastorer:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: '0808e1faedb92c34a87c7a206115b7837fef6675'
    - require:
      - virtualenv: {{ ckan.venv_path }}
