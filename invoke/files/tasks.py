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


@task
def deploy(branch='master'):
    """デプロイ&再起動する"""
    pass


@task
def unittest(options=''):
    """アプリケーションサーバーをテストする"""
    pass


@task
def ssh(host="vagrant", env='vagrant'):
    """sshラッパー"""
    run('ssh -F %(dir)s/ssh_config -i %(dir)s/%(env)s.pem %(host)s' %
        {'dir': os.environ['KEY_DIR'], 'env': env, 'host': host})
