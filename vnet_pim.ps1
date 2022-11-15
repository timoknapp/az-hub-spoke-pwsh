# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Printing details on the currently selected Subscription
Write-Output "Subscription ID: $((Get-AzContext).Subscription.Id)"
Write-Output "Subscription Name: $((Get-AzContext).Subscription.Name)"


# ---------------Create virtual network--------
$vnet = @{
    Name = $VnetPimName
    ResourceGroupName = $RgPimName
    Location = $Location
    AddressPrefix = $VnetPimIpPrefix  
}

$virtualNetwork = New-AzVirtualNetwork @vnet

# ---------------Create subnets----------------

# Create default subnet
$subnet_default = @{
    Name = "snet-default-$Env-$Location-001"
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetPimDefaultPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_default

# Link all subnets to the virtual network
$virtualNetwork | Set-AzVirtualNetwork
