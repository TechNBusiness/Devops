provider "aws" {
  region     = "eu-west-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

/*data "aws_vpc" "existing_vpc" {
  default = true

}*/

/*resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.64.0/20"
  availability_zone = "eu-west-1a"
  tags = {
    Name : "default-subnet-2"
  }

}*/

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id

  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name : "${var.env_prefix}-igw"
  }
}

resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg" {
  name   = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name : "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "myapp-server" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  subnet_id              = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = ["aws_security_group.myapp-sg"]
  availability_zone      = var.avail_zone

  associate_public_ip_address = true
  key_name                    = ""

  user_data = file("entry-script.sh")

  /*connection {
    type = "ssh"
    host = self.associate_public_ip
    user = "ec2-user"
    private_key = file(var.private_key_location)
  }*/

  # remote-exec provisoner invokes script on a remote resource after it is created.
  provisioner "remote-exec" {
    inline = [
      "export ENV=dev",
      "mkdir WorkDir"
    ]
  }

  tags = {
    Name: "${var.env_prefix}-server"
  }
}

