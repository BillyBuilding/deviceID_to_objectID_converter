<#
.SYNOPSIS
    Retrieves the Azure AD (Entra ID) Object ID for a given Intune Managed Device ID.

.DESCRIPTION
    This script queries Microsoft Graph to translate an Intune Managed Device ID 
    into its corresponding Azure AD Object ID. 
    
    This is useful because Intune and Azure AD use different identifiers. 
    The Object ID is required for operations like adding devices to Azure AD Groups.

.PARAMETER IntuneDeviceId
    The GUID of the device in Intune (ManagedDeviceId).

.EXAMPLE
    .\Get-EntraIdFromIntune.ps1 -IntuneDeviceId "00573fe3-1ea2-41a3-8a9e-dba379266904"

.NOTES
    Author: [Your Name]
    Required Modules: Microsoft.Graph.DeviceManagement, Microsoft.Graph.Identity.DirectoryManagement
    Required Scopes: DeviceManagementManagedDevices.Read.All, Device.Read.All
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "Enter the Intune Managed Device ID")]
    [string]$IntuneDeviceId
)

process {
    # Define required scopes for the script to function
    $RequiredScopes = @("DeviceManagementManagedDevices.Read.All", "Device.Read.All")

    # Check for existing Graph connection
    try {
        if (-not (Get-MgContext)) {
            Write-Verbose "No active Graph connection found. Attempting to connect..."
            Connect-MgGraph -Scopes $RequiredScopes -ErrorAction Stop
        }
    }
    catch {
        Write-Error "Failed to connect to Microsoft Graph. Ensure you have the Microsoft.Graph module installed and valid credentials."
        exit 1
    }

    try {
        Write-Verbose "Looking up Intune Device: $IntuneDeviceId"

        # 1. Get the Intune Device Object
        $intuneDeviceObj = Get-MgDeviceManagementManagedDevice -ManagedDeviceId $IntuneDeviceId -ErrorAction Stop

        if ($null -eq $intuneDeviceObj) {
            Write-Error "Intune device not found for ID: $IntuneDeviceId"
            return
        }

        # 2. Extract the AzureADDeviceId (The bridge between Intune and Entra)
        $azureADDeviceId = $intuneDeviceObj.AzureADDeviceId

        if ([string]::IsNullOrEmpty($azureADDeviceId)) {
            Write-Error "The Intune device exists, but it is not synced to Azure AD (AzureADDeviceId is empty)."
            return
        }

        Write-Verbose "Found match. Azure AD Device ID (Hardware ID): $azureADDeviceId"

        # 3. Get the Entra ID (Azure AD) Object
        # We filter by 'deviceId' (Hardware ID) to get the 'Id' (Object ID)
        $EntraObject = Get-MgDevice -Filter "deviceId eq '$azureADDeviceId'" -ErrorAction Stop

        if ($null -eq $EntraObject) {
            Write-Error "Azure AD device object not found using Hardware ID: $azureADDeviceId"
            return
        }

        # 4. Output the result
        $azureADObjectId = $EntraObject.Id
        
        Write-Verbose "Successfully retrieved Azure AD Object ID."
        
        # Return the ID to the pipeline (allows this script to be used by other scripts)
        Write-Output $azureADObjectId

    }
    catch {
        Write-Error "An unexpected error occurred: $_"
        exit 1
    }
}
