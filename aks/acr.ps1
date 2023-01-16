

function CreateContainerRegistry {


    Param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ACRName,
        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $ACRRG 
    )Process {
        Write-Host  "############ Create Registry  ################" -ForegroundColor Cyan 
        Write-Host "5 Creating Container registry " 
        
        Write-Host "    5 getting ACR  " 
        $ExistingACR = Get-AzContainerRegistry -Name $ACRName  -ResourceGroupName $ACRRG -ErrorAction SilentlyContinue
        # ResourceExists variable holds boolean value indicating whether storage account exists
        $ResourceExists = $null -eq $ExistingACR
        Write-Host  "     5 ACR Exist=$ResourceExists" # Outputs True or False
        
        if ( $ResourceExists ) {
           Write-Host "    5 Creating ACR  cos it does not exist"
           $ExistingACR = New-AzContainerRegistry -ResourceGroupName $ACRRG -Name $ACRName -EnableAdminUser -Sku Basic -Location $Location 
        } 
        # set 
        Write-Host $ExistingACR.ToString()
        return $ExistingACR


    }

}