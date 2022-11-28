. ".\..\utils\setContext.ps1"

# Set context
setSpokeContext

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

## Parameter help description

# Printing details on the currently selected Subscription
Write-Output "Subscription ID: $((Get-AzContext).Subscription.Id)"
Write-Output "Subscription Name: $((Get-AzContext).Subscription.Name)"

# Create resource group
$rg = @{
    Name = $RgOdusName
    Location = $Location
}
New-AzResourceGroup @rg