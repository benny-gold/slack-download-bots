edge = require("edge")
executePowerShell = edge.func('ps', -> ###
  . .\scripts\Get-SlackTV.ps1
  Get-SlackTV -tvSearchString $inputFromJS.tvName
###
)

module.exports = (robot) ->
  robot.respond /download tv (.*)$/i, (msg) ->
    tvName = msg.match[1]
    psObject = {
      tvName: tvName
    }
    callPowerShell = (psObject, msg) ->
      executePowerShell psObject, (error,result) ->
        if error
          msg.send ":fire: An error was thrown in Node.js/CoffeeScript"
          msg.send error
        else
          console.log result
          result = JSON.parse result[0]

          console.log result

          if result.success is true
            msg.send ":thumbsup:  #{result.output}"
          else
            msg.send ":thumbsdown: #{result.output}"
    callPowerShell psObject, msg