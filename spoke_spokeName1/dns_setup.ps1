# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1
# Import variables from hub
. $CurrentDirectory\..\hub\_variables.ps1

# Retrieve the VNET & Subnet for the DNS Private Resolver
$VnetSpokeName1 = Get-AzVirtualNetwork -ResourceGroupName $RgSpokeName1Name -Name $VnetSpokeName1Name

$DnsPrForwardingRuleset = Get-AzDnsForwardingRuleset -Name $DnsPrForwardingRulesetName -ResourceGroupName $RgHubName -ErrorAction SilentlyContinue
# ResourceExists variable holds boolean value indicating whether DNS Private Resolver Forwarding Ruleset exists
$ForwardingRulesetExists = $null -ne $DnsPrForwardingRuleset

if ( $ForwardingRulesetExists )
{
    # Create a virtual network link from the spokeName1 spoke to a DNS forwarding ruleset (Outbound Endpoint)
    New-AzDnsForwardingRulesetVirtualNetworkLink `
        -DnsForwardingRulesetName $DnsPrForwardingRulesetName `
        -ResourceGroupName $RgHubName `
        -VirtualNetworkLinkName "vnet-link-spokeName1-$Env-$Location-001" `
        -VirtualNetworkId $VnetSpokeName1.Id
} else {
    Write-Host "DNS Private Resolver Forwarding Ruleset does not exist yet."
}

# Retrieve DNS Zone
$DnsZone = Get-AzPrivateDnsZone -ResourceGroupName $RgHubName -ErrorAction SilentlyContinue
# ResourceExists variable holds boolean value indicating whether DNS Private Zone exists
$DnsZoneExists = $null -ne $DnsZone

if ( $DnsZoneExists )
{
    # Create a virtual network link from the spokeName1 spoke to a DNS Private Zone
    New-AzPrivateDnsVirtualNetworkLink `
        -ZoneName $DnsZone.Name `
        -ResourceGroupName $RgHubName `
        -Name "$($DnsZone.Name)-link-spokeName1-$Env-$Location-001" `
        -VirtualNetworkId $VnetSpokeName1.Id `
        -EnableRegistration
} else {
    Write-Host "DNS Private Zone does not exist yet."
}