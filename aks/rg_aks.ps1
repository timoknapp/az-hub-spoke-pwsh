


function    CreateAKSRG {


    Param(
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AKSRGName
    )Process {
        ## Place the previously created webapp into a variable. ##
        ############# Create Keyvault ################
        # Create resource group
        $rg = @{
            Name     = $RgAKSName
            Location = $Location
        }
        $rg = New-AzResourceGroup @rg -force

        return $rg

    }

}