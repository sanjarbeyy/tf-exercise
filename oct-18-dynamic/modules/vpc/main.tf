resource "aws_vpc" "bambam" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = join("-", [var.prefix, "vpc"])
  }
}

variable "prefix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

output "vpc_id" {
  value = aws_vpc.bambam.id
}

