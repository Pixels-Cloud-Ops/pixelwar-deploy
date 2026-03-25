resource "aws_vpc" "pixelwar_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "pixelwar-vpc" }
}

resource "aws_subnet" "pixelwar_indus_subnet" {
  vpc_id = aws_vpc.pixelwar_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true # Pour pouvoir accéder depuis ANSIBE
  tags = { Name = "subnet-indus" }
  
}

resource "aws_subnet" "pixelwar_production_subnet" {
  vpc_id = aws_vpc.pixelwar_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b" # On met la prod dans la zone B (pour la haute disponibilité !)
  map_public_ip_on_launch = true # Pour pouvoir accéder depuis ANSIBE
  tags = { Name = "subnet-prod" }
}

resource "aws_internet_gateway" "pixelwar_igw" {
  vpc_id = aws_vpc.pixelwar_vpc.id
  tags   = { Name = "main-igw" }
}

# Nécessaire pour que les instances dans les subnets puissent accéder à Internet (pour les mises à jour, etc.)
resource "aws_route_table" "pixelwar_public_rt" {
  vpc_id = aws_vpc.pixelwar_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pixelwar_igw.id
  }

  tags = { Name = "public-route-table" }
}

resource "aws_route_table_association" "indus_link" {
  subnet_id      = aws_subnet.pixelwar_indus_subnet.id
  route_table_id = aws_route_table.pixelwar_public_rt.id
}

resource "aws_route_table_association" "prod_link" {
  subnet_id      = aws_subnet.pixelwar_production_subnet.id
  route_table_id = aws_route_table.pixelwar_public_rt.id
}

# LE GARDE DU CORPS DE L'INDUS
resource "aws_security_group" "indus_sg" {
  name   = "pixelwar-indus-sg"
  vpc_id = aws_vpc.pixelwar_vpc.id

  #conx SSH pour Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Pour Ansible
  }

  #conx HTTP pour les joueurs
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # API K3s : Crucial pour que le Worker rejoigne le Master
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # GitHub Actions doit pouvoir joindre le cluster
  }

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    self        = true  # entre les nodes uniquement
  }
  ingress {
    from_port   = 30815
    to_port     = 30815
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 3. SORTIE : Pour que la machine puisse télécharger K3s et RÉPONDRE aux clients
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# LE GARDE DU CORPS DE LA PROD
resource "aws_security_group" "prod_sg" {
  name   = "pixelwar-prod-sg"
  vpc_id = aws_vpc.pixelwar_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Pour Ansible
  }

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    self        = true  # entre les nodes uniquement
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Pour les joueurs
  }

  # API K3s : Crucial pour que le Worker rejoigne le Master
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # GitHub Actions doit pouvoir joindre le cluster
  }

  # 3. SORTIE : Pour que la machine puisse télécharger K3s et RÉPONDRE aux clients
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}