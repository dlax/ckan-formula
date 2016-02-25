#/bin/sh
{% from "ckan/map.jinja" import ckan with context %}
{{ ckan.venv_path }}/bin/paster \
  --plugin=ckanext-report report generate \
  --config={{ [ckan.confdir, ckan.conffile]|join('/') }} \
  >> {{ [ckan.ckan_home, 'ckanext-report.log']|join('/') }} 2>&1
