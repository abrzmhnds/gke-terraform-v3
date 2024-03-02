import {
  id = "projects/gcp-shared-host-nonprod/global/networks/shared-host-nonprod"
  to = google_compute_network.vpc
}

import {
  id = "projects/gcp-shared-host-nonprod/regions/asia-southeast2/subnetworks/gcp-rnd-gke-node-devops"
  to = google_compute_subnetwork.subnet
}

module "gkevpc" {
  source  = "app.terraform.io/cimb-tf-cloud/gkevpc/google"
  version = "1.0.5"
  
  # GKE
  google_container_cluster = {
    name                            = "terraform-cloud-gke"
    initial_node_count              = 1
    default_max_pods_per_node       = 8
  }
  project_host                      = "rnd-devops-nonprod"
  region_host                       = "asia-southeast2-b"
  ip_allocation_policy              = {
    cluster_secondary_range_name    = "gcp-rnd-gke-pod-devops"
    services_secondary_range_name   = "gcp-rnd-gke-service-devops"
  }
  private_cluster_config = {
    master_ipv4_cidr_block          = "10.121.115.208/28"
  }

  # Node pool
  google_container_node_pool = {
    name            = "general"
    node_count      = 1
  }
  node_config = {
    machine_type    = "e2-small"
  }

  service_account_name              = "terragrunt@rnd-devops-nonprod.iam.gserviceaccount.com"

}