solr:
  pkg.installed:
    - pkgs:
      - solr-jetty

  file.comment:
    - name: /etc/default/jetty8
    - regex: ^NO_START=1

  service.running:
    - name: jetty8
    - watch:
      - pkg: solr
