"""States for managing CKAN extensions."""

import os

import yaml


__virtualname__ = 'ckanext'


def __virtual__():
    return __virtualname__


def _ckan():
    # XXX duplicate the whole map.jinja logic
    stream = __salt__['cp.get_file_str']('salt://ckan/defaults.yaml')
    default_settings = yaml.load(stream)
    os_family_map = __salt__['grains.filter_by'](
        {'Debian': {},
         'RedHat': {}},
        grain="os_family",
        merge=__salt__['pillar.get']('ckan:lookup')
    )
    default_settings['ckan'].update(os_family_map)
    ckan = __salt__['pillar.get'](
        'ckan',
        default=default_settings['ckan'],
        merge=True
    )
    ckan['venv_path'] = ckan['ckan_home'] + '/venv'
    return ckan


def installed(name, repourl=None, rev=None, requirements_file=None):
    """Install the `name` CKAN extension.
    """
    if rev is None:
        rev = 'master'
    if requirements_file is None:
        requirements_file = 'requirements.txt'
    ret = {
        'changes': {},
        'comment': '',
        'name': name,
        'result': None,
    }
    fullname = 'ckanext-' + name
    if repourl is None:
        repourl = 'git://github.com/ckan/' + fullname
    ckan = _ckan()
    srcdir = os.path.join(ckan['src_dir'], fullname)
    user = ckan['ckan_user']
    bin_env = ckan['venv_path']
    if __opts__['test']:
        ret['comment'] = (
            'would install {0} CKAN extention into {1} virtualenv'.format(
            name, bin_env))
        ret['result'] = None
        return ret

    def log(change_ctx, msg):
        ret['changes'][change_ctx] = msg

    def failed(*args):
        log(*args)
        ret['result'] = False
        return ret

    if os.path.isdir(srcdir):
        current_rev = __salt__['git.revision'](cwd=srcdir, user=user)
        if current_rev != rev:
            res = __salt__['git.fetch'](cwd=srcdir)
            if isinstance(res, dict) and res.get('retcode'):
                return failed('sources update', res['stderr'])
            log('sources update', res)
            ret['changes']['sources checkout'] = __salt__['git.checkout'](
                cwd=srcdir, rev=rev)
    else:
        ret['changes']['sources clone'] = __salt__['git.clone'](
            cwd=srcdir, repository=repourl)
        ret['changes']['sources checkout'] = __salt__['git.checkout'](
            cwd=srcdir, rev=rev)
    ret['changes']['sources ownership'] = __salt__['file.chown'](
        srcdir, user=user, group=user)
    res = __salt__['pip.install'](editable=srcdir, user=user, bin_env=bin_env)
    if res['retcode']:
        return failed('pip install', res['stderr'])
    log('pip install', 'pip installed {0}'.format(fullname))
    requirements_file = os.path.join(srcdir, requirements_file)
    if os.path.exists(requirements_file):
        res = __salt__['pip.install'](
            requirements=requirements_file, user=user, bin_env=bin_env)
        if res['retcode']:
            return failed('pip install dependencies', '\n'.join(
                ['failed:', res['stderr'], res['stdout']]))
        log('pip install dependencies',
            'install {0} dependencies from {1}'.format(
                fullname, requirements_file))
    ret['comment'] = ' successfully installed CKAN extension {0}'.format(name)
    ret['result'] = True
    return ret
