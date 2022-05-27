resource "ionoscloud_k8s_cluster" "k8s_cluster_03" {
  name        = var.k8s_name
  k8s_version = var.k8s_ver
  public      = true
}
