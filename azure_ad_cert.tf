resource "azuread_application" "eh_consumer_app" {
  display_name = "eh_consumer_app"
  owners = [ var.user-principal ]
}

#resource "azuread_application_certificate" "eh_consumer_app_cert" {
#  application_object_id = azuread_application.eh_consumer_app.id
#  type                  = "AsymmetricX509Cert"
#  value                 = file("cert.cer")
#  end_date              = "2022-07-15T00:00:00Z"
#}


data "azurerm_key_vault_certificate_data" "example" {
  name         = "eh-dev-client"
  key_vault_id = azurerm_key_vault.eh-keyvault.id
}

resource "azuread_application_certificate" "eh_consumer_app_cert" {
  application_object_id = azuread_application.eh_consumer_app.id
  type                  = "AsymmetricX509Cert"
  value                 = data.azurerm_key_vault_certificate_data.example.pem
  end_date              = "2022-07-15T00:00:00Z"
}