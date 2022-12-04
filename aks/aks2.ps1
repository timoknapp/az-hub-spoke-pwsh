function CreateAKS {


    Param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AksName,

        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $AksRG,

        [parameter(Position = 2, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $keyvaultname,


        [parameter(Position = 3, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $ACRResourceID, 

        [parameter(Position = 4, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $SubNetID,

        [parameter(Position = 5, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $WorkspaceID
    )
    Process {

        $ManagedRgAKSName = "$AksName-managed"
        $UserManagedIdentityName = "$AksName-cpidentity"
        $KubeletUserManagedIdentityName = "$AksName-kubelet"
     
        ############# Sanity checks ################
        Write-Host  "      Assigning identity $($AKSKubeletUserManagedIdentity.PrincipalId)  to  REgistry   "+ 
        $ExistingACR = Get-AzContainerRegistry  -ResourceId $ACRResourceID -ErrorAction SilentlyContinue
        if ( $null -eq $ExistingACR ) {
            $msg = "       ACR with name  {0}  not found " -f $KeyVaultName
            throw " $msg "        
        } 
        $KeyVault = Get-AzKeyVault -Name $KeyVaultName   -ErrorAction SilentlyContinue
        if ( $null -eq $KeyVault ) {
            $msg = "        Keyvault with name  {0}  not found " -f $KeyVaultName
            throw "$msg "
        }
        $SubNetAKS = Get-AzVirtualNetworkSubnetConfig -ResourceId $SubNetID 
        if ( $null -eq $SubNetAKS ) {
            $msg = "      Subnet with id  {0}  not found " -f $SubNetID
            throw "$msg "
        }
        ############# Create CP identity ################
        Write-Host '############# Create CP identity ################'  -ForegroundColor Cyan  
        ### Used to configure loadbalancers 
        Write-Host  $SubNetAKS.ToString()
        Write-Host "     Creating identity for AKS control plane $UserManagedIdentityName "        
        $AKSUserManagedIdentity = New-AzUserAssignedIdentity -ResourceGroupName $AksRG  -Name $UserManagedIdentityName -Location $Location  
        Write-Host -InputObject $AKSUserManagedIdentity
      
        ############# Create kubelet identity ################
        ## Used for pulling down images 
        Write-Host "         Creating kubelet identity $UserManagedIdentityName " 
        $AKSKubeletUserManagedIdentity = New-AzUserAssignedIdentity -ResourceGroupName $RgAKSName  -Name $KubeletUserManagedIdentityName -Location $Location  
        Write-Host -InputObject $AKSKubeletUserManagedIdentity
      
        ##### leeping a bit as the Graph is not immediately available 
        Write-Host "         Sleeping a bit, 60 seconds as the Graph is not immediately available " 
        for ($i = 1; $i -le 100; $i++ ) {
            Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i
            Start-Sleep -Seconds 1s
        }
       

        $AKSKubeletUserManagedIdentity = Get-AzUserAssignedIdentity -ResourceGroupName $RgAKSName -Name $KubeletUserManagedIdentityName 
        Write-Host "         Creating got full kubelet identity  "
        Write-Host -InputObject $AKSKubeletUserManagedIdentity
        $AKSUserManagedIdentity = Get-AzUserAssignedIdentity -ResourceGroupName $AksRG -Name $UserManagedIdentityName 
        Write-Host "         Creating got full identity  "
        Write-Host -InputObject $AKSUserManagedIdentity
        
        
        ############# Create Keyvault Permission ################
        Write-Host '############# Create Keyvault Permission ################'  -ForegroundColor Cyan  
        $parms = @{
            VaultName                 = $KeyVault.VaultName
            ResourceGroupName         = $KeyVault.ResourceGroupName
            ObjectId                  = $AKSUserManagedIdentity.PrincipalId
            PermissionsToSecrets      = "Get"
            PermissionsToKeys         = "Get"
            PermissionsToCertificates = "Get"    
     
        }  
        $resp = Set-AzKeyVaultAccessPolicy @parms
        Write-Host -InputObject $resp
        
        ############# Create Keyvault Permission ################
        Write-Host  '########### Assign kubelet a acrpull role on  registry #################' -ForegroundColor Cyan  
        AssignRole  "AcrPull"  $AKSKubeletUserManagedIdentity.PrincipalId   $ExistingACR.Id

        ############# Apply permissions to Network  ################

        Write-Host  "############  Apply permissions to Network ################"   -ForegroundColor Cyan  
        $end = $SubNetID.IndexOf('/subnets/')
        $VNetId = $SubNetID.Substring(0, $end)
        Write-Host "        Derived networkID= $VNetId"
        Write-Host "         apply permissions to Network PimSubNetAKS"
        AssignRole "Contributor" $AKSUserManagedIdentity.PrincipalId  $VNetId
        AssignRole "Network Contributor" $AKSUserManagedIdentity.PrincipalId  $SubNetAKS.Id
      
        Write-Host  "############  Creating AKS Cluster ################"   -ForegroundColor Cyan  

        ############ Lets create an AKS now 
        az aks create `
            --resource-group $AksRG `
            --name $AksName `
            --network-plugin $NetworkPlugin `
            --node-count 1 `
            --node-vm-size=$NodeVmSize `
            --kubernetes-version=$KubernetesVersion `
            --dns-service-ip $DnsServiceIP `
            --service-cidr $ServiceCidr `
            --location $Location `
            --enable-addons  $AddOnNameToBeEnabled `
            --vm-set-type "VirtualMachineScaleSets"   `
            --tags $tags `
            --nodepool-name="basepool" `
            --enable-cluster-autoscaler `
            --min-count $NodeMinCount `
            --max-count $NodeMaxCount `
            --subscription $AZURE_SUBSCRIPTION_ID_SPOKE `
            --workspace-resource-id $WorkspaceID `
            --generate-ssh-keys `
            --zones $AvailabilityZone `
            --node-resource-group $AksRG-managed `
            --attach-acr $ACRResourceID  `
            --enable-managed-identity `
            --assign-identity $AKSUserManagedIdentity.Id  `
            --auto-upgrade-channel stable `
            --assign-kubelet-identity $AKSKubeletUserManagedIdentity.Id

    }

  
}
<#
.SYNOPSIS
Short description

.DESCRIPTION
A fucntion to apply a role. Checks if role already exist to avoid conflicts 

.PARAMETER RoleDefinitionName
Parameter description

.PARAMETER ObjectId
Parameter description

.PARAMETER Scope
Parameter description

.EXAMPLE
 AssignRole "Network Contributor" $AKSUserManagedIdentity.PrincipalId  $SubNetAKS.Id

.NOTES
General notes
#>
function AssignRole {
    Param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RoleDefinitionName,

        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $PrincipalId,

        [parameter(Position = 2, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $Scope

    )
    process {  
        $parms2 = @{
            RoleDefinitionName = $RoleDefinitionName
            ObjectId           = $PrincipalId
            Scope              = $Scope
        } 
        $hasRole = Get-AzRoleAssignment  @parms2
        if ( $null -eq $hasRole ) {
            $msg = "        Assign role {0} to the principal {1} for the scope {2}  " -f $RoleDefinitionName, $PrincipalId, $Scope
            Write-Host $msg
            New-AzRoleAssignment -ObjectId $PrincipalId -RoleDefinitionName $RoleDefinitionName -Scope  $Scope
        }
    }
}


#    $parms2 = @{
#        RoleDefinitionName="AcrPull"
#        ObjectId=$AKSKubeletUserManagedIdentity.PrincipalId
#        Scope=$ExistingACR.Id
#    } 
#    $hasRole = Get-AzRoleAssignment  @parms2
#    if ( $null -eq $hasRole ) {
#        New-AzRoleAssignment -ObjectId $AKSKubeletUserManagedIdentity.PrincipalId -RoleDefinitionName "AcrPull"  -Scope  $ExistingACR.Id
#    }