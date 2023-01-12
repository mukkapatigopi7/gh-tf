terraform {
  backend "s3" {
  }
}
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/*20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    
    owners = ["099720109477"] # Canonical
}

provider "aws" {
  region  = "us-east-2"
}



resource "aws_vpc" "VPC1_TF1" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "VPC1_TF1"
    Owner= "gopi.mukkapati@cloudeq.com"
    Purpose = "Assaignment"
  }
}

resource "aws_subnet" "SUBNET1_VPC1_TF1" {
  vpc_id            = aws_vpc.VPC1_TF1.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "SUBNET1_VPC1_TF1"
    Owner= "gopi.mukkapati@cloudeq.com"
    Purpose = "Assaignment"
  }
}

resource "aws_network_interface" "NI1_SUBNET1_VPC1_TF1" {
  subnet_id   = aws_subnet.SUBNET1_VPC1_TF1.id
  private_ips = ["10.10.1.100"]

  tags = {
    Name = "NI1_SUBNET1_VPC1_TF1"
    Owner= "gopi.mukkapati@cloudeq.com"
    Purpose = "Assaignment"
  }
}


resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "gopi-ceq-gh-ssh-key"
    
  network_interface {
  network_interface_id = aws_network_interface.NI1_SUBNET1_VPC1_TF1.id
  device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = var.ec2_name
    Owner= "gopi.mukkapati@cloudeq.com"
    Purpose = "Assaignment"
  }
    volume_tags = {
    Name = var.ec2_name
    Owner= "gopi.mukkapati@cloudeq.com"
    Purpose = "Assaignment"
  }
}

