terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "my-image" {
  name         = "my-image:v4"
  keep_locally = false
}

resource "docker_container" "my-cname" {
  image = docker_image.my-image.latest
  name  = "web4"
  ports {
    internal = 5000
    external = 8000
  }
}
