#/bin/sh
{% from "ckan/map.jinja" import ckan with context %}
{{ ckan.venv_path }}/bin/paster \
  --plugin=ckanext-harvest harvester run \
  --config={{ [ckan.confdir, ckan.conffile]|join('/') }} \
  >> {{ [ckan.ckan_home, 'harvester.log']|join('/') }} 2>&1
