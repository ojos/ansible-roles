---
- hosts: all
  become: no
  vars:
  roles:
    - timezone
    - devtools
    - project
- include: "{{ lookup('env', 'ANSIBLE_HOME') }}/deploy.yml"