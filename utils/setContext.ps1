function setHubContext {
    if ($AZURE_SUBSCRIPTION_ID_HUB -ne $null) { 
        Set-AzContext -Subscription $AZURE_SUBSCRIPTION_ID_HUB
    
        Write-Output "Subscription ID: $((Get-AzContext).Subscription.Id)"
        Write-Output "Subscription Name: $((Get-AzContext).Subscription.Name)"
    }
    else {
        Write-Output "AZURE_SUBSCRIPTION_ID_HUB is not set"
        exit
    }
}


function setSpokeContext {
    if ($AZURE_SUBSCRIPTION_ID_SPOKE -ne $null) { 
        Set-AzContext -Subscription $AZURE_SUBSCRIPTION_ID_SPOKE
    
        Write-Output "Subscription ID: $((Get-AzContext).Subscription.Id)"
        Write-Output "Subscription Name: $((Get-AzContext).Subscription.Name)"
    }
    else {
        Write-Output "AZURE_SUBSCRIPTION_ID_SPOKE is not set"
        exit
    }
}