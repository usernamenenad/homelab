terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50.0"
    }
  }
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

resource "hcloud_ssh_key" "main" {
  name       = "ssh-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "server" {
  count       = 2
  name        = "server-${count.index + 1}"
  server_type = "cx22"
  image       = "ubuntu-22.04"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.main.name]
}
