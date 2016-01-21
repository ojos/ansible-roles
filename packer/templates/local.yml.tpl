---
- hosts: localhost
  become: no
  roles:
    - {{ packer_ansible_main_role_name }}