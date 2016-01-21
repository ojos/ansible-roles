---
- hosts: all
  become: no
  roles:
    - {{ ansible_main_role_name }}