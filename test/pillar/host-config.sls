ckan:
  lookup:
    ckan_user: datamanager
    ckan_group: datamasters
    ckan_home: /home/datamanager
    src_dir: /home/datamanager/src
    standard_plugins:
      - datastore
      - resource_proxy
    extensions:
      archiver:
        options:
          ckanext-archiver.archive_dir: /home/datamanager/ckan-resources
