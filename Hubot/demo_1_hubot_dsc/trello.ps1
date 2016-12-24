# Need to do:
# $token = New-TrelloToken -Key $Key -AppName "TrellOpsWrite" -Expiration "never" -Scope 'read,write'
# Originally on a machine with a GUI to get the token and access key.
# These can then be saved and used by the bot.

function Install-HubotTrelloCard
{
    [CmdletBinding()]
    Param
    (
    )

    if (!(Get-Module -ListAvailable).Name.Contains('TrellOps'))
    {
        Install-Module -Name 'TrellOps' -Force -Scope CurrentUser
    }
}

function New-HubotTrelloCard
{
    [CmdletBinding()]
    Param
    (
        # Trello token
        [Parameter(Mandatory=$true)]
        [string]
        $Token,

        # Trello access key
        [Parameter(Mandatory=$true)]
        [string]
        $AccessKey,

        # Board to put the card in
        [Parameter(Mandatory=$true)]
        [string]
        $Board,

        # List on the board to put the card in
        [Parameter(Mandatory=$true)]
        [string]
        $List,

        # Name of the trello card
        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        # Description for the Trello card
        [Parameter(Mandatory=$true)]
        [string]
        $Description
    )

    # make sure the module is installed
    Install-HubotTrelloCard

    $apiToken = @{
        Token = $Token
        AccessKey = $AccessKey
    }

    try
    {
        $boardObject = Get-TrelloBoard -Token $apiToken -All | Where-Object { $_.Name -eq $Board }
        $backlogList = Get-TrelloList -Token $apiToken -Id $boardObject.id | Where-Object { $_.Name -eq $List }
        $newCard = New-TrelloCard -Token $apiToken -Id $backlogList.id -Name $Name -Position "bottom" -Description $Description
        $output = ":+1: New card created - ``$($Name)`` ($($newCard.url))"
    }
    catch
    {
        if ($_.Exception.Message)
        {
            $output = "Error adding Trello Card - ``$($_.Exception.Message)``"
        }
        else
        {
            $output = "Error adding Trello Card. Check your API Token and AccessKey."
        }
    }

    return $output
}

function Get-HubotTrelloBoard
{
    [CmdletBinding()]
    Param
    (
        # Trello token
        [Parameter(Mandatory=$true)]
        [string]
        $Token,

        # Trello access key
        [Parameter(Mandatory=$true)]
        [string]
        $AccessKey
    )

    # make sure the module is installed
    Install-HubotTrelloCard

    $apiToken = @{
        Token = $Token
        AccessKey = $AccessKey
    }

    try
    {
        $boardList = Get-TrelloBoard -Token $apiToken -All

        # build output
        $output = "*Board List*: `n"
        ForEach ($board in $boardList)
        {
            $output += "> Name: ``$($board.Name)`` URL: $($board.Url) `n"
        }
    }
    catch
    {
        if ($_.Exception.Message)
        {
            $output = "Error getting Trello Boards - ``$($_.Exception.Message)``"
        }
        else
        {
            $output = "Error getting Trello Boards. Check your API Token and AccessKey."
        }
    }

    return $output
}
