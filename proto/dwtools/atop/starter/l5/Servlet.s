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
  if( system )
  {
    _.assert
    (
      system.servletsMap[ servlet.serverPath ] === servlet,
      `Servlet at ${servlet.serverPath} is already launched`
    );
    delete system.servletsMap[ servlet.serverPath ];
  }

  return _.Copyable.prototype.finit.call( servlet );
}

//

function unform()
{
  let servlet = this;
  let system = servlet.system;

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

}

//

function form()
{
  let servlet = this;
  let system = servlet.system;

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

  // if( Config.debug && system.verbosity )
  if( Config.debug && servlet.loggingConnection )
  {
    if( !ExpressLogger )
    ExpressLogger = require( 'morgan' );
    express.use( ExpressLogger( 'dev' ) );
  }

  express.use( ( request, response, next ) => servlet.requestMidHandler({ request, response, next }) );

  servlet._requestScriptWrapHandler = servlet.ScriptWrap_functor
  ({
    basePath : servlet.basePath,
    allowedPath : servlet.allowedPath,
    verbosity : servlet.verbosity,
    incudingExts : servlet.incudingExts,
    excludingExts : servlet.excludingExts,
    starterMaker : system.maker,
    templatePath : servlet.templatePath
  });
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

  if( servlet.loggingApplication )
  {
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
  // let filePath = _.uri.reroot( servlet.basePath, o.request.originalUrl );
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

function openPathGet()
{
  let servlet = this;

  let parsedServerPath = _.uri.parseAtomic({ full : servlet.serverPath });

  if( parsedServerPath.host === '0.0.0.0' )
  parsedServerPath.host = '127.0.0.1';

  return _.uri.str( parsedServerPath );
}

// --
//
// --

function ScriptWrap_functor( fop )
{
  fop = _.routineOptions( ScriptWrap_functor, arguments );

  if( fop.system === null )
  fop.system = new _.starter.System();

  if( fop.incudingExts === null )
  fop.incudingExts = [ 's', 'js', 'ss' ];

  if( fop.excludingExts === null )
  fop.excludingExts = [ 'raw', 'usefile' ];

  _.assert( _.strDefined( fop.basePath ) );
  _.assert( _.strDefined( fop.allowedPath ) );

  if( !Querystring )
  Querystring = require( 'querystring' );

  let ware;

  if( !ware )
  {
    let splits = fop.starterMaker.sourcesJoinSplits
    ({
      interpreter : 'browser',
      libraryName : 'Application',
      proceduresWatching : 1,
    });
    ware = splits.prefix + splits.ware + splits.interpreter + splits.starter + splits.env + '' + splits.externalBefore + splits.entry + splits.externalAfter + splits.postfix;
  }

  let fileProvider = _.FileProvider.HardDrive({ encoding : 'utf8' });

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

    o.request.url = Querystring.unescape( o.request.url );

    let uri = _.uri.parseFull( o.request.url );
    let exts = _.uri.exts( uri.resourcePath );
    let query = uri.query ? _.strWebQueryParse( uri.query ) : Object.create( null );

    query.entry = !!query.entry;
    if( query.running === undefined )
    query.running = 1;
    // if( query.running === undefined && !query.entry )
    // query.running = 1;
    // else
    // query.running = 0;
    query.running = !!query.running;

    if( uri.resourcePath === '/.starter' )
    {
      return starterWareReturn();
    }
    else if( _.strBegins( uri.resourcePath, '/.resolve/' ) )
    {
      return remoteResolve();
    }
    else if( query.entry )
    {
      return htmlGenerate();
    }

    if( !_.longHasAny( fop.incudingExts, exts ) )
    return o.next();

    if( _.longHasAny( fop.excludingExts, exts ) )
    return o.next();

    let filePath = _.path.normalize( _.path.reroot( fop.basePath, uri.longPath ) );
    let shortName = _.strVarNameFor( _.path.fullName( filePath ) );

    surePathAllowed( filePath );

    if( !_.fileProvider.isTerminal( filePath ) )
    return o.next();

    let splits = fop.starterMaker.sourceWrapSplits
    ({
      basePath : fop.basePath,
      filePath : filePath,
      running : query.running,
      interpreter : 'browser',
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

    if( fop.verbosity )
    console.log( ' . scriptWrap', uri.resourcePath, 'of', filePath );

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
      errorHandle
      ({
        err : err,
        request : o.request,
        response : o.response,
      });
      state = 2;
    });

    /* - */

    function htmlGenerate()
    {
      let filePath = _.strRemoveBegin( uri.resourcePath, '/.resolve/' );
      let realPath = _.path.reroot( fop.basePath, filePath );

      let filter = { filePath : _.path.detrail( realPath ), basePath : fop.basePath };
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
      return _.servlet.errorHandle
      ({
        request : o.request,
        response : o.response,
        err : _.err( `Found no ${filePath}` ),
      });

      let srcScriptsMap = Object.create( null );
      resolvedFilePath.forEach( ( p ) => surePathAllowed( p.absolute ) );
      resolvedFilePath.forEach( ( p ) =>
      {
        srcScriptsMap[ _.path.join( '/', p.relative ) ] = _.fileProvider.fileRead( p.absolute );
      });
      let title = _.path.fullName( resolvedFilePath[ 0 ].absolute );

      let template = null;
      if( fop.templatePath )
      template = _.fileProvider.fileRead( fop.templatePath );

      let html = fop.starterMaker.htmlFor
      ({
        srcScriptsMap,
        title,
        template
      });

      o.response.setHeader( 'Content-Type', 'text/html; charset=UTF-8' );
      o.response.write( html );
      o.response.end();

    }

    /* - */

    function remoteResolve()
    {
      let filePath = _.strRemoveBegin( uri.resourcePath, '/.resolve/' );
      filePath = _.path.reroot( fop.basePath, filePath );

      let basePath = _.path.fromGlob( filePath );

      debugger;
      surePathAllowed( basePath );

      let resolvedFilePath = [];
      if( _.path.isGlob( filePath ) )
      {

        if( !fop.resolvingGlob )
        return _.servlet.errorHandle
        ({
          request : o.request,
          response : o.response,
          err : _.err( `Cant resolve ${filePath} because {- fop.resolvingGlob -} is off` ),
        });

        let filter = { filePath, basePath : fop.basePath };
        resolvedFilePath = _.fileProvider.filesFind
        ({
          filter,
          mode : 'distinct',
          mandatory : 0,
          withDirs : 0,
        });

        resolvedFilePath.forEach( ( p ) => surePathAllowed( p.absolute ) );
        resolvedFilePath = resolvedFilePath.map( ( p ) => _.path.join( '/', p.relative ) );

      }
      else
      {

        if( !fop.resolvingNpm )
        return _.servlet.errorHandle
        ({
          request : o.request,
          response : o.response,
          err : _.err( `Cant resolve ${filePath} because {- fop.resolvingNpm -} is off` ),
        });

        debugger;
      }

      o.response.json( resolvedFilePath );
      return;
    }

    /* - */

    function starterWareReturn()
    {
      o.response.setHeader( 'Content-Type', 'application/javascript; charset=UTF-8' );
      o.response.write( ware );
      o.response.end();
      return null;
    }

    /* - */

    function surePathAllowed( filePath )
    {
      _.all( filePath, ( p ) =>
      {
        _.sure( _.path.begins( p, fop.allowedPath ), () => `Path ${p} is beyond allowed path ${fop.allowedPath}` );
      });
    }

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

let defaults = ScriptWrap_functor.defaults = Object.create( null );

defaults.basePath = null;
defaults.allowedPath = '/';
defaults.verbosity = 0;
defaults.incudingExts = null;
defaults.excludingExts = null;
defaults.starterMaker = null;
defaults.resolvingGlob = 1;
defaults.resolvingNpm = 1;
// defaults.autoGeneratingHtml = 1;
defaults.templatePath = null;

// --
// relations
// --

let Composes =
{

  servingDirs : 0,
  loggingApplication : 1,
  loggingConnection : 0,
  owningHttpServer : 1,

  serverPath : 'http://127.0.0.1:5000',
  // serverPath : 'http://0.0.0.0:5000',
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
  _requestScriptWrapHandler : null,
}

let Statics =
{
  ScriptWrap_functor,
}

let Accessor =
{
  verbosity : { getter : _verbosityGet, readOnly : 1 }
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

  requestPreHandler,
  requestMidHandler,
  requestPostHandler,
  requestErrorHandler,

  _verbosityGet,
  openPathGet,

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
