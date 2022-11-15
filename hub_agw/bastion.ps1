# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

$publicip = New-AzPublicIpAddress -ResourceGroupName $RgHubName -name "pip-bh-$Env-$Location" -location $Location -AllocationMethod Static -Sku Standard

New-AzBastion -ResourceGroupName $RgHubName -Name "bh-$Env-$Location" `
   -PublicIpAddressRgName $RgHubName -PublicIpAddressName $publicip.Name `
   -VirtualNetworkRgName $RgHubName -VirtualNetworkName $VnetAgwName `
   -Sku "Standard"