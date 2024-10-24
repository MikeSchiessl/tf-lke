
resource "linode_firewall" "module-lke-firewall_" {
  label = "${var.name}-firewall"
  tags = var.tags

# INBOUND
  inbound_policy = "DROP"

  ## User proivided rules
  ### Additional inbound firewall rules from outside of the module
  dynamic "inbound" {
    for_each = var.inbound_fw_rules
    content {
      label = inbound.value["label"]
      action = inbound.value["action"]
      protocol = inbound.value["protocol"]
      ports = inbound.value["ports"]
      ipv4 = inbound.value["ipv4"]
      ipv6 = inbound.value["ipv6"]
    }
  }

  ## K8S CLUSTER COMMS
  ### TCP Controller <-> Node communication
  inbound {
    label    = "k8s_clusterComm_TCP"
    action   = "ACCEPT"
    protocol = "TCP"
    ports = "10250,10256"
    ipv4     = ["192.168.128.0/17"]
  }

  ## ICMP from everywhere
  inbound {
    label    = "k8s_clusterComm_ICMP"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = ["0.0.0.0/0"]
  }

   ## IPENCAP internally
   inbound {
    label    = "k8s_clusterComm_IPENCAP"
    action   = "ACCEPT"
    protocol = "IPENCAP"
    ipv4     = ["192.168.128.0/17"]
  }


################################################
# Outbound
  outbound_policy = "DROP"

  ## Additional outbound firewall rules from outside of the module
  dynamic "outbound" {
    for_each = var.outbound_fw_rules
    content {
      label = outbound.value["label"]
      action = outbound.value["action"]
      protocol = outbound.value["protocol"]
      ports = outbound.value["ports"]
      ipv4 = outbound.value["ipv4"]
      ipv6 = outbound.value["ipv6"]
    }
  }


  # K8S CLUSTER COMMS
  outbound {
    label    = "k8s_clusterComm_TCP"
    action   = "ACCEPT"
    protocol = "TCP"
    ipv4     = ["192.168.128.0/17"]
  }

  outbound {
    label    = "k8s_clusterComm_ICMP"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = ["0.0.0.0/0"]
  }

  outbound {
    label    = "k8s_clusterComm_IPENCAP"
    action   = "ACCEPT"
    protocol = "IPENCAP"
    ipv4     = ["192.168.128.0/17"]
  }

  ## DNS
  outbound {
    label    = "dns-traffic_TCP"
    action   = "ACCEPT"
    protocol = "TCP"
    ports = "53"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  outbound {
    label    = "dns-traffic_UDP"
    action   = "ACCEPT"
    protocol = "UDP"
    ports = "53"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  ## WEB
  outbound {
    label    = "web-traffic_out"
    action   = "ACCEPT"
    protocol = "TCP"
    ports = "80,443,8080,8443"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  linodes = local.instance-id-list

}
