( function _Servlet_ss_() {

'use strict';

let Express = null;
let ExpressLogger = null;
let ExpressDir = null;
let _ = wTools;
let Parent = null;
let Self = function wStarterServlet( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Servlet';

// --
// routine
// --

function unform()
{
  let servlet = this;

  _.assert( 0, 'not implemented' );

/*
qqq : implement please
*/

}

//

function form()
{
  let servlet = this;
  let starter = servlet.starter;

  if( starter.servletsMap[ servlet.servePath ] && starter.servletsMap[ servlet.servePath ] !== servlet )
  throw _.err( 'Servlet at ' + servlet.servePath + ' is already launched' );

  starter.servletsMap[ servlet.servePath ] = servlet;

  let parsedServerPath = _.servlet.serverPathParse({ serverPath : servlet.serverPath });
  servlet.serverPath = parsedServerPath.full;
  _.sure( _.numberIsFinite( parsedServerPath.port ), () => 'Expects number {-port-}, but got ' + _.toStrShort( parsedServerPath.port ) );

  /* - */

  if( !servlet.express )
  {
    if( !Express )
    Express = require( 'express' );
    servlet.express = Express();
  }

  let express = servlet.express;

  express.use( ( request, response, next ) => servlet.requestPreHandler({ request, response, next }) );

  if( Config.debug && starter.verbosity )
  {
    if( !ExpressLogger )
    ExpressLogger = require( 'morgan' );
    express.use( ExpressLogger( 'dev' ) );
  }

  express.use( ( request, response, next ) => servlet.requestMidHandler({ request, response, next }) );

  servlet._requsetScriptWrapHandler = servlet.ScriptWrap_functor
  ({
    filterPath : '/',
    rootPath : servlet.rootPath,
    verbosity : servlet.verbosity,
    incudingExts : servlet.incudingExts,
    excludingExts : servlet.excludingExts,
    starterMaker : starter.maker,
  });
  express.use( ( request, response, next ) => servlet._requsetScriptWrapHandler({ request, response, next }) );

  express.use( parsedServerPath.localWebPath, Express.static( _.path.nativize( servlet.rootPath ) ) );

  if( servlet.servingDirs )
  {
    if( !ExpressDir )
    ExpressDir = require( 'serve-index' );
    let directoryOptions =
    {
      'icons' : true,
      'hidden' : true,
    }
    express.use( parsedServerPath.localWebPath, ExpressDir( _.path.nativize( servlet.rootPath ), directoryOptions ) );
  }

  express.use( ( request, response, next ) => servlet.requestPostHandler({ request, response, next }) );

  let o3 = _.servlet.controlExpressStart
  ({
    name : servlet.nickName,
    verbosity : starter.verbosity - 1,
    server : servlet.server,
    express : servlet.express,
    serverPath : servlet.serverPath,
  });

  servlet.server = o3.server;
  servlet.express = o3.express;
  servlet.serverPath = o3.serverPath;

  /* - */

  return servlet;
}

//

function requestPreHandler( o )
{
  let servlet = this;

  _.servlet.controlRequestPreHandle
  ({
    allowCrossDomain : servlet.allowCrossDomain,
    verbosity : servlet.verbosity,
    request : o.request,
    response : o.response,
    next : o.next,
  });

  o.next();
}

//

function requestMidHandler( o )
{
  let servlet = this;

  // debugger;
  // let filePath = _.uri.reroot( servlet.rootPath, o.request.originalUrl );
  // _.assert( _.uri.isLocal( filePath ) );

  o.next();
}

//

function requestPostHandler( o )
{
  let servlet = this;

  _.servlet.controlRequestPostHandle
  ({
    verbosity : servlet.verbosity,
    request : o.request,
    response : o.response,
    next : o.next,
  });

  o.next();
}

//

function _verbosityGet()
{
  let servlet = this;
  if( !servlet.starter )
  return 9;
  return servlet.starter.verbosity;
}

// --
//
// --

function ScriptWrap_functor( gen )
{
  gen = _.routineOptions( ScriptWrap_functor, arguments );

  if( gen.starter === null )
  gen.starter = new _.Starter();

  if( gen.incudingExts === null )
  gen.incudingExts = [ 's', 'js', 'ss' ];

  if( gen.excludingExts === null )
  gen.excludingExts = [ 'raw', 'usefile' ];

  _.assert( _.strDefined( gen.rootPath ) );

  let ware;
  let fileProvider = _.FileProvider.HardDrive({ encoding : 'utf8' });
  function scriptWrap( o )
  {

    _.assertRoutineOptions( scriptWrap, arguments );

    let uri = _.uri.parseFull( o.request.url );
    let exts = _.uri.exts( uri.localWebPath );
    let query = uri.query ? _.strWebQueryParse( uri.query ) : Object.create( null );
    if( query.running === undefined )
    query.running = 1;
    query.running = !!query.running;

    debugger;
    if( uri.localWebPath === '/.starter.raw.js' )
    {
      if( !ware )
      {
        let splits = gen.starterMaker.filesSplitsFor({ platform : 'browser', libraryName : 'browser' });
        debugger;
        ware = splits.prefix + splits.ware + splits.browser + splits.starter + splits.env + '' + splits.externalBefore + splits.entry + splits.externalAfter + splits.postfix;
      }
      o.response.write( ware );
      o.response.end();
      return null;
    }

    if( !_.strBegins( uri.localWebPath, gen.filterPath ) )
    return o.next();

    if( !_.arrayHasAny( gen.incudingExts, exts ) )
    return o.next();

    if( _.arrayHasAny( gen.excludingExts, exts ) )
    return o.next();

    // let uriParsed = _.uri.parse( uri );
    let filePath = _.path.normalize( _.path.reroot( gen.rootPath, uri.longPath ) );
    let shortName = _.strVarNameFor( _.path.fullName( filePath ) );

    // let requestPath = _.uri.reroot( gen.rootPath, o.request.originalUrl );
    // console.log( 'requestPath', requestPath, query.running );

    if( !_.fileProvider.isTerminal( filePath ) )
    return o.next();

    let splits = gen.starterMaker.fileSplitsFor
    ({
      basePath : gen.rootPath,
      filePath : filePath,
      running : query.running,
      platform : 'browser',
    });

    let stream = fileProvider.streamRead
    ({
      filePath : filePath,
      throwing : 0,
    });

    if( !stream )
    return o.next();

    o.response.setHeader( 'Content-Type', 'application/javascript; charset=UTF-8' );

    let state = 0;

    if( gen.verbosity )
    console.log( ' . scriptWrap', uri.localWebPath, 'of', filePath );

    stream.on( 'open', function()
    {
      state = 1;
      o.response.write( splits.prefix1 );
      o.response.write( splits.prefix2 );
    });

    stream.on( 'data', function( d )
    {
      state = 1;
      o.response.write( d );
    });

    stream.on( 'end', function()
    {
      if( state < 2 )
      {
        o.response.write( splits.postfix2 );
        o.response.write( splits.ware );
        o.response.write( splits.postfix1 );
        o.response.end();
      }
      state = 2;
    });

    stream.on( 'error', function( err )
    {
      if( !state )
      {
        o.next();
      }
      else
      {
        err = _.errLogOnce( err );
        o.response.write( err.toString() );
        o.response.end();
      }
      state = 2;
    });

  }

  scriptWrap.defaults =
  {
    request : null,
    response : null,
    next : null,
  }

  return scriptWrap;
}

let defaults = ScriptWrap_functor.defaults = Object.create( null );

defaults.rootPath = null;
defaults.filterPath = '/';
defaults.verbosity = 0;
defaults.incudingExts = null;
defaults.excludingExts = null;
defaults.starterMaker = null;

// --
// relationships
// --

let Composes =
{

  servingDirs : 0,
  serverPath : 'http://127.0.0.1:5000',
  rootPath : null,

  incudingExts : _.define.own([ 's', 'js', 'ss' ]),
  excludingExts : _.define.own([ 'raw', 'usefile' ]),

}

let Associates =
{
  starter : null,
  server : null,
  express : null,
}

let Restricts =
{
  _requsetScriptWrapHandler : null,
}

let Statics =
{
  ScriptWrap_functor,
}

let Accessor =
{
  verbosity : { getter : _verbosityGet, readOnly : 1 }
}

// --
// prototype
// --

let Proto =
{

  unform,
  form,

  requestPreHandler,
  requestMidHandler,
  requestPostHandler,

  _verbosityGet,

  ScriptWrap_functor,

  /* */

  Composes,
  Associates,
  Restricts,
  Statics,
  Accessor,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.staticDeclare
({
  prototype : _.Starter.prototype,
  name : Self.shortName,
  value : Self,
});

})();
