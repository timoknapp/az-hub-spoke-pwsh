. ".\..\utils\setContext.ps1"

# Set context
setSpokeContext

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Credential
$password = 'DasIstEinTestPassword!64';
$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force;  
$user = 'azureuser';
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);


New-AzVm `
    -ResourceGroupName $RgSpokeName1Name `
    -Name 'vm-spokeName1' `
    -VirtualNetworkName $VnetSpokeName1Name `
    -SubnetName "snet-default-$Env-$Location-001" `
    -Credential $cred `
    -Location $Location `
    -Image UbuntuLTS `
    -size Standard_B2s `
    -PublicIpAddressName "" `
    -OpenPorts 22


Invoke-AzVMRunCommand `
    -ResourceGroupName $RgSpokeName1Name `
    -Name 'vm-spokeName1' `
    -CommandId 'RunShellScript' `
    -ScriptString 'sudo apt-get update && sudo apt-get install -y nginx'