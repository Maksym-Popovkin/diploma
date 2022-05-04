terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "diploma" {
  name      = var.resource_group_name
  location  = var.resource_group_location
}

# Create virtual network
resource "azurerm_virtual_network" "internal_network" {
  name                = "internal_net"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name
}

# Create subnet
resource "azurerm_subnet" "subnet_for_jenkins" {
  name                 = "subnet_for_jenkins"
  resource_group_name  = azurerm_resource_group.diploma.name
  virtual_network_name = azurerm_virtual_network.internal_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet_for_DEV_QA" {
  name                 = "subnet_for_DEV_QA"
  resource_group_name  = azurerm_resource_group.diploma.name
  virtual_network_name = azurerm_virtual_network.internal_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet_for_STG_PROD" {
  name                 = "subnet_for_STG_PROD"
  resource_group_name  = azurerm_resource_group.diploma.name
  virtual_network_name = azurerm_virtual_network.internal_network.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "Jenkins_IP" {
  name                         = "JenkinsIP"
  location                     = azurerm_resource_group.diploma.location
  resource_group_name          = azurerm_resource_group.diploma.name
  allocation_method            = "Static"
}

resource "azurerm_public_ip" "Dev_IP" {
  name                         = "DevIP"
  location                     = azurerm_resource_group.diploma.location
  resource_group_name          = azurerm_resource_group.diploma.name
  allocation_method            = "Static"
}

resource "azurerm_public_ip" "Qa_IP" {
  name                         = "QaIP"
  location                     = azurerm_resource_group.diploma.location
  resource_group_name          = azurerm_resource_group.diploma.name
  allocation_method            = "Static"
}

resource "azurerm_public_ip" "Stg_IP" {
  name                         = "StgIP"
  location                     = azurerm_resource_group.diploma.location
  resource_group_name          = azurerm_resource_group.diploma.name
  allocation_method            = "Static"
}

resource "azurerm_public_ip" "Prod_IP" {
  name                         = "ProdIP"
  location                     = azurerm_resource_group.diploma.location
  resource_group_name          = azurerm_resource_group.diploma.name
  allocation_method            = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "Jenkins_NSG" {
  name                = "JenkinsNSG"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Jenkins_Port"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "Dev_QA_NSG" {
  name                = "DevQaNSG"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Jenkins_Port"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "Stg_Prod_NSG" {
  name                = "StageProdNSG"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Jenkins_Port"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "Jenkins_Net_interface" {
  name                = "Jenkins_NI"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  ip_configuration {
    name                          = "NicConfigurationforJenkins"
    subnet_id                     = azurerm_subnet.subnet_for_jenkins.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Jenkins_IP.id
  }
}

resource "azurerm_network_interface" "DEV_Net_interface" {
  name                = "Dev_NI"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  ip_configuration {
    name                          = "NicConfigurationforJenkins"
    subnet_id                     = azurerm_subnet.subnet_for_DEV_QA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Dev_IP.id
  }
}

resource "azurerm_network_interface" "QA_Net_interface" {
  name                = "QA_NI"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  ip_configuration {
    name                          = "NicConfigurationforJenkins"
    subnet_id                     = azurerm_subnet.subnet_for_DEV_QA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Qa_IP.id
  }
}

resource "azurerm_network_interface" "STG_Net_interface" {
  name                = "STG_NI"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  ip_configuration {
    name                          = "NicConfigurationforJenkins"
    subnet_id                     = azurerm_subnet.subnet_for_STG_PROD.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Stg_IP.id
  }
}

resource "azurerm_network_interface" "PROD_Net_interface" {
  name                = "PROD_NI"
  location            = azurerm_resource_group.diploma.location
  resource_group_name = azurerm_resource_group.diploma.name

  ip_configuration {
    name                          = "NicConfigurationforJenkins"
    subnet_id                     = azurerm_subnet.subnet_for_STG_PROD.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Prod_IP.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "Connect_Jenkins_NSG_to_NI" {
  network_interface_id      = azurerm_network_interface.Jenkins_Net_interface.id
  network_security_group_id = azurerm_network_security_group.Jenkins_NSG.id
}

resource "azurerm_network_interface_security_group_association" "Connect_Dev_NSG_to_NI" {
  network_interface_id      = azurerm_network_interface.DEV_Net_interface.id
  network_security_group_id = azurerm_network_security_group.Dev_QA_NSG.id
}

resource "azurerm_network_interface_security_group_association" "Connect_Qa_NSG_to_NI" {
  network_interface_id      = azurerm_network_interface.QA_Net_interface.id
  network_security_group_id = azurerm_network_security_group.Dev_QA_NSG.id
}

resource "azurerm_network_interface_security_group_association" "Connect_Stg_NSG_to_NI" {
  network_interface_id      = azurerm_network_interface.STG_Net_interface.id
  network_security_group_id = azurerm_network_security_group.Stg_Prod_NSG.id
}

resource "azurerm_network_interface_security_group_association" "Connect_Prod_NSG_to_NI" {
  network_interface_id      = azurerm_network_interface.PROD_Net_interface.id
  network_security_group_id = azurerm_network_security_group.Stg_Prod_NSG.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.diploma.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.diploma.location
  resource_group_name      = azurerm_resource_group.diploma.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "Jenkins_VM" {
  name                  = "Jenkins"
  location              = azurerm_resource_group.diploma.location
  resource_group_name   = azurerm_resource_group.diploma.name
  network_interface_ids = [azurerm_network_interface.Jenkins_Net_interface.id]
  size                  = "Standard_DS2_v2"

  os_disk {
    name                 = "Jenkins_Disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "jenkins"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  provisioner "remote-exec" {
        connection {
            host = self.public_ip_address
            type     = "ssh"
            user     = var.username
            password = var.password
        }

        inline = [
        "sudo apt-get update -y",
        "sudo apt-get install -y openjdk-11-jdk",
        "sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
        "sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
        "sudo apt-get update -y",
        "sudo apt-get install -y jenkins"
        ]
    }  
}

resource "azurerm_linux_virtual_machine" "Dev_VM" {
  name                  = "Dev"
  location              = azurerm_resource_group.diploma.location
  resource_group_name   = azurerm_resource_group.diploma.name
  network_interface_ids = [azurerm_network_interface.DEV_Net_interface.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "Dev_Disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "dev"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}

resource "azurerm_linux_virtual_machine" "Qa_VM" {
  name                  = "Qa"
  location              = azurerm_resource_group.diploma.location
  resource_group_name   = azurerm_resource_group.diploma.name
  network_interface_ids = [azurerm_network_interface.QA_Net_interface.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "Qa_Disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "qa"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}

resource "azurerm_linux_virtual_machine" "Stage_VM" {
  name                  = "Stage"
  location              = azurerm_resource_group.diploma.location
  resource_group_name   = azurerm_resource_group.diploma.name
  network_interface_ids = [azurerm_network_interface.STG_Net_interface.id]
  size                  = "Standard_DS2_v2"

  os_disk {
    name                 = "Stage_Disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "stage"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}

resource "azurerm_linux_virtual_machine" "Prod_VM" {
  name                  = "Prod"
  location              = azurerm_resource_group.diploma.location
  resource_group_name   = azurerm_resource_group.diploma.name
  network_interface_ids = [azurerm_network_interface.PROD_Net_interface.id]
  size                  = "Standard_DS2_v2"

  os_disk {
    name                 = "Prod_Disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "prod"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}