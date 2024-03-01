module "gkevpc" {
  source  = "app.terraform.io/cimb-tf-cloud/gkevpc/google"
  version = "1.0.0"
  
  # VPC
  vpc_name                          = "shared-host-nonprod"
  project_network                   = "gcp_shared_host_nonprod"
  subnetwork_name                   = "gcp-rnd-gke-node-devops"
  region_network                    = "asia-southeast2"
  google_compute_subnetwork = {
    ip_cidr_range                   = "10.121.115.0/26"
  }
  secondary_ip_range = {
    first_range_name                = "gcp-rnd-gke-pod-devops"
    first_ip_cidr_range             = "10.121.115.64/26"
    second_range_name               = "gcp-rnd-gke-service-devops"
    second_ip_cidr_range            = "10.121.115.128/26"
  }
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