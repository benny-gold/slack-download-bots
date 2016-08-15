edge = require("edge")
executePowerShell = edge.func('ps', -> ###
  . .\scripts\Get-SlackMovie.ps1
  Get-SlackMovie -movieSearchString $inputFromJS.movieName
###
)

module.exports = (robot) ->
  robot.respond /download movie (.*)$/i, (msg) ->
    movieName = msg.match[1]
    psObject = {
      movieName: movieName
    }
    callPowerShell = (psObject, msg) ->
      executePowerShell psObject, (error,result) ->
        if error
          msg.send ":fire: An error was thrown in Node.js/CoffeeScript"
          msg.send error
        else
          result = JSON.parse result[0]

          console.log result

          if result.success is true
            msg.send ":thumbsup:  #{result.output}"
          else
            msg.send ":thumbsdown: #{result.output}"
    callPowerShell psObject, msg