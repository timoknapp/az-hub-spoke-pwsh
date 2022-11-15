# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

$VnetAgw = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetHubName

# Get a Public IP for the firewall
$FWpip = New-AzPublicIpAddress -Name "pip-fw-$Env-$Location" -ResourceGroupName $RgHubName `
  -Location $Location -AllocationMethod Static -Sku Standard

# Create the firewall
New-AzFirewall -Name fw-$Env -ResourceGroupName $RgHubName -Location $Location -VirtualNetwork $VnetAgw -PublicIpAddress $FWpip
