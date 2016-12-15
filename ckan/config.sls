{% from "ckan/map.jinja" import ckan with context %}
include:
  - ckan.install

{% set ckan_conffile = [ckan.confdir, ckan.conffile]|join('/') %}

{% if ckan.generate_config %}
make_config:
  cmd.run:
    - name: {{ ckan.venv_path }}/bin/paster make-config ckan {{ ckan.conffile }}
    - unless: test -f {{ ckan.conffile }}
    - user: {{ ckan.ckan_user }}
    - require:
      - pip: ckan
      - virtualenv: ckan-venv
      - file: {{ ckan.confdir }}
{% else %}
ckan-ini-file:
  file.managed:
    - name: {{ ckan_conffile }}
    - source: salt://ckan/files/deployment.ini
    - template: jinja
    - backup: minion
    - require:
      - file: {{ ckan.confdir }}
{% endif %}
