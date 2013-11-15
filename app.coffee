express = require("express")
cors = require("cors")
app = express()
app.use express.logger()
app.use cors()
app.use express.bodyParser()

app.get "/", (request, response) ->
  response.send "CRM node"

app.get "/customers", (request, response) ->
  response.send []

port = process.env.PORT or 5000
app.listen port, ->
  console.log "Listening on " + port

exports.app = app
