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