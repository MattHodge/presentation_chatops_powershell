  # Description:
#   Script to work with Trello
#
# Commands:
#   hubot trello boards - Lists the trello boards
#   hubot trello add <card name> | card description  - Adds trello card to the DemoBoard board

# run powershell function
runPScommand = (command,returnPrefix, msg) ->
  exec = require('child_process').exec
  path = require('path');

  # find path of trello script
  fullPathToTrelloScript = path.resolve(__dirname, 'Trello.ps1')

  # dot source the script then execute the PS Command
  fullExecCmd = "powershell -command \"& { . #{fullPathToTrelloScript} ; #{command} }\""
  console.log "Running: #{fullExecCmd}"
  exec fullExecCmd, (error, stdout, stderr) ->
    if error
      console.error "exec error: #{error}"
      msg.send "*ERROR* ```#{error}```"
    if stderr
      console.log "std err #{stderr}"
      msg.send "*STDERR* ```#{stderr}```"
    if stdout
      console.log "stdout #{stdout}"
      msg.send "#{stdout}"

module.exports = (robot) ->
  robot.respond /trello boards$/i, (msg) ->
    # environment variable needs to be set
    unless process.env.TRELLO_TOKEN and process.env.TRELLO_ACCESS_KEY
      msg.send "Please set the `TRELLO_TOKEN` and `TRELLO_ACCESS_KEY` environment variable."
      return

    runPScommand(
      "Get-HubotTrelloBoard -Token #{process.env.TRELLO_TOKEN} -AccessKey #{process.env.TRELLO_ACCESS_KEY}"
      "", # not using return prefix - PowerShell script will format the text.
      msg
    )

  robot.respond /trello add (.*) \| (.*)/i, (msg) ->
    # environment variable needs to be set
    unless process.env.TRELLO_TOKEN and process.env.TRELLO_ACCESS_KEY
      msg.send "Please set the `TRELLO_TOKEN` and `TRELLO_ACCESS_KEY` environment variable."
      return

    console.log "Card Name #{msg.match[1]}"
    cardName = msg.match[1]
    console.log "Card details #{msg.match[2]}"
    cardDetails = msg.match[2]

    runPScommand(
      "New-HubotTrelloCard -Token #{process.env.TRELLO_TOKEN} -AccessKey #{process.env.TRELLO_ACCESS_KEY} -Board 'DemoBoard' -List 'Backlog' -Name '#{cardName}' -Description '#{cardDetails}'"
      "", # not using return prefix - PowerShell script will format the text.
      msg
    )
