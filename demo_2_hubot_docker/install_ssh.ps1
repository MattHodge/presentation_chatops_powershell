Write-Output "Checking if PowerShell 5.0 is installed"
if ($PSVersionTable.PSVersion.Major -eq 4)
{
  Write-Output "Installing PowerShell 5.0"
  choco install -y powershell
}
else
{
  Write-Output "PowerShell 5.0 is already installed."  
}

Write-Output "Checking if OpenSSH-Win64 is installed"
if (!(Test-Path -Path 'C:\\Program Files\\OpenSSH-Win64'))
{
  Write-Output "Installing OpenSSH-Win64 is installed"
  choco install -y win32-openssh -version 2016.05.30.20160902 --params='/SSHServerFeature /KeyBasedAuthenticationFeature /UseNTRights'
}
else
{
  Write-Output "OpenSSH-Win64 is already installed."
}

Write-Output "Checking if PowerShell 6.0 is installed"
if (!(Test-Path -Path "C:\\Program Files\\PowerShell"))
{
  Write-Output "Installing PowerShell 6.0"
  mkdir "C:\\temp" | Out-Null
  Invoke-WebRequest -Uri 'https://github.com/PowerShell/PowerShell/releases/download/v6.0.0-alpha.9/PowerShell_6.0.0.9-alpha.9-win10-x64.msi' -UseBasicParsing -OutFile "C:\\temp\\PowerShell_6.0.0.9-alpha.9-win10-x64.msi"
  Start-Process -FilePath msiexec -ArgumentList "/i C:\\temp\\PowerShell_6.0.0.9-alpha.9-win10-x64.msi /quiet /qn /norestart" -wait
}
else
{
  Write-Output "PowerShell 6.0 is already installed."
}
