TokenStrategy = require('passport-accesstoken').Strategy
passport = require 'passport' 

module.exports = ( (flowee) ->
  ##
  # Local strategy (auth using POST formvalues 'email' + 'passwd' )
  ##

  passport.use new TokenStrategy
    tokenHeader: 'x-custom-token'
    tokenField:  'custom-token'
  , ( apitoken, done ) ->
    flowee.auth.getuser {apitoken:apitoken}, (user) ->
      return done new Error("invalid apitoken..sorry :/") if not user
      done null, user


  # API Token auth middleware
  flowee.use (req,res,next) -> 
    console.log "middleware:passport-apitoken" if flowee.verbosity > 1
    isjson = String(req.headers['content-type']).match /^application.*json/
    # bypass authentication for public urls 
    return next() if flowee.auth.shouldignore( req.url, req.method ) or not isjson
    (passport.authenticate 'token')(req,res,next) 
 
).bind({})
