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

