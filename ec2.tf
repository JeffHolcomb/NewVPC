# Security group for private subnet
resource "aws_security_group" "security_group_private" {
  name        = "ec2_private"
  description = "MongDBEc2"
  vpc_id      = aws_vpc.dev.id


  ingress {
    #description      = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}



# Security group for public subnet
resource "aws_security_group" "security_group_public" {
  name        = "ec2_public"
  description = "4 ec2 webservers"
  vpc_id      = aws_vpc.dev.id

  ingress {
    #description      = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    #description      = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    #description      = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-ssh, http, https"
  }
}


#Ec2 for public subnet (4 web-servers)
resource "aws_instance" "public_instance" {
  ami                         = "ami-0d70546e43a941d70"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.security_group_public.id]
  key_name                    = "fun"
  count                       = 4
  associate_public_ip_address = true
  subnet_id                   = "subnet-08bc223a678ac9b6a"
  tags = {
    "Name" = "public_instance"
  }
}


#Ec2 for Private subnet (MongoDB)
resource "aws_instance" "private_instance" {
  subnet_id                   = "subnet-03d2e54967661cf6f"
  ami                         = "ami-0d70546e43a941d70"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.security_group_private.id]
  key_name                    = "fun"
  count                       = 1
  associate_public_ip_address = true
  
  tags = {
    "Name" = "private_instance"
  }
}
