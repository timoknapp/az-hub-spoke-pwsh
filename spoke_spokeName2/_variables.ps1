$AZURE_SUBSCRIPTION_ID_HUB      = $AZURE_SUBSCRIPTION_ID_HUB
$AZURE_SUBSCRIPTION_ID_SPOKE    = $AZURE_SUBSCRIPTION_ID_SPOKE
$Location                       = 'westeurope'
$Env                            = 'dev'

# Resource groups
$RgSpokeName2Name                      = "rg-spokeName2-$Env-$Location-001"

#----------Variables SpokeName2 VNET----------
$VnetSpokeName2Name                    = "vnet-spokeName2-$Env-$Location-001"
$VnetSpokeName2IpPrefix                = '172.18.0.0/16'
$SubnetSpokeName2DefaultPrefix         = '172.18.1.0/24'

$SubnetSpokeName2DefaultName           = "snet-default-$Env-$Location-001"