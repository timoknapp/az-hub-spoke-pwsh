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
$VnetSpokeName1 = Get-AzVirtualNetwork -ResourceGroupName $RgSpokeName1Name -Name $VnetSpokeName1Name


# Create route table
New-AzRouteTable -Name "rt-vm" -ResourceGroupName $RgSpokeName1Name -Location $Location
$RouteTable = Get-AzRouteTable -ResourceGroupName $RgSpokeName1Name -Name "rt-vm"


# Internet route
Add-AzRouteConfig -Name "fw-internet" -AddressPrefix 0.0.0.0/0 -NextHopType VirtualAppliance -NextHopIpAddress $FwPrivateIpAdress -RouteTable $RouteTable

# Add route hub vnet
Add-AzRouteConfig -Name "hub-vnet" -AddressPrefix $HubVnetIpPrefix -NextHopType "VnetLocal" -RouteTable $RouteTable

# Add route to onprem
Add-AzRouteConfig -Name "onprem" -AddressPrefix $OnPremIpPrefix -NextHopType VirtualAppliance -NextHopIpAddress $FwPrivateIpAdress -RouteTable $RouteTable

Set-AzRouteTable -RouteTable $RouteTable

# Associate route table
Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork $VnetSpokeName1 `
  -Name $SubnetSpokeName1DefaultName `
  -AddressPrefix $SubnetSpokeName1DefaultPrefix `
  -RouteTable $RouteTable | `
Set-AzVirtualNetwork
