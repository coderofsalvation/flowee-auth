request      = require './util/requester.coffee'
t            = require './util/tester.coffee'
  
flowee   = require 'flowee'
flowee.verbosity = 2
require('./../index.coffee')(flowee)
model    = require('flowee/test/model.coffee')

t.test 'starting server', (next) ->

  app = flowee.init {model: model, store:true }
    
  app.get '/', (req,res,next) ->
    res.json {foo:true}
    next()

  app.post '/login', (req,res,next) ->
    res.json {loggedin:false}
    next()

  app.get '/protected', (req,res,next) ->
    console.log "ja"
    res.end("you are only able to see this when you're logged in")
    next()
  
  app.post '/auth', (req, res, next) ->
    res.json {title:"congrats! logged in!",code:0, user:req.user} # userfield for debugging reasons only :)
    next()

  # lets make some urls public
  flowee.auth.ignore "/"
  flowee.auth.ignore "/login","get"
  flowee.auth.ignore "/login","post"

  flowee.start (server) ->
    port = process.env.PORT || 1337
    console.log "starting flowee at port %s",port

    server.listen port
    next()

#t.test 'adding user', (next) ->
#  flowee.request "create", 
#    type:'user'
#    payload:
#      name: "John Doe"
#      username: "john"
#      password: "doe"
#      apitoken: (process.env.APITOKEN = "jdjd")
#  .then () ->
#    next()
#
#t.test 'posting to /auth', (next) ->
#  request 'POST', "/auth", {}, () ->
#    next()
#
#t.test 'getting /foo to check session', (next) ->
#  request 'GET', "/foo", {}, () ->
#    next()

t.run()
