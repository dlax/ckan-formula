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
    - rev: '6e555f5a06b515135fc85445de529a4a0ef5dac0'
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: packages_deps
