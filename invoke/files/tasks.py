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


@task
def plan(env='vagrant', provider='aws'):
    """Terraformで計画ファイルを作成"""
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s/%s' % (os.environ['TF_HOME'], provider, env),
        'terraform plan -var "public_key=%s"' % public_key
    ]
    run(' && '.join(cmd_list))


@task
def show(env='vagrant', provider='aws'):
    """Terraformで計画ファイルを出力"""
    cmd_list = [
        'cd %s/%s/%s' % (os.environ['TF_HOME'], provider, env),
        'terraform show'
    ]
    run(' && '.join(cmd_list))


@task
def apply(env='vagrant', provider='aws'):
    """Terraformでサーバー環境を構築"""
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s/%s' % (os.environ['TF_HOME'], provider, env),
        'terraform apply -var "public_key=%s"' % public_key
    ]
    run(' && '.join(cmd_list))


@task
def destroy(env='vagrant', provider='aws'):
    """Terraformでサーバー環境を撤去"""
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s/%s' % (os.environ['TF_HOME'], provider, env),
        'terraform destroy -var "public_key=%s"' % public_key
    ]
    run(' && '.join(cmd_list))


@task
def pack(builder="amazon_ebs"):
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
    plan(env, provider)
    apply(env, provider)

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
