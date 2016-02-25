{% from "ckan/map.jinja" import ckan with context %}

redis-server:
  pkg:
    - installed
    - name: {{ ckan.redis_pkg }}

python-redis:
  pip.installed:
    - name: redis == 2.10.1
    - user: {{ ckan.ckan_user }}
    - bin_env: {{ ckan.venv_path }}
    - require:
      - virtualenv: {{ ckan.venv_path }}

