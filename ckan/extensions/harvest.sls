{% from "ckan/map.jinja" import ckan, supervisor_confdir with context %}

include:
  - ckan.install
  - ckan.supervisor
  - ckan.config
  - ckan.redis_install

harvest:
  ckanext.installed:
    - requirements_file: 'pip-requirements.txt'
    - require:
      - virtualenv: {{ ckan.venv_path }}

{{ supervisor_confdir }}/ckanext-harvest.conf:
  file.managed:
    - source: salt://ckan/extensions/files/supervisor-harvest.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir

harvest_crontab:
  file.managed:
    - name: {{ ckan.ckan_home }}/bin/ckanext-harvest-run.sh
    - source: salt://ckan/extensions/files/ckanext-harvest-run.sh
    - user: {{ ckan.ckan_user }}
    - mode: 0755
    - template: jinja
  pkg.installed:
    - name: {{ ckan.cron_pkg }}
  cron.present:
    - name: {{ ckan.ckan_home }}/bin/ckanext-harvest-run.sh
    - minute: '*/15'
    - user: {{ ckan.ckan_user }}

{% if grains['pythonversion'][:2] < [2, 7] %}
ssl-sni-deps:
  pkg.installed:
    - pkgs:
      - {{ ckan.libffi_dev }}
      - {{ ckan.libssl_dev }}

{% for pippkg in ['pyopenssl', 'ndg-httpsclient', 'pyasn1'] %}
{{ pippkg }}:
  pip.installed:
    - bin_env: {{ ckan.venv_path }}
    - user: {{ ckan.ckan_user }}
    - require:
      - ckanext: harvest
      - pkg: ssl-sni-deps
{% endfor %}
{% endif %}
