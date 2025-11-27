# Intune to Entra ID Device ID Converter

A collection of PowerShell scripts using the Microsoft Graph SDK to translate Intune Managed Device IDs into their corresponding Azure AD (Entra ID) Object IDs.

## Overview

Intune and Azure AD (Entra ID) use different identifiers for the same device:
- **Intune:** Uses `ManagedDeviceId`
- **Azure AD:** Uses `ObjectId` for group memberships and permissions

These scripts bridge that gap by querying Intune, finding the sync key (`AzureADDeviceId`), and retrieving the target Azure AD Object.

## Prerequisites

- **PowerShell:** Version 5.1 or 7+
- **Module:** Microsoft Graph PowerShell SDK
  ```powershell
  Install-Module Microsoft.Graph
  ```

## Permissions

The account or Managed Identity running these scripts requires the following Microsoft Graph API scopes:
- `DeviceManagementManagedDevices.Read.All`
- `Device.Read.All`

## Usage

### 1. Single Device Converter (`deviceID_to_objectID_converter.ps1`)

Use this script when you want to look up a single device manually.

**Syntax:**
```powershell
.\deviceID_to_objectID_converter.ps1 -IntuneDeviceId "your-guid-here"
```

### 2. Batch Converter (`deviceID_to_objectID_batchconverter.ps1`)

Use this script to process multiple devices at once. It supports arrays and pipeline input.

#### Method A: Pass an Array of IDs
```powershell
$myIds = @("id-1", "id-2", "id-3")
.\deviceID_to_objectID_batchconverter.ps1 -IntuneDeviceIds $myIds
```

#### Method B: Import from CSV (Pipeline)
Assuming your CSV has a header named `IntuneDeviceIds` (or matches the property name):
```powershell
Import-Csv "C:\Temp\devices.csv" | .\deviceID_to_objectID_batchconverter.ps1
```

#### Method C: Output Raw IDs Only
If you want to feed the results directly into another automation script without the table headers:
```powershell
$myIds = @("id-1", "id-2")
.\deviceID_to_objectID_batchconverter.ps1 -IntuneDeviceIds $myIds -OutputIdOnly
```

## Output Examples

### Single Script
Returns a single String (GUID).

### Batch Script (Default)
Returns a PowerShell Object containing details:
```
IntuneDeviceId                       AzureADName    AzureADObjectId                      Status
--------------                       -----------    ---------------                      ------
00573fe3-1ea2-41a3-8a9e-dba379266904 LAPTOP-01      a1b2c3d4-e5f6-7890-1234-567890abcdef Success
```

## License

MIT License - Feel free to use and modify as needed.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues or questions, please open an issue on GitHub.
