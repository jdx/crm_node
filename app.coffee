_ = require("underscore")
express = require("express")
cors = require("cors")
mongo = require('mongodb')
ObjectId = require('mongodb').ObjectID
app = express()
app.use express.logger()
app.use cors()
app.use express.bodyParser()

collection = null

mongoUri = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://localhost/crm'
mongo.Db.connect mongoUri, (err, db) ->
  db.collection 'customers', (er, c) ->
    collection = c

app.get "/", (request, response) ->
  response.send "CRM node"

app.get "/api/v1/customers.json", (request, response) ->
  collection.find().toArray (err, customers) ->
    customers = _.map customers, (c) ->
      id: c._id
      name: c.name
      phone: c.phone
    response.send customers

app.put "/api/v1/customers/:id.json", (request, response) ->
  id = request.params.id
  doc = 
    _id: ObjectId(id)
    name: request.body.name
    phone: request.body.phone
  collection.save doc, (err) ->
    response.send 200

app.post "/api/v1/customers.json", (request, response) ->
  cmd = 
    name: request.body.name
    phone: request.body.phone
  collection.insert cmd, (err) ->
    response.send 200

port = process.env.PORT or 5000
app.listen port, ->
  console.log "Listening on " + port

exports.app = app
