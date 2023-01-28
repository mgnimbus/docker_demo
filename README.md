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