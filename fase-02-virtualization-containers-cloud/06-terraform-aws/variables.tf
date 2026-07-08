variable "aws_region" {
  description = "Región de AWS donde desplegaremos la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre base para los recursos del proyecto"
  type        = string
  default     = "roadmap-terraform"
}
