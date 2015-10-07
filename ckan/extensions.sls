{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install

{% for extension, data in ckan.extensions.items() %}
{% set extname = 'ckanext-' + extension %}
{% set rev = data.get('rev') %}
{% set requirements_file = data.get('requirements_file') %}

{{ extname }}:
  ckanext.installed:
    - name: {{ extension }}
    - requirements_file: {{ requirements_file }}
    - rev: {{ rev }}
    - require:
      - virtualenv: {{ ckan.venv_path }}

{% endfor %}
