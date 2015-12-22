#!/bin/zsh
setopt EXTENDED_GLOB
for rcfile in {{ prezto_dir }}/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "{{ prezto_dir }}/.${rcfile:t}"
done