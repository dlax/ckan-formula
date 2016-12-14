ckan:
  lookup:
    db_host: postgres
    ckan_repo: 'https://github.com/logilab/ckan'
    ckan_rev: 'datalocale-v2.5.3'
    ckan_home: /home/ckan
    src_dir: /home/ckan/src
    standard_plugins:
      - datastore
      - datapusher
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
      issues:
        plugins:
          - issues
        options:
          ckanext.issues.send_email_notifications: true
          ckanext.issues.max_strikes: 2
      datalocale:
        repourl: https://github.com/logilab/ckanext-datalocale
        branch: logilab
        plugins:
          - datalocale
