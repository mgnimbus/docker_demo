# --Path refrences
# > path.root
# "."
# > path.cwd
# "/home/ubuntu/environment/docker_demo"
# > path.module
# "."

# volumes {
#   container_path = "/data"
#   host_path      = "${path.cwd}/dockervol/"
# }

#   --lookup

#   lookup(map, key, default)

#   lookup({dev="image1", prod="image2"}, dev)
#   image1

#   lookup({dev="image1", prod="image2"}, prod)
#   image2

#   resource "docker_image" "nodered_image" {
#   name = lookup(var.docket_image, "${var.env}")
# }

# variable "env" {
#   type        = string
#   description = "Env to deploy to"
#   default     = "dev"
# }

# variable "docket_image" {
#   type        = map(string)
#   description = "Image to use for provisioning"
#   default = {
#     dev  = "nodered/node-red:latest"
#     prod = "nodered/node-red:latest-minimal"
#   }
# }
