$Location                   = 'westeurope'
$Env                        = 'dev'

# Resource groups
$RgOdusName                 = "rg-odus-$Env-$Location-001"

#----------Variables ODUS VNET----------
$VnetOdusName                 = "vnet-odus-$Env-$Location-001"
$VnetOdusIpPrefix             = '172.17.0.0/16'
$SubnetOdusDefaultPrefix      = '172.17.1.0/24'

$SubnetOdusDefaultName        = "snet-default-$Env-$Location-001"