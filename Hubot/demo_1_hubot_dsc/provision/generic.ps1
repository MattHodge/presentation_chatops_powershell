if ($PSVersionTable.PSVersion.Major -eq 4)
{
  choco install powershell 5 -y
}
else
{
  $WUSettings = (New-Object -com 'Microsoft.Update.AutoUpdate').Settings
  $WUSettings.NotificationLevel = 1
  $WUSettings.save()

  Set-Item WSMan:\\localhost\\Client\\TrustedHosts * -Force

  $packages = (Get-PackageProvider).Name
  $modules = (Get-Module -ListAvailable).Name

  if (!($packages -contains 'NuGet'))
  {
      Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force
  }
  else
  {
    Write-Output "NuGet is already instaled"
  }

  if (!($modules -contains 'Hubot'))
  {
    Install-Module -Name Hubot -Force
  }
  else
  {
    Write-Output "Hubot Module is already instaled"
  }  
}
