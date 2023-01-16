. ".\..\utils\setContext.ps1"

# Set context
setHubContext

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# ---------------Create virtual network--------
$vnet = @{
    Name = $VnetAgwName
    ResourceGroupName = $RgHubName
    Location = $Location
    AddressPrefix = $VnetAgwIpPrefix    
}

$virtualNetwork = New-AzVirtualNetwork @vnet

# ---------------Create subnets----------------

# Create AGW subnet
$subnet_agw = @{
    Name = $SubnetAgwName
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetAgwIpPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_agw

# Create Bastion Host subnet
$subnet_bst = @{
    Name = $SubnetBastionName
    VirtualNetwork = $virtualNetwork
    AddressPrefix = $SubnetBastionIpPrefix
}

Add-AzVirtualNetworkSubnetConfig @subnet_bst

# Link all subnets to the virtual network
$virtualNetwork | Set-AzVirtualNetwork
