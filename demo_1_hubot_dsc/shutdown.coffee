# Description:
#   Shuts down or Restarts a PC over WinRM
#
# Commands:
#   hubot shutdown <servername/ip> - Shuts down the specified machine
#   hubot restart <servername/ip> - Restarts the specified machine

module.exports = (robot) ->
  robot.respond /(restart|shutdown) (.*)$/i, (msg) ->
    # Get the regex captures
    console.log "RebootType #{msg.match[1]}"
    rebootType = msg.match[1]
    computerName = msg.match[2]

    # Create shutdown command
    if rebootType == 'restart'
      rebootCommand = 'Restart-Computer'
    else
      rebootCommand = 'Stop-Computer'

    shell = require('node-powershell')

    powershellCmd = "#{rebootCommand} -ComputerName '#{computerName}' -Protocol WSman -Force"

    msg.send "Running Command: ```\n#{powershellCmd}```"

    ps = new shell(
      executionPolicy: 'Bypass'
      debugMsg: true)

    ps.addCommand(powershellCmd).then(->
      ps.invoke()
    ).then((output) ->
      console.log output
      msg.send ":+1: Command Successful"
      msg.send output
      ps.dispose()
      return
    ).catch (err) ->
      console.log err
      msg.send ":shit: that didn't work..."
      msg.send err
      ps.dispose()
      return
