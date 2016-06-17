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


def installed(name, repourl=None, branch='master', rev=None, requirements_file=None):
    """Install the `name` CKAN extension.
    """
    ckan = _ckan()
    # Retrieve target revision from pillar rev or branch data, default to rev
    # or branch parameters if unspecified.
    extension_data = ckan['extensions'].get(name, {})
    rev_is_branch = False
    if 'branch' in extension_data:
        branch = extension_data['branch']
    if 'rev' in extension_data:
        rev = extension_data['rev']
    else:
        if rev is None:
            rev = branch
            rev_is_branch = True
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
        repourl = extension_data.get(
            'repourl', 'https://github.com/ckan/' + fullname)
    srcdir = os.path.join(ckan['src_dir'], fullname)
    user, group = ckan['ckan_user'], ckan['ckan_group']
    bin_env = ckan['venv_path']
    if __opts__['test']:
        ret['comment'] = (
            'would install {0} CKAN extention into {1} virtualenv'.format(
            name, bin_env))
        ret['result'] = None
        return ret

    def log(change_ctx, msg):
        if msg:
            ret['changes'][change_ctx] = msg

    def failed(change_ctx, res):
        msg = 'failed'
        if isinstance(res, dict):
            msg = '\n'.join(
                [msg + ':', res.get('stderr', ''), res.get('stdout', '')])
        else:
            msg = ': '.join([msg, str(res)])
        log(change_ctx, msg)
        ret['result'] = False
        return ret

    def checkout():
        res = __salt__['git.checkout'](cwd=srcdir, rev=rev, user=user)
        if isinstance(res, dict) and res.get('retcode'):
            return failed('sources checkout', res)
        log('sources checkout', res)

    def clone_repo():
        ret['changes']['sources clone'] = __salt__['git.clone'](
            cwd=srcdir, repository=repourl, user=user)
        checkout()

    # Fetch or clone.
    if os.path.isdir(srcdir):
        # Ensure git repositories are owned by ckan user before doing anything.
        owner = __salt__['file.get_user'](srcdir).strip()
        if owner != user:
            # And if not, clone it from scratch.
            res = __salt__['file.remove'](srcdir)
            ret['changes']['removed existing source directory'] = res
            clone_repo()
        else:
            # TODO handle change in remote.
            res = __salt__['git.fetch'](cwd=srcdir, user=user,
                                        opts='origin ' + branch)
            if isinstance(res, dict) and res.get('retcode'):
                return failed('sources fetch', res)
            log('sources fetch', res)
            checkout()
            if rev_is_branch:
                res = __salt__['git.pull'](cwd=srcdir, user=user,
                                           opts='--ff-only')
                if isinstance(res, dict) and res.get('retcode'):
                    return failed('sources pull', res)
                log('sources pull', res)
    else:
        clone_repo()

    current_rev = __salt__['git.revision'](cwd=srcdir, user=user).strip()
    log('git revision', current_rev)
    if not rev_is_branch:
        # 'rev' specified explicitly.
        if current_rev != rev.strip():
            return failed('git revision', '{0} != {1}'.format(current_rev, rev))
    else:
        # otherwise, ensure 'branch' is checked out.
        branch_rev = __salt__['git.revision'](cwd=srcdir, rev=branch, user=user).strip()
        log('git revision (branch "{0}")'.format(branch), branch_rev)
        if branch_rev != current_rev:
            return failed('git revision (branch "{0}")'.format(branch),
                          '{0} != {1}'.format(branch_rev, current_rev))


    res = __salt__['pip.install'](editable=srcdir, user=user, bin_env=bin_env)
    if res['retcode']:
        return failed('pip install', res)
    log('pip install', 'pip installed {0}'.format(fullname))

    requirements_file = os.path.join(srcdir, requirements_file)
    if os.path.exists(requirements_file):
        res = __salt__['pip.install'](
            requirements=requirements_file, user=user, bin_env=bin_env)
        if res['retcode']:
            return failed('pip install dependencies', res)
        log('pip install dependencies',
            'install {0} dependencies from {1}'.format(
                fullname, requirements_file))
    ret['comment'] = ' successfully installed CKAN extension {0}'.format(name)
    ret['result'] = True
    return ret
