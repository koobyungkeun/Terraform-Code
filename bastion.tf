# bastion 용도의 ec2 인스턴스 생성
resource "aws_instance" "bastion" {
  ami                    = "ami-055166f8a8041fbf1" # ap-southeast-2 amazon linux
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.0.id
  key_name               = aws_key_pair.bastion_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]

  user_data = file("bastion.sh")

  user_data_replace_on_change = true

  tags = {
    Name = "${var.name}_bastion"
  }
}

# bastion에 할당할 eip 생성
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id

  tags = {
    Name = "${var.name}_bastion_eip"
  }
}

# bastion에 적용할 security group 생성
resource "aws_security_group" "bastion_sg" {
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}_bastion_sg"
  }
}
