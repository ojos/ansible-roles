---
- hosts: all
  become: no
  roles:
    - {{ xbuild_ansible_main_role_name }}