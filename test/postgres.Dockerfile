FROM postgres:9.4

RUN apt-get update -qq \
    && apt-get install -y -qq postgresql-9.4-postgis-2.3

COPY init-ckan-db-and-users.sh /docker-entrypoint-initdb.d/init-ckan-db-and-users.sh
