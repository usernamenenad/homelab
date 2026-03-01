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

module "servers" {
  for_each = local.server_instances
  source   = "./modules/server"

  server_name        = each.key
  server_type        = each.value.type
  server_image       = each.value.image
  server_location    = each.value.location
  server_network_id  = module.network.network_id
  server_ssh_key_ids = [for k in hcloud_ssh_key.keys : k.id]
}

module "load_balancers" {
  source = "./modules/load_balancer"

  load_balancer_name       = var.load_balancer.name
  load_balancer_type       = var.load_balancer.type
  load_balancer_location   = var.load_balancer.location
  load_balancer_network_id = module.network.network_id
}
