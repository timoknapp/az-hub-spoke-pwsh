. ".\..\utils\setContext.ps1"

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1


setSpokeContext

# Get Output data Hub
setHubContext
$VirtualNetworkHub  = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetHubName
$VirtualNetworkAgw  = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetAgwName

# Get Output data Spoke
setSpokeContext
$VirtualNetworkSpokeName1 = Get-AzVirtualNetwork -ResourceGroupName $RgSpokeName1Name -Name $VnetSpokeName1Name

# $VirtualNetworkSpokeName2  = Get-AzVirtualNetwork -ResourceGroupName $RgSpokeName2Name -Name $VnetSpokeName2Name


# ---------------Create virtual network peerings--------
# Create peering between Hub and SpokeName1
setHubContext
Add-AzVirtualNetworkPeering `
  -Name "peering-hub-spokeName1-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkHub `
  -RemoteVirtualNetworkId $VirtualNetworkSpokeName1.Id

# Create peering between AGW and SpokeName1
Add-AzVirtualNetworkPeering `
-Name "peering-agw-spokeName1-$Env-$Location" `
-VirtualNetwork $VirtualNetworkAgw `
-RemoteVirtualNetworkId $VirtualNetworkSpokeName1.Id

# Create peering between SpokeName1 and Hub
setSpokeContext
Add-AzVirtualNetworkPeering `
  -Name "peering-spokeName1-hub-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkSpokeName1 `
  -RemoteVirtualNetworkId $VirtualNetworkHub.Id

# Create peering between SpokeName1 and AGW
Add-AzVirtualNetworkPeering `
  -Name "peering-spokeName1-agw-$Env-$Location" `
  -VirtualNetwork $VirtualNetworkSpokeName1 `
  -RemoteVirtualNetworkId $VirtualNetworkAgw.Id

# # Create peering between SpokeName2 and SpokeName1
# Add-AzVirtualNetworkPeering `
#   -Name "peering-spokeName2-spokeName1-$Env-$Location" `
#   -VirtualNetwork $VirtualNetworkSpokeName2 `
#   -RemoteVirtualNetworkId $VirtualNetworkSpokeName1.Id

# # Create peering between SpokeName1 and SpokeName2
# Add-AzVirtualNetworkPeering `
#   -Name "peering-spokeName1-spokeName2-$Env-$Location" `
#   -VirtualNetwork $VirtualNetworkSpokeName1 `
#   -RemoteVirtualNetworkId $VirtualNetworkSpokeName2.Id