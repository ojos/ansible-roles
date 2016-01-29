---
- hosts: all
  become: no
  roles:
    - {{ packer_playbook_file_name }}