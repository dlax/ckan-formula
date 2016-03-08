{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install
  - ckan.config

geos-devel:
  pkg.installed:
    - pkgs:
      - {{ ckan.geos_dev }}
      - {{ ckan.libxml2_dev }}
      - {{ ckan.libxslt_dev }}
      - gcc

spatial:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - rev: 'f6cf9cd3f00945b29d6df6d16d7487651811cbf8'
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: geos-devel
