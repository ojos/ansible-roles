# -*- coding: utf-8 -*-
from __future__ import division, print_function, absolute_import, unicode_literals

from locust import HttpLocust, TaskSet, task


class MyTaskSet(TaskSet):

    @task(1)
    def index(self):
        self.client.get("/")


class MyLocust(HttpLocust):
    task_set = MyTaskSet
