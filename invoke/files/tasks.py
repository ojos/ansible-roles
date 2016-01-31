# -*- coding: utf-8 -*-
from __future__ import division

import os

from invoke import run, task


@task
def Hello():
    print("World!!")


@task
def subl():
    """Sublime Textでプロジェクトを開く"""
    run('subl %s' % os.environ['PROJECT_HOME'])


@task
def atom():
    """Atomでプロジェクトを開く"""
    run('atom %s' % os.environ['PROJECT_HOME'])


@task
def restart():
    """サーバーを再起動する"""
    pass


def _generate_bootstrap_command(action, env, hosts):
    private_key = '%s/%s' % (os.environ['KEY_HOME'], env)
    return './bootstrap -p ./%s.yml -i %s -o \'["-l %s", "--private-key %s.pem"]\'' % (
        action, hosts, hosts, private_key)


@task
def deploy(env='vagrant', hosts='vagrant'):
    """デプロイ&再起動する"""
    private_key = '%s/%s' % (os.environ['KEY_HOME'], env)
    deploy_cmd = _generate_bootstrap_command('deploy', env, hosts)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        deploy_cmd
    ]
    run(' && '.join(cmd_list))


@task
def buildout(env='vagrant', hosts='vagrant'):
    """環境構築する"""
    private_key = '%s/%s' % (os.environ['KEY_HOME'], env)
    buildout_cmd = _generate_bootstrap_command('buildout', env, hosts)
    cmd_list = [
        'cd %s' % os.environ['ANSIBLE_HOME'],
        buildout_cmd
    ]
    run(' && '.join(cmd_list))


@task
def unittest(options=''):
    """アプリケーションサーバーをテストする"""
    pass


@task
def tf_plan(env='vagrant'):
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s' % (os.environ['TF_HOME'], env),
        'terraform plan -var "public_key=%s"' % public_key
    ]
    run(' && '.join(cmd_list))


@task
def tf_apply(env='vagrant'):
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s' % (os.environ['TF_HOME'], env),
        'terraform apply -var "public_key=%s"' % public_key
    ]
    run(' && '.join(cmd_list))


@task
def tf_destroy(env='vagrant'):
    public_key = '%s/%s.pem.pub' % (os.environ['KEY_HOME'], env)
    cmd_list = [
        'cd %s/%s' % (os.environ['TF_HOME'], env),
        'terraform destroy -var "public_key=%s"' % public_key
    ]
    run(' && '.join(cmd_list))


@task
def tf_show(env='vagrant'):
    cmd_list = [
        'cd %s/%s' % (os.environ['TF_HOME'], env),
        'terraform show'
    ]
    run(' && '.join(cmd_list))


@task
def pack(builder="amazon_ebs"):
    cmd_list = [
        'cd %s' % os.environ['PACKER_HOME'],
        'packer build %s.json' % builder
    ]
    run(' && '.join(cmd_list))
