{% from "ckan/map.jinja" import ckan, solr, supervisor_confdir with context %}

include:
  - solr
  - ckan.install
{% if grains['os_family'] == 'RedHat' %}
  - ckan.supervisor
{% endif %}

solr-schema:
  file.copy:
    {% if 'multilingual_dataset' in salt['pillar.get']('ckan:lookup:standard_plugins')  %}
    - source: {{ ckan.src_dir }}/ckan/ckanext/multilingual/solr/schema.xml
    {% else %}
    - source: {{ ckan.src_dir }}/ckan/ckan/config/solr/schema.xml
    {% endif %}
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

{% if 'multilingual_dataset' in salt['pillar.get']('ckan:lookup:standard_plugins')  %}
{% for stop_filename in salt['file.readdir'](ckan.src_dir + '/ckan/ckanext/multilingual/solr') if stop_filename.ends
{{ stop_filename }}:
  file.copy:
    - source: {{ ckan.src_dir }}/ckan/ckanext/multilingual/solr/{{ stop_filename }}
    {% if grains['os_family'] == 'Debian' %}
    - name: /usr/share/solr/conf/{{ stop_filename }}
    - watch_in:
      - service: solr
    {% elif grains['os_family'] == 'RedHat' %}
    - name: {{ solr.home }}/solr/collection1/conf/{{ stop_filename }}
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
{% endfor %}
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
