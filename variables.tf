# LKE Variables
variable "name" {
  description = "The cluster name to use"
  default = "lke-cluster"
}

variable "k8s_version" {
  description = "The desired LKE-k8s version (major.minor)"
  default = "1.31"
  type = string
}

variable "region" {
  description = "The desired LKE region"
  default = "us-east"
  type = string
}

variable "tags" {
  description = "A List of tags to identify the cluster"
  default = ["terraform: true"]
  type = list
}

variable "controlplane_ha" {
  # Please enable "api_version=v4beta" when using this
  description = "Enable Cluster Control Plane High availability"
  default = false
  type = bool
}

variable "pools" {
  description = "The Node Pool specifications for the Kubernetes cluster. (required)"
  type = list(object({
    type = string
    count = number
    autoscaling = bool
    scale_min = number
    scale_max = number
  }))

  default = [
    {
      type = "g6-standard-4"
      count = 3
      autoscaling = false
      scale_min = 3
      scale_max = 6
    }
  ]
}


variable "inbound_fw_rules" {
  type = list(object({
    label = string
    action = string
    protocol = string
    ports = string
    ipv4 = list(any)
    ipv6 = list(any)
  }))
  default = []
  description = "Additional inbound firewall rules"
}

variable "outbound_fw_rules" {
  type = list(object({
    label = string
    action = string
    protocol = string
    ports = string
    ipv4 = list(any)
    ipv6 = list(any)
  }))
  default = []
  description = "Additional outbound firewall rules"
}