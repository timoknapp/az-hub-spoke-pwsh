$AZURE_SUBSCRIPTION_ID_HUB      = $AZURE_SUBSCRIPTION_ID_HUB
$AZURE_SUBSCRIPTION_ID_SPOKE    = $AZURE_SUBSCRIPTION_ID_SPOKE
$Location                       = 'westeurope'
$Env                            = 'dev'

# Resource groups
$RgSpokeName1Name                     = "rg-spokeName1-$Env-$Location-001"

#----------Variables SpokeName1 VNET----------
$VnetSpokeName1Name                   = "vnet-spokeName1-$Env-$Location-001"
$VnetSpokeName1IpPrefix               = '172.17.0.0/16'
$SubnetSpokeName1DefaultPrefix        = '172.17.1.0/24'

$SubnetSpokeName1DefaultName          = "snet-default-$Env-$Location-001"

$OnPremIpPrefix                 = '20.0.0.0/8'
$HubVnetIpPrefix                = '20.13.252.0/24'
