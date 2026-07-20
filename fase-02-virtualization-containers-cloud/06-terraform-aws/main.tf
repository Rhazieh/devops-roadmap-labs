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
