module.exports = ( (flowee) ->

  flowee.auth    = me = {}
  me.public_urls = {}
  me.ignore      = (url,method) -> 
    me.public_urls[url] = {methods:{}} if not me.public_urls[url]?
    me.public_urls[url].methods[ ( if method? then method else "get" ) ] = true 

  me.shouldignore = (url,method) ->
    if flowee.auth.public_urls[url]? and flowee.auth.public_urls[url].methods[method.toLowerCase()]?
      return true
    else return false

  flowee.on 'start', (flowee) ->
    for path,methods of flowee.model.paths
      for method,resource of methods
        me.ignore path,method if resource.public? and resource.public
    console.log "public urls: "+ JSON.stringify(me.public_urls,null,2) if flowee.verbosity > 1

  me.getuser = (opts,cb) ->
    if opts?
      console.log "requesting user with args: "+JSON.stringify(opts) if flowee.verbosity > 1
      flowee.request "find", { type:"user", payload: opts }
      .then (result) -> 
        console.dir result if flowee.verbosity > 1
        return cb ( if result.payload?.length then result.payload[0] else undefined )
      .catch () -> cb()
    else return cb()

  try
    require('./src/passport.strategy.apitoken')(flowee)
  catch e
    console.warn "flowee-auth: use 'npm install passport passport-accesstoken' for POST form authentication"

  try
    require('./src/passport.strategy.local')(flowee)
  catch e
    console.warn "flowee-auth: use 'npm install express-session body-parser passport passport-local' for POST form authentication"

  me

).bind({})
