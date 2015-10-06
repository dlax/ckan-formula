{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install

{% for extension, data in ckan.extensions.items() %}
{% set extname = 'ckanext-' + extension %}
{% set repourl = data.get('repourl', 'https://github.com/ckan/' + extname) %}
{% set rev = data.get('rev', None) %}
{% set srcdir = [ckan.src_dir, extname]|join('/') %}
{% set requirements_file = [srcdir, data.get('requirements_file', 'pip-requirements.txt')]|join('/') %}
{% set ckan_venv = ckan.ckan_home + '/venv' %}  # XXX duplicate declaration from ckan.install

{{ extname }}:
  git.latest:
    - name: {{ repourl }}
    - target: {{ srcdir }}
    - rev: {{ rev }}

  file.directory:
    - name: {{ srcdir }}
    - user: {{ ckan.ckan_user }}
    - recurse:
      - user
    - require:
      - user: ckan-user
      - git: {{ extname }}

  pip.installed:
    - editable: {{ srcdir }}
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan_venv }}
    - require:
      - virtualenv: ckan-venv
    - watch:
      - git: {{ extname }}

{% if salt['file.file_exists'](requirements_file) %}
{{ extname }}-deps:
  pip.installed:
    - requirements: {{ requirements_file }}
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan_venv }}
    - require:
      - virtualenv: ckan-venv
      - pip: {{ extname }}
{% endif %}

{% endfor %}

