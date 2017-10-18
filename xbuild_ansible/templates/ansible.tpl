[defaults]
inventory = $ANSIBLE_HOME/hosts
roles_path = $ANSIBLE_HOME/roles
forks = 64
retry_files_enabled = False

[ssh_connection]
ssh_args = -F {{ keygen_key_directory }}/ssh_config
