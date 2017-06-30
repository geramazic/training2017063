#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-58475f3e
#
# Your subnet ID is:
#
#     subnet-04e4095f
#
# Your security group ID is:
#
#     sg-c326e1bb
#
# Your Identity is:
#
#     amazic-moose
#

terraform {
  backend "atlas" {
    name = "geramazic/training"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "eu-west-1"
}

variable "instances_count" {
  default = "3"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami                    = "ami-58475f3e"
  count                  = "${var.instances_count}"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-04e4095f"
  vpc_security_group_ids = ["sg-c326e1bb"]

  tags = {
    Identity = "amazic-moose"
    Name     = "web ${count.index+1}/${var.instances_count}"
  }
}

provider "dnsimple" {
  account = "yaydaa"
  token   = "dskfjlasdfj'as"
}

resource "dnsimple_record" "example" {
  name   = "blub"
  domain = "yada-international.com"
  type   = "A"
  value  = "${aws_instance.web.0.public_ip}"
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
