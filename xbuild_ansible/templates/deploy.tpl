---
- hosts: all
  become: no
  vars:
  roles:
    - deploy
- include: {{ xbuild_ansible_directory }}/restart.yml