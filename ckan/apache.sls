{% from "ckan/map.jinja" import ckan with context %}

include:
  - ckan.config

{% set ckan_conffile = [ckan.confdir, ckan.conffile]|join('/') %}

{{ [ckan.confdir, 'apache.wsgi']|join('/') }}:
  file.managed:
    - source: salt://ckan/files/apache.wsgi
    - template: jinja
    - context:
        ckan_conffile: {{ ckan_conffile }}
    - user: {{ ckan.ckan_user }}
