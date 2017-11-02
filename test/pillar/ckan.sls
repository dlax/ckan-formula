ckan:
  lookup:
    db_host: postgres
    ckan_home: /home/ckan
    src_dir: /home/ckan/src
    standard_plugins:
      - multilingual_dataset
      - multilingual_group
      - multilingual_tag
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
        repourl: https://github.com/ckan/ckanext-dcat
        rev: '54f6366a5c6368e70cc136b32fe7b2006f30ee27'
        plugins:
          - dcat
          - dcat_rdf_harvester
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
