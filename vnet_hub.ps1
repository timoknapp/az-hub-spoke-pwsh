# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Printing details on the currently selected Subscription
Write-Output "Subscription ID: $((Get-AzContext).Subscription.Id)"
Write-Output "Subscription Name: $((Get-AzContext).Subscription.Name)"


# ---------------Create virtual network--------
# IPs: 256
$vnet = @{
    Name = $VnetHubName
    ResourceGroupName = $RgHubName
    Location = $Location
    AddressPrefix = $VnetHubIpPrefix     
}

$virtualNetwork = New-AzVirtualNetwork @vnet

# ---------------Create subnets----------------

#####---------Created by provided scriopt from Hybrid Cloud Team---------#####
# Create VNET Gateway (express route gateway) subnet
# $subnet_vnet_er_gateway = @{
#     Name = "snet-vnet-er-gw-$Env-$Location-001"
#     VirtualNetwork = $virtualNetwork
#     AddressPrefix = $SubnetErGatewayPrefix
# }

# Add-AzVirtualNetworkSubnetConfig @subnet_vnet_er_gateway


# Create Firewall subnet
$subnet_firewall = @{
    Name = "AzureFirewallSubnet"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetFirewallPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_firewall


# Create DNS Private Resolver subnet inbound endpoint
$subnet_dnspr_inbound = @{
    Name = "snet-dns-pr-inbound-$Env-$Location-001"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetDnsPrInboundPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_dnspr_inbound


# Create DNS Private Resolver subnet outbound endpoint
$subnet_dnspr_outbound = @{
    Name = "snet-dns-pr-outbound-$Env-$Location-001"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetDnsPrOutboundPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_dnspr_outbound


# Create private link (privaten endpoint) subnet outbound endpoint
$subnet_private_link = @{
    Name = "snet-private-link-$Env-$Location-001"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetPrivateLinkPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_private_link

# Link all subnets to the virtual network
$virtualNetwork | Set-AzVirtualNetwork

