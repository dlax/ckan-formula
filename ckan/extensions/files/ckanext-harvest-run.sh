#/bin/sh
{% from "ckan/map.jinja" import ckan with context %}
. {{ [ckan.confdir, 'environment.sh']|join('/') }}
{{ ckan.venv_path }}/bin/paster --plugin=ckanext-harvest harvester run --config={{ [ckan.confdir, ckan.conffile]|join('/') }}
