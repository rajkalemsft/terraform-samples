variable "application_name" {}

data "azuread_client_config" "current" {
}

resource "azuread_application" "aad_application" {
  display_name       = var.application_name
  owners             = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "app_service_principal" {
  application_id                    = azuread_application.aad_application.application_id
  app_role_assignment_required      = false
  owners                            = [data.azuread_client_config.current.object_id]
}

resource "time_rotating" "app_password_rotation" {
  rotation_hours = 1
  lifecycle {
    create_before_destroy = true
  }
}

resource "azuread_application_password" "app_password" {
  application_object_id = azuread_application.aad_application.id
  rotate_when_changed = {
    rotation = time_rotating.app_password_rotation.id
  }
}

resource "azuread_service_principal_password" "app_password" {
  service_principal_id = azuread_service_principal.app_service_principal.id
  #rotate_when_changed = {
  #  rotation = time_rotating.app_password_rotation.id
  #}
}

output "sp" {
  value     = azuread_service_principal.app_service_principal.id
  sensitive = true
}

output "sp_password" {
  value     = azuread_service_principal_password.app_password.value
  sensitive = true
}
output "sp_end_date" {
  value     = azuread_service_principal_password.app_password.end_date
}

output "app_password" {
  value     = azuread_application_password.app_password.value
  sensitive = true
}

output "app_end_date" {
  value     = azuread_application_password.app_password.end_date
  sensitive = true
}