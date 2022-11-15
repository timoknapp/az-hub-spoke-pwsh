Import-Module -Name $PSScriptroot\rg_hub.ps1
Import-Module -Name $PSScriptroot\rg_odus.ps1
Import-Module -Name $PSScriptroot\rg_pim.ps1
Import-Module -Name $PSScriptroot\vnet_hub.ps1
Import-Module -Name $PSScriptroot\vnet_agw.ps1
Import-Module -Name $PSScriptroot\vnet_odus.ps1
Import-Module -Name $PSScriptroot\vnet_pim.ps1
Import-Module -Name $PSScriptroot\vnet_peerings.ps1
Import-Module -Name $PSScriptroot\private_dns_zones.ps1
Import-Module -Name $PSScriptroot\bastion.ps1
Import-Module -Name $PSScriptroot\firewall.ps1
Import-Module -Name $PSScriptroot\agw.ps1
import-module -Name $PSScriptroot\vm_odus.ps1
import-module -Name $PSScriptroot\vm_pim.ps1
import-module -Name $PSScriptroot\route_tables.ps1

# Create the different resource groups
"$PSScriptroot\rg_hub.ps1"
"$PSScriptroot\rg_odus.ps1"
"$PSScriptroot\rg_pim.ps1"

# Create the hub VNET & resources
"$PSScriptroot\vnet_hub.ps1"
"$PSScriptroot\private_dns_zones.ps1"
"$PSScriptroot\firewall.ps1"

# Create the AGW VNET & resources
"$PSScriptroot\vnet_agw.ps1"
"$PSScriptroot\bastion.ps1"
"$PSScriptroot\agw.ps1"

# Create the ODUS VNET & resources
"$PSScriptroot\vnet_odus.ps1"

# Create the PIM VNET & resources
"$PSScriptroot\vnet_pim.ps1"

# Create the peering between the VNETs
"$PSScriptroot\vnet_peerings.ps1"

# Create VMs
"$PSScriptroot\vm_odus.ps1"
"$PSScriptroot\vm_pim.ps1"

# Create the route tables
"$PSScriptroot\route_tables.ps1"
