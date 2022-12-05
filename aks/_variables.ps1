$AZURE_SUBSCRIPTION_ID_HUB      = $AZURE_SUBSCRIPTION_ID_HUB
$AZURE_SUBSCRIPTION_ID_SPOKE    = $AZURE_SUBSCRIPTION_ID_SPOKE
$Location                       = 'westeurope'
$Env                            = 'dev'
#$uuid = (Get-Random -Maximum 99999)

$tag=@{deparment="pims";stage="dev";suffix=$ProjectSufix}
$labels = $tag


######## AKS VARS 
$KubernetesVersion = "1.24.6"
$NetworkPlugin = "azure"
$NodeVmSize="Standard_DS4_V2"
$AutoUpgradeChannel="node-image"
$AddOnNameToBeEnabled="monitoring,azure-keyvault-secrets-provider"
$PoolName= "basepool"
$Subnetid="set this "
$NodeVnetSubnetID=""
$NodeMaxCount = 5
$NodeMinCount = 1
$NodePoolMode="System"
$NodeName = "basepool"
$NodeOsDiskSize = "100"
$NodePoolLabel = $labels
$ServiceCidr="10.2.0.0/24"
$DnsServiceIP ="10.2.0.10" 
$AvailabilityZone="3"
$AKSAdminUser="<Add your user id here>"

###### PIM Networking 

## These variable are required as we need to 
#  - Create the AKS subent 
#  - Assign the Managed identity of AKS rights to modify the networks
# Resource groups

#----------Variables PIM VNET----------

$SubnetPimAKSPrefix             = '172.17.4.0/22'





################## Hub Stuff #############################
# Resource groups
$RgHubName                      = "rg-network-$Env-$Location-001"

#----------Variables Hub VNET----------
$VnetHubName                    = "vnet-hub-$Env-$Location-001"
## hub pl subnet 
$SubnetPrivateLinkName          = "snet-private-link-$Env-$Location-001"


###### Supported Private Link types 
## https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
#### 
$keyvaultPL = [PSCustomObject]@{
    DNSZone     = 'privatelink.vaultcore.azure.net'
    Prefix  = "kv"
    ZoneGroup = 'zonegroup'
    GroupId = "vault"
    Type = "Microsoft.KeyVault/vaults"
  
}
$postgresPL = [PSCustomObject]@{
    DNSZone     = 'privatelink.postgres.database.azure.com'
    Prefix  = "pgsql"
    ZoneGroup = 'mygroup'
    GroupId = "postgresqlServer"
    Type = "Microsoft.DBforPostgreSQL/servers"
}
$acrPl = [PSCustomObject]@{
    DNSZone     = 'privatelink.azurecr.io'
    Prefix  = "acr"
    ZoneGroup = 'mygroup'
    GroupId = "registry"
    Type = "Microsoft.ContainerRegistry/registries"
}
$cosmosPL = [PSCustomObject]@{
    DNSZone     = 'privatelink.documents.azure.com'
    Prefix  = "cosmos"
    ZoneGroup = 'mygroup'
    GroupId = "sql"
    Type = "Microsoft.DocumentDB/databaseAccounts"
    Kind = "GlobalDocumentDB"

}
