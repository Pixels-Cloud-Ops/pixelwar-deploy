resource "aws_instance" "prod_master" {
  #Amazon Machine Image
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t3.small"
  
  subnet_id              = aws_subnet.pixelwar_production_subnet.id
  vpc_security_group_ids = [aws_security_group.prod_sg.id]

  key_name = "pixelwarSSH" #ssh key name in aws
  
  tags = {
    Name = "prod-pixelwar-master"
  }

}

resource "aws_instance" "prod_worker" {
  count = 2
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t3.small"
  
  subnet_id              = aws_subnet.pixelwar_production_subnet.id
  vpc_security_group_ids = [aws_security_group.prod_sg.id]
  
  key_name = "pixelwarSSH" #ssh key name in aws

  tags = {
    Name = "prod-pixelwar-worker${count.index + 1}"
  }
}