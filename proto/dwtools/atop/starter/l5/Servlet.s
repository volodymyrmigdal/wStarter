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

function instanceOptions( o )
{
  let self = this;

  for( let k in o )
  {
    if( o[ k ] === null && self[ k ] !== null && self[ k ] !== undefined )
    o[ k ] = self[ k ];
  }

  return o;
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
    verbosity : servlet.verbosity-2,
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

  _.routineOptions( htmlForHtml, o );

  if( o.realPath === null )
  o.realPath = _.path.canonize( _.path.reroot( servlet.basePath, o.resourcePath ) );

  let o2 = Object.create( null );
  o2.inPath = false;
  // o2.basePath = servlet.basePath;
  o2.outPath = false;
  o2.templatePath = o.realPath;
  o2.allowedPath = servlet.allowedPath;
  o2.withScripts = servlet.withScripts;

  let html = system.maker.htmlForFiles( o2 );

  if( o.response )
  {
    o.response.setHeader( 'Content-Type', 'text/html; charset=UTF-8' );
    o.response.write( html );
    o.response.end();
  }

  return html;

  // let title = _.path.fullName( o.realPath );
  //
  // servlet.surePathAllowed( o.realPath );
  //
  // let template = _.fileProvider.fileRead( o.realPath );
  // let html = system.maker.htmlFor
  // ({
  //   title,
  //   template,
  // });
  //
  // if( o.response )
  // {
  //   o.response.setHeader( 'Content-Type', 'text/html; charset=UTF-8' );
  //   o.response.write( html );
  //   o.response.end();
  // }
  //
  // return html;
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

  _.routineOptions( htmlForJs, o );

  if( o.realPath === null )
  o.realPath = _.path.canonize( _.path.reroot( servlet.basePath, o.resourcePath ) );

  let o2 = Object.create( null );
  o2.inPath = o.realPath;
  // o2.basePath = servlet.basePath;
  o2.outPath = false;
  o2.templatePath = servlet.templatePath;
  o2.allowedPath = servlet.allowedPath;
  o2.withScripts = servlet.withScripts;

  let html = system.maker.htmlForFiles( o2 );

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

function jsSingleForJs( o )
{
  let servlet = this;
  let system = servlet.system;
  let maker = servlet.maker;

  o = _.routineOptions( jsSingleForJs, arguments );

  try
  {

    let o2 = _.mapOnly( servlet, system.maker.sourcesJoinFiles.defaults );
    o2.entryPath = o.realPath
    o2.inPath = servlet.basePath + '/**';
    o2.basePath = servlet.basePath;
    o2.interpreter = 'browser';
    o2.libraryName = _.path.fullName( o.realPath );
    o2.outPath = null;

    _.assert( _.strDefined( o2.entryPath ) );
    _.assert( _.strDefined( o2.inPath ) );
    _.assert( _.strDefined( o2.basePath ) );

    debugger;
    let data = system.maker.sourcesJoinFiles( o2 );
    debugger;

    if( o.response )
    {
      o.response.write( data );
      o.response.end();
    }

    return data;
  }
  catch( err )
  {
    err = _.err( err );
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

}

jsSingleForJs.defaults =
{
  realPath : null,
  request : null,
  response : null,
}

//

function jsForJs( o )
{
  let servlet = this;
  let system = servlet.system;

  o =_.routineOptions( jsForJs, arguments );

  if( o.realPath === null )
  o.realPath = _.path.canonize( _.path.reroot( servlet.basePath, o.resourcePath ) );

  if( o.withScripts === 'single' )
  return servlet.jsSingleForJs({ realPath, request, response });

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

  if( servlet.verbosity >= 5 )
  console.log( ' . scriptWrap', o.resourcePath, 'of', o.realPath );

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
  withScripts : null,
}

//

function remoteResolve( o )
{
  let servlet = this;
  let resolvedFilePath;

  _.routineOptions( remoteResolve, arguments );

  try
  {

    if( o.realPath === null )
    o.realPath = _.path.reroot( servlet.basePath, _.strRemoveBegin( o.resourcePath, '/.resolve/' ) );

    _.assert( _.strBegins( o.resourcePath, '/.resolve/' ) );

    let basePath = _.path.fromGlob( o.realPath );

    debugger;

    servlet.surePathAllowed( basePath );

    if( _.path.isGlob( o.realPath ) )
    {

      if( !servlet.resolvingGlob )
      {
        let err = _.err( `Field {- servlet.resolvingGlob -} is off` );
        throw err;
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

      debugger;
      resolvedFilePath = [ o.realPath ];
      resolvedFilePath.forEach( ( p ) => servlet.surePathAllowed( p ) );
      resolvedFilePath = resolvedFilePath.map( ( p ) => _.path.join( '/', _.path.relative( servlet.basePath, p ) ) );
      debugger;

      if( !servlet.resolvingNpm )
      {
        let err = _.err( `Field {- servlet.resolvingNpm -} is off` );
        debugger;
        throw err;
      }

      debugger;
    }

    if( o.response )
    o.response.json( resolvedFilePath );

  }
  catch( err )
  {
    err = _.err( err, `\nFailed to resolve ${o.realPath}` );
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
    let o2 = _.mapOnly( servlet, system.maker.sourcesJoinSplits.defaults );
    o2.interpreter = 'browser';
    o2.libraryName = 'Starter';
    let splits = system.maker.sourcesJoinSplits( o2 );
    fop.ware = system.maker.sourcesSplitsJoin( splits );
  }

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

    if( servlet.loggingRequests )
    logger.log( ` . request ${_.ct.format( _.uri.str( o.uri ), 'path' )} ` );

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

    o.realPath = _.path.canonize( _.path.reroot( servlet.basePath, o.uri.longPath ) );
    o.shortName = _.strVarNameFor( _.path.fullName( o.realPath ) );

    if( o.query.withScripts === 'single' )
    {
      return servlet.jsSingleForJs
      ({
        realPath : o.realPath,
        response : o.response,
        request : o.request,
      });
    }

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

// --
// relations
// --

let Composes =
{

  servingDirs : 0,
  loggingApplication : 1,
  loggingConnection : 0,
  loggingRequests : 0,
  proceduring : 0,
  catchingUncaughtErrors : 1,
  naking : 0,
  withScripts : 'include',

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
  system : null, /* xxx : remove? */
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

let Accessors =
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
  instanceOptions,
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
  jsSingleForJs,
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
  Accessors,

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
