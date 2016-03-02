{% from "ckan/map.jinja" import ckan, supervisor_confdir with context %}

{% if 'datapusher' in ckan.standard_plugins %}

include:
  - ckan.install
  - ckan.supervisor

deps:
  pkg.installed:
    - pkgs:
      - {{ ckan.libxslt_dev }}
      - {{ ckan.libxml2_dev }}

{% set datapusher_src = ckan.src_dir + '/datapusher' %}

datapusher:
  git.latest:
    - name: https://github.com/ckan/datapusher
    - rev: master
    - target: {{ datapusher_src }}
    - require:
      - file: {{ ckan.src_dir }}
  file.directory:
    - name: {{ datapusher_src }}
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}
    - recurse:
      - user
      - group

  pip.installed:
    - editable: {{ datapusher_src }}
    - bin_env: {{ ckan.venv_path }}
    - user: {{ ckan.ckan_user }}
    - require:
      - virtualenv: ckan-venv
    - watch:
      - git: datapusher

datapusher deps:
  pip.installed:
    - requirements: {{ datapusher_src }}/requirements.txt
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan.venv_path }}
    - require:
      - pip: datapusher

gunicorn:
  pip.installed:
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan.venv_path }}
    - require:
      - virtualenv: ckan-venv

{{ supervisor_confdir }}/datapusher.conf:
  file.managed:
    - source: salt://ckan/files/datapusher-supervisor.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir

{% endif %}
