variable "hcloud_token" {
  sensitive = true
  type      = string
}

variable "ssh_keys" {
  type    = list(string)
  default = []
}

variable "network" {
  type = object({
    name     = string
    ip_range = string
    zone     = string
  })
}

variable "servers" {
  type = map(object({
    type     = string
    image    = string
    location = string
    count    = number
  }))
}

variable "load_balancer" {
  type = object({
    name     = string
    type     = string
    location = string
  })
}
