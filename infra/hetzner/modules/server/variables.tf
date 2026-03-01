variable "server_name" {
  type = string
}

variable "server_type" {
  type = string
}

variable "server_image" {
  type = string
}

variable "server_location" {
  type = string
}

variable "server_ssh_key_ids" {
  type    = list(string)
  default = []
}

variable "server_network_id" {
  type = string
}
