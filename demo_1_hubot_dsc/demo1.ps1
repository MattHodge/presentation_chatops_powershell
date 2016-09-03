# RUN FROM WINDOWS10 Machine
# Run from adminstrative ISE

$dscOutPath = 'C:\DSC'

# Make a folder store the generated DSC configuration
New-Item -Path $dscOutPath -Force -ItemType Directory

$password = "vagrant" | ConvertTo-SecureString -AsPlainText -Force
$cred =  New-Object -typename System.Management.Automation.PSCredential -ArgumentList 'vagrant', $password

# Set the name of the machine that will host the bot
$botserver = '172.28.128.100'

$slackAPIKey = "xoxb-19034991254-KuSxkQfZT4vleMLi5blJviOt"

#####################
# Configure the LCM
#####################

# Configure LCM so we can manually run DSC and see what is happening
[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node $botserver
    {
        Settings
        {
            ActionAfterReboot = 'StopConfiguration'
        }
    }
}

LCMConfig -OutputPath 'C:\DSC'

Set-DscLocalConfigurationManager -Path $dscOutPath -ComputerName $botserver -Credential $cred -Verbose

#####################
# DSC Local Apply
#####################
# Install Hubot locally
Install-Module -Name Hubot

# Let's look at the configuation example
psedit 'C:\Program Files\WindowsPowerShell\Modules\Hubot\1.1.5\Examples\dsc_configuration.ps1'

# Load the configuration example
. 'C:\Program Files\WindowsPowerShell\Modules\Hubot\1.1.5\Examples\dsc_configuration.ps1'

# Provide the configuration data
$botConfigData = @{
    AllNodes =
    @(
        @{
            NodeName = $botserver;
            Role = 'Hubot'
            SlackAPIKey = $slackAPIKey
            HubotAdapter = 'slack'
            HubotBotName = 'demobot'
            HubotBotPath = 'C:\myhubot'
        }
    )
}

# Generate the mof. $configData comes from dsc_configuration.ps1
Hubot -OutputPath 'C:\DSC' -ConfigurationData $botConfigData

Invoke-Command -ComputerName $botserver -Credential $cred -ScriptBlock {
    Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force
    Install-Module -Name Hubot -Force
}

Start-DscConfiguration -ComputerName $botserver -Credential $cred -Path $dscOutPath -Verbose -Wait

Restart-Computer -ComputerName $botserver -Credential $cred -Wait -Force -Protocol WSMan

<# backup plan

Invoke-Command -ComputerName $botserver -Credential $cred -ScriptBlock {
    Restart-Computer -Force
}

#>

Test-WSMan -ComputerName $botserver

Start-DscConfiguration -ComputerName $botserver -Credential $cred -UseExisting -Verbose -Wait
