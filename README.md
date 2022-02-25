# Goal : Scaling up EC2 instances in AWS Cloud with webserver running on it

This project demonstrates building an AMI with nginx and flask from packer and launching the EC2 instance using terraform

## Tools Used

AWS cloud
Hashicorp Packer
Terraform
Ansible
Nginx
flask

## Directory structure and project execution 

AMI is created from packer includes nginx and flask installed in it from ansible playbooks,shell scripts in image folder 

 image\packer-build.json will build the AMI with nginx and flask configured in it.

 Terraform to build the instances in AWS cloud by running terraform commands like init , plan , apply from Terraform directory will create EC2 instances from the AMI created from packer. By default I have kept the EC2 instances to 4 and it can be scale up to any number by changing the relative value for var.size_default in varibles.

 Snapshots are added to the snapshots folder with the expected output from each execution.

