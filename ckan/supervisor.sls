{% from "ckan/map.jinja" import ckan, supervisor_confdir with context %}

include:
  - ckan.install

{% if grains['os_family'] == 'Debian' %}

supervisor:
  pkg:
    - installed

supervisor_confdir:
  file.directory:
    - name: {{ supervisor_confdir }}
    - require:
      - pkg: supervisor

{% elif grains['os_family'] == 'RedHat' %}

supervisor:
  pip.installed:
    - user: {{ ckan.ckan_user }}
    - install_options:
      - --user
    - require:
      - user: {{ ckan.ckan_user }}

{% for fname in ('supervisorctl', 'supervisord') %}
{{ ckan.ckan_home }}/bin/{{ fname }}:
  file.symlink:
    - target: {{ ckan.ckan_home }}/.local/bin/{{ fname }}
    - user: {{ ckan.ckan_user }}
    - makedirs: true
    - require:
      - pip: supervisor
{% endfor %}

remove old supervisor dir:
  file.absent:
    - name: {{ [ckan.ckan_home, 'etc', 'supervisor']|join('/') }}

supervisor_confdir:
  file.directory:
    - name: {{ supervisor_confdir }}
    - user: {{ ckan.ckan_user }}
    - require:
      - file: {{ ckan.confdir }}
      - user: {{ ckan.ckan_user }}

{{ ckan.ckan_home }}/etc/supervisord.conf:
  file.managed:
    - source: salt://ckan/files/supervisord.conf
    - template: jinja
    - user: {{ ckan.ckan_user }}
    - require:
      - file: {{ ckan.confdir }}

{% endif %}

{% for name in ('celery', 'ckan', 'redis') %}
{{ supervisor_confdir }}/{{ name }}.conf:
  file.managed:
    - source: salt://ckan/files/{{ name }}-supervisor.conf
    - template: jinja
    {% if grains['os_family'] != 'Debian' %}
    - user: {{ ckan.ckan_user }}
    {% endif %}
    - require:
      - file: supervisor_confdir
      - pip: gunicorn
{% endfor %}
