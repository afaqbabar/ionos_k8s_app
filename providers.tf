terraform {

  required_providers {
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = "= 6.2.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6.0"
    }


  }

  cloud {
    organization = "ionos"

    workspaces {
      name = "ionos-k8s-app"
    }
  }
}

