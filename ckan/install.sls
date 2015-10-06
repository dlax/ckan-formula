{% from "ckan/map.jinja" import ckan with context %}

ckan-user:
  user.present:
    - name: {{ ckan.ckan_user }}
    - home: {{ ckan.ckan_home }}
    - createhome: True
    - system: True
    - shell: /bin/bash

{% set ckan_venv = ckan.ckan_home + '/venv' %}

ckan-venv:
  pkg.installed:
    - pkgs:
      - python-virtualenv
      - python-pip

  virtualenv.managed:
    - name: {{ ckan_venv }}
    - user: {{ ckan.ckan_user }}
    - require:
      - user: ckan-user

{% set ckan_src = ckan.src_dir + '/ckan' %}

ckan-src:
  git.latest:
    - rev: {{ ckan.ckan_rev }}
    - name: {{ ckan.ckan_repo }}
    - target: {{ ckan_src }}

ckan:
  pip.installed:
    - editable: {{ ckan_src }}
    - require:
      - virtualenv: ckan-venv
    - watch:
      - git: ckan-src

ckan-deps:
  pkg.installed:
    - pkgs:
      - python-dev
      - libpq-dev  # required by psycopg2.
  pip.installed:
    - requirements: {{ ckan_src }}/requirements.txt
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan_venv }}
    - require:
      - pip: ckan

{% set ckan_confdir = [ckan.ckan_home, 'etc', 'ckan', 'default']|join('/') %}

{{ ckan_confdir }}:
  file.directory:
    - user: {{ ckan.ckan_user }}
    - makedirs: true
    - recurse:
      - user

{% set ckan_conffile = [ckan_confdir, 'development.ini']|join('/') %}

make_config:
  cmd.run:
    - name: {{ ckan_venv}}/bin/paster make-config ckan {{ ckan_conffile }}
    - unless: test -f {{ ckan_conffile }}
    - user: {{ ckan.ckan_user }}
    - require:
      - pip: ckan
      - virtualenv: ckan-venv
      - file: {{ ckan_confdir }}

ckan_environmnent:
  file.managed:
    - name: {{ ckan_confdir }}/environment.sh
    - source: salt://ckan/environment.sh
    - template: jinja
    - user: {{ ckan.ckan_user }}
    - mode: 0700
    - require:
      - file: {{ ckan_confdir }}

ckan_user_bashrc:
  file.append:
    - name: {{ ckan.ckan_home }}/.bashrc
    - text: source {{ ckan_confdir }}/environment.sh
