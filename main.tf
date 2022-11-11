# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider  
provider "azurerm" {

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.secret_id
  tenant_id       = var.tenant_id
}

resource "azure_resource_group" "rg" {
  name     = var.resource_group
  location = var.locations["location1"]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "TF-VirtualNetwork1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["10.0.0.0/16"]
  dns_server          = ["10.0.0.4", "10.0.0.5"]


  subnet {
    name           = "subnet1"
    address_prefix = var.subnets[0]
  }
  subent {
    name           = "subnet2"
    address_prefix = var.subnets[1]
  }

  tags = {
    environment = "Dev"
  }

}

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_storage_account" "my-storage" {
  name                     = "storage125"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_managed_disk" "disk" {
  name                 = "managed_disk"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  location             = "${azurerm_resource_group.rg.location}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"

  tags = {
    environment = "Dev"
  }
}

# Create a terraform backend storage account to store remotely and share tfstate file.
terraform {
  backend "azurerm" {
    storage_account_name = "storage125"
    container_name       = "terraform"
    key                  = "Data.terraform.tfstate"
  }
}

# Export access key to the storage account to give access for terraform to create the container in it.
// export ARM_ACCESS_KEY=XXXXXXYYYYYY
 // $env:ARM_ACCESS_KEY= "XXXXYY"