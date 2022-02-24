
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}


data "aws_ami" "web-ami" {
  owners = ["self"]
  filter {
    name   = "name"
    values = ["web-ami"]
  }

}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_subnet" "subnet1" {
  cidr_block              = var.vpc_subnet1_cidr_block
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch

}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}


resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key-1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMPAysFdBn3kYaPT5Op60dx/PEbouQfQvCnKsEOlni78v9QDe5HKp526L3gAdfPmtl2mtUGLbjPrUx8ek29TlZvXNbDn3weIOoeWdlliBG6qWfxtiLgYdIx3gK4Q993brRpLudP6dYI4dub+dLm7TjRwN+0asBOJl7Hh1xDLVoz7FCJEH7jBY6apCNmlFOW+jMs8OFoPWG+4ci2r/H8LZIF/6S7wuwKlxyYWuRW5VTqV36rLFwgv6LTg6q7LguCDoqaCIQwSbBlvzpXskORrlQMhE4443VP+nF5e3/rhiDc3FjOFJmk8cdi5lmx4/r3EwkPEZPOvalzmpbdF/bTAMMPud2Qy9e5Ur3oyhqHRx+QiHbxmTF95BVYr+L0VO5nABh55OxD08hVSiEmeUvnPZOxhy5IFkfArrI/eECIm1oO6Tdt6VFdikWNvTC0KdskZ4XhXgRACjd41vcVOo6nxHa7cge6s2FfQaeCVuBUJejhysPVsRLSFqNn1VLFNLVRuE= z16241@40W3PV2"
}

resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.web-ami.id
  instance_type          = var.instance_type
  count                  = var.size_default
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = "ssh-key-1"

  tags = {
    Name = "web-vm-${count.index + 1}"
  }

}


