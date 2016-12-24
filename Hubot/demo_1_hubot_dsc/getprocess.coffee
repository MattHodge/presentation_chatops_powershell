# Description:
#   Get's a process on the local machine
#
# Commands:
#   hubot get process <process name> - Gets a process on the local machine

module.exports = (robot) ->
  robot.respond /get process (.*)$/i, (msg) ->
    processName = msg.match[1]

    exec = require('child_process').exec
    exec "powershell -command \"& { Get-Process -Name #{processName} }\"", (error, stdout, stderr) ->
      if stdout
        msg.send stdout
      else
        msg.send error
        msg.send stderr
