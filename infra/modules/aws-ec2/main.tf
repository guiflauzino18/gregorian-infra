resource "aws_key_pair" "this" {
  key_name = var.aws-key-name
  public_key = var.aws-public-key
}