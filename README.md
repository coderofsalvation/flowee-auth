Helper / Example extension for flowee (passport) authentication (incl. local- and apitoken passport examples)

<img alt='' src='https://travis-ci.org/coderofsalvation/flowee-auth.svg'/>

## Usage

Assuming you already have your [flowee](https://npmjs.org/flowee) api running/installed:

    npm install flowee-auth

## Optional: REST Apitoken authentication using [passport-accesstoken](https://npmjs.org/passport-accesstoken)

    npm install passport passport-accesstoken

## Optional: local POST authentication with session [passport-local](https://npmjs.org/passport-local)
    
    npm install express-session body-parser passport passport-local

## Usage

You can install the apitoken, local (or both) as shown above, and you've got 2 ways of authentication out of the box!

> All restpoints are now secured, except when they have `public:true`

    '/model':
      'get':
        public: true                    <------ set this to false if you want to secure this with authentication 

Also, you can turn endpoints into public ones at runtime:

    flowee.auth.ignore "/foo", "get"

## Other/Custom passport strategies 

However, this module is also handy to use for extra [passport](https://npmjs.org/passport) strategies, because it exposes
the `flowee.auth.getuser` function.

#### `flowee.auth.getuser` can be used with passsport strategies:

    flowee.auth.getuser({id:"444"}, function(user){  } );
    flowee.auth.getuser({username:"john",password:"doe"}, function(user){  } );

If you look at the README.md files of random passport-strategies, you know exactly where to use this function.
