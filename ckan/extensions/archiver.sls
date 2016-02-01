{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config


packages_deps:
  pkg.installed:
    - pkgs:
      - {{ ckan.libxml2_dev }}
      - {{ ckan.libxslt_dev }}

archiver:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: '384e2d3088cc208a6ebe89cd5873008b6ac6518c'
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: packages_deps
