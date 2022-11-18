# Execution example
# .\rg_hub_dev.ps1 -location westeurope

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Get output variables
$Firewall = Get-AzFirewall -ResourceGroupName $RgHubName -Name fw-$Env
$VnetOdus = Get-AzVirtualNetwork -ResourceGroupName $RgOdusName -Name $VnetOdusName
$FwPrivateIpAdress = $Firewall.IpConfigurations.PrivateIPAddress


$Route = New-AzRouteConfig -Name "fw-internet" -AddressPrefix 0.0.0.0/0 -NextHopType VirtualAppliance -NextHopIpAddress $FwPrivateIpAdress

New-AzRouteTable -Name "rt-vm" -ResourceGroupName $RgOdusName -Location $Location -Route $Route

$RouteTable = Get-AzRouteTable -ResourceGroupName $RgOdusName -Name "rt-vm"

Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork $VnetOdus `
  -Name $SubnetOdusDefaultName `
  -AddressPrefix $SubnetOdusDefaultPrefix `
  -RouteTable $RouteTable | `
Set-AzVirtualNetwork
