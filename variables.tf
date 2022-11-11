variable "client_id" {
  description = "Enter Client ID"
}

variable "client_secret" {
  description = "Enter client secret"
}

variable "tenant_id" {
  description = "Enter Tenand ID"
}

variable "subscription_id" {
  description = "Enter Subscription ID"
}

variable "resource_group" {
  type = map(string)
  default = {
    name     = "rg-1"
    location = "EastUS"
  }
}

variable "locations" {
  type = map(string)
  default = {
    location1 = "EastUS"
    location2 = " WestUS"
  }
}

variable "subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_ip" {
  type = list(string)
}

