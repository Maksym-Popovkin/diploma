output "Jenkins_IP" {
  value = azurerm_linux_virtual_machine.Jenkins_VM.public_ip_address
}

output "DEV_IP" {
  value = azurerm_linux_virtual_machine.Dev_VM.public_ip_address
}

output "QA_IP" {
  value = azurerm_linux_virtual_machine.Qa_VM.public_ip_address
}

output "STG_IP" {
  value = azurerm_linux_virtual_machine.Stage_VM.public_ip_address
}

output "PROD_IP" {
  value = azurerm_linux_virtual_machine.Prod_VM.public_ip_address
}