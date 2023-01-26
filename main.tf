terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

provider "docker" {
  # Configuration options
}


resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"

}
