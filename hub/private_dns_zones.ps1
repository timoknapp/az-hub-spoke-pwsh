. ".\..\utils\setContext.ps1"

# Set context
setHubContext

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Get Output data
$VirtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetHubName

#-------------------Create DNS Private Zones-------------------
foreach ($DnsZone in $AzPrivateDnsZones) {
    New-AzPrivateDnsZone -Name $DnsZone -ResourceGroupName $RgHubName

    New-AzPrivateDnsVirtualNetworkLink `
        -ZoneName $DnsZone `
        -ResourceGroupName $RgHubName `
        -Name "$DnsZone-link-hub-$Env-$Location-001" `
        -VirtualNetworkId $VirtualNetwork.Id `
        -EnableRegistration
}

