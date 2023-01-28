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

resource "null_resource" "docker_volume" {
  provisioner "local-exec" {
    command = "mkdir dockervol/ || true && chown -R 1000:1000 dockervol/"
  }
}



resource "random_string" "random" {
  count   = local.no_of_container
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered" {
  count = local.no_of_container
  name  = "nodered-container-${random_string.random[count.index].id}"
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.internal
    external = var.external[count.index]
    protocol = "tcp"
  }
  volumes {
    container_path = "/data"
    host_path      = "/home/ununtu/environment/docker_demo/dockervol/"
  }
}

locals {
  no_of_container = length(var.external)
}


variable "internal" {
  type    = number
  default = "1880"
  validation {
    condition     = var.internal == 1880
    error_message = "The internal port must be between 1880."
  }
}

variable "external" {
  type    = list(number)
  default = [1880, 1881]

  validation {
    condition     = max(var.external...) <= 65535 && min(var.external...) >= 0
    error_message = "The external port must be between 0 - 65535."
  }
}
