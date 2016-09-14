if ($PSVersionTable.PSVersion.Major -eq 5)
{
  $secpasswd = ConvertTo-SecureString 'MyPassword101!' -AsPlainText -Force
  $SafeModePW = New-Object System.Management.Automation.PSCredential ('Administrator', $secpasswd)

  $secpasswd = ConvertTo-SecureString 'MyPassword101!' -AsPlainText -Force
  $localuser = New-Object System.Management.Automation.PSCredential ('Administrator', $secpasswd)

  $dscOutPath = 'C:\DSC'
  New-Item -Path $dscOutPath -ItemType Directory -Force

  #####################
  # Configure the LCM
  #####################

  # Configure LCM so we can manually run DSC and see what is happening
  [DSCLocalConfigurationManager()]
  configuration LCMConfig
  {
      Node 'localhost'
      {
          Settings
          {
            ConfigurationMode = "ApplyOnly"
            ActionAfterReboot = 'StopConfiguration'
            RebootNodeIfNeeded = $false
          }
      }
  }

  LCMConfig -OutputPath $dscOutPath

  Set-DscLocalConfigurationManager -Path $dscOutPath -Verbose 

  configuration TestLab
  {
      #Import the required DSC Resources
      Import-DscResource -Module xActiveDirectory
      Import-DscResource -Module xNetworking
      Import-DscResource -Module xComputerManagement

      node $AllNodes.Where{$_.Role -eq "DomainController"}.NodeName
      { #ConfigurationBlock

        xComputer NewNameAndWorkgroup
        {
            Name = $Node.MachineName
        }

        WindowsFeature ADDSInstall
        {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
            IncludeAllSubFeature = $true
        }

        WindowsFeature RSATTools
        {
            DependsOn= '[WindowsFeature]ADDSInstall'
            Ensure = 'Present'
            Name = 'RSAT-AD-Tools'
            IncludeAllSubFeature = $true
        }

        xADDomain SetupDomain
        {
            DomainAdministratorCredential = $Node.DomainAdministratorCredential
            DomainName = $Node.DomainName
            SafemodeAdministratorPassword  = $Node.SafemodeAdministratorPassword
            DependsOn ='[WindowsFeature]RSATTools'
        }

      #End Configuration Block
      }
  }

  $configData = @{
      AllNodes = @(
                      @{
                          NodeName = 'localhost';
                          PSDscAllowPlainTextPassword = $true
                          DomainAdministratorCredential = $localuser
                          SafemodeAdministratorPassword = $SafeModePW
                          DomainName = 'hdg.local'
                          MachineName = 'HDGDC'
                          Role = 'DomainController'
                      }
                  )
  }

  TestLab -ConfigurationData $configData -OutputPath $dscOutPath

  Start-DscConfiguration -Path $dscOutPath -Verbose -Wait -Force
}
