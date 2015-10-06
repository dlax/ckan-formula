solr:
  pkg.installed:
    - pkgs:
      - solr-jetty

  service.running:
    - name: jetty8
    - watch:
      - pkg: solr
