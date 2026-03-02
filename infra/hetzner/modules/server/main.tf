terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

resource "hcloud_server" "this" {
  name        = var.server_name
  server_type = var.server_type
  image       = var.server_image
  location    = var.server_location
  ssh_keys    = var.server_ssh_key_ids
  user_data   = templatefile("${path.module}/templates/k3s-init.sh.tftpl", {
    k3s_role          = var.k3s_role
    k3s_token         = var.k3s_token
    k3s_server_url    = var.k3s_server_url
    is_initial_server = var.is_initial_server
  })

  labels = {
    role = var.server_name
  }
}

resource "hcloud_server_network" "this" {
  server_id  = hcloud_server.this.id
  network_id = var.server_network_id
}
