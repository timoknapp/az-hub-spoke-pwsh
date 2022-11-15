# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Add additional DNS Zones
$DnsZones = @('mydns.com')

# Get Output data
$VirtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetHubName

#-------------------Create DNS Private Zones-------------------
foreach ($DnsZone in $DnsZones) {

    New-AzPrivateDnsZone -Name $DnsZone -ResourceGroupName $RgHubName

    New-AzPrivateDnsVirtualNetworkLink -ZoneName $DnsZone `
        -ResourceGroupName $RgHubName -Name "$DnsZone-link" `
        -VirtualNetworkId $VirtualNetwork.Id -EnableRegistration

}

