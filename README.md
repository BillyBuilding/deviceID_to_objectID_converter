# Intune to Entra ID Device Translator

A PowerShell script using the Microsoft Graph SDK to retrieve the Azure AD (Entra ID) Object ID based on an Intune Managed Device ID.

## Prerequisites

- PowerShell 5.1 or PowerShell 7+
- Microsoft Graph PowerShell SDK (`Install-Module Microsoft.Graph`)

## Permissions

 The account or Managed Identity running this script requires the following Microsoft Graph API scopes:
 - `DeviceManagementManagedDevices.Read.All`
 - `Device.Read.All`

## Usage

```powershell
.\Get-EntraIdFromIntune.ps1 -IntuneDeviceId "your-guid-here"
