terraform {
  cloud {
    organization = "024_2023-summer-cloud"

    workspaces {
      name = "infra-vpc"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "subnets" {
  type = map(object({
    cidr_block = string
  }))
  default = {}
}

variable "vpc_cidr" {
  type = string
}

module "vpc" {
  source   = "./modules/vpc/"
  vpc_cidr = "10.0.0.0/16" #var.vpc_cidr
  prefix   = local.prefix
}

locals {
  prefix = "project-csa-23"
  date = "oct-16"
}

module "subnets" {
  source = "./modules/subnet/"
  bambam = module.vpc.vpc_id
  prefix = local.prefix
  subnets = {
    my_first_subnet_using_module = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1c"
    }
    my-demo2-subnet = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
    }
    my-demo3-subnet = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1b"
    }
  }
}

output "bambams_vpc" {
  value = module.vpc.vpc_id
}

#replace(string, substring, replacement)

variable "config" {
  type = map(string)
  default = {
    region     = "us-east-1"
    instance_type = "t1.small"
    environment = "development"
    availability_zone = "us-east-1b"
  }
}


resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = lookup(var.config, "instance_type", "t2.micro")
  availability_zone = lookup(var.config, "availability_zone", "us-east-1a")
  tags = {
    #Name = "${lookup(var.config,"environment","unknown")}-${lookup(var.config,"availability_zone","unknown")}"
    #Name = "${lookup(var.config,"environment","unknown")}-${lookup(var.config,"region","unknown")}"
    #lookup(var.config, "environment", "unknown")
  }
}


