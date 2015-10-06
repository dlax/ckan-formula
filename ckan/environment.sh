{% from "ckan/map.jinja" import ckan with context %}
export CKAN_SQLALCHEMY_URL=postgresql://{{ ckan.db_user }}:{{ ckan.db_password }}@{{ ckan.db_host }}/{{ ckan.db_name }}
export CKAN_DATASTORE_WRITE_URL=postgresql://{{ ckan.db_user }}:{{ ckan.db_password }}@{{ ckan.db_host }}/{{ ckan.datastore_db_name }}
export CKAN_DATASTORE_READ_URL=postgresql://{{ ckan.datastore_db_user }}:{{ ckan.datastore_db_password }}@{{ ckan.db_host }}/{{ ckan.datastore_db_name }}
export CKAN_SITE_URL={{ ckan.site_url }}
