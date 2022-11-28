$AZURE_SUBSCRIPTION_ID_HUB      = $AZURE_SUBSCRIPTION_ID_HUB
$AZURE_SUBSCRIPTION_ID_SPOKE    = $AZURE_SUBSCRIPTION_ID_SPOKE
$Location                       = 'westeurope'
$Env                            = 'dev'

# Resource groups
$RgOdusName                     = "rg-odus-$Env-$Location-001"

#----------Variables ODUS VNET----------
$VnetOdusName                   = "vnet-odus-$Env-$Location-001"
$VnetOdusIpPrefix               = '172.17.0.0/16'
$SubnetOdusDefaultPrefix        = '172.17.1.0/24'

$SubnetOdusDefaultName          = "snet-default-$Env-$Location-001"

$OnPremIpPrefix                 = '53.0.0.0/8'
$HubVnetIpPrefix                = '53.13.252.0/24'
