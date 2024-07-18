provider "aws" {
  alias  = "east"
  region = "us-east-2"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# VPC for East Region
resource "aws_vpc" "east_vpc" {
  provider = aws.east
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "East-VPC"
  }
}

resource "aws_subnet" "east_subnet" {
  provider = aws.east
  vpc_id = aws_vpc.east_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "East-Subnet"
  }
}

resource "aws_internet_gateway" "east_igw" {
  provider = aws.east
  vpc_id = aws_vpc.east_vpc.id
  tags = {
    Name = "East-Internet-Gateway"
  }
}

resource "aws_route_table" "east_route_table" {
  provider = aws.east
  vpc_id = aws_vpc.east_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.east_igw.id
  }
  tags = {
    Name = "East-Route-Table"
  }
}

resource "aws_route_table_association" "east_rta" {
  provider = aws.east
  subnet_id = aws_subnet.east_subnet.id
  route_table_id = aws_route_table.east_route_table.id
}

resource "aws_security_group" "east_mongodb_sg" {
  provider = aws.east
  vpc_id = aws_vpc.east_vpc.id
  name = "east-mongodb-sg"
  description = "Security group for MongoDB in East region"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "East-MongoDB-SG"
  }
}

resource "aws_instance" "east_mongodb_instance" {
  provider = aws.east
  ami = var.ami_id_east
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.east_subnet.id
  vpc_security_group_ids = [aws_security_group.east_mongodb_sg.id]
  associate_public_ip_address = true

  user_data = file("user_data_east.sh")

  tags = {
    Name = "East-MongoDB-Instance"
  }
}

# VPC for West Region
resource "aws_vpc" "west_vpc" {
  provider = aws.west
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "West-VPC"
  }
}

resource "aws_subnet" "west_subnet" {
  provider = aws.west
  vpc_id = aws_vpc.west_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "West-Subnet"
  }
}

resource "aws_internet_gateway" "west_igw" {
  provider = aws.west
  vpc_id = aws_vpc.west_vpc.id
  tags = {
    Name = "West-Internet-Gateway"
  }
}

resource "aws_route_table" "west_route_table" {
  provider = aws.west
  vpc_id = aws_vpc.west_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.west_igw.id
  }
  tags = {
    Name = "West-Route-Table"
  }
}

resource "aws_route_table_association" "west_rta" {
  provider = aws.west
  subnet_id = aws_subnet.west_subnet.id
  route_table_id = aws_route_table.west_route_table.id
}

resource "aws_security_group" "west_mongodb_sg" {
  provider = aws.west
  vpc_id = aws_vpc.west_vpc.id
  name = "west-mongodb-sg"
  description = "Security group for MongoDB in West region"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "West-MongoDB-SG"
  }
}

resource "aws_instance" "west_mongodb_instance" {
  provider = aws.west
  ami = var.ami_id_west
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.west_subnet.id
  vpc_security_group_ids = [aws_security_group.west_mongodb_sg.id]
  associate_public_ip_address = true

  user_data = file("user_data_west.sh")

  tags = {
    Name = "West-MongoDB-Instance"
  }
}

output "east_instance_public_ip" {
  value = aws_instance.east_mongodb_instance.public_ip
}

output "west_instance_public_ip" {
  value = aws_instance.west_mongodb_instance.public_ip
}
