# -*- coding: utf-8 -*-
from __future__ import division

from invoke import run, task


@task
def Hello():
    print("World!!")


@task
def subl():
    """Sublime Textでプロジェクトを開く"""
    local('subl %s' % os.environ['PROJECT_HOME'])
