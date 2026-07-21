# 1. Crear la VPC, red privada aislada en la nube
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # Espacio de IPs disponible (65.536 ips)
  enable_dns_hostnames = true          # Permite que las instancias tengan DNS públicos

  tags = {
    Name        = "${var.project_name}-vpc"
    ManagedBy   = "Terraform"
    Environment = "Lab"
  }
}

# 2. Crear el Bucket de S3 (Para los archivos o el estado remoto futuro)
resource "aws_s3_bucket" "lab_bucket" {
  # El nombre debe ser único globalmente en todo AWS. Le sumamos el ID propio.
  bucket = "${var.project_name}-bucket-maxi-tandil"

  tags = {
    Name        = "${var.project_name}-bucket"
    ManagedBy   = "Terraform"
    Environment = "Lab"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id # vincula el gateway a la VPC que creamos antes

  tags = {
    Name      = "${var.project_name}-igw"
    ManagedBy = "Terraform"
  }
}

# 4. Subred Pública (El lote específico dentro de la VPC)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24" # una porcion de la 10.0.0.0/16, o sea 254 host IPs
  map_public_ip_on_launch = true          # IP pública asignada automáticamente a las EC2 que creemos acá

  tags = {
    Name      = "${var.project_name}-public-subnet"
    ManagedBy = "Terraform"
  }
}

# 5. Tabla de Ruteo
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id # lo manda a traves de nuestro internet gw
  }

  tags = {
    Name      = "${var.project_name}-public-rt"
    ManagedBy = "Terraform"
  }
}

# 6. Asociación (conectar el lote a las reglas)
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Buscar la ultima AMI oficial de Ubuntu 24.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID oficial de Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# 8. Security Group (Firewall)
resource "aws_security_group" "web_sg" {
  name        = "web-docker-sg"
  description = "Permitir SSH y trafico web"
  vpc_id      = aws_vpc.main.id

  # Regla de Entrada: SSH desde cualquier lado (para desarrollo)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de Entrada: HTTP para app Docker
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de Salida: Permitir que la EC2 salga a internet a bajar paquetes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Significa "todos los protocolos"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "web-docker-sg"
    ManagedBy = "Terraform"
  }
}

# 9. Instancia EC2
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id # Usa el ID de la AMI que busco el bloque data
  instance_type = "t3.micro"             # Entra en el Free Tier

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name      = "${var.project_name}-ec2"
    ManagedBy = "Terraform"
  }
}
