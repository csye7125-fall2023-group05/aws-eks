resource "aws_key_pair" "ssh_key" {
  key_name   = "tf-ssh-key"
  public_key = file("~/.ssh/${var.SSH_KEY_FILE}")
}
