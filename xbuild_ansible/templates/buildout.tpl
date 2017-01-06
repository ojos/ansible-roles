---
- hosts: all
  become: no
  vars:
  roles:
    - timezone
    - devtools
    - project
- include: {{ xbuild_ansible_directory }}/deploy.yml