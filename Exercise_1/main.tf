provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "udacity_t2" {
  count         = 4
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"

  tags = {
    Name  = "Udacity T2 (${count.index + 1})"
  }
}
resource "aws_instance" "udacity_m4" {
  count         = 2
  ami           = "ami-0022f774911c1d690"
  instance_type = "m4.large"

  tags = {
    Name  = "Udacity M4 (${count.index + 1})"
  }
}