$AZURE_SUBSCRIPTION_ID_HUB      = $AZURE_SUBSCRIPTION_ID_HUB
$AZURE_SUBSCRIPTION_ID_SPOKE    = $AZURE_SUBSCRIPTION_ID_SPOKE
$Location                       = 'westeurope'
$Env                            = 'dev'

# Resource groups
$RgHubName                      = "rg-network-$Env-$Location-001"

#----------Variables AGW VNET----------
$VnetAgwName                    = "vnet-agw-$Env-$Location-001"
$VnetAgwIpPrefix                = '172.16.224.0/23'
$SubnetAgwIpPrefix              = '172.16.224.0/24'
$SubnetBastionIpPrefix          = '172.16.225.0/26'

$SubnetAgwName                  = "snet-agw-$Env-$Location-001"
$SubnetBastionName              = 'AzureBastionSubnet'

#----------Config App Gateway----------
$AppGwName                      = "appgw-$Env-$Location-001"