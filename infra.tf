resource "ionoscloud_datacenter" "dc_01" {
  name                = var.dc_name
  location            = var.dc_location
  description         = var.dc_description
  sec_auth_protection = false
}

resource "ionoscloud_lan" "lan_01" {

  datacenter_id = ionoscloud_datacenter.dc_01.id
  public        = false
  name          = var.lan_name
}


resource "ionoscloud_ipblock" "ipblock_01" {
  location = var.dc_location
  size     = var.ipblock_size
  name     = var.ipblock_name
}



resource "ionoscloud_k8s_cluster" "k8s_cluster_03" {
  name        = var.k8s_name
  k8s_version = var.k8s_ver
  public      = true
}

resource "ionoscloud_k8s_node_pool" "k8s_node_pool_01" {
  datacenter_id  = ionoscloud_datacenter.dc_01.id
  k8s_cluster_id = ionoscloud_k8s_cluster.k8s_cluster_03.id
  name           = var.nodepool_name
  k8s_version    = ionoscloud_k8s_cluster.k8s_cluster_03.k8s_version
  maintenance_window {
    day_of_the_week = "Sunday"
    time            = "09:00:00Z"
  }
  auto_scaling {
    min_node_count = 2
    max_node_count = 3
  }
  cpu_family        = "INTEL_SKYLAKE"
  availability_zone = "AUTO"
  storage_type      = "SSD"
  node_count        = 2
  cores_count       = 4
  ram_size          = 4096
  storage_size      = 80
  public_ips        = [ionoscloud_ipblock.ipblock_01.ips[0], ionoscloud_ipblock.ipblock_01.ips[1], ionoscloud_ipblock.ipblock_01.ips[2], ionoscloud_ipblock.ipblock_01.ips[3]]

}

data "ionoscloud_k8s_cluster" "k8s_cluster_03" {
  name = var.k8s_name
}

resource "local_file" "kubeconfig" {
  depends_on        = [ionoscloud_k8s_cluster.k8s_cluster_03]
  sensitive_content = yamlencode(jsondecode(data.ionoscloud_k8s_cluster.k8s_cluster_03.kube_config))
  filename          = "kubeconfig.yaml"
}


provider "helm" {

  kubernetes {
    host  = data.ionoscloud_k8s_cluster.k8s_cluster_03.config[0].clusters[0].cluster.server
    token = data.ionoscloud_k8s_cluster.k8s_cluster_03.config[0].users[0].user.token
    cluster_ca_certificate = base64decode(
      yamldecode(data.ionoscloud_k8s_cluster.k8s_cluster_03.kube_config).clusters[0].cluster.certificate-authority-data
    )
  }
}

resource "helm_release" "ingress-nginx" {

  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  set {
    name  = "controller.service.loadBalancerIP"
    value = "212.227.51.61"
  }
}
