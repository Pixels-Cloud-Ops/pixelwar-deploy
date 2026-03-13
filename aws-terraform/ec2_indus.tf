resource "aws_instance" "indus_master" {
  #Amazon Machine Image
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t3.small"
  
  subnet_id              = aws_subnet.pixelwar_indus_subnet.id
  vpc_security_group_ids = [aws_security_group.indus_sg.id]

  key_name = "pixelwarSSH" #ssh key name in aws

  tags = {
    Name = "indus-pixelwar-master"
  }
}

resource "aws_instance" "indus_worker" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t3.small"
  
  subnet_id              = aws_subnet.pixelwar_indus_subnet.id
  vpc_security_group_ids = [aws_security_group.indus_sg.id]

  key_name = "pixelwarSSH" #ssh key name in aws

  tags = {
    Name = "indus-pixelwar-worker"
  }
  
}