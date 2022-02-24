#!/bin/bash
set -ex

# Add EPEL repository
sudo yum update -y
sudo yum install -y epel-release
sudo yum install centos-release-scl -y

# Install PIP for python pkg mgmt
#sudo yum install python-pip -y
sudo yum install rh-python36 -y
#pip install --upgrade pip
sudo yum install python3-pip -y



scl enable rh-python36 bash
python --version
# Install development tools
sudo yum install python-devel -y
sudo yum groupinstall 'development tools' -y

# Install Ansible
sudo yum install -y ansible



#echo -e '[defaults]\nansible_managed = ANSIBLE MANAGED : DO NOT EDIT !!!\nhost_key_checking = False\ntransport = ssh\n' >> /root/.ansible.cfg