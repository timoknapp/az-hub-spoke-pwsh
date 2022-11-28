. ".\..\utils\setContext.ps1"

# Set context
setHubContext

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1


# Create resource group
$rg = @{
    Name = $RgHubName
    Location = $Location
}
New-AzResourceGroup @rg