. ".\..\utils\setContext.ps1"

# Set context
setHubContext

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

# Setting up the forwarding ruleset for the DNS Private Resolver for On-Premises and Azure
$targetDnsOnPrem = New-AzDnsResolverTargetDnsServerObject -IPAddress $DnsServerOnPremIp -Port 53 
$targetDnsResolverInbound = New-AzDnsResolverTargetDnsServerObject -IPAddress $InboundEndpoint.IPConfiguration.PrivateIPAddress -Port 53

# Create a forwarding rule for each On-Premises Hostname
foreach ($Hostname in $HostnamesOnPrem) {
    $HostnameWithoutSpecialChars = $Hostname.Replace('.','')
    write-host "Creating forwarding rule for $Hostname"
    New-AzDnsForwardingRulesetForwardingRule `
        -ResourceGroupName $RgHubName `
        -DnsForwardingRulesetName $DnsPrForwardingRulesetName `
        -Name "OnPrem-$HostnameWithoutSpecialChars" `
        -DomainName $Hostname `
        -ForwardingRuleState "Enabled" `
        -TargetDnsServer $targetDnsOnPrem
}

# Create a forwarding rule for each Azure Private DNS Zone
foreach ($PrivateDnsZone in $AzPrivateDnsZones) {
    write-host "Creating forwarding rule for $PrivateDnsZone"
    New-AzDnsForwardingRulesetForwardingRule `
        -ResourceGroupName $RgHubName `
        -DnsForwardingRulesetName $DnsPrForwardingRulesetName `
        -Name "AzurePrivate" `
        -DomainName "$PrivateDnsZone." `
        -ForwardingRuleState "Enabled" `
        -TargetDnsServer $targetDnsResolverInbound
}