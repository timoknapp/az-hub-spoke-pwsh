# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Install the Azure PowerShell module for DNS Private Resolver
Install-Module Az.DnsResolver

# Retrieve the VNET & Subnet for the DNS Private Resolver
$VnetHub = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetHubName
$SubnetDnsPrInboundId = $VnetHub.Subnets | Where-Object {$_.Name -eq $SubnetDnsPrInboundName} | Select-Object -ExpandProperty Id
$SubnetDnsPrOutboundId = $VnetHub.Subnets | Where-Object {$_.Name -eq $SubnetDnsPrOutboundName} | Select-Object -ExpandProperty Id

$DnsPrResolverName = "dns-pr-$Env-$Location-001"

$DnsPrResolver = Get-AzDnsResolver -Name $DnsPrResolverName -ResourceGroupName $RgHubName -ErrorAction SilentlyContinue
# ResourceExists variable holds boolean value indicating whether DNS Private Resolver exists
$ResourceExists = $null -ne $DnsPrResolver

if ( !$ResourceExists )
{
    # Create the DNS Private Resolver if it does not exist
    New-AzDnsResolver `
        -Name $DnsPrResolverName `
        -ResourceGroupName $RgHubName `
        -Location $Location `
        -VirtualNetworkId $VnetHub.Id
}

$InboundIpConfig = New-AzDnsResolverIPConfigurationObject `
    -PrivateIPAllocationMethod Dynamic `
    -SubnetId $SubnetDnsPrInboundId

# Create the DNS Private Resolver Inbound Endpoint
$InboundEndpoint = New-AzDnsResolverInboundEndpoint `
    -DnsResolverName $DnsPrResolverName `
    -Name "dns-pr-inbound-$Env-$Location-001" `
    -ResourceGroupName $RgHubName `
    -Location $Location `
    -IpConfiguration $InboundIpConfig

# Create the DNS Private Resolver Outbound Endpoint
$OutboundEndpoint = New-AzDnsResolverOutboundEndpoint `
    -DnsResolverName $DnsPrResolverName `
    -Name "dns-pr-outbound-$Env-$Location-001" `
    -ResourceGroupName $RgHubName `
    -Location $Location `
    -SubnetId $SubnetDnsPrOutboundId

# Create DNS resolver forwarding ruleset for the outbound endpoint
$DnsForwardingRuleset = New-AzDnsForwardingRuleset `
    -Name $DnsPrForwardingRulesetName `
    -ResourceGroupName $RgHubName `
    -DnsResolverOutboundEndpoint $OutboundEndpoint `
    -Location $Location

# Create a virtual network link from the hub to a DNS forwarding ruleset (Outbound Endpoint)
New-AzDnsForwardingRulesetVirtualNetworkLink `
    -DnsForwardingRulesetName $DnsPrForwardingRulesetName `
    -ResourceGroupName $RgHubName `
    -VirtualNetworkLinkName "vnet-link-hub-$Env-$Location-001" `
    -VirtualNetworkId $VnetHub.Id

# Keep in mind that the spoke VNETs will be linked within the spoke configuration

# Sample
# $targetDNS1 = New-AzDnsResolverTargetDnsServerObject -IPAddress 192.168.1.2 -Port 53 
# $targetDNS2 = New-AzDnsResolverTargetDnsServerObject -IPAddress 192.168.1.3 -Port 53
# $targetDNS3 = New-AzDnsResolverTargetDnsServerObject -IPAddress 10.0.0.4 -Port 53
# $targetDNS4 = New-AzDnsResolverTargetDnsServerObject -IPAddress 10.5.5.5 -Port 53
# $forwardingrule = New-AzDnsForwardingRulesetForwardingRule -ResourceGroupName myresourcegroup -DnsForwardingRulesetName myruleset -Name "Internal" -DomainName "internal.contoso.com." -ForwardingRuleState "Enabled" -TargetDnsServer @($targetDNS1,$targetDNS2)
# $forwardingrule = New-AzDnsForwardingRulesetForwardingRule -ResourceGroupName myresourcegroup -DnsForwardingRulesetName myruleset -Name "AzurePrivate" -DomainName "azure.contoso.com" -ForwardingRuleState "Enabled" -TargetDnsServer $targetDNS3
# $forwardingrule = New-AzDnsForwardingRulesetForwardingRule -ResourceGroupName myresourcegroup -DnsForwardingRulesetName myruleset -Name "Wildcard" -DomainName "." -ForwardingRuleState "Enabled" -TargetDnsServer $targetDNS4