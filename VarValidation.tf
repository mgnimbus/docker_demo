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


resource "docker_image" "nodered_image1" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random23" {
  count   = var.no_of_container
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered23" {
  count = var.no_of_container
  name  = "nodered-container-${random_string.random[count.index].id}"
  image = docker_image.nodered_image1.image_id
  ports {
    internal = var.internal
    external = var.external
    protocol = "tcp"
  }
}


variable "no_of_container" {
  default = "1"
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
  type    = number
  default = "7000"

  validation {
    condition     = var.external <= 65535 && var.external >= 0
    error_message = "The external port must be between 0 - 65535."

  }
}
