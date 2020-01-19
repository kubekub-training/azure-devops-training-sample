  module "linuxservers" {
    source              = "Azure/compute/azurerm"
    location            = "West Europe"
    vm_os_simple        = "UbuntuServer"
    public_ip_dns       = ["linsimplevmips"] // change to a unique name per datacenter region
    vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
  }
module "network" {
    source              = "Azure/network/azurerm"
    version             = "~> 1.1.1"
    location            = "West Europe"
    allow_rdp_traffic   = "true"
    allow_ssh_traffic   = "true"
    resource_group_name = "terraform-compute"
  }

output "linux_vm_public_name"{
value = "${module.linuxservers.public_ip_dns_name}"
}
