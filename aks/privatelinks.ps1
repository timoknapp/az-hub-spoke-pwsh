<#
.SYNOPSIS
Short description

.DESCRIPTION
Creates a preivate link ing the hub network. supports a multiple types of services. Simply add a new "Service Type"

.PARAMETER HubResourceGroup
RG where the hub vnet is sitting

.PARAMETER HubVnetName
Name of the Hub vnet 

.PARAMETER HubVnetSubnetName
Name of the subnet where the private link should be created 
.PARAMETER ResourceID
id of the service to link up 

.PARAMETER NamePrefix
Some name. all resources wil be based on this 
.PARAMETER ServiceType

eiother one of the following strings 
'KeyVault','ACR', 'Postgres', 'Cosmos'
a new DNS zone is created based on this 

.EXAMPLE
An example

.NOTES
General notes
#>
function CreatePrivateLinkInHuB {


    Param(
        [parameter(Position=0,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $HubResourceGroup,

        [parameter(Position=1,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $HubVnetName,

        [parameter(Position=2,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $HubVnetSubnetName,

        [parameter(Position=3,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ResourceID,

        [string]
        [parameter(Position=4,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $NamePrefix,

        [Parameter(Position=5,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('KeyVault','ACR', 'Postgres', 'Cosmos')]
        [string]$ServiceType

        ) 
        Process 
        { 
          
            . ".\..\utils\setContext.ps1"
            # Set context
            setHubContext

            # Import variables
            $CurrentDirectory = Get-Location
            . $CurrentDirectory\_variables.ps1

            ### Checking resoourceid if it exisits 
            $resource =  Get-AzResource    -ResourceId $ResourceID
            if ( $null -eq $resource ) {
                throw "Resource does not exist, cannot build private link: $ResourceID"
            }
            ## Prepare 
            switch ( $ServiceType )
            {
                KeyVault
                {
                    $plType = $keyvaultPL
                }
                ACR
                {
                    $plType = $acrPl
                }
                Postgres
                {
                    $plType = $postgresPL
                }
                Cosmos
                {
                    $plType = $cosmos    
                }
            }

            ## sanity checks now verify Type 
            if (!$resource.Type -eq $plType.Type) {
                $msg =  "Resource's type {0} for resourceid({1}) Does not match the target private link type:  {2} " -f $resource.Type, $ResourceID, $plType.Type
                throw "Type mismatch $msg "
            }
            $NamePrefix  = "{0}-{1}" -f  $NamePrefix, $plType.Prefix    
            ## Create the private endpoint connection. ## 
            $pec = @{
                Name = "$NamePrefix-pe"
                PrivateLinkServiceId = $ResourceID
                GroupID = $plType.GroupId
            }

           
            Write-Host "      5 Created  PrivateLinkServiceConnection"

            $privateEndpointConnection = New-AzPrivateLinkServiceConnection @pec
            Write-Host "      6 Created  PrivateLinkServiceConnection"
            Write-Host -InputObject $privateEndpointConnection

            ## Place the virtual network you created previously into a variable. ##
            Write-Host "      7 Getting Vnet"
            $VnetHub = Get-AzVirtualNetwork -ResourceGroupName $HubResourceGroup -Name $HubVnetName  
            Write-Host "      8 Getting subnet "
            $SubnetPrivateLink = Get-AzVirtualNetworkSubnetConfig -Name $HubVnetSubnetName  -VirtualNetwork $VnetHub

            ## Create the private endpoint. ##
            $pe = @{
                ResourceGroupName = $HubResourceGroup
                Name = "$NamePrefix-pe"
                Location = $Location
                Subnet = $SubnetPrivateLink
                PrivateLinkServiceConnection = $privateEndpointConnection
            }
            Write-Host "       9 Creating privateendpoint"

            $resp = New-AzPrivateEndpoint @pe -Force
            Write-Host -InputObject $resp



            ## Create the private DNS zone. ##
            $zn = @{
                ResourceGroupName = $HubResourceGroup
                Name = $plType.DNSZone
            }
            $zone = Get-AzPrivateDnsZone @zn 
            if ($null -eq $zone) {
                Write-Host "      10 Creating private zone"
                $zone = New-AzPrivateDnsZone @zn
                Write-Host "      10 Created Private Zone"
            }else{
                Write-Host "      10 Zone Already Exists"
            }
            Write-Host -InputObject $zone
            ## Create a DNS network link. ##
            $lk = @{
                ResourceGroupName = $HubResourceGroup
                ZoneName = $plType.DNSZone
                Name = "$NamePrefix-pl"
                VirtualNetworkId = $VnetHub.Id
            }


            $Link = Get-AzPrivateDnsVirtualNetworkLink  -ResourceGroupName $HubResourceGroup -ZoneName  $plType.DNSZone

            if ($null -eq $link) {
                Write-Host "      11 Creating Network Link"
                $link = New-AzPrivateDnsVirtualNetworkLink @lk -enableregistration -ErrorAction SilentlyContinue
                Write-Host "      11 Created Network Link"
            }else{
                Write-Host "      11 Link Alread Exisits "

            }
            Write-Host -InputObject $link

            ## Configure the DNS zone. ##
            $cg = @{
                Name = $plType.DNSZone
                PrivateDnsZoneId = $zone.ResourceId
            }
            Write-Host "      12 Creating New-AzPrivateDnsZoneConfig"

            $config = New-AzPrivateDnsZoneConfig @cg

            ## Create the DNS zone group. ##
            $zg = @{
                ResourceGroupName = $HubResourceGroup
                PrivateEndpointName = "$NamePrefix-pe"
                Name = $plType.ZoneGroup
                PrivateDnsZoneConfig = $config
            }
            Write-Host "      13 Creating Zone Group "
            $zgrp = New-AzPrivateDnsZoneGroup @zg -Force
            Write-Host -InputObject  $zgrp
        } 
                    
       
}