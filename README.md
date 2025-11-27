# Intune to Entra ID Device Translator

A PowerShell script using the Microsoft Graph SDK to retrieve the Azure AD (Entra ID) Object ID based on an Intune Managed Device ID.

The first script 'deviceID_to_objectID_converter' is made to be used for a single ID at a time
The second script 'deviceID_to_objectID_batchconverter' is made to be used for multiples ID.

## Prerequisites

- PowerShell 5.1 or PowerShell 7+
- Microsoft Graph PowerShell SDK (`Install-Module Microsoft.Graph`)

## Permissions

 The account or Managed Identity running this script requires the following Microsoft Graph API scopes:
 - `DeviceManagementManagedDevices.Read.All`
 - `Device.Read.All`

## Usage

'deviceID_to_objectID_converter'

```powershell
.\deviceID_to_objectID_converter.ps1 -IntuneDeviceId "your-guid-here"



'deviceID_to_objectID_batchconverter'

```powershell
$myIds = @("id-1", "id-2", "id-3")
.\deviceID_to_objectID_batchconverter.ps1 -IntuneDeviceIds $myIds

or

Import-Csv "C:\Temp\devices.csv" | .\deviceID_to_objectID_batchconverter.ps1
