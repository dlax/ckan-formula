{% from "ckan/map.jinja" import ckan, solr, supervisor_confdir with context %}

include:
  - solr
  - ckan.install
{% if grains['os_family'] == 'RedHat' %}
  - ckan.supervisor
{% endif %}

solr-schema:
  file.copy:
    - source: {{ ckan.src_dir }}/ckan/ckan/config/solr/schema.xml
    {% if grains['os_family'] == 'Debian' %}
    - name: /usr/share/solr/conf/schema.xml
    - watch_in:
      - service: solr
    {% elif grains['os_family'] == 'RedHat' %}
    - name: {{ solr.home }}/solr/collection1/conf/schema.xml
    {% endif %}
    - force: True
    - makedirs: True
    - require:
      - git: ckan-src
      {% if grains['os_family'] == 'Debian' %}
      - pkg: solr
      {% elif grains['os_family'] == 'RedHat' %}
      - archive: solr
      {% endif %}

{% if grains['os_family'] == 'RedHat' %}
{{ supervisor_confdir }}/solr.conf:
  file.managed:
    - source: salt://solr/files/solr-supervisor.conf
    - template: jinja
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}
    - require:
      - file: supervisor_confdir
{% endif %}

{% if grains['os_family'] == 'Debian' %}
/etc/default/jetty8:
  file.append:
    - text: JETTY_PORT=8983
    - require:
      - pkg: solr
{% endif %}
