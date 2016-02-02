{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config
  - ckan.extensions.report


packages_deps:
  pkg.installed:
    - pkgs:
      - {{ ckan.libxml2_dev }}
      - {{ ckan.libxslt_dev }}

archiver:
  ckanext.installed:
    - requirements_file: 'requirements.txt'
    - rev: 'master'
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: packages_deps
