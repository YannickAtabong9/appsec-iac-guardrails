# main.tf
# WARNING: This file contains intentional security vulnerabilities for testing.

provider "aws" {
  region = "us-east-1"
}
# ------------------------------------------------------------------
# SIN 1: The Public S3 Bucket (Data Leak Risk)
# ------------------------------------------------------------------
resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "company-sensitive-data-bucket-12345"
}

resource "aws_s3_bucket_public_access_block" "vulnerable_bucket_access" {
  bucket = aws_s3_bucket.vulnerable_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# ------------------------------------------------------------------
# SIN 2: The "Wide Open" Security Group (Botnet Target)
# ------------------------------------------------------------------
resource "aws_security_group" "vulnerable_sg" {
  name        = "web_server_sg"
  description = "Allow SSH inbound traffic from anywhere"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
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
# ------------------------------------------------------------------
# SIN 3: The Public, Unencrypted Database (Data Breach)
# ------------------------------------------------------------------
resource "aws_db_instance" "vulnerable_database" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  db_name              = "customer_financial_data"
  username             = "admin"
  password             = "SuperSecretPassword123!" 
  
  publicly_accessible  = true 
  storage_encrypted    = false 
  skip_final_snapshot  = true
}
