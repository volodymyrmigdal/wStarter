( function _Servlet_ss_() {

'use strict';

let Express = null;
let ExpressLogger = null;
let ExpressDir = null;
let Querystring = null;
let _ = _global_.wTools;
let Parent = null;
let Self = function wStarterServlet( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Servlet';

// --
// routine
// --

function finit()
{
  let servlet = this;
  let system = servlet.system;

  servlet.unform();

  return _.Copyable.prototype.finit.call( servlet );
}

//

function unform()
{
  let servlet = this;
  let system = servlet.system;

  if( !servlet.formed )
  return;

  _.arrayRemoveOnceStrictly( system.servletsArray, servlet );

  if( servlet.serverPath )
  {
    _.assert
    (
      system.servletsMap[ servlet.serverPath ] === servlet,
      `Found no servlet::${servlet.serverPath}`
    );
    delete system.servletsMap[ servlet.serverPath ];
  }

  if( servlet.loggerSocket )
  {
    servlet.loggerSocket.finit();
    servlet.loggerSocket = null;
  }

  if( servlet.httpServer )
  {
    if( servlet.owningHttpServer )
    servlet.httpServer.close();
    servlet.httpServer = null;
  }

  servlet.formed = 0;
}

//

function form()
{
  let servlet = this;
  let system = servlet.system;

  if( servlet.system === null )
  system = servlet.system = new _.starter.System();

  _.assert( system instanceof _.starter.System );

  _.arrayAppendOnceStrictly( system.servletsArray, servlet );
  servlet.formed = 1;

  // let o2 = _.mapOnly( servlet, servlet.scriptWrap_functor.defaults );
  // o2.starterMaker = servlet.system.maker;
  // servlet._requestScriptWrapHandler = servlet.scriptWrap_functor( o2 );
  servlet._requestScriptWrapHandler = servlet.scriptWrap_functor();

  if( servlet.serverPath )
  servlet.serverForm();

  if( servlet.serverPath && servlet.loggingApplication )
  servlet.serverLoggingForm();

  return servlet;
}

//

function serverForm()
{
  let servlet = this;
  let system = servlet.system;

  _.assert( _.routineIs( servlet._requestScriptWrapHandler ) );

  _.assert
  (
    !system.servletsMap[ servlet.serverPath ] || system.servletsMap[ servlet.serverPath ] === servlet,
    `Servlet at ${servlet.serverPath} is already launched`
  );
  system.servletsMap[ servlet.serverPath ] = servlet;

  let parsedServerPath = _.servlet.serverPathParse({ full : servlet.serverPath });
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

  if( Config.debug && servlet.loggingConnection )
  {
    if( !ExpressLogger )
    ExpressLogger = require( 'morgan' );
    express.use( ExpressLogger( 'dev' ) );
  }

  express.use( ( request, response, next ) => servlet.requestMidHandler({ request, response, next }) );

  // let o2 = _.mapOnly( servlet, servlet.scriptWrap_functor.defaults );
  // o2.starterMaker = servlet.system.maker;
  // servlet._requestScriptWrapHandler = servlet.scriptWrap_functor( o2 );
  // servlet._requestScriptWrapHandler = servlet.scriptWrap_functor();
  express.use( ( request, response, next ) => servlet._requestScriptWrapHandler({ request, response, next }) );

  express.use( parsedServerPath.resourcePath, Express.static( _.path.nativize( servlet.basePath ) ) );

  if( servlet.servingDirs )
  {
    if( !ExpressDir )
    ExpressDir = require( 'serve-index' );
    let directoryOptions =
    {
      'icons' : true,
      'hidden' : true,
    }
    express.use( parsedServerPath.resourcePath, ExpressDir( _.path.nativize( servlet.basePath ), directoryOptions ) );
  }

  express.use( ( request, response, next ) => servlet.requestPostHandler({ request, response, next }) );
  express.use( ( error, request, response, next ) => servlet.requestErrorHandler({ error, request, response, next }) );

  let o3 = _.servlet.controlExpressStart
  ({
    name : servlet.qualifiedName,
    verbosity : servlet.loggingApplication ? 0 : system.verbosity - 1, /* xxx : use servlet.verbosity? */
    server : servlet.httpServer,
    express : servlet.express,
    serverPath : servlet.serverPath,
  });

  servlet.httpServer = o3.server;
  servlet.express = o3.express;
  servlet.serverPath = o3.serverPath;

  /* - */

  return servlet;
}

//

function serverLoggingForm()
{
  let servlet = this;

  _.assert( _.strDefined( servlet.serverPath ) );
  _.assert( !!servlet.httpServer );

  _.assert( servlet.loggerSocket === null );
  let loggerServerPath = _.uri.join( servlet.serverPath, '.log/' );
  loggerServerPath = _.uri.parseAtomic( loggerServerPath );
  loggerServerPath.protocol = 'ws';
  delete loggerServerPath.protocols;
  loggerServerPath = _.uri.str( loggerServerPath );
  servlet.loggerSocket = _.LoggerSocketReceiver
  ({
    httpServer : servlet.httpServer,
    owningHttpServer : 0,
    serverPath : loggerServerPath,
  });
  servlet.loggerSocket.form();
  servlet.loggerSocket.outputTo( logger );

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

function requestErrorHandler( o )
{
  debugger;
  if( o.response.headersSent )
  return o.next( o.error );
  o.error = _.err( o.error );

  _.errLogOnce( o.error )

  o.response.status( 500 );
  o.response.send( o.error.message );
  // o.response.write( o.error.message );
  // o.response.end();
  // o.response.render( 'error', { error : o.error } );
}

//

function _verbosityGet()
{
  let servlet = this;
  if( !servlet.system )
  return 9;
  return servlet.system.verbosity;
}

//

function openUriGet()
{
  let servlet = this;

  let parsedServerPath = _.uri.parseAtomic({ full : servlet.serverPath });

  if( parsedServerPath.host === '0.0.0.0' )
  parsedServerPath.host = '127.0.0.1';

  return _.uri.str( parsedServerPath );
}

//

function htmlForHtml( o )
{
  let servlet = this;
  let system = servlet.system;
  // let resourcePath = o.uri.resourcePath;
  // let resourcePath = o.resourcePath;

  _.routineOptions( htmlForHtml, o );

  if( o.realPath === null )
  o.realPath = _.path.reroot( servlet.basePath, o.resourcePath );

  let title = _.path.fullName( o.realPath );

  servlet.surePathAllowed( o.realPath );

  let template = _.fileProvider.fileRead( o.realPath );
  let html = system.maker.htmlFor
  ({
    title,
    template,
  });

  if( o.response )
  {
    o.response.setHeader( 'Content-Type', 'text/html; charset=UTF-8' );
    o.response.write( html );
    o.response.end();
  }

  return html;
}

htmlForHtml.defaults =
{
  resourcePath : null,
  realPath : null,
  response : null,
  next : null,
}

//

function htmlForJs( o )
{
  let servlet = this;
  let system = servlet.system;

  if( o.realPath === null )
  o.realPath = _.path.reroot( servlet.basePath, o.resourcePath );

  _.routineOptions( htmlForJs, o );

  let filter = { filePath : _.path.detrail( o.realPath ), basePath : servlet.basePath };
  let resolvedFilePath = _.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
    withDirs : 0,
    withDefunct : 0,
    withStem : 1
  });

  if( !resolvedFilePath.length )
  {
    let err = _.err( `Found no ${o.resourcePath || o.realPath}` );
    if( o.request && o.response )
    {
      return _.servlet.errorHandle
      ({
        request : o.request,
        response : o.response,
        err : err,
      });
    }
    else
    {
      throw err;
    }
  }

  let srcScriptsMap = Object.create( null );
  resolvedFilePath.forEach( ( p ) => servlet.surePathAllowed( p.absolute ) );
  resolvedFilePath.forEach( ( p ) =>
  {
    srcScriptsMap[ _.path.join( '/', p.relative ) ] = _.fileProvider.fileRead( p.absolute );
  });
  let title = _.path.fullName( resolvedFilePath[ 0 ].absolute );

  let template = null;
  if( servlet.templatePath )
  template = _.fileProvider.fileRead( servlet.templatePath );

  let html = system.maker.htmlFor
  ({
    srcScriptsMap,
    title,
    template
  });

  if( o.response )
  {
    o.response.setHeader( 'Content-Type', 'text/html; charset=UTF-8' );
    o.response.write( html );
    o.response.end();
  }

  return html;
}

htmlForJs.defaults =
{
  resourcePath : null,
  realPath : null,
  request : null,
  response : null,
  next : null,
}

//

function jsForJs( o )
{
  let servlet = this;
  let system = servlet.system;

  _.routineOptions( jsForJs, arguments );

  if( o.realPath === null )
  o.realPath = _.path.reroot( servlet.basePath, o.resourcePath );

  let splits = system.maker.sourceWrapSplits
  ({
    basePath : servlet.basePath,
    filePath : o.realPath,
    running : o.query.running,
    interpreter : 'browser',
  });

  let stream = _.fileProvider.streamRead
  ({
    filePath : o.realPath,
    throwing : 0,
  });

  if( !stream )
  return o.next();

  o.response.setHeader( 'Content-Type', 'application/javascript; charset=UTF-8' );

  let state = 0;

  debugger;
  if( servlet.verbosity )
  console.log( ' . scriptWrap', o.uri.resourcePath, 'of', o.realPath );

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
    return _.servlet.errorHandle
    ({
      err : err,
      request : o.request,
      response : o.response,
    });
    state = 2;
  });

}

jsForJs.defaults =
{
  resourcePath : null,
  realPath : null,
  query : null,
  request : null,
  response : null,
  next : null,
}

//

function remoteResolve( o )
{
  let servlet = this;
  // let filePath = _.strRemoveBegin( o.uri.resourcePath, '/.resolve/' );
  // filePath = _.path.reroot( servlet.basePath, filePath );

  _.routineOptions( remoteResolve, arguments );

  if( o.realPath === null )
  o.realPath = _.path.reroot( servlet.basePath, _.strRemoveBegin( o.resourcePath, '/.resolve/' ) );

  _.assert( _.strBegins( o.resourcePath, '/.resolve/' ) );

  let basePath = _.path.fromGlob( o.realPath );

  debugger;
  servlet.surePathAllowed( basePath );

  let resolvedFilePath = [];
  if( _.path.isGlob( o.realPath ) )
  {

    if( !servlet.resolvingGlob )
    {
      let err = _.err( `Cant resolve ${o.realPath} because {- servlet.resolvingGlob -} is off` );
      if( o.request && o.response )
      {
        return _.servlet.errorHandle
        ({
          request : o.request,
          response : o.response,
          err : err,
        });
      }
      else
      {
        throw err;
      }
    }

    let filter = { filePath : o.realPath, basePath : servlet.basePath };
    resolvedFilePath = _.fileProvider.filesFind
    ({
      filter,
      mode : 'distinct',
      mandatory : 0,
      withDirs : 0,
    });

    resolvedFilePath.forEach( ( p ) => servlet.surePathAllowed( p.absolute ) );
    resolvedFilePath = resolvedFilePath.map( ( p ) => _.path.join( '/', p.relative ) );

  }
  else
  {

    if( !servlet.resolvingNpm )
    {
      let err = _.err( `Cant resolve ${o.realPath} because {- servlet.resolvingNpm -} is off` );
      if( o.request && o.response )
      {
        return _.servlet.errorHandle
        ({
          request : o.request,
          response : o.response,
          err : err,
        });
      }
      else
      {
        throw err;
      }
    }

    debugger;
  }

  if( o.response )
  o.response.json( resolvedFilePath );

  return resolvedFilePath;
}

remoteResolve.defaults =
{
  resourcePath : null,
  realPath : null,
  request : null,
  response : null,
}

//

function starterWareReturn( o )
{
  let servlet = this;
  o.response.setHeader( 'Content-Type', 'application/javascript; charset=UTF-8' );
  o.response.write( o.fop.ware );
  o.response.end();
  return null;
}

//

function surePathAllowed( filePath )
{
  let servlet = this;
  _.all( filePath, ( p ) =>
  {
    _.sure( _.path.begins( p, servlet.allowedPath ), () => `Path ${p} is beyond allowed path ${servlet.allowedPath}` );
  });
}

// --
//
// --

function scriptWrap_functor( fop )
{
  let servlet = this;
  let system = servlet.system;

  fop = _.routineOptions( scriptWrap_functor, arguments );

  // if( servlet.system === null )
  // servlet.system = new _.starter.System();
  //
  // if( servlet.incudingExts === null )
  // servlet.incudingExts = [ 's', 'js', 'ss' ];
  //
  // if( servlet.excludingExts === null )
  // servlet.excludingExts = [ 'raw', 'usefile' ];

  _.assert( servlet instanceof _.starter.Servlet );
  _.assert( system instanceof _.starter.System );
  _.assert( system.maker instanceof _.starter.Maker );
  _.assert( _.strDefined( servlet.basePath ) );
  _.assert( _.strDefined( servlet.allowedPath ) );
  _.assert( _.arrayIs( servlet.incudingExts ) );
  _.assert( _.arrayIs( servlet.excludingExts ) );

  if( !Querystring )
  Querystring = require( 'querystring' );

  if( !fop.ware )
  {
    let splits = system.maker.sourcesJoinSplits
    ({
      interpreter : 'browser',
      libraryName : 'Application',
      proceduring : servlet.proceduring,
      loggingApplication : servlet.loggingApplication,
    });
    fop.ware = system.maker.librarySplitsJoin( splits );
  }

  // let fileProvider = _.FileProvider.HardDrive({ encoding : 'utf8' });

  scriptWrap.defaults =
  {
    request : null,
    response : null,
    next : null,
  }

  return scriptWrap;

  function _scriptWrap( o )
  {

    _.assertRoutineOptions( scriptWrap, arguments );

    o.fop = fop;
    o.request.url = Querystring.unescape( o.request.url );
    o.uri = _.uri.parseFull( o.request.url );
    o.exts = _.uri.exts( o.uri.resourcePath );
    o.query = o.uri.query ? _.strWebQueryParse( o.uri.query ) : Object.create( null );

    o.query.entry = !!o.query.entry;
    if( o.query.running === undefined )
    o.query.running = 1;
    o.query.running = !!o.query.running;

    debugger;

    if( o.uri.resourcePath === '/.starter' )
    {
      return servlet.starterWareReturn( o );
    }
    else if( _.strBegins( o.uri.resourcePath, '/.resolve/' ) )
    {
      return servlet.remoteResolve
      ({
        resourcePath : o.uri.resourcePath,
        realPath : o.realPath,
        response : o.response,
        request : o.request,
      });
    }

    o.realPath = _.path.normalize( _.path.reroot( servlet.basePath, o.uri.longPath ) );
    o.shortName = _.strVarNameFor( _.path.fullName( o.realPath ) );

    if( o.query.entry )
    {
      if( o.query.format === 'html' )
      return servlet.htmlForHtml
      ({
        resourcePath : o.uri.resourcePath,
        realPath : o.realPath,
        response : o.response,
        next : o.next,
      });
      else
      return servlet.htmlForJs
      ({
        resourcePath : o.uri.resourcePath,
        realPath : o.realPath,
        response : o.response,
        request : o.request,
        next : o.next,
      });
    }

    o.realPath = _.path.normalize( _.path.reroot( servlet.basePath, o.uri.longPath ) );
    o.shortName = _.strVarNameFor( _.path.fullName( o.realPath ) );

    if( _.longHasAny( servlet.excludingExts, o.exts ) )
    return o.next();

    if( !_.fileProvider.isTerminal( o.realPath ) )
    return o.next();

    if( _.longHasAny( o.exts, [ 'html', 'htm' ] ) )
    return servlet.htmlForHtml
    ({
      resourcePath : o.uri.resourcePath,
      realPath : o.realPath,
      response : o.response,
      next : o.next,
    });

    if( servlet.naking )
    return o.next();

    if( !_.longHasAny( servlet.incudingExts, o.exts ) )
    return o.next();

    servlet.surePathAllowed( o.realPath );

    return servlet.jsForJs
    ({
      resourcePath : o.uri.resourcePath,
      realPath : o.realPath,
      query : o.query,
      response : o.response,
      request : o.request,
    });
  }

  /* - */

  function scriptWrap( o )
  {
    try
    {
      return _scriptWrap.apply( this, arguments );
    }
    catch( err )
    {
      throw _.err( err );
    }
  }

}

var defaults = scriptWrap_functor.defaults = Object.create( null );

// defaults.system = null;
// defaults.servlet = null;

// defaults.basePath = null;
// defaults.allowedPath = '/';
// defaults.verbosity = 0;
// defaults.incudingExts = null;
// defaults.excludingExts = null;
// defaults.starterMaker = null;
// defaults.templatePath = null;
//
// defaults.resolvingGlob = 1;
// defaults.resolvingNpm = 1;
// defaults.proceduring = 0;
// defaults.loggingApplication = 0;

//

function ScriptWrap_functor( o )
{
  o = _.routineOptions( ScriptWrap_functor, arguments );

  if( o.servlet === null )
  {
    delete o.servlet;
    o.servlet = new _.Servlet( o );
  }

  let result = o.servlet.scriptWrap_functor();

  return result;
}

var defaults = ScriptWrap_functor.defaults = Object.create( null );

defaults.servlet = null;
defaults.system = null;
defaults.basePath = null;
defaults.allowedPath = '/';
defaults.verbosity = 0;
defaults.incudingExts = null;
defaults.excludingExts = null;
defaults.templatePath = null;
defaults.resolvingGlob = 1;
defaults.resolvingNpm = 1;
defaults.proceduring = 0;
defaults.loggingApplication = 0;

// defaults.starterMaker = null;

// --
// relations
// --

let Composes =
{

  servingDirs : 0,
  loggingApplication : 1,
  loggingConnection : 0,
  proceduring : 0,
  catchingUncaughtErrors : 1,
  naking : 0,

  resolvingGlob : 1,
  resolvingNpm : 1,

  owningHttpServer : 1,

  serverPath : 'http://127.0.0.1:15000',
  // serverPath : 'http://0.0.0.0:15000',
  basePath : null,
  allowedPath : '/',
  templatePath : null,

  incudingExts : _.define.own([ 's', 'js', 'ss' ]),
  excludingExts : _.define.own([ 'raw', 'usefile' ]),

}

let Associates =
{
  system : null,
  httpServer : null,
  express : null,
  loggerSocket : null,
}

let Restricts =
{
  formed : 0,
  _requestScriptWrapHandler : null,
}

let Statics =
{
  ScriptWrap_functor,
}

let Accessor =
{
  verbosity : { getter : _verbosityGet, readOnly : 1 },
}

let Forbids =
{
  server : 'server',
}

// --
// prototype
// --

let Proto =
{

  finit,
  unform,
  form,
  serverForm,
  serverLoggingForm,

  requestPreHandler,
  requestMidHandler,
  requestPostHandler,
  requestErrorHandler,

  _verbosityGet,
  openUriGet,

  htmlForHtml,
  htmlForJs,
  jsForJs,
  remoteResolve,
  starterWareReturn,
  surePathAllowed,

  scriptWrap_functor,
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

_.starter[ Self.shortName ] = Self;

})();
