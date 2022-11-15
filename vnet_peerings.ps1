# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Get Output data
$VirtualNetworkHub  = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetHubName
$VirtualNetworkOdus = Get-AzVirtualNetwork -ResourceGroupName $RgOdusName -Name $VnetOdusName
$VirtualNetworkAgw  = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetAgwName
$VirtualNetworkPim  = Get-AzVirtualNetwork -ResourceGroupName $RgPimName -Name $VnetPimName


# ---------------Create virtual network peerings--------
# Create peering between Hub and ODUS
Add-AzVirtualNetworkPeering `
  -Name "peering-hub-odus-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkHub `
  -RemoteVirtualNetworkId $VirtualNetworkOdus.Id

# Create peering between Odus and Hub
Add-AzVirtualNetworkPeering `
  -Name "peering-odus-hub-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkOdus `
  -RemoteVirtualNetworkId $VirtualNetworkHub.Id

# Create peering between Odus and AGW
Add-AzVirtualNetworkPeering `
  -Name "peering-odus-agw-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkOdus `
  -RemoteVirtualNetworkId $VirtualNetworkAgw.Id

# Create peering between AGW and Odus
Add-AzVirtualNetworkPeering `
  -Name "peering-agw-odus-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkAgw `
  -RemoteVirtualNetworkId $VirtualNetworkOdus.Id

# Create peering between Pim and Odus
Add-AzVirtualNetworkPeering `
  -Name "peering-pim-odus-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkPim `
  -RemoteVirtualNetworkId $VirtualNetworkOdus.Id

# Create peering between Odus and Pim
Add-AzVirtualNetworkPeering `
  -Name "peering-odus-pim-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkOdus `
  -RemoteVirtualNetworkId $VirtualNetworkPim.Id