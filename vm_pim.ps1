# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Credential
$password = 'DasIstEinTestPassword!64';
$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force;  
$user = 'azureuser';
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);


New-AzVm `
    -ResourceGroupName $RgPimName `
    -Name 'vm-pim' `
    -VirtualNetworkName $VnetPimName `
    -SubnetName "snet-default-$Env-$Location-001" `
    -Credential $cred `
    -Location $Location `
    -Image UbuntuLTS `
    -size Standard_B2s `
    -PublicIpAddressName "" `
    -OpenPorts 22


Invoke-AzVMRunCommand `
    -ResourceGroupName $RgPimName `
    -Name 'vm-pim' `
    -CommandId 'RunShellScript' `
    -ScriptString 'sudo apt-get update && sudo apt-get install -y nginx'