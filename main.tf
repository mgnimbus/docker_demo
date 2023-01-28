terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "docker" {
  # Configuration options
}


resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered" {
  count = 2
  name  = "nodered-container-${random_string.random[count.index].id}"
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    #external = 1880
  }
}

output "container_ids" {
  value = docker_container.nodered[*].name
}

output "container_ip-address_port" {
  value = join(":", [docker_container.nodered[0].network_data[0].ip_address, docker_container.nodered[0].ports[0].external])
}

output "http_container_ip-address_port" {
  value = join(":", ["http:\\${docker_container.nodered[1].network_data[0].ip_address}", docker_container.nodered[1].ports[0].external])
}

output "container_ports" {
  value = docker_container.nodered[*].ports
}

output "container_ip_with_for" {
  value = [for i in docker_container.nodered[*] : join(":", [i.network_data[0].ip_address, i.ports[0].external])]
}

//splat operator shoes the op in differnt list where as indexing shows in the same list
output "container_ip_addr_with_splat" {
  value = [for i in docker_container.nodered[*] : i.network_data[*].ip_address]
}

output "container_ip_addr_with_index" {
  value = [for i in docker_container.nodered[*] : i.network_data[0]["ip_address"]]
}



# resource "docker_container" "nodered2" {
#   name  = join ("-", ["nodered-container2",random_string.random.id]) 
#   image = docker_image.nodered_image.image_id
#   ports {
#     internal = 1880
#     #external = 1880
#   }
# }

# output "http_container_ip-address_port" {
#   value = join(":", ["http:\\${docker_container.nodered.network_data[0].ip_address}", docker_container.nodered2.ports[0].external])
# }

