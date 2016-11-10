# -*- coding: utf-8 -*-
from __future__ import division, print_function, absolute_import, unicode_literals

from locust import (HttpLocust, TaskSet, task)


class SampleTaskSet(TaskSet):

    def on_start(self):
        pass

    @task
    def index(self):
        self.client.get('/')


class WebsiteUser(HttpLocust):
    task_set = SampleTaskSet
