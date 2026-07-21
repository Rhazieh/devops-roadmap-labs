output "ec2_public_ip" {
  description = "IP pública de la instancia EC2 recién creada"
  value       = aws_instance.web_server.public_ip
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3 creado"
  value       = aws_s3_bucket.lab_bucket.id
}
