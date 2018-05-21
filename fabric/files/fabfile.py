# -*- coding: utf-8 -*-
from __future__ import division, print_function, absolute_import, unicode_literals

import json
import os
import re

from fabric.api import *  # NOQA

env.use_ssh_config = True
env.ssh_config_path = '%s/ssh_config' % os.environ['KEY_HOME']
REMOTE_WORK_DIRECTORY = '/var/www'


def _is_local():
    return len(env.hosts) == 0


def _exec(command, remote=run, *args, **kwargs):
    if _is_local():
        cmd = 'cd %s && %s ' % (os.environ['PROJECT_HOME'], command)
        local(cmd, *args, **kwargs)
    else:
        with cd(REMOTE_WORK_DIRECTORY):
            cmd = 'source %s/.envrc && %s' % (REMOTE_WORK_DIRECTORY, command)
            remote(cmd, *args, **kwargs)


@task
def subl():
    """Sublime Textでプロジェクトを開く"""
    local('subl %s' % os.environ['PROJECT_HOME'])


@task
def atom():
    """Atomでプロジェクトを開く"""
    local('atom %s' % os.environ['PROJECT_HOME'])


@task
def test(options=''):
    """コードをテストする"""
    pass


@task
def fmt(options=''):
    """コードをフォーマットする"""
    pass


@task
def lint(options=''):
    """コードを構文チェックする"""
    pass


def _sv_start(deamon, ctl, conf, pid):
    if os.path.exists(pid):
        local('sudo -E %s -c %s reload' % (ctl, conf))
    else:
        local('sudo -E %s --configuration %s --pidfile %s' % (deamon, conf, pid))


def _sv_stop(pid):
    if os.path.exists(pid):
        with open(pid, "r") as fh:
            local('sudo -E kill %s' % (fh.read().rstrip("\n")))


def _sv_reload(deamon, ctl, conf, pid):
    print(pid)
    if os.path.exists(pid):
        local('sudo -E %s -c %s reload' % (ctl, conf))
    else:
        local('sudo -E %s --configuration %s --pidfile %s' % (deamon, conf, pid))


@task
def sv(command):
    """Supervisordサービスの起動/停止/再起動/リロード"""
    if _is_local():
        deamon = 'supervisord'
        ctl = 'supervisorctl'
        conf = os.environ['SUPERVISORD_CONF']
        pid = os.environ['SUPERVISORD_PID']

        if command == 'start':
            _sv_start(deamon, ctl, conf, pid)
        elif command == 'stop':
            _sv_stop(pid)
        elif command == 'reload' or command == 'restart':
            _sv_reload(deamon, ctl, conf, pid)
    else:
        sudo('service supervisord %s' % command)


@task
def tda(command):
    if _is_local():
        if command == 'start':
            local('sudo -E launchctl load /Library/LaunchDaemons/td-agent.plist')
        elif command == 'stop':
            local('sudo -E launchctl unload /Library/LaunchDaemons/td-agent.plist')
    else:
        sudo('service td-agent %s' % command)


@task
def tf(command, env='vagrant', provider='aws'):
    """Terraformのラッパー"""
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s/%s' % (os.environ['TF_HOME'], provider, env),
        "terraform %s -var 'public_key=\"%s\"'" % (command, public_key)
    ]
    local(' && '.join(cmd_list))


@task
def pck(builder="ansible"):
    """Packerでイメージを構築"""
    cmd_list = [
        'cd %s' % os.environ['PACKER_HOME'],
        'packer build %s.json' % builder
    ]
    local(' && '.join(cmd_list))


@task
def ssh(env='vagrant', host='vagrant'):
    cmd = 'ssh -F %(key_dir)s/ssh_config -i %(key_dir)s/%(env)s.pem %(host)s' % {
        'key_dir': os.environ['KEY_HOME'], 'env': env, 'host': host}
    local(cmd)


def _update_ansible_roles():
    cmd_list = [
        'cd %s/roles' % os.environ['ANSIBLE_HOME'],
        'git pull'
    ]
    local(' && '.join(cmd_list))


def _generate_bootstrap_command(action, env, hosts, vars):
    private_key = '%s/%s' % (os.environ['KEY_HOME'], env)
    cmd = './bootstrap -p %s.yaml -i %s -o \'["-l %s", "--private-key %s.pem"]\'' % (
        action, hosts, hosts, private_key)
    if vars is not None:
        cmd = '%s -v \'%s\'' % (cmd, vars)

    return cmd


@task
def restart(env='vagrant', hosts='vagrant', vars=None):
    """サーバーを再起動する"""
    _update_ansible_roles()
    restart_cmd = _generate_bootstrap_command('restart', env, hosts, vars)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        restart_cmd
    ]
    local(' && '.join(cmd_list))


@task
def deploy(env='vagrant', hosts='vagrant', vars=None):
    """デプロイ&再起動する"""
    _update_ansible_roles()
    deploy_cmd = _generate_bootstrap_command('deploy', env, hosts, vars)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        deploy_cmd
    ]
    local(' && '.join(cmd_list))


@task
def buildout(env='vagrant', hosts='vagrant', vars=None):
    """システム環境構築する"""
    _update_ansible_roles()
    buildout_cmd = _generate_bootstrap_command('buildout', env, hosts, vars)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        buildout_cmd
    ]
    local(' && '.join(cmd_list))


@task
def restart_proxy(env='develop', hosts='develop-proxy', vars=None):
    """サーバーを再起動する"""
    _update_ansible_roles()
    restart_cmd = _generate_bootstrap_command('restart_proxy', env, hosts, vars)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        restart_cmd
    ]
    local(' && '.join(cmd_list))


@task
def buildout_proxy(env='develop', hosts='develop-proxy', vars=None):
    """システム環境構築する"""
    _update_ansible_roles()
    buildout_cmd = _generate_bootstrap_command('buildout_proxy', env, hosts, vars)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        buildout_cmd
    ]
    local(' && '.join(cmd_list))


@task
def replace(path, replaces):
    """ファイルに置換処理する"""
    with open(path, 'r') as fh:
        string = fh.read()

    for repl in replaces:
        string = re.sub(repl['pattern'], repl['repl'], string)

    with open(path, 'w') as fh:
        fh.write(string)


@task
def launch(env='vagrant', provider='aws'):
    """サーバー環境を起動する"""
    tf('plan', env, provider)
    tf('apply', env, provider)

    tfstate_path = '%s/%s/%s/terraform.tfstate' % (os.environ['TF_HOME'], provider, env)
    with open(tfstate_path, 'r') as tf_fh:
        tfstate = json.loads(tf_fh.read())

    eip = tfstate['modules'][0]['resources'][
        'aws_eip.default']['primary']['attributes']['public_ip']

    replace('%s/ssh_config' % os.environ['KEY_HOME'],
            [{'pattern': r'(Host\s%s\nHostName)\s.+\n' % env, 'repl': r'\1 %s\n' % eip}])

    if env == 'vagrant':
        sg_id = tfstate['modules'][0]['resources'][
            'aws_security_group.default']['primary']['attributes']['id']

        replace('%s/.envrc' % os.environ['PROJECT_HOME'],
                [{'pattern': r'(export\sVAGRANT_ELASTIC_IP)=.+\n', 'repl': r'\1=%s\n' % eip},
                 {'pattern': r'(export\sVAGRANT_SECURITY_GROUPS)=.+\n', 'repl': r'\1=%s\n' % sg_id}])

    local('direnv allow')


@task
def delete_log():
    local('find %s -name "*.log" -delete' % os.environ['PROJECT_HOME'])


@task
def delete_DS_Store():
    local('find %s -name ".DS_Store" -delete' % os.environ['PROJECT_HOME'])
