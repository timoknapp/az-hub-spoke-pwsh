. ".\..\utils\setContext.ps1"

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\..\hub\_variables.ps1
. $CurrentDirectory\_variables.ps1

# Get output variables
setHubContext
$Firewall = Get-AzFirewall -ResourceGroupName $RgHubName -Name fw-$Env
$FwPrivateIpAdress = $Firewall.IpConfigurations.PrivateIPAddress
SetSpokeContext
$VnetOdus = Get-AzVirtualNetwork -ResourceGroupName $RgOdusName -Name $VnetOdusName


# Create route table
New-AzRouteTable -Name "rt-vm" -ResourceGroupName $RgOdusName -Location $Location
$RouteTable = Get-AzRouteTable -ResourceGroupName $RgOdusName -Name "rt-vm"


# Internet route
Add-AzRouteConfig -Name "fw-internet" -AddressPrefix 0.0.0.0/0 -NextHopType VirtualAppliance -NextHopIpAddress $FwPrivateIpAdress -RouteTable $RouteTable

# Add route hub vnet
Add-AzRouteConfig -Name "hub-vnet" -AddressPrefix $HubVnetIpPrefix -NextHopType "VnetLocal" -RouteTable $RouteTable

# Add route to onprem
Add-AzRouteConfig -Name "onprem" -AddressPrefix $OnPremIpPrefix -NextHopType VirtualAppliance -NextHopIpAddress $FwPrivateIpAdress -RouteTable $RouteTable

Set-AzRouteTable -RouteTable $RouteTable

# Associate route table
Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork $VnetOdus `
  -Name $SubnetOdusDefaultName `
  -AddressPrefix $SubnetOdusDefaultPrefix `
  -RouteTable $RouteTable | `
Set-AzVirtualNetwork
