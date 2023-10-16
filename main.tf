terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "enabling_internode_encryption_in_apache_cassandra" {
  source    = "./modules/enabling_internode_encryption_in_apache_cassandra"

  providers = {
    shoreline = shoreline
  }
}