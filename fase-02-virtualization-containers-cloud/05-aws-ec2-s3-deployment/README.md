# Fase 5: Cloud Computing (AWS Free Tier)

Este laboratorio contiene la configuración inicial, despliegue y automatización de infraestructura en Amazon Web Services (AWS).

## Misión 1: Seguridad Base (IAM) y Gestión de Costos

Para asegurar la cuenta y cumplir con las buenas prácticas de AWS, se realizaron las siguientes acciones:

- [x] **Segurización de Cuenta Root:** Se activó la autenticación multifactor (MFA) en la cuenta principal.
- [x] **Alerta de Presupuesto (Billing Alarm):** Se configuró una alerta en *AWS Budgets* automatizada para recibir un correo electrónico si el gasto proyectado o real supera los **$1 USD**.
- [x] **Usuario IAM Administrador:** Se creó el usuario operativo `maxi-admin` con la política `AdministratorAccess` y MFA obligatorio. La cuenta Root ya no se utiliza para el despliegue diario.

### Evidencias de Configuración
![IAM Users List](images/iam_user_mfa.png)
