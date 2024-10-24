# Terrafrom Moduel for the Linode Kubernetes Engine
This repo provides a Terraform module that allows ramping up a firewalled LKE cluster (using the Linode TF provider).  

<!-- TOC -->
* [Terrafrom Moduel for the Linode Kubernetes Engine](#terrafrom-moduel-for-the-linode-kubernetes-engine)
* [Details](#details)
  * [Accepted Variables](#accepted-variables)
    * [pool data model](#pool-data-model)
    * [firewall model](#firewall-model)
  * [Example Usage](#example-usage)
* [License & Support](#license--support)
  * [License](#license)
  * [Support](#support)
<!-- TOC -->

# Details
This module comes witht the following features:
- control plane High Availability
- One or multiple pools
- Autoscaling
- A secure Linode cloud firewall
  - Default inbout & outbound rules set to drop
  - Fully working k8s cluster communication (including kubectl exec ...)
  - Allowed Inbound ICMP
  - Allowed Outbound DNS (Port 53 tcp/udp)
  - Allowed Outbound HTTP (Ports 80,443,8080,8443 tcp)
  - Additional rules can be amended

----

## Accepted Variables
Also have a look at the [variables.tf](./variables.tf) file

| Variable           | Description                                                                           | Default                                                                                         |
|--------------------|---------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| name               | The cluster name to use                                                               | lke-cluster                                                                                     |
| k8s_version        | The desired LKE-k8s version (major.minor)                                             | 1.23                                                                                            |
| region             | The desired LKE region                                                                | us-east                                                                                         |
| tags               | A List of tags to identify the cluster                                                | ["terraform: true"]                                                                             |
| controlplane_ha    | Enable Cluster Control Plane High availability<br>enabling this, cannot be reverted ! | false                                                                                           |
| pools              | A list of pool definitions (see pool data model, below)                               | [{"type": "g6-standard-4", "count": 3, "autoscaling": "false", "scale_min": 3, "scale_max": 6}] |
| inbound_fw_rules   | Inbound FW rules to be applied to the LKE firewall (see firewall data model, below)   | []                                                                                              |
| outbound_fw_rules  | Outbound FW rules to be applied to the LKE firewall (see firewall data model, below)  | []                                                                                              |


### pool data model
```json
[
  {
    "type": "<linode_instance_type>",
    "count": "<pool_instance_number>",
    "autoscaling": "<BOOL - true/false>",
    "scale_min": "<minimum scaling size>",
    "scale_max": "maximum_scaling_size"
  },
  ...
]
```

### firewall model
See [this link](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/firewall) for potential values
```json
[
  {
    "label": "<fw_rule_label>",
    "action": "<fw_rule_action - ACCEPT/DROP>",
    "protocol": "<fw_rule_protocol>",
    "ports": "<fw_rule_portlist>",
    "ipv4": "<fw_ipv4_source/fw_ipv4_target>",
    "ipv6": "<fw_ipv6_source/fw_ipv6_target>"
  },
  ...
]
```

----
## Outputs
Also have a look at the [variables.tf](./outputs.tf) file

| Name                 | Description                                                                                                                                      |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| lke-cluster          | Providing the full [LKE TF output](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/lke_cluster#attributes-reference) | 
| lke-firewall         | Providing the full [Firewall output](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/firewall#attributes-reference)  |
| lke-instance_id_list | A full list of instance id's mapped against the LKE cluster                                                                                      | 

----

## Example Usage
```terraform
module "vle-lke-prod01" {
  source = "git::https://github.com/MikeSchiessl/tf-lke.git/?ref=main"
  name = var.CLUSTER_NAME
  k8s_version = "1.31"
  controlplane_ha = true
  region = "eu-west"
  pools = [
    {
      type = "g6-standard-8"
      count = 3
      autoscaling = true
      scale_min = 3
      scale_max = 6
    }
  ]
  inbound_fw_rules = [      ### SSH to the nodes
    {
    label    = "mike-ssh_in"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["1.2.3.4/32"]
    ipv6     = ["acdc:4d:beef::/40"]
  }]
}

```

---

# License & Support
## License
Created and maintained by Mike Schiessl under the MIT license

```text
THE SOFTWARE IS PROVIDED “AS IS”,
WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
## Support
I will offer supoort on a best effort basis, whenever I find time to review rasied issues or pull-requests.
There is absolutely no guarantee in keeping this repo updated or maintained at all.
