variable "username" {
  type = list(string)
}

variable "user_addresses" {
  type = list(string)
}

variable "service_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "my_public_key" {
  type = string
}

variable "instance_connect" {
  type        = list(string)
  description = "IP range for instance connect service"
}

variable "account_id" {
  type        = string
  description = "Account ID"
}