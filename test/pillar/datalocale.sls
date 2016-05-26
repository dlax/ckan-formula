ckan:
  lookup:
    ckan_home: /home/ckan
    src_dir: /home/ckan/src
    standard_plugins: []
    extensions:
      qa:
        plugins:
          - qa
      report:
        plugins:
          - report
      archiver:
        plugins:
          - archiver
        options:
          ckanext-archiver.archive_dir: /var/www/ckan-resources
          ckanext-archiver.cache_url_root: http://localhost:9876/resources
      harvest:
        plugins:
          - harvest
          - ckan_harvester
        options:
          ckan.harvest.mq.type: redis
      dcat:
        repourl: https://github.com/logilab/ckanext-dcat
        branch: datalocale
        plugins:
          - dcat
          - dcat_rdf_harvester
        options:
          ckanext.dcat.rdf.profiles: euro_dcat_ap eurovoc_groups_dcat_ap labeled_concepts_dcat_ap
      spatial:
        plugins:
          - spatial_metadata
          - spatial_query
      datalocale:
        repourl: https://github.com/logilab/ckanext-datalocale
        branch: logilab
        plugins:
          - datalocale
