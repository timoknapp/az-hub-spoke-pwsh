
function CreateAKSSubnet {

    [cmdletBinding()]
    Param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SpokeVnetAKSName,
        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $AKSSubnetName,
        [parameter(Position = 2, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $SpokeVnetAKSRG,
        [parameter(Position = 3, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $subnetRange
    )Process {  
        Write-Host " ############### Start Create Subnet ####################"  -ForegroundColor Cyan  
    
        $msg =  "Creating subnet:{0} range:{3} in Vnet:{1}  within RG:{2}  " -f $AKSSubnetName, $SpokeVnetAKSName, $SpokeVnetAKSRG,$subnetRange


        Write-Host " $msg" 
       $AKSVirtualNetwork = Get-AzVirtualNetwork -Name $SpokeVnetAKSName  -ResourceGroupName $SpokeVnetAKSRG
       $PimSubNetAKS = Get-AzVirtualNetworkSubnetConfig -Name $AKSSubnetName -VirtualNetwork $AKSVirtualNetwork  -ErrorAction SilentlyContinue

        if ($null -eq $PimSubNetAKS) {
            Write-Host "Subnet not found, gona create"

            $PimSubNetAKS = Add-AzVirtualNetworkSubnetConfig -Name $AKSSubnetName -VirtualNetwork $AKSVirtualNetwork -AddressPrefix $subnetRange 
            $AKSVirtualNetwork |  Set-AzVirtualNetwork

        }
        Write-Host " ############### End Create Subnet ####################" 
       $PimSubNetAKS = Get-AzVirtualNetworkSubnetConfig -Name $AKSSubnetName -VirtualNetwork $AKSVirtualNetwork  -ErrorAction SilentlyContinue

        return $PimSubNetAKS
        ## TODO 
    }

}