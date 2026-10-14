terraform {
  required_providers {
    secureaccess = { source = "netascode/secureaccess" }
  }
}
provider "secureaccess" {}

data "secureaccess_regions" "all" {}

output "region_ids"    { value = [for r in data.secureaccess_regions.all.regions : r.region] }
output "first_region"  { value = data.secureaccess_regions.all.regions[0] }
output "bgp_as_number" { value = data.secureaccess_regions.all.bgp_as_number }
output "bgp_peer_ips"  { value = data.secureaccess_regions.all.bgp_peer_ips }
output "bgp_peer_range"{ value = data.secureaccess_regions.all.bgp_peer_range }
