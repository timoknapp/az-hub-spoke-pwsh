. ".\..\utils\setContext.ps1"

# Set context
setHubContext

$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

$firewallpolicy = New-AzFirewallPolicy -Name "fw-policy-$Env" -ResourceGroupName $RgHubName -Location $Location

# Update SNAT configuration for the firewall policy to always SNAT. This can only be performed by running an ARM template so far. See docs: https://learn.microsoft.com/en-us/azure/firewall/snat-private-range#firewall-policy
New-AzResourceGroupDeployment -ResourceGroupName $RgHubName -TemplateFile fw_policies.json -TemplateParameterObject @{name="fw-policy-$Env";env=$Env;location=$Location}

$RCGroup = New-AzFirewallPolicyRuleCollectionGroup -Name "myCollectionGroup" -Priority 200 -FirewallPolicyObject $firewallpolicy

$netrule1 = New-AzFirewallPolicyNetworkRule -Name "all-traffic" -Description "Rule for all TCP traffic" -Protocol Any -SourceAddress "*" -DestinationAddress "*" -DestinationPort "*"

$netcoll1 = New-AzFirewallPolicyFilterRuleCollection -Name Net-coll01 -Priority 200 -Rule $netrule1 -ActionType "Allow"

Set-AzFirewallPolicyRuleCollectionGroup -Name $RCGroup.Name -Priority 200 -RuleCollection $netcoll1 -FirewallPolicyObject $firewallpolicy