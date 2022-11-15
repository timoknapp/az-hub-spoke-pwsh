Import-Module -Name $PSScriptroot\vnet_agw.ps1
Import-Module -Name $PSScriptroot\bastion.ps1
Import-Module -Name $PSScriptroot\agw.ps1

# Create the AGW VNET & resources
"$PSScriptroot\vnet_agw.ps1"
"$PSScriptroot\bastion.ps1"
"$PSScriptroot\agw.ps1"