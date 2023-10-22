# Import the AzureRM module if it's not already imported
if (-not (Get-Module -Name Az.Accounts -ListAvailable)) {
    Install-Module -Name Az -Force -AllowClobber -Scope CurrentUser
}
Import-Module -Name Az.Accounts -Force

# Authenticate to Azure
Connect-AzAccount

# Define variables
$roleAssignmentName = "MyRoleAssignment"  # Set a unique name for your role assignment
$principalId = "PrincipalID"  # Replace with the Principal ID you want to assign the role to
$resourceGroup = "MyResourceGroup"  # Specify the target resource group
$roleDefinitionName = "Contributor"  # Replace with the desired role name (e.g., Contributor)
$pimConfigId = "PIMConfigID"  # If using PIM, provide the PIM configuration ID
$permanentEligible = $true  # Set to $true if the assignment should be permanently eligible, otherwise set to $false
$endDate = "2023-12-31"  # If not permanent, specify an end date (YYYY-MM-DD)

try {
    # Check if the role definition exists
    $roleDefinition = Get-AzRoleDefinition -Name $roleDefinitionName
    if (!$roleDefinition) {
        Write-Host "Role definition '$roleDefinitionName' not found. Please ensure it exists."
        exit 1
    }

    # Create the role assignment
    $roleAssignment = New-AzRoleAssignment -SignInName $principalId -ResourceGroupName $resourceGroup -RoleDefinitionName $roleDefinitionName

    # If you want to configure PIM settings
    if ($pimConfigId) {
        $pimSettings = Set-AzRoleAssignmentSchedule -RoleAssignmentName $roleAssignmentName -PermanentEligible $permanentEligible -EndDate $endDate -PimConfigurationId $pimConfigId
    }

    Write-Host "Role assignment '$roleAssignmentName' created successfully."

} catch {
    Write-Host "An error occurred: $_"
} finally {
    # Disconnect from Azure
    Disconnect-AzAccount
}
