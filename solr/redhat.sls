{% from "ckan/map.jinja" import solr, ckan with context %}

solr:
  pkg.installed:
     - pkgs:
       - java-1.7.0-openjdk
       - tar

  file.directory:
    - name: {{ solr.base_dist_dir }}
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}

  archive:
    - extracted
    - name: {{ solr.base_dist_dir }}
    - source: {{ [solr.apache_mirror, 'lucene', 'solr', solr.release, solr.dist]|join('/') }}.tgz
    - source_hash: md5={{ solr.md5 }}
    - archive_format: tar
    - tar_options: x
    - if_missing: {{ solr.dist_dir }}

{{ solr.home }}:
  file.directory:
    - user: {{ ckan.ckan_user }}
    - group: {{ ckan.ckan_group }}
    - recurse:
      - user
      - group
    - require:
      - archive: solr
