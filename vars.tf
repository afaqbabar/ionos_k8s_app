variable "dc_name" {
  description = "Name of DC"
  default     = "DC for k8s - 01"
}

variable "dc_location" {
  description = "The regional location where VDC will be created"
  default     = "de/fra"
}

variable "dc_description" {
  description = "Description of DC"
  default     = "DC for k8s - 03"
}

variable "lan_name" {
  description = "Name of Private LAN"
  default     = "lan_01"
}


variable "ipblock_name" {
  description = "Name of IP block"
  default     = "ipblock_01"
}

variable "ipblock_size" {
  description = "Size of IP block"
  default     = 6
}

variable "k8s_name" {
  description = "Name of k8s cluster"
  default     = "k8s_cluster_03"
}

variable "k8s_ver" {
  description = "K8s Version"
  default     = "1.22.8"
}

variable "nodepool_name" {
  description = "Name of node pool"
  default     = "k8s_nodepool_01"
}
