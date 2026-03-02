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

variable "k3s_token" {
  description = "Shared secret used by k3s nodes to join the cluster"
  sensitive   = true
  type        = string
}
