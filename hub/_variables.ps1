$Location                   = 'westeurope'
$Env                        = 'dev'

# Resource groups
$RgHubName                  = "rg-network-$Env-$Location-001"

#----------Variables Hub VNET----------
$VnetHubName                = "vnet-hub-$Env-$Location-001"
$VnetHubIpPrefix            = '53.13.252.0/24'
$SubnetErGatewayPrefix      = '53.13.252.64/27'
$SubnetFirewallPrefix       = '53.13.252.0/26'
$SubnetDnsPrInboundPrefix   = '53.13.252.96/28'
$SubnetDnsPrOutboundPrefix  = '53.13.252.128/28'
$SubnetPrivateLinkPrefix    = '53.13.252.144/28'

$SubnetErGatewayName        = 'GatewaySubnet'
$SubnetFirewallName         = 'AzureFirewallSubnet'
$SubnetDnsPrInboundName     = "snet-dns-pr-inbound-$Env-$Location-001"
$SubnetDnsPrOutboundName    = "snet-dns-pr-outbound-$Env-$Location-001"
$SubnetPrivateLinkName      = "snet-private-link-$Env-$Location-001"

$DnsPrForwardingRulesetName = "dns-pr-ruleset-$Env-$Location-001"