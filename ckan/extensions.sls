{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.install

{% for extension, data in ckan.extensions.items() %}
{% set extname = 'ckanext-' + extension %}
{% set rev = data.get('rev') %}
{% set requirements_file = data.get('requirements_file') %}
{% set ckan_venv = ckan.ckan_home + '/venv' %}  # XXX duplicate declaration from ckan.install

{{ extname }}:
  ckanext.installed:
    - name: {{ extension }}
    - bin_env: {{ ckan_venv }}
    - requirements_file: {{ requirements_file }}
    - rev: {{ rev }}

{% endfor %}
