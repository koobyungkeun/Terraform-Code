# bastion key pair 생성
resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key"
  public_key = file("../.ssh/id_rsa.pub")
}

# eks worker node key pair 생성
resource "aws_key_pair" "eks_node_key" {
  key_name   = "eks_node_key"
  public_key = file("../.ssh/id_rsa2.pub")
}
