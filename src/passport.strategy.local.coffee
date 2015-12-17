LocalStrategy = require('passport-local').Strategy
passport      = require 'passport'
bodyParser    = require 'body-parser'

module.exports = ( (flowee) ->
  ##
  # Local strategy (auth using POST formvalues 'email' + 'passwd' )
  ##

  passport.use new LocalStrategy
    usernameField: 'login'
    passwordField: 'passwd'
    , ( username, password, done ) ->
      flowee.auth.getuser {username:username,password:password}, (user) ->
        return done new Error("invalid credentials..sorry :/") if not user
        done null, user

  passport.serializeUser (user, done) ->
    console.log "serialize user"
    done null, user.id
    return

  passport.deserializeUser (id, done) ->
    console.log "deserialize userid "+id
    flowee.auth.getuser {id:id}, (user) ->
      console.dir {"user is":user}
      return done null, user if user
      done new Error("user not found")

  flowee.use bodyParser.urlencoded({ extended: false })
  flowee.use require('express-session')
    secret: 'keyboard cat'
    cookie: { secure: false, maxAge: 6000, httpOnly:false }
    resave: false
    saveUninitialized: true

  flowee.use passport.initialize()
  flowee.use passport.session()
  
  # middleware
  flowee.use (req,res,next) ->
    console.log "middleware:passport-local "+JSON.stringify(req.session) if flowee.verbosity > 1
    # bypass authentication for public urls 
    return next() if flowee.auth.shouldignore( req.url, req.method )
    (passport.authenticate 'local', {failureRedirect: '/login'}, (rs,rq) -> next() )(req,res,next)

).bind({})
