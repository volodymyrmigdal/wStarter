( function _StarterServer_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../Tools.s' );
  var _ = _global_.wTools;
  _.include( 'wFiles' );
  require( './StarterMaker.s' );

}

var _ = wTools;
var Self = _.starter = _.starter || Object.create( null );

// --
// routine
// --

function serverStart()
{
  var self = this;
  var url;

  _.assert( self.Self,'self should be have { Copyable } mixin' );
  _.assert( self.name !== undefined,'self needs field { name }' );
  _.assert( self.port !== undefined,'self needs field { port }' );
  _.assert( self.usingHttps !== undefined,'self needs field { usingHttps }' );
  _.assert( self.allowCrossDomain !== undefined,'self needs field { allowCrossDomain }' );
  _.assert( self.verbosity !== undefined,'self needs field { verbosity }' );
  _.assert( self.server !== undefined,'self needs field { server }' );
  _.assert( self.express !== undefined,'self needs field { express }' );
  _.assert( arguments.length === 0,'Expects none argument' );

  if( !Express )
  Express = require( 'express' );

  if( !self.port )
  return;

  if( !self.express )
  self.express = Express();

  if( self.server )
  return;

  if( self.usingHttps )
  {

    if( !Https )
    Https = require( 'https' );

    url = 'https://127.0.0.1:' + self.port;

    var httpsOptions = self.httpsOptions;
    if( !httpsOptions )
    {
      _.assert( self.certificatePath );

      httpsOptions = {};
      httpsOptions.key = _.fileProvider.fileRead( self.certificatePath + '.rsa' );
      httpsOptions.cert = _.fileProvider.fileRead( self.certificatePath + '.crt' );

    }

    self.server = Https.createServer( httpsOptions, self.express ).listen( self.port );

  }
  else
  {

    if( !Http )
    Http = require( 'http' );

    url = 'http://127.0.0.1:' + self.port;
    self.server = Http.createServer( self.express ).listen( self.port );

  }

  logger.log( self.name, ':', 'express.locals :','\n' + _.toStr( self.express.locals,{ wrap : 0 } ) );
  logger.log( self.name, ':', 'Serving',self.nickName,'on',self.port,'port..','\n' )

  return url;
}

//

function staticRequestHandler_functor( gen )
{
  var gen = _.routineOptions( staticRequestHandler_functor, arguments );

  if( gen.starter === null )
  gen.starter = new _.Starter();

  if( gen.incudingExts === null )
  gen.incudingExts = [ 's', 'js', 'ss' ];

  if( gen.excludingExts === null )
  gen.excludingExts = [ 'raw', 'usefile' ];

  _.assert( _.strDefined( gen.basePath ) );

  var fileProvider = _.FileProvider.HardDrive({ encoding : 'utf8' });
  function staticRequestHandler( request, response, next )
  {

    var url = request.url;
    var exts = _.uri.exts( url );

    if( !_.strBegins( url, gen.filterPath ) )
    return next();

    if( _.arrayHasAny( gen.incudingExts, exts ) )
    response.setHeader( 'Content-Type', 'application/javascript; charset=UTF-8' );
    else
    return next();

    var isExcluded = _.arrayHasAny( gen.excludingExts, exts );

    if( isExcluded )
    return next();

    var urlParsed = _.uri.parse( url );
    var filePath = urlParsed.longPath;
    var dirPath = _.path.dir( filePath );
    var path = _.path.normalize( _.path.reroot( gen.basePath, filePath ) );
    var shortName = _.strVarNameFor( _.path.fullName( filePath ) );

    var fixes = gen.starter.fixesFor
    ({
      filePath : filePath,
    });

    var stream = fileProvider.streamRead
    ({
      filePath : path,
      throwing : 0,
    });

    if( !stream )
    return next();

    var state = 0;

    if( gen.verbosity )
    console.log( '- staticRequestHandler', url, 'at', path );

    stream.on( 'open', function()
    {
      state = 1;
      response.write( fixes.prefix );
    });

    stream.on( 'data', function( d )
    {
      state = 1;
      response.write( d );
    });

    stream.on( 'end', function()
    {
      if( state < 2 )
      {
        response.write( fixes.postfix );
        response.end();
      }
      state = 2;
    });

    stream.on( 'error', function( err )
    {
      if( !state )
      {
        next();
      }
      else
      {
        err = _.errLogOnce( err );
        response.write( err.toString() );
        response.end();
      }
      state = 2;
    });

  }

  return staticRequestHandler;
}

var defaults = staticRequestHandler_functor.defaults = Object.create( null );

defaults.basePath = null;
defaults.filterPath = '/';
defaults.verbosity = 0;
defaults.incudingExts = null;
defaults.excludingExts = null;
defaults.starter = null;

// --
// declare
// --

var Proto =
{

  staticRequestHandler_functor : staticRequestHandler_functor,

}

_.mapExtend( Self, Proto );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
