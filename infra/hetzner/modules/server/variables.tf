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

variable "k3s_role" {
  description = "K3s role: 'server' or 'agent'"
  type        = string
  validation {
    condition     = contains(["server", "agent"], var.k3s_role)
    error_message = "k3s_role must be 'server' or 'agent'."
  }
}

variable "k3s_token" {
  description = "Shared secret for k3s cluster join"
  type        = string
  sensitive   = true
}

variable "k3s_server_url" {
  description = "URL of the k3s server to join (empty for the initial server)"
  type        = string
  default     = ""
}

variable "is_initial_server" {
  description = "Whether this is the first control plane node that bootstraps the cluster"
  type        = bool
  default     = false
}
