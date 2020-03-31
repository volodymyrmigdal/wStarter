( function _Session_s_() {

'use strict';

let Open;

let _ = _global_.wTools;
let Parent = null;
let Self = function wStarterSession( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Session';

// --
// routine
// --

function finit()
{
  let session = this;
  let system = session.system;
  session.unform();
  if( system )
  _.arrayRemoveOnceStrictly( system.sessionArray, session );
  session.off();
  return _.Copyable.prototype.finit.call( session );
}

//

function init()
{
  let session = this;

  _.Copyable.prototype.init.call( session, ... arguments );

  let system = session.system;

  _.assert( system instanceof _.starter.System );

  system.sessionCounter += 1;
  session.id = system.sessionCounter;

  _.arrayAppendOnceStrictly( system.sessionArray, session );

}

//

function unform()
{
  let session = this;
  let system = session.system;
  let ready = new _.Consequence().take( null );

  if( session.unforming )
  return;
  session.unforming = 1;

  if( session.cdp )
  ready.then( () => session.cdpClose() );

  /*
    do not assign null to field curratedRunState in method unform
  */
  // ready.then( () => session.curratedRunState = null );

  if( session.servlet )
  ready.then( ( arg ) =>
  {
    session.servlet.finit();
    session.servlet = null;
    return arg;
  });

  ready.finally( ( err, arg ) =>
  {
    session.unforming = 0;
    if( err )
    {
      err = _.err( err, '\nError unforming Session' );
      if( !session.error )
      session.error = err;
      logger.error( _.errOnce( err ) );
      throw err;
    }
    return arg;
  });

  return ready;
}

//

function form()
{
  let session = this;
  let system = session.system;
  let logger = system.logger;

  _.assert( session.error === null );

  session.on( _.anything, ( e ) =>
  {
    logger.log( `! event::${e.kind}` );
  });

  session.pathsForm();
  if( !session.servlet )
  session.servletOpen();

  if( session.entryPath )
  session.entryFind();

  if( session.curating )
  session.curratedRunOpen();

  return session;
}

//

function pathsForm()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;

  session.basePath = path.resolve( session.basePath || '.' );
  if( session.allowedPath === null )
  session.allowedPath = '.';
  session.allowedPath = path.resolve( session.basePath, session.allowedPath );
  if( session.templatePath )
  session.templatePath = path.resolve( session.basePath, session.templatePath );

}

//

function entryFind()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;

  session.entryPath = path.resolve( session.basePath, session.entryPath );

  let filter = { filePath : session.entryPath, basePath : session.basePath };
  let found = _.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
    withDirs : 0,
    withDefunct : 0,
  });

  if( !found.length )
  throw _.errBrief( `Found no ${session.entryPath}` );
  if( found.length !== 1 )
  throw _.errBrief( `Found ${found.length} of ${session.entryPath}, but expects single file.` );

  session.entryPath = found[ 0 ].absolute;

  if( session.servlet && path.isAbsolute( session.entryPath ) )
  session.entryUriForm();

}

//

function servletOpen()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( session.servlet === null );

  let o2 = Object.create( null );
  o2.basePath = session.basePath;
  o2.templatePath = session.templatePath;
  o2.allowedPath = session.allowedPath;
  o2.system = session.system;
  o2.loggingApplication = session.loggingApplication;
  o2.loggingConnection = session.loggingConnection;

  session.servlet = new _.starter.Servlet( o2 );
  session.servlet.form();

  if( session.servlet && path.isAbsolute( session.entryPath ) )
  session.entryUriForm();

}

//

function entryUriForm()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  session.entryShortUri = _.uri.join( session.servlet.openPathGet(), _.path.relative( session.basePath, session.entryPath ) );
  session.entryFullUri = _.uri.join( session.entryShortUri, '?entry:1' );

}

//

function curratedRunOpen()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  let chromeAppName = 'google-chrome';//linux
  if( process.platform === 'win32' )
  chromeAppName = 'chrome';
  else if( process.platform === 'darwin' )
  chromeAppName = 'google chrome'

  if( !Open )
  Open = require( 'open' );
  let opts = Object.create( null );
  if( session.headless )
  opts.app = [ chromeAppName, '--headless', '--disable-gpu', '--remote-debugging-port=9222' ];
  else
  opts.app = [ chromeAppName, '--remote-debugging-port=9222' ];

  let tempDir = path.resolve( path.dirTemp(), 'wStarter/session/chrome' );
  fileProvider.dirMake( tempDir );

  if( opts.app )
  opts.app.push( `--user-data-dir=${_.path.nativize( _.path.current() )}` )

  _.Consequence.Try( () => Open( session.entryFullUri, opts ) )
  .finally( ( err, process ) =>
  {
    session.process = process;
    if( err )
    {
      err = _.err( err );
      if( !session.error )
      session.error = err;
      return logger.error( _.errOnce( err ) ) || null;
    }
    session.process.on( 'exit', () =>
    {
    });
    if( system.verbosity >= 3 )
    {
      if( system.verbosity >= 7 )
      logger.log( session.process );
      if( system.verbosity >= 5 )
      logger.log( `Started ${_.ct.format( session.entryPath, 'path' )}` );
    }
    session.cdpConnect();
    return process;
  });

}

//

function _curatedRunLaunchBegin()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( session.curratedRunState === null || session.curratedRunState === 'terminated' );

  session.curratedRunState = 'launching';
  session.eventGive({ kind : 'curatedRunLaunchBegin' });

}

//

function _curatedRunLaunchEnd()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  session.curratedRunState = 'launched';
  session.eventGive({ kind : 'curatedRunLaunchEnd' });

}

//

function _curatedRunTerminateEnd()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  debugger;
  if( session.curratedRunState === 'terminated' )
  return;

  session.curratedRunState = 'terminated';
  session.eventGive({ kind : 'curatedRunTerminateEnd' });

  session.unform();

}

//

function _curratedRunWindowClose()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( _.longHas( [ 'launching', 'launched' ], session.curratedRunState ) );
  _.assert( !!session.cdp );

  return _.Consequence.Try( () =>
  {
    return session.cdp.Browser.close();
  });
}

//

function _curratedRunPageEmptyOpen( o )
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  o = o || Object.create( null );

  _.assert( _.longHas( [ 'launching', 'launched' ], session.curratedRunState ) );
  _.assert( !!session.cdp );

  return _.Consequence.Try( () =>
  {
    if( o.url === undefined || o.url === null )
    o.url = 'http://google.com';
    return session.cdp.Target.createTarget( o );
  });
}

//

function _curratedRunPageClose( o )
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  o = o || Object.create( null );

  _.assert( _.longHas( [ 'launching', 'launched' ], session.curratedRunState ) );
  _.assert( !!session.cdp );

  return _.Consequence.Try( async function()
  {
    if( o.targetId === undefined || o.targetId === null )
    {
      let targets = await session.cdp.Target.getTargets();
      let filtered = _.filter( targets.targetInfos, { url : session.entryFullUri } );
      _.sure( filtered.length >= 1, `Found no tab with URI::${session.entryFullUri}` );
      _.sure( filtered.length <= 1, `Found ${filtered.length} tabs with URI::${session.entryFullUri}` );
      o.targetId = filtered[ 0 ].targetId;
    }
    return await session.cdp.Target.closeTarget( o );
  });
}

//

function _CurratedRunWindowIsOpened()
{

  return _.Consequence.Try( () =>
  {
    let Cdp = require( 'chrome-remote-interface' );
    return Cdp()
  })
  .catch( ( err ) =>
  {
    _.errAttend( err );
    return false;
  });

}

// --
// cdp
// --

async function _cdpConnect( o )
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let Cdp = require( 'chrome-remote-interface' );

  _.routineOptions( _cdpConnect, o );

  // logger.log( '_cdpConnect' );

  try
  {
    session.cdp = await Cdp();
    // debugger;
    // session.cdp.Network.requestWillBeSent( ( params ) =>
    // {
    //   console.log( params.request.url ); debugger;
    // });
    // await session.cdp.Network.enable();
    // await session.cdp.Page.navigate({ url : 'https://github.com' });
    // session.cdp.Page.lifecycleEvent( ( e ) =>
    // {
    //   // debugger;
    //   logger.log( e );
    // });
    // debugger;
    // await session.cdp.Page.setLifecycleEventsEnabled({ enabled : true });
    // await session.cdp.Page.enable();
    // await session.cdp.Page.loadEventFired();
    // debugger;
    // session.eventGive({ kind : 'curatedRunLaunchEnd' });
    // let window = await session.cdp.Browser.getWindowForTarget();
    // let manifest = await session.cdp.Page.getAppManifest();
    // let history = await session.cdp.Page.getNavigationHistory();
    // let history2 = await session.cdp.Page.getNavigationHistory();
    // await session.cdp.Browser.close();
    // debugger;

    // _.time._periodic( 1000, async function()
    // {
    //   debugger;
    //   try
    //   {
    //     let history = await session.cdp.Page.getNavigationHistory();
    //     logger.log( _.toStr( history.entries, { levels : 5 } ) );
    //   }
    //   catch( err )
    //   {
    //     _cdpReconnectAndClose();
    //   }
    //   debugger;
    // });
    //
    // session.cdp.on( 'close', () =>
    // {
    //   session.eventGive({ kind : 'curatedRunTerminateEnd' });
    // });

  }
  catch( err )
  {
    if( o.throwing )
    {
      err = _.err( err );
      if( session.error === null )
      session.error = err;
      logger.error( _.errOnce( err ) );
      throw err;
    }
  }
  // finally
  // {
  //   // if( session.cdp )
  //   // await session.cdp.close();
  // }

  return session.cdp;
}

_cdpConnect.defaults =
{
  throwing : 1,
}

//

async function cdpConnect()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( session.cdp === null );

  session._curatedRunLaunchBegin();

  await session._cdpConnect({ throwing : 1 });

  session._curatedRunLaunchEnd();
  session.cdp.on( 'close', () => session._curatedRunTerminateEnd() );
  session.cdp.on( 'end', () => session._curatedRunTerminateEnd() );

  _.time._periodic( session._cdpTrackingPeriod, async function( timer )
  {
    try
    {
      let history = await session.cdp.Page.getNavigationHistory();
      // logger.log( _.toStr( history.entries, { levels : 5 } ) );
    }
    catch( err )
    {
      timer.cancel();
      await session._cdpReconnectAndClose();
    }
  });

}

//

async function _cdpReconnectAndClose()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  if( session.curratedRunState !== 'terminated' )
  session.curratedRunState = 'terminating';

  try
  {
    await session._cdpConnect({ throwing : 0 });
    await session.cdp.Browser.close();
    debugger;
    await session.cdp.close();
    debugger;
    session._curatedRunTerminateEnd();
  }
  catch( err )
  {
    debugger;
    session._curatedRunTerminateEnd();
  }

}

//

function cdpClose()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let ready = _.Consequence().take( null );

  _.assert( !!session.cdp );

  if( session.curratedRunState === 'terminated' || session.curratedRunState === 'terminating' )
  return ready;

  session.curratedRunState = 'terminating';

  if( session.cdp )
  ready.then( () => session.cdp.Browser.close() );
  ready.then( () => session.cdp.close() );

  ready.catch( ( err ) =>
  {
    err = _.err( err );
    if( !session.error )
    session.error = err;
    logger.error( _.errOnce( err ) )
    return null;
  });

  ready.then( ( arg ) =>
  {
    session._curatedRunTerminateEnd();
    return arg;
  });

  return ready;
}

// --
// relations
// --

let Composes =
{

  basePath : null,
  entryPath : null,
  allowedPath : null,
  templatePath : null,
  entryShortUri : null,
  entryFullUri : null,

  curating : 1,
  headless : 0,
  loggingApplication : 1,
  loggingConnection : 0

}

let Associates =
{

  system : null,
  servlet : null,
  process : null,

}

let Restricts =
{

  id : null,
  error : null,
  curratedRunState : null,
  unforming : 0,

  cdp : null,
  _cdpTrackingPeriod : 500,

}

let Statics =
{
  _CurratedRunWindowIsOpened,
}

let Events =
{
  'curatedRunLaunchBegin' : {},
  'curatedRunLaunchEnd' : {},
  'curatedRunTerminateEnd' : {},
}

let Accessor =
{
}

// --
// prototype
// --

let Proto =
{

  finit,
  init,
  unform,
  form,

  /* */

  pathsForm,
  entryFind,
  servletOpen,
  entryUriForm,

  /* curated run */

  curratedRunOpen,
  _curatedRunLaunchBegin,
  _curatedRunLaunchEnd,
  _curatedRunTerminateEnd,

  _curratedRunWindowClose,
  _curratedRunPageEmptyOpen,
  _curratedRunPageClose,
  _CurratedRunWindowIsOpened,

  /* cdp */

  _cdpConnect,
  cdpConnect,
  _cdpReconnectAndClose,
  cdpClose,

  /* */

  Composes,
  Associates,
  Restricts,
  Statics,
  Events,
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
_.EventHandler.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.starter[ Self.shortName ] = Self;

})();
