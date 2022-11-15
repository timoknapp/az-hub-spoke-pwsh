$Location                   = 'westeurope'
$Env                        = 'dev'

$RgName                     = "rg-network-$Env-$Location-001"


#----------Variables Hub VNET----------
$VnetHubDev                 = "vnet-hub-$Env-$Location-001"
$VnetHubDevIpPrefix         = '53.1.0.0/24'
$SubnetFirewallPrefix       = '53.1.0.128/26'
$SubnetDnsPrInboundPrefix   = '53.1.0.192/28'
$SubnetDnsPrOutboundPrefix  = '53.1.0.208/28'
$SubnetPrivateLinkPrefix    = '53.1.0.224/28'


#----------Variables AGW VNET----------
$VnetAgwDev                 = "vnet-agw-$Env-$Location-001"
$VnetAgwDevIpPrefix         = '53.2.0.0/23'
$SubnetAgwPrefix            = '53.2.0.0/24'
$SubnetBastionPrefix        = '53.2.1.128/26'