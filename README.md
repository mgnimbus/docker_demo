provider acts as a bridge to make APi calls to service like GCP,AWS,Azure...etc

version contrains with ~> which allows right most to increment 
~> 2.0 it is allowed to update till 2.9
~>3.0.0 its is allowed to update till 3.0.99

A program may need mutliple provider may its ia hashicorp or 3rd party like null,aws one in default region other in another region for backup

you first initiliaze the tf with the terraform block whick has the info about whick specifies the source and the verison you want to use

and provider block provides the addiition info about the region and other 



//to get the  meta data from aws console
curl http://169.254.169.254/latest/meta-data/public-ipv4 

//to see the state file better
sudo apt install jq

//to view the state file with jq
terraform show -json | jq

//to list the resources deployed
terraform state list

// to list the state file
terraform show

//to parse the state file show the required file,
where it show the all the names that are in that are in the state file
terraform show | name

//terraform cli
$ terraform console

<resource name>.<resource identifier>.<the flied you want to see like name,port,ip>

join(seperator, list)
join("-" [${name},db])
tfdemo-db

array{

    key1 = value1
    key2 = value2
}

to use as a reference you need to add index as an arry can be mutiple 
like root block device ther  may be many so to differtiate programs use indexing
docker_container.node_red.array[0].key

join(":", [docker_container.nodered.network_data[0].ip_address,docker_container.nodered.ports[0].internal])

join(":", [docker_container.nodered.network_data[0].ip_address,docker_container.nodered.ports[0].internal])

container_ip-address_port = "172.17.0.2:1880"
http_container_ip-address_port = "http:\\172.17.0.2:1880"





//variable can be set through 
//cli, env set up, tfvars, auto.tfvars, default

//In cli, you need to provide ip's for  every run
terraform plan -var ami_id="ami-xxxx"


//env set up,once you set then they are fixed untill you unset them

$ export TF_VAR_ami_id="ami-xxxxxxx"
then ami_id will be set to "ami-xxxxxxx" in the conf, until you remove the setup with 'unset'

$ unset TF_VAR_ami_id


//default

variable "ami_id" {
    type = number
    default = "ami-xxxxx"
}

validation in variables

variable "external" {
  type = number
  default = "70000"
  
  validation {
    condition = var.external <= 65535 && var.external >= 0
    error_message = "The external port must be between 0 - 65535"
    
  }
}

// when you run tou get this error message

variable "external" {
    
var.external is 70000

The external port must be between 0 - 65535
 
This was checked by the validation rule at main.tf:55,3-13.

//tfvars is file where you provides the value for the variableyou defined

terraform.tfvars
ami_id= "ami-xxxx"
instancve_type = "t2.micro"
internal_port = 1800
external_port = 7000

//ami_ids differ by hr region you selected

west.tfvar
ami_id= "ami-yyyy"
instancve_type = "t2.micro"
internal_port = 1800
external_port = 7000

//in theis case terraform.tfvars takes precendence as you havent set anything in particular
$ terraform plan 

//to use the west,tf.vars
$ terraform plan -var-file=west.tfvars

//for central
$ terraform plan -var-file=cent.tfvars

//If you want to hide the imp values then you add the fucntio  
sensitive=true

variable "external" {
  type = number
  default = "70000"
  sensitive = true
  
  validation {
    condition = var.external <= 65535 && var.external >= 0
    error_message = "The external port must be between 0 - 65535
  }
}

provisioners
they will excute resources on your behalf like ansible does

ther are file,local-exec,remote-exec

resource "null_resource" "docker_volume" {
  provisioner "local-exec" {
    command = "mkdir dockervol/ || true && chown -R 1000:1000 dockervol/"
  }
}

they are a bit tricky to use just use them for last resort 
most production use tools like ansible and shit

Like they are not idemoptent like other resource you need to take a precaution while using them

like here in case dockervil is present already,its show a error it's already present
need to make them idempotent by using the commande '"mkdir dockervol/ || true && chown -R 1000:1000 dockervol/"
If the directory is present 


//now lets say you need to provision containers based on the ports available
variable "external" {
  type    =  list(number)
  default = [1880, 1881, 1882]
  }
  
  resource "docker_container" "nodered" {
  count = var.no_of_container
  name  = "nodered-container-${random_string.random[count.index].id}"
  image = docker_image.nodered_image.image_id
  ports {
    internal = var.internal
    external = var.external[count.index]
    protocol = "tcp"
  }
  }
  
--now the ports are fixed and the count must be depend on the number of ext ports
so lets fix no_of_container

variable "no_of_containes" {
  type = number
  default = length(var.external)
}

NO we cant call another function in the variable.
FOr that we need to use local

locals {
  no_of_containers = length(var.external)
}

count = local.no_of_container

NOw to use validation for a list we need to make use of another function called max and min 
with which we find the max value amoung the list and minimum

max(1,2,3)
3

max([1, 2, 3])
//Its wont work as its looking for the list

max([1, 2 ,3]...)
... is the expand/spread opertor is to break the function and test individuvally


In real use in variable
  validation {
    condition     = max(var.external...) <= 65535 && min(var.external...) >= 0
    error_message = "The external port must be between 0 - 65535."
  }
  
  
  variable "external" {
  type    =  list(number)
  default = [1880, 1881]

  validation {
    condition     = max(var.external...) <= 65535 && min(var.external...) >= 0
    error_message = "The external port must be between 0 - 65535."
  }
}

condition     = max(var.external...) doesn't need square[] as its already in the list


--Path refrences
> path.root
"."
> path.cwd
"/home/ubuntu/environment/docker_demo"
> path.module
"."

  volumes {
    container_path ="/data"
    host_path = "${path.cwd}/dockervol/"
  }
  
  --string Interpolatin ${}
  
  
  --lookup
  
  lookup(map, key, default)
  
  lookup({dev="image1", prod="image2"}, dev)
  image1
  
  lookup({dev="image1", prod="image2"}, prod)
  image2
  
  resource "docker_image" "nodered_image" {
  name = lookup(var.docket_image, "${var.env}")
}

variable "env" {
  type        = string
  description = "Env to deploy to"
  default     = "dev"
}

variable "docket_image" {
  type        = map(string)
  description = "Image to use for provisioning"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}