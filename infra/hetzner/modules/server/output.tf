output "server_id" {
  value = hcloud_server.this.id
}

output "ipv4_address" {
  value = hcloud_server.this.ipv4_address
}

output "private_ip" {
  value = hcloud_server_network.this.ip
}
