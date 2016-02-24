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
    - rev: '9640a4d2b89f63c5492099cdb1920779378e0f5b'
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: packages_deps
