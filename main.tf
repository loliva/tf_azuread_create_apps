provider "azuread" {
  tenant_id = var.tenant_id
}
data "azuread_domains" "current" {}
data "azuread_client_config" "current" {}

//Backend
resource "random_uuid" "backend" {}
resource "azuread_application" "backend" {
  display_name = upper("${var.app_backend}-${var.app_environment}")
  owners       = [
    data.azuread_client_config.current.object_id
  ]
  sign_in_audience = "AzureADMyOrgs"
  identifier_uris = [lower(
    "api://${var.app_backend}.${data.azuread_domains.current.domains[0].domain_name}"
  )]
  api {
    oauth2_permission_scope {
      admin_consent_description  = "Acceso a backend desde frontend"
      admin_consent_display_name = "Access"
      enabled                    = true
      id                         = resource.random_uuid.backend.result
      type                       = "User"
      user_consent_description   = "Accesso a backend desde frontend"
      user_consent_display_name  = "Access"
      value                      = "access"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

//Frontend
resource "random_uuid" "frontend" {}
resource "azuread_application" "frontend" {
  display_name = upper("${var.app_frontend}-${var.app_environment}")
  owners       = [
    data.azuread_client_config.current.object_id
  ]
  sign_in_audience = "AzureADMyOrgs"
  api {
    known_client_applications = [
      azuread_application.backend.application_id,
    ]
  }
  //Roles
  app_role {
    allowed_member_types = ["User"]
    description          = "Rol admin para app"
    display_name         = "Rol admin para app"
    enabled              = true
    id                   = resource.random_uuid.frontend.result
    value                = "admin"
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = azuread_application.backend.application_id #Backend-to-frontend
    resource_access {
      id   = resource.random_uuid.backend.result
      type = "Scope"
    }
  }
  single_page_application {
    redirect_uris = [
      "http://localhost:3000/"
    ]
  }
}
