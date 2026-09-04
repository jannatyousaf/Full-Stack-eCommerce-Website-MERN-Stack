provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "ecom_sg" {
  name = "ecom-app-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["39.37.197.6/32"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4005
    to_port     = 4005
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5174
    to_port     = 5174
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ecom_server" {
  ami                    = "ami-03c1c093c5c9344ab"
  instance_type          = "t3.micro"
  key_name               = "jannat-key"
  vpc_security_group_ids = [aws_security_group.ecom_sg.id]

  tags = {
    Name = "ecom-app-server"
  }
}

output "server_public_ip" {
  value = aws_instance.ecom_server.public_ip
}
output "admin_url"{
    value="http://${aws_instance.ecom_server.public_ip}:5174"
}
output "frontend_url"{
    value="http://${aws_instance.ecom_server.public_ip}:3000"
}
output "backend_url"{
    value="http://${aws_instance.ecom_server.public_ip}:4005"
}
output "aws_instance_id"{
    value=aws_instance.ecom_server.id
}
output "aws_security_group_id"{
    value=aws_security_group.ecom_sg.id
}