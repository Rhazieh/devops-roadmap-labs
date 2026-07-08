terraform {
  required_version = ">=  1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Descarga la version 5.x más reciente"
    }
  }
}

provider "aws" {
  region = var.aws_region # Acá llamamos a la variable que declaramos antes
}
