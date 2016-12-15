#!/bin/bash

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER ckan_default UNENCRYPTED PASSWORD 'pass';
    CREATE DATABASE ckan_default OWNER ckan_default ENCODING 'utf-8';
    CREATE DATABASE datastore_default OWNER ckan_default ENCODING 'utf-8';
    CREATE USER datastore_default UNENCRYPTED PASSWORD 'pass';
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" ckan_default <<-EOSQL
    CREATE EXTENSION "postgis";
EOSQL
