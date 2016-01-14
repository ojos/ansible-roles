#!/bin/zsh
setopt EXTENDED_GLOB
for rcfile in {{ ansible_user_dir }}/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "{{ ansible_user_dir }}/.${rcfile:t}"
done