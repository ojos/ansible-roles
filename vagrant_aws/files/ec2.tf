resource "aws_key_pair" "default" {
  key_name = "${var.project}-${var.environment}" 
  public_key = "${file(var.public_key)}"
}

resource "aws_eip" "default" {
    vpc = true
}
