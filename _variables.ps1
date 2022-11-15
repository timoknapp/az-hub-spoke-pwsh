$Location                   = 'westeurope'
$Env                        = 'dev'

# Resource groups
$RgHubName                  = "rg-network-$Env-$Location-001"
$RgOdusName                 = "rg-odus-$Env-$Location-001"
$RgPimName                  = "rg-pim-$Env-$Location-001"


#----------Variables Hub VNET----------
$VnetHubName                = "vnet-hub-$Env-$Location-001"
$VnetHubIpPrefix            = '53.1.0.0/24'
$SubnetErGatewayPrefix      = '53.1.0.64/27'
$SubnetFirewallPrefix       = '53.1.0.128/26'
$SubnetDnsPrInboundPrefix   = '53.1.0.192/28'
$SubnetDnsPrOutboundPrefix  = '53.1.0.208/28'
$SubnetPrivateLinkPrefix    = '53.1.0.224/28'


#----------Variables AGW VNET----------
$VnetAgwName                = "vnet-agw-$Env-$Location-001"
$VnetAgwIpPrefix            = '53.2.0.0/23'
$SubnetAgwIpPrefix          = '53.2.0.0/24'
$SubnetBastionIpPrefix      = '53.2.1.128/26'


#----------Variables ODUS VNET----------
$VnetOdusName                 = "vnet-odus-$Env-$Location-001"
$VnetOdusIpPrefix             = '172.16.0.0/16'
$SubnetOdusDefaultPrefix      = '172.16.1.0/24'


#----------Variables PIM VNET----------
$VnetPimName                 = "vnet-pim-$Env-$Location-001"
$VnetPimIpPrefix             = '172.17.0.0/16'
$SubnetPimDefaultPrefix      = '172.17.1.0/24'

#----------Config App Gateway----------
$AppGwName                  = "appgw-$Env-$Location-001"