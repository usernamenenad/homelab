terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

locals {
  server_instances = merge([
    for role, cfg in var.servers : {
      for i in range(cfg.count) : "${role}-${i}" => {
        type     = cfg.type
        image    = cfg.image
        location = cfg.location
        role     = role
      }
    }
  ]...)
}

resource "hcloud_ssh_key" "keys" {
  for_each   = toset(var.ssh_keys)
  name       = basename(each.value)
  public_key = file(each.value)
}

module "network" {
  source = "./modules/network"

  network_name     = var.network.name
  network_ip_range = var.network.ip_range
  network_zone     = var.network.zone
}


module "control_plane_init" {
  source = "./modules/server"

  server_name        = "control-0"
  server_type        = var.servers["control"].type
  server_image       = var.servers["control"].image
  server_location    = var.servers["control"].location
  server_network_id  = module.network.network_id
  server_ssh_key_ids = [for k in hcloud_ssh_key.keys : k.id]
  k3s_role           = "server"
  k3s_token          = var.k3s_token
  is_initial_server  = true
}

module "servers" {
  for_each = { for k, v in local.server_instances : k => v if k != "control-0" }
  source   = "./modules/server"

  server_name        = each.key
  server_type        = each.value.type
  server_image       = each.value.image
  server_location    = each.value.location
  server_network_id  = module.network.network_id
  server_ssh_key_ids = [for k in hcloud_ssh_key.keys : k.id]
  k3s_role           = each.value.role == "control" ? "server" : "agent"
  k3s_token          = var.k3s_token
  k3s_server_url     = "https://${module.control_plane_init.private_ip}:6443"

  depends_on = [module.control_plane_init]
}
