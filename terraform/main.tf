provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "ecom_sg" {
  name = "ecom-app-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 4005
  #   to_port     = 4005
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

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
resource "aws_s3_bucket" "product_images" {
  bucket = "ecom-app-product-images-jannat"
}

resource "aws_s3_bucket_public_access_block" "product_images_access" {
  bucket = aws_s3_bucket.product_images.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "product_images_policy" {
  bucket = aws_s3_bucket.product_images.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.product_images.arn}/*"
      }
    ]
  })
}

output "s3_bucket_name" {
  value = aws_s3_bucket.product_images.id
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
#output "backend_url"{
    #value="http://${aws_instance.ecom_server.public_ip}:4005"
#}
output "aws_instance_id"{
    value=aws_instance.ecom_server.id
}
output "aws_security_group_id"{
    value=aws_security_group.ecom_sg.id
}