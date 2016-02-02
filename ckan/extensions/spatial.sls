{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

geos-devel:
  pkg.installed:
    - name: {{ ckan.geos_dev }}

spatial:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: geos-devel
