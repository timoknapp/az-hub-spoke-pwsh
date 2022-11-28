. ".\..\utils\setContext.ps1"

# Set context
setHubContext

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

$VnetHub = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetHubName

# Get a Public IP for the firewall
$FWpip = New-AzPublicIpAddress -Name "pip-fw-$Env-$Location" -ResourceGroupName $RgHubName `
  -Location $Location -AllocationMethod Static -Sku Standard

# Get Azure Firewall Policy
$AzfwPolicy = Get-AzFirewallPolicy -ResourceGroupName $RgHubName -Name "fw-policy-$Env"

# Create the firewall
New-AzFirewall -Name fw-$Env -ResourceGroupName $RgHubName -Location $Location -VirtualNetwork $VnetHub -PublicIpAddress $FWpip -FirewallPolicyId $AzfwPolicy.Id