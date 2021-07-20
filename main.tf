terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "webeuro" {
  name         = "webeuro:v4"
  keep_locally = false
}

resource "docker_container" "webeuro" {
  image = docker_image.webeuro.latest
  name  = "web4"
  ports {
    internal = 5000
    external = 8000
  }
}
