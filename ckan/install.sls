{% from "ckan/map.jinja" import ckan with context %}

{% set home = salt['user.info'](ckan.ckan_user).get('home', ckan.ckan_home) %}

ckan-user:
  user.present:
    - name: {{ ckan.ckan_user }}
    - home: {{ home }}
    - createhome: True
    - system: True
    - shell: /bin/bash
  group.present:
    - name: {{ ckan.ckan_group }}
    - system: True
    - addusers:
      - {{ ckan.ckan_user }}
    - require:
      - user: ckan-user

{{ ckan.ckan_home }}:
  file.directory:
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}

{{ ckan.ckan_home }}/bin:
  file.directory:
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}

{{ ckan.src_dir }}:
  file.directory:
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}

ckan-venv:
  pkg.installed:
    - pkgs:
      - {{ ckan.python_pip }}

  cmd.run:
    - name: pip install --user virtualenv
    - user: {{ ckan.ckan_user }}
    - creates: {{ home }}/.local/bin/virtualenv

  {% if ckan.scratch_venv -%}
  file.absent:
    - name: {{ ckan.venv_path }}
  {%- endif %}

  virtualenv.managed:
    - name: {{ ckan.venv_path }}
    - venv_bin: {{ home }}/.local/bin/virtualenv
    - user: {{ ckan.ckan_user }}
    - require:
      - user: ckan-user

{% set ckan_src = ckan.src_dir + '/ckan' %}

ckan-src:
  git.latest:
    - rev: {{ ckan.ckan_rev }}
    - name: {{ ckan.ckan_repo }}
    - force_reset: true
    - target: {{ ckan_src }}
    - user: {{ ckan.ckan_user }}
    - require:
      - file: {{ ckan.src_dir }}
  file.directory:
    - name: {{ ckan_src }}
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}
    - recurse:
      - user
      - group

{% if grains['os_family'] == 'RedHat' -%}
gcc:
  pkg:
    - installed
{% endif -%}

ckan:
  pip.installed:
    - editable: {{ ckan_src }}
    - bin_env: {{ ckan.venv_path }}
    - user: {{ ckan.ckan_user }}
    - require:
      - virtualenv: ckan-venv
    {% if grains['os_family'] == 'RedHat' %}
      - pkg: gcc
    {% endif %}
    - watch:
      - git: ckan-src

{% if grains['os_family'] == 'RedHat' -%}
ckan_user_bash_profile:
  file.append:
    - name: {{ home }}/.bash_profile
    - text: |
        PATH=/usr/pgsql-9.4/bin/:$PATH
        export PATH
{% endif %}

ckan-deps:
  pkg.installed:
    - pkgs:
      - {{ ckan.python_dev }}
      - {{ ckan.postgresql_libs }}  # required by psycopg2.
      - gcc
      {% if grains['os_family'] == 'RedHat' -%}
      - {{ ckan.postgresql_contrib }}  # pg_config is here on RedHat.
      - {{ ckan.postgresql_devel }}
      {% endif %}
  pip.installed:
    - requirements: {{ ckan_src }}/requirements.txt
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan.venv_path }}
    - require:
      - pip: ckan
      {% if grains['os_family'] == 'RedHat' -%}
      - file: ckan_user_bash_profile
      {% endif %}

gunicorn:
  pip.installed:
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan.venv_path }}
    - require:
      - virtualenv: ckan-venv

{{ ckan.confdir }}:
  file.directory:
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}
    - makedirs: true
    - recurse:
      - user
      - group

{{ ckan.confdir}}/who.ini:
  file.symlink:
    - target: {{ ckan_src }}/who.ini
    - user: {{ ckan.ckan_user }}
    - force: true
    - require:
      - file: {{ ckan.confdir }}
