{% from "ckan/map.jinja" import ckan with context %}

{% set home = salt['user.info'](ckan.ckan_user).get('home', ckan.ckan_home) %}

ckan-user:
  user.present:
    - name: {{ ckan.ckan_user }}
    - home: {{ home }}
    - createhome: True
    - system: True
    - shell: /bin/bash

{{ ckan.ckan_home }}:
  file.directory:
    - user: {{ ckan.ckan_user }}

{{ ckan.ckan_home }}/bin:
  file.directory:
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
  file.directory:
    - name: {{ ckan_src }}
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}
    - recurse:
      - user
      - group

ckan:
  pip.installed:
    - editable: {{ ckan_src }}
    - bin_env: {{ ckan.venv_path }}
    - user: {{ ckan.ckan_user }}
    - require:
      - virtualenv: ckan-venv
    - watch:
      - git: ckan-src

{% if grains['os_family'] == 'RedHat' -%}
postgresql-repo:
  # copied from https://github.com/saltstack-formulas/postgres-formula/blob/master/postgres/upstream.sls
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - source: https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG
    - source_hash: md5=78b5db170d33f80ad5a47863a7476b22
  pkgrepo.managed:
    - name: pgdg-9.4-centos
    - order: 1
    - humanname: PostgreSQL 9.4 $releasever - $basearch
    - baseurl: https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-$releasever-$basearch
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
    - require:
      - file: postgresql-repo

/etc/profile.d/pgsql.sh:
  file.managed:
    - contents:
      - export PATH=/usr/pgsql-9.4/bin:$PATH
{% endif %}

ckan-deps:
  pkg.installed:
    - pkgs:
      - {{ ckan.python_dev }}
      - {{ ckan.postgresql_libs }}  # required by psycopg2.
      {% if grains['os_family'] == 'RedHat' -%}
      - {{ ckan.postgresql_devel }}  # pg_config is here on RedHat.
      {% endif %}
    {% if grains['os_family'] == 'RedHat' -%}
    - require:
      - pkgrepo: postgresql-repo
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
    - force: true
