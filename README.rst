.. image:: https://travis-ci.org/saltstack-formulas/ckan-formula.svg?branch=master
    :target: https://travis-ci.org/saltstack-formulas/ckan-formula
    
============
ckan-formula
============

A saltstack formula handling installation of CKAN_.


Docker image
============

You can run ckan from the docker image directly::

    docker pull logilab/ckan-formula
    docker run -d --name ckan \
        --env CKAN_DATASTORE_WRITE_URL=postgresql://user:pass@pghost/datastore_default
        --env CKAN_DATASTORE_READ_URL=postgresql://user_ro:pass@pghost/datastore_default
        --env SQLALCHEMY_URL=postgresql://user:pass@pghost/ckan_default
        logilab/ckan-formula


Database could be initialized with::

    docker exec -it --user root ckan \
        salt-call state.sls ckan.dbsetup
    docker exec -it ckan /home/ckan/bin/supervisorctl start all


Available states
================

.. contents::
    :local:

``ckan.install``
----------------

Installs the CKAN Python package and its dependencies from sources.

``ckan.config``
----------------

Manage configuration files for a CKAN instance from a templated ``.ini``
filled with pillar data.

``ckan.supervisor``
-------------------

Install and manage `supervisor`_ configuration for the CKAN installation.

``ckan.solr``
-------------

Setup a Solr server and configure it for CKAN (only available on Debian
systems).

``ckan.apache``
---------------

Install a WSGI file along with CKAN configuration to be used with Apache
``mod_wsgi``.


``ckan.extensions``
-------------------

The following extensions are currently supported:

- archiver
- datastorer
- dcat
- harvest
- qa
- spatial

Selection of extensions to install and respective configuration is to be set
in pillars.


.. _CKAN: http://ckan.org
.. _supervisor: http://supervisord.org
