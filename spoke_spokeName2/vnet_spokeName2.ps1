. ".\..\utils\setContext.ps1"

# Set context
setSpokeContext


# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Printing details on the currently selected Subscription
Write-Output "Subscription ID: $((Get-AzContext).Subscription.Id)"
Write-Output "Subscription Name: $((Get-AzContext).Subscription.Name)"


# ---------------Create virtual network--------
$vnet = @{
    Name = $VnetSpokeName2Name
    ResourceGroupName = $RgSpokeName2Name
    Location = $Location
    AddressPrefix = $VnetSpokeName2IpPrefix  
}

$virtualNetwork = New-AzVirtualNetwork @vnet

# ---------------Create subnets----------------

# Create default subnet
$subnet_default = @{
    Name = $SubnetSpokeName2DefaultName
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetSpokeName2DefaultPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_default

# Link all subnets to the virtual network
$virtualNetwork | Set-AzVirtualNetwork
