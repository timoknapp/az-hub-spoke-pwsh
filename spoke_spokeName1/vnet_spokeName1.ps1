. ".\..\utils\setContext.ps1"

# Set context
setSpokeContext


# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# ---------------Create virtual network--------
$vnet = @{
    Name = $VnetSpokeName1Name
    ResourceGroupName = $RgSpokeName1Name
    Location = $Location
    AddressPrefix = $VnetSpokeName1IpPrefix    
}

$virtualNetwork = New-AzVirtualNetwork @vnet

# ---------------Create subnets----------------

# Create default subnet
$subnet_default = @{
    Name = $SubnetSpokeName1DefaultName
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetSpokeName1DefaultPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_default

# Link all subnets to the virtual network
$virtualNetwork | Set-AzVirtualNetwork
