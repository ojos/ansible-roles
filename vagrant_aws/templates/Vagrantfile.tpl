# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "{{ vagrant_aws_box_name }}"
  config.vm.box_url = "{{ vagrant_aws_box_url }}"

  config.vm.provider "aws" do |aws, override|
    aws.ami = ENV["VAGRANT_AMI"]
    aws.elastic_ip = ENV["VAGRANT_ELASTIC_IP"]
    aws.instance_type = ENV["VAGRANT_INSTANCE_TYPE"]
    aws.tags = {{ vagrant_aws_tags }}
    aws.user_data = "#!/bin/bash\nsed -i -e 's/^Defaults.*requiretty/# Defaults requiretty/g' /etc/sudoers"

    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    aws.region = ENV["AWS_DEFAULT_REGION"]
    aws.availability_zone =  ENV["AWS_DEFAULT_AVAILABILITY_ZONE"]
    aws.keypair_name = ENV["VAGRANT_KEYPAIR_NAME"]
    aws.security_groups = ENV["VAGRANT_SECURITY_GROUPS"]
    aws.subnet_id = ENV["VAGRANT_SUBNET_ID"]

    override.ssh.username = ENV["VAGRANT_USERNAME"]
    override.ssh.private_key_path = ENV["VAGRANT_PRIVATE_KEY_PATH"]
    override.ssh.pty              = true
  end
end