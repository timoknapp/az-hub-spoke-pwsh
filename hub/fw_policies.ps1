$CurrentDirectory = Get-Location
. $CurrentDirectory\_variables.ps1

$firewallpolicy = New-AzFirewallPolicy -Name "fw-policy-$Env" -ResourceGroupName $RgHubName -Location $Location

$RCGroup = New-AzFirewallPolicyRuleCollectionGroup -Name "myCollectionGroup" -Priority 200 -FirewallPolicyObject $firewallpolicy

$netrule1 = New-AzFirewallPolicyNetworkRule -Name "all-tcp-traffic" -Description "Rule for all TCP traffic" -Protocol TCP -SourceAddress "*" -DestinationAddress "*" -DestinationPort "*"

$netcoll1 = New-AzFirewallPolicyFilterRuleCollection -Name Net-coll01 -Priority 200 -Rule $netrule1 -ActionType "Allow"

Set-AzFirewallPolicyRuleCollectionGroup -Name $RCGroup.Name -Priority 200 -RuleCollection $netcoll1 -FirewallPolicyObject $firewallpolicy