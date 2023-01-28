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
  name = lookup(var.docker_image, "${var.env}")
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
    external = lookup(var.external, var.env)
    protocol = "tcp"
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/dockervol/"
  }
}

locals {
  no_of_container = length(var.external)
}

variable "env" {
  type        = string
  description = "Env to deploy to"
  default     = "dev"
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
  type = map(string)
  default = {
    dev  = "1880"
    prod = "2000"
  }

  validation {
    condition     = max(values(var.external)...) <= 65535 && min(values(var.external)...) >= 0
    error_message = "The external port must be between 0 - 65535."
  }
}

variable "docker_image" {
  type        = map(string)
  description = "Image to use for provisioning"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}
