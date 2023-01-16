# Import variables from other variable files
$CurrentDirectory = Get-Location
. $CurrentDirectory\..\hub\_variables.ps1
. $CurrentDirectory\..\hub_agw\_variables.ps1
. $CurrentDirectory\..\spoke_spokeName1\_variables.ps1
. $CurrentDirectory\..\spoke_spokeName2\_variables.ps1
