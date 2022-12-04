

function CreateKeyVault {


    Param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $KeyVaultName,
        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]   $KeyvaultRG
    )Process {
        ## Place the previously created webapp into a variable. ##
        ############# Create Keyvault ################
        Write-Host "#############  Start Create Keyvault ################" -ForegroundColor Cyan  
        $msg =  "Creating Keyvault:{0} in Resource Group :{1}   " -f $KeyVaultName, $KeyvaultRG

        Write-Host "    1  getting keyvault $KeyvaultRG"
        $ExistingKV = Get-AzKeyVault -Name $KeyVaultName  -ResourceGroupName $KeyvaultRG  -ErrorAction SilentlyContinue
        # ResourceExists variable holds boolean value indicating whether storage account exists
        $ResourceExists = $null -eq $ExistingKV
        Write-Host  "     2 xxKeyvault Exist=$ResourceExists" # Outputs True or False

        if ( $ResourceExists ) {
            Write-Host "    3 Keyvault does not Exist, creating "

            $KeyVault = New-AzKeyVault -Name $KeyVaultName  -ResourceGroupName $RgAKSName -Location $Location 
        }
        else {
            $KeyVault = $ExistingKV
        }
        # set policy to access keys in your key vault
       
        Write-Host -Object  $KeyVault
        Write-Host "#############  End Create Keyvault ################" -ForegroundColor Cyan  

        return $KeyVault


    }

}