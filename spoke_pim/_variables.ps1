$AZURE_SUBSCRIPTION_ID_HUB      = $AZURE_SUBSCRIPTION_ID_HUB
$AZURE_SUBSCRIPTION_ID_SPOKE    = $AZURE_SUBSCRIPTION_ID_SPOKE
$Location                       = 'westeurope'
$Env                            = 'dev'

# Resource groups
$RgPimName                      = "rg-pim-$Env-$Location-001"

#----------Variables PIM VNET----------
$VnetPimName                    = "vnet-pim-$Env-$Location-001"
$VnetPimIpPrefix                = '172.18.0.0/16'
$SubnetPimDefaultPrefix         = '172.18.1.0/24'

$SubnetPimDefaultName           = "snet-default-$Env-$Location-001"