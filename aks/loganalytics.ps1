
function CreateLogAnaylticsWorkspace {


    Param(
        [parameter(Position=0,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $WorkspaceName,
        [parameter(Position=1,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]   $WorkspaceRG
    )

        Process 
        {
            Write-Host "3 Creating workspace "

            $LogAnalytics = New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -Sku PerGB2018 -ResourceGroupName $WorkspaceRG -Force
            Write-Host "    $AKSUserManagedIdentity"
            return  $LogAnalytics
        }

    }

