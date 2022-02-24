# Demo on Scaling up EC2 instances in AWS Cloud with webserver running on it

### This project demonistrates setting up AWS EC2 web instances running Nginx and Flask using Terraform using an ami build from packer

### AMI is created from packer includes nginx and flask installed in it from ansible play books shell scripts in image folder 

### image\packer-build.json will build the packer image with nhinx and flask configured in it.

### terraform executing terraform commands like init , plan , apply will create EC2 instances from the AMI created from packer. By default I have kept the EC2 instances to 4 and it can be scale up to any number by changing the relative value for var.size_default in varibles