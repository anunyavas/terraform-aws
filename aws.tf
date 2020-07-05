provider "aws" {
  region = "us-east-1"
}

variable "subnet_id" {
  default = "subnet-e96ebeb6"
}

variable "vpc_id" {
  default = "vpc-7a2ccf07"
}
variable "image_id" {
  default = "ami-0ac80df6eff0e70b5"
}

resource "aws_key_pair" "amazon" {
  key_name   = "amazon"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCaHrKnfYR+2Z6pTG5ZifZh6ee+JVfqb4iEayYnoea9MuCeUyER9+V62HENR1zbr1ww1laGGxI3oTrAYe+Freh3LVM+g7RQrtJr1WM25xZ78IPuncGJmtbh1qnuE4DWLSwxik1cWYhkKJu7hIZ0M+6TkHmQmr0zmX/itMk9s5tGbc/I0yfEXK4Eyldr5psLSiyQbjEPdYDeLzUmF5TVkyh07Gt0p5QWNg3yM7mnk39RZ1xILtPC1/189Drm3xjjs6E0XVvBwK17JzmTGfqAv6WQeYzxILfDwPTgd6dC+yyOm867sWcOXmzje49SGTAW1mlE9Ac7Y0+XwlYBzxx1HtX"
}

resource "aws_security_group" "allow_app_traffic" {
  name        = "allow_traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description = "app from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["176.59.47.44/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "build_instance" {
  ami = "${var.image_id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.amazon.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_app_traffic.id}"]
  subnet_id = "${var.subnet_id}"
  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}

resource "aws_instance" "prod_instance" {
  ami = "${var.image_id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.amazon.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_app_traffic.id}"]
  subnet_id = "${var.subnet_id}"
  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}


