terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

resource "hcloud_load_balancer" "this" {
  name               = var.load_balancer_name
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
}

resource "hcloud_load_balancer_network" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  network_id       = var.load_balancer_network_id
}

resource "hcloud_load_balancer_target" "this" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.this.id
  server_id        = "122442915" # TODO - replace this
  use_private_ip   = true
}
