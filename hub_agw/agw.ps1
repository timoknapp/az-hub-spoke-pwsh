. ".\..\utils\setContext.ps1"

# Set context
setHubContext

# Import variables
$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

# Local variables
$appgwName = "agw-$Env-$Location-001"

$VnetAgw = Get-AzVirtualNetwork -ResourceGroupName $RgHubName -Name $VnetAgwName


#Create a Static Public VIP
$publicip = New-AzPublicIpAddress -ResourceGroupName $RgHubName -name "pip-agw-$Env-$Location" `
  -location $Location -AllocationMethod Static -Sku Standard -DomainNameLabel "agw-oneplatform-$Env"

#Create pool and frontend port
$gwSubnet = Get-AzVirtualNetworkSubnetConfig -Name "snet-agw-$Env-$Location-001" -VirtualNetwork $VnetAgw

$gipconfig = New-AzApplicationGatewayIPConfiguration -Name "AppGwIpConfig" -Subnet $gwSubnet
$fipconfig01 = New-AzApplicationGatewayFrontendIPConfig -Name "fipconfig" -PublicIPAddress $publicip
$pool = New-AzApplicationGatewayBackendAddressPool -Name "pool1" `
  -BackendIPAddresses testbackend1.westus.cloudapp.azure.com, testbackend2.westus.cloudapp.azure.com
$fp01 = New-AzApplicationGatewayFrontendPort -Name "port1" -Port 80

#Create a listener, http setting, rule, and autoscale
$listener01 = New-AzApplicationGatewayHttpListener -Name "listener1" -Protocol Http `
  -FrontendIPConfiguration $fipconfig01 -FrontendPort $fp01
$poolSetting01 = New-AzApplicationGatewayBackendHttpSettings -Name "setting1" -Port 80 `
  -Protocol Http -CookieBasedAffinity Disabled
$rule01 = New-AzApplicationGatewayRequestRoutingRule -Name "rule1" -RuleType basic `
  -BackendHttpSettings $poolSetting01 -HttpListener $listener01 -BackendAddressPool $pool -Priority 1
$autoscaleConfig = New-AzApplicationGatewayAutoscaleConfiguration -MinCapacity 3
$sku = New-AzApplicationGatewaySku -Name WAF_v2 -Tier WAF_v2


# Create the custom rule and apply it to WAF policy
$variable = New-AzApplicationGatewayFirewallMatchVariable -VariableName RequestHeaders -Selector User-Agent
$condition = New-AzApplicationGatewayFirewallCondition -MatchVariable $variable -Operator Contains -MatchValue "evilbot" -Transform Lowercase -NegationCondition $False  
$rule = New-AzApplicationGatewayFirewallCustomRule -Name blockEvilBot -Priority 2 -RuleType MatchRule -MatchCondition $condition -Action Block
$policy = New-AzApplicationGatewayFirewallPolicySetting -Mode "Prevention"
$wafPolicy = New-AzApplicationGatewayFirewallPolicy -Name wafPolicy -ResourceGroup $RgHubName -Location $Location -CustomRule $rule -PolicySetting $policy

#Create the Application Gateway
New-AzApplicationGateway -Name $appgwName -ResourceGroupName $RgHubName -Location $Location -BackendAddressPools $pool -BackendHttpSettingsCollection $poolSetting01 -GatewayIpConfigurations $gipconfig -FrontendIpConfigurations $fipconfig01 -FrontendPorts $fp01 -HttpListeners $listener01 -RequestRoutingRules $rule01 -Sku $sku -AutoscaleConfiguration $autoscaleConfig -FirewallPolicy $wafPolicy