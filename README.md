provider acts as a bridge to make APi calls to service like GCP,AWS,Azure...etc

version contrains with ~> which allows right most to increment 
~> 2.0 it is allowed to update till 2.9
~>3.0.0 its is allowed to update till 3.0.99

A program may need mutliple provider may its ia hashicorp or 3rd party like null,aws one in default region other in another region for backup

you first initiliaze the tf with the terraform block whick has the info about whick specifies the source and the verison you want to use

and provider block provides the addiition info about the region and other 