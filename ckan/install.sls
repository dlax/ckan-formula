{% from "ckan/map.jinja" import ckan with context %}

ckan-user:
  user.present:
    - name: {{ ckan.ckan_user }}
    - home: {{ ckan.ckan_home }}
    - createhome: True
    - system: True

{{ set ckan_venv = {{ ckan.ckan_home}} + '/venv' }}

venv:
  pkg.installed:
    - pkgs:
      - python-virtualenv
      - python-pip

  virtualenv.managed:
    - name: {{ ckan_venv }}
    - user: {{ ckan.ckan_user }}
    - require:
      - user: ckan-user

{{ set ckan_src = {{ ckan.src_dir}} + '/ckan' }}

ckan-src:
  git.latest:
    - name: {{ ckan.ckan_repo }}
    - target: {{ ckan_src }}

ckan:
  pip.installed:
    - editable: {{ ckan_src }}
  - require:
    - virtualenv: venv
  - watch:
    - git: ckan-src

ckan-deps:
  pip.installed:
    - requirements: {{ ckan_src }}/requirements.txt
    - user: {{ ckan_user }}
    - bin_env: {{ ckan_venv }}
    - require:
      - pip: ckan
