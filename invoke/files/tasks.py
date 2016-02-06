# -*- coding: utf-8 -*-
from __future__ import division

import json
import os
import re

from invoke import run, task


@task
def subl():
    """Sublime Textでプロジェクトを開く"""
    run('subl %s' % os.environ['PROJECT_HOME'])


@task
def atom():
    """Atomでプロジェクトを開く"""
    run('atom %s' % os.environ['PROJECT_HOME'])


def _ngx_start(deamon, pid):
    if pid:
        run('sudo %s -s reopen' % deamon)
    else:
        run('sudo %s' % deamon)


def _ngx_stop(deamon, pid):
    if pid:
        run('sudo %s -s stop' % deamon)


def _ngx_reload(deamon, pid):
    if pid:
        run('sudo %s -s reload' % deamon)
    else:
        run('sudo %s' % deamon)


@task
def ngx(command):
    """Nginxのラッパー"""
    deamon = os.environ['NGINX_BIN']
    pid = os.path.exists(os.environ['NGINX_PID'])

    if command == 'start':
        _ngx_start(deamon, pid)
    elif command == 'stop':
        _ngx_stop(deamon, pid)
    elif command == 'reload':
        _ngx_reload(deamon, pid)
    elif command == 'restart':
        _ngx_stop(deamon, pid)
        _ngx_start(deamon, pid)


def _sv_start(deamon, ctl, conf, pid):
    if os.path.exists(pid):
        run('%s -c %s reload' % (ctl, conf))
    else:
        run('%s --configuration %s --pidfile %s' % (deamon, conf, pid))


def _sv_stop(pid):
    if os.path.exists(pid):
        with open(pid, "r") as fh:
            run('kill %s' % (fh.read().rstrip("\n")))


def _sv_reload(deamon, ctl, conf, pid):
    if os.path.exists(pid):
        run('%s -c %s reload' % (ctl, conf))
    else:
        run('%s --configuration %s --pidfile %s' % (deamon, conf, pid))


@task
def sv(command):
    """Supervisordサービスの起動/停止/再起動/リロード"""
    deamon = 'supervisord'
    ctl = 'supervisorctl'
    conf = os.environ['SUPERVISORD_CONF']
    pid = os.environ['SUPERVISORD_PID']

    if command == 'start':
        _sv_start(deamon, ctl, conf, pid)
    elif command == 'stop':
        _sv_stop(pid)
    elif command == 'reload':
        _sv_reload(deamon, ctl, conf, pid)
    elif command == 'restart':
        _sv_stop(pid)
        _sv_start(deamon, ctl, conf, pid)


@task
def tf(command, env='vagrant', provider='aws'):
    """Terraformのラッパー"""
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s/%s' % (os.environ['TF_HOME'], provider, env),
        'terraform %s -var "public_key=%s"' % (command, public_key)
    ]
    run(' && '.join(cmd_list))


@task
def pck(builder="amazon_ebs"):
    """Packerでイメージを構築"""
    cmd_list = [
        'cd %s' % os.environ['PACKER_HOME'],
        'packer build %s.json' % builder
    ]
    run(' && '.join(cmd_list))


@task
def unittest(options=''):
    """アプリケーションサーバーをテストする"""
    pass


def _update_ansible_roles():
    cmd_list = [
        'cd %s/roles' % os.environ['ANSIBLE_HOME'],
        'git pull'
    ]
    run(' && '.join(cmd_list))


def _generate_bootstrap_command(action, env, hosts):
    private_key = '%s/%s' % (os.environ['KEY_HOME'], env)
    return './bootstrap -p ./%s.yml -i %s -o \'["-l %s", "--private-key %s.pem"]\'' % (
        action, hosts, hosts, private_key)


@task
def restart(env='vagrant', hosts='vagrant'):
    """サーバーを再起動する"""
    _update_ansible_roles()
    restart_cmd = _generate_bootstrap_command('restart', env, hosts)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        restart_cmd
    ]
    run(' && '.join(cmd_list))


@task
def deploy(env='vagrant', hosts='vagrant'):
    """デプロイ&再起動する"""
    _update_ansible_roles()
    deploy_cmd = _generate_bootstrap_command('deploy', env, hosts)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        deploy_cmd
    ]
    run(' && '.join(cmd_list))
    restart()


@task
def buildout(env='vagrant', hosts='vagrant'):
    """システム環境構築する"""
    _update_ansible_roles()
    buildout_cmd = _generate_bootstrap_command('buildout', env, hosts)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        buildout_cmd
    ]
    run(' && '.join(cmd_list))


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

    run('direnv allow')
