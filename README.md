# tf_azuread_create_apps
Creación desde Terraform para aplicaciones backend/frontend sobre Azure AD

# Uso

#### Exportar variables
<br/>$ export TF_VAR_tenant_id=00000000-0000-0000-0000-000000000000
<br/>$ export TF_VAR_app_backend=backend
<br/>$ export TF_VAR_app_frontend=frontend
<br/>$ export TF_VAR_app_environment=dev

#### Ejecución de terraform

<br/>$ terraform init
<br/>$ terraform plan
<br/>$ terraform apply
