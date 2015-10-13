{% from "ckan/map.jinja" import ckan with context -%}
import os
activate_this = os.path.join('{{ ckan.venv_path }}', 'bin', 'activate_this.py')
execfile(activate_this, dict(__file__=activate_this))

from paste.deploy import loadapp
config_filepath = '{{ ckan_conffile }}'
from paste.script.util.logging_config import fileConfig
fileConfig(config_filepath)
application = loadapp('config:%s' % config_filepath)
