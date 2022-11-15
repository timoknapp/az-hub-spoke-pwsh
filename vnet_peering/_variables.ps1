# Import variables from other variable files
$CurrentDirectory = Get-Location
. $CurrentDirectory\..\hub\_variables.ps1
. $CurrentDirectory\..\hub_agw\_variables.ps1
. $CurrentDirectory\..\spoke_odus\_variables.ps1
. $CurrentDirectory\..\spoke_pim\_variables.ps1
