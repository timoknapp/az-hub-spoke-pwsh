. ".\..\utils\setContext.ps1"

# Set context
setHubContext
# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1


. "$PSScriptroot\_variables.ps1"
. "$PSScriptroot\rg_aks.ps1"

## import functions 
. "$PSScriptroot\acr.ps1"
. "$PSScriptroot\keyvault.ps1"
. "$PSScriptroot\loganalytics.ps1"
. "$PSScriptroot\akssubnet.ps1"
. "$PSScriptroot\aks2.ps1"
. "$PSScriptroot\privatelinks.ps1"

#. "$PSScriptroot\aks.ps1"
# Create KeyVault 
#$uuid = (Get-Random -Maximum 99999)
$uuid = "ivantest10"
$ProjectSufix                       ="pim-$uuid"
$RgAKSName                          ="$ProjectSufix-$Env-$Location"
#$UserManagedIdentityName="$ProjectSufix-identity"
#$KubeletUserManagedIdentityName="$ProjectSufix-kubelet"

##################################################
######### Defining Vars here as more transparent 
##################################################
$WorkspaceName = "$ProjectSufix-ala" 
$KeyVaultName = "$ProjectSufix-kv" 
$KeyVaultName = $KeyVaultName.Replace("-" ,"")
$AKSClusterName = "$ProjectSufix-aks"
$ACRName = "$ProjectSufix-acr"
$ACRName = $ACRName.Replace("-" ,"")
#### Targeting spoke variables ######
# Vnet to create aks cluster into
$VnetName                    = "vnet-odus-$Env-$Location-001"
# RG where target vnet is 
$RgPimName                      = "rg-odus-$Env-$Location-001"
# subnet name for aks
$AKSSubnetName = "aks"
Write-Host "####################### Variables #####################################" -ForegroundColor Cyan
Write-Host " AKSCluster name =          $ProjectSufix"
Write-Host " Resource Group  =          $RgAKSName" 
Write-Host " Keyvault name =            $KeyVaultName" 
Write-Host " Log Analytics workspace =  $WorkspaceName" 
Write-Host " Container Registry =       $ACRName" 

Write-Host " Virtual Netwoork =         $VnetName" 
Write-Host " Virtual Network RG =       $RgPimName" 

## Create RG to put AKS stuff into
$rg = CreateAKSRG $RgAKSName
## Creating KV 
$kv = CreateKeyVault $KeyVaultName $RgAKSName 
## Creating log analytics 
$loganalytics = CreateLogAnaylticsWorkspace  $WorkspaceName   $RgAKSName 
#Write-Output -InputObject $loganalytics
#$T = $loganalytics.ResourceId
#Write-Host "********* $T"


## Creating ACR
$Registry = CreateContainerRegistry $ACRName $RgAKSName 
## Creating subnet ### 
$subnet = CreateAKSSubnet $VnetName $AKSSubnetName $RgPimName $SubnetPimAKSPrefix
$myid = $kv.ResourceId
Write-Host " ****** $myid ******" 
CreatePrivateLinkInHuB  $RgHubName $VnetHubName  $SubnetPrivateLinkName $myid $ProjectSufix  "KeyVault"
#Write-Output -InputObject $Registry
#rite-Output -InputObject $subnet
Write-Output -InputObject $subnet

$RegistryId = $Registry.Id
$Subnetid = $subnet.Id
#Write-Output -InputObject $subnet
#Write-Output -InputObject $Subnetid
#Exit
$workspaceid = $loganalytics.ResourceId
Write-Host "Adding AKS to subnet =  $Subnetid"
Write-Host "Attaching Registry =  $RegistryId"
Write-Host "Attching =  $workspaceid"

CreateAKS $ProjectSufix $RgAKSName $KeyVaultName $RegistryId $Subnetid $workspaceid

