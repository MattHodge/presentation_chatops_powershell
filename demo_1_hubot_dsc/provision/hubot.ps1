if ($PSVersionTable.PSVersion.Major -eq 5)
{
  if ((Get-DscLocalConfigurationManager).LCMState  -eq 'PendingConfiguration')
  {
    Start-DscConfiguration -UseExisting -Wait -Verbose
  }
  else
  {

    # DSC
    $dscOutPath = 'C:\DSC'

    # Make a folder store the generated DSC configuration
    New-Item -Path $dscOutPath -Force -ItemType Directory

    # Configure LCM so we can manually run DSC and see what is happening
    [DSCLocalConfigurationManager()]
    configuration LCMConfig
    {
        Node 'localhost'
        {
            Settings
            {
                ActionAfterReboot = 'StopConfiguration'
            }
        }
    }

    LCMConfig -OutputPath 'C:\DSC'

    Set-DscLocalConfigurationManager -Path $dscOutPath -Verbose

    configuration Hubot
    {
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -Name MSFT_xRemoteFile -ModuleName xPSDesiredStateConfiguration
        Import-DscResource -ModuleName @{ModuleName="Hubot"; RequiredVersion="1.1.5"}

        node $AllNodes.Where{$_.Role -eq "Hubot"}.NodeName
        {
            # Set an adapter for hubot to use
            Environment hubotadapter
            {
                Name = 'HUBOT_ADAPTER'
                Value = $Node.HubotAdapter
                Ensure = 'Present'
            }

            # Set the hubot debug level - either debug or info
            Environment hubotdebug
            {
                Name = 'HUBOT_LOG_LEVEL'
                Value = 'debug'
                Ensure = 'Present'
            }

            # Set any other environment variables that may be required for the hubot scripts
            Environment hubotslacktoken
            {
                Name = 'HUBOT_SLACK_TOKEN'
                Value = $Node.SlackAPIKey
                Ensure = 'Present'
            }

            # Install the Prereqs using the same Hubot user
            HubotPrerequisites installPreqs
            {
                Ensure = 'Present'
            }

            # Download the HubotWindows Repo
            xRemoteFile hubotRepo
            {
                DestinationPath = "$($env:Temp)\HubotWindows.zip"
                Uri = "https://github.com/MattHodge/HubotWindows/releases/download/0.0.2/HubotWindows-0.0.2.zip"
            }

            # Extract the Hubot Repo
            Archive extractHubotRepo
            {
                Path = "$($env:Temp)\HubotWindows.zip"
                Destination = $Node.HubotBotPath
                Ensure = 'Present'
                DependsOn = '[xRemoteFile]hubotRepo'
            }

            # Install Hubot
            HubotInstall installHubot
            {
                BotPath = $Node.HubotBotPath
                Ensure = 'Present'
                DependsOn = '[Archive]extractHubotRepo','[HubotPrerequisites]installPreqs'
            }

            # Install Hubot as a service using NSSM
            HubotInstallService myhubotservice
            {
                BotPath = $Node.HubotBotPath
                ServiceName = "Hubot_$($Node.HubotBotName)"
                BotAdapter = $Node.HubotAdapter
                Ensure = 'Present'
                DependsOn = '[HubotInstall]installHubot','[HubotPrerequisites]installPreqs'
            }
        }
    }

    # Provide the configuration data
    $botConfigData = @{
        AllNodes =
        @(
            @{
                NodeName = 'localhost';
                Role = 'Hubot'
                SlackAPIKey = 'xoxb-XXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXX'
                HubotAdapter = 'slack'
                HubotBotName = 'bender'
                HubotBotPath = 'C:\myhubot'
            }
        )
    }

    # Generate the mof. $configData comes from dsc_configuration.ps1
    Hubot -OutputPath 'C:\DSC' -ConfigurationData $botConfigData

    Start-DscConfiguration -Path $dscOutPath -Verbose -Wait
  }
}
else
{
  Write-Output "WMF5 is not installed yet."
}
