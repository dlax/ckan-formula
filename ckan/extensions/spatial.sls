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
    - require:
      - virtualenv: {{ ckan.venv_path }}
      - pkg: geos-devel
