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
