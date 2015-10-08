{% from "ckan/map.jinja" import ckan with context %}

ckan-user:
  user.present:
    - name: {{ ckan.ckan_user }}
    - home: {{ ckan.ckan_home }}
    - createhome: True
    - system: True
    - shell: /bin/bash
  file.directory:
    - name: {{ ckan.ckan_home }}/bin
    - user: {{ ckan.ckan_user }}

ckan-venv:
  pkg.installed:
    - pkgs:
      - python-virtualenv
      - python-pip

  {% if ckan.scratch_venv -%}
  file.absent:
    - name: {{ ckan.venv_path }}
  {%- endif %}

  virtualenv.managed:
    - name: {{ ckan.venv_path }}
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
      - {{ ckan.python_dev }}
      - {{ ckan.postgresql_libs }}  # required by psycopg2.
      {% if grains['os_family'] == 'RedHat' -%}
      - postgresql-devel  # pg_config is here on RedHat.
      {% endif %}
  pip.installed:
    - requirements: {{ ckan_src }}/requirements.txt
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan.venv_path }}
    - require:
      - pip: ckan

{{ ckan.confdir }}:
  file.directory:
    - user: {{ ckan.ckan_user }}
    - makedirs: true
    - recurse:
      - user

{{ ckan.confdir}}/who.ini:
  file.symlink:
    - target: {{ ckan_src }}/who.ini
    - user: {{ ckan.ckan_user }}
