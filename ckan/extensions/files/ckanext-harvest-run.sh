#/bin/sh
{% from "ckan/map.jinja" import ckan with context %}
source {{ [ckan.confdir, 'environment.sh']|join('/') }}
{{ ckan.ckan_home }}/bin/paster --plugin=ckanext-harvest harvester run --config={{ [ckan.confdir, ckan.conffile]|join('/') }}
