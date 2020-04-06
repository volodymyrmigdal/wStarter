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

function instanceOptions( o )
{
  let session = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o )
  for( let k in o )
  {
    if( o[ k ] === null && session.InstanceDefaults[ k ] !== undefined )
    o[ k ] = session[ k ];
  }
  else
  for( let k in session.InstanceDefaults )
  {
    if( session[ k ] === null && session.InstanceDefaults[ k ] !== undefined )
    session[ k ] = session.InstanceDefaults[ k ];
  }

  return o;
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

  session.timerCancel();

  if( session.cdp )
  ready.then( () => session.cdpClose() );

  /*
    do not assign null to field curratedRunState in method unform
  */

  if( session.servlet )
  ready.then( ( arg ) =>
  {
    session.servlet.finit();
    session.servlet = null;
    return arg;
  });

  ready.then( ( arg ) =>
  {
    session.entryUri = null;
    session.entryWithQueryUri = null;
    return arg;
  });

  ready.finally( ( err, arg ) =>
  {
    session.unforming = 0;
    if( err )
    {
      err = _.err( err, '\nError unforming Session' );
      throw session.errorEncounterEnd( err );
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

  try
  {

    session.instanceOptions();

    for( let k in session.Bools )
    {
      // if( session[ k ] === null )
      // session[ k ] = session.Bools[ k ];
      _.assert( _.boolLike( session[ k ] ) );
    }

    _.assert( session.error === null );
    _.assert( _.longHas( [ 'single', 'include', 'inline', 0, false ], session.withScripts ), `Unknown value of option::withScripts ${session.withScripts}` );

    if( session._cdpPort === null )
    session._cdpPort = session._CdpPortDefault;

    if( session.loggingSessionEvents )
    session.on( _.anything, ( e ) =>
    {
      logger.log( ` . event::${e.kind}` );
    });

    session.pathsForm();
    if( !session.servlet )
    session.servletOpen();

    if( session.entryPath )
    session.entryFind();

    if( session.curating )
    session.curratedRunOpen();

    session.timerForm();

    if( session.loggingOptions )
    logger.log( session.exportString() );

  }
  catch( err )
  {
    throw session.errorEncounterEnd( err );
  }

  return session;
}

// --
// forming
// --

function pathsForm()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;

  if( session.withModule !== null )
  session.withModule = _.arrayAs( session.withModule );

  if( session.basePath === null )
  {
    let common = [];
    if( session.withModule )
    for( let b = 0 ; b < session.withModule.length ; b++ )
    {
      common.push( _.module.resolve( session.withModule[ b ] ) );
    }
    if( session.entryPath )
    {
      session.entryPath = path.canonize( path.resolve( session.entryPath ) );
      common.push( session.entryPath );
    }
    session.basePath = path.canonize( path.common( common ) );
    if( session.basePath === session.entryPath )
    session.basePath = path.dir( session.basePath );
  }

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

  if( session.format === null )
  {
    let exts = path.exts( session.entryPath );
    if( _.longHas( exts, 'html' ) || _.longHas( exts, 'htm' ) )
    session.format = 'html';
    if( session.format === null )
    session.format = 'js';
  }

  if( session.servlet && path.isAbsolute( session.entryPath ) && session.format )
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

  let o2 = _.mapOnly( session, _.starter.Servlet.FieldsOfCopyableGroups );
  session.servlet = new _.starter.Servlet( o2 );
  session.servlet.form();

  if( session.servlet && path.isAbsolute( session.entryPath ) && session.format )
  session.entryUriForm();

}

//

function entryUriForm()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( _.strDefined( session.format ) );
  _.assert( session.entryUri === null );
  _.assert( session.entryWithQueryUri === null );

  session.entryUri = _.uri.join( session.servlet.openUriGet(), _.path.relative( session.basePath, session.entryPath ) );

  if( session.format === 'html' )
  session.entryWithQueryUri = session.entryUri;
  else if( session.format === 'js' )
  session.entryWithQueryUri = _.uri.join( session.entryUri, `://?entry:1` );
  else
  session.entryWithQueryUri = _.uri.join( session.entryUri, `://?entry:1&format:${session.format}` );

}

// --
// error
// --

function errorEncounterEnd( err )
{
  let session = this;

  err = _.err( err );
  if( session.error === null )
  session.error = err;
  logger.error( _.errOnce( err ) );

  logger.log( '' );
  logger.log( session.exportString() );
  logger.log( '' );

  return err;
}

// --
// export
// --

function exportStructure( o )
{
  let session = this;

  o = _.routineOptions( exportStructure, arguments );

  let dst = _.mapOnly( session, session.Composes );

  if( o.contraction )
  for( let k in dst )
  if( dst[ k ] === null )
  delete dst[ k ];

  if( o.dst === null )
  o.dst = dst;
  else
  _.mapExtend( o.dst, dst );

  return o.dst;
}

exportStructure.defaults =
{
  dst : null,
  contraction : 1,
}

//

function exportString()
{
  let session = this;

  let structure = session.exportStructure();
  let result = _.toStrNice( structure );

  return result;
}

// --
// time
// --

function timerForm()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( session._timeOutTimer === null );

  if( session.timeOut )
  session._timeOutTimer = _.time.begin( session.timeOut, () =>
  {
    if( session.unforming )
    return;
    if( _.workpiece.isFinited( session ) )
    return;

    session._timeOutTimer = null;

    session._timerTimeOutEnd();

  });

}

//

function timerCancel()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  if( session._timeOutTimer )
  {
    debugger;
    _.time.cancel( session._timeOutTimer );
    session._timeOutTimer = null
  }

}

//

function _timerTimeOutEnd()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  session.eventGive({ kind : 'timeOut' });
  session.unform();

}

// --
// currated
// --

function curratedRunOpen()
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  if( !Open )
  Open = require( 'open' );
  let opts = Object.create( null );
  if( session.headless )
  opts.app = [ `chrome`, `--headless`, `--disable-gpu`, `--remote-debugging-port=${session._cdpPort}` ];
  else
  opts.app = [ `chrome`, `--remote-debugging-port=${session._cdpPort}` ];

  let tempDir = path.resolve( path.dirTemp(), `wStarter/session/chrome` );
  fileProvider.dirMake( tempDir );
  _.assert( fileProvider.isDir( tempDir ) );

  if( opts.app )
  opts.app.push( `--user-data-dir=${_.path.nativize( tempDir )}` )

  _.Consequence.Try( () => Open( session.entryWithQueryUri, opts ) )
  .finally( ( err, process ) =>
  {
    session.process = process;
    if( err )
    return session.errorEncounterEnd( err );
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

  if( session.curratedRunState === 'terminated' )
  return;

  // console.log( _.introspector.stack() );

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
  // let cdp = session.cdp;
  let cdp = session._cdpConnect({});

  _.assert( _.longHas( [ 'launching', 'launched' ], session.curratedRunState ) );
  _.assert( !!cdp );

  return _.Consequence.From( cdp )
  .then( ( cdp ) =>
  {
    _.assert( !!cdp );
    return cdp.Browser.close();
  });
}

//

function _curratedRunPageEmptyOpen( o )
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  // let cdp = session.cdp;
  let cdp = session._cdpConnect({});

  o = o || Object.create( null );

  _.assert( _.longHas( [ 'launching', 'launched' ], session.curratedRunState ) );
  _.assert( !!cdp );

  return _.Consequence.From( cdp )
  .then( ( cdp ) =>
  {
    _.assert( !!cdp );
    if( o.url === undefined || o.url === null )
    o.url = 'http://google.com';
    return cdp.Target.createTarget( o );
  });
}

//

function _curratedRunPageClose( o )
{
  let session = this;
  let system = session.system;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  // let cdp = session.cdp;
  let cdp = session._cdpConnect({});

  o = o || Object.create( null );

  _.assert( _.longHas( [ 'launching', 'launched' ], session.curratedRunState ) );
  _.assert( !!cdp );

  return _.Consequence.From( cdp )
  .then( async function( cdp )
  {
    _.assert( !!cdp );
    if( o.targetId === undefined || o.targetId === null )
    {
      // logger.log( 'await cdp.Target.getTargets()' );
      let targets = await cdp.Target.getTargets();
      // logger.log( 'targets', targets.targetInfos.length, targets.targetInfos );
      let filtered = _.filter( targets.targetInfos, { url : session.entryWithQueryUri } );
      _.sure( filtered.length >= 1, `Found no tab with URI::${session.entryWithQueryUri}` );
      _.sure( filtered.length <= 1, `Found ${filtered.length} tabs with URI::${session.entryWithQueryUri}` );
      o.targetId = filtered[ 0 ].targetId;
    }
    // logger.log( `await cdp.Target.closeTarget({ targetId : ${o.targetId} })` );
    return await cdp.Target.closeTarget( o );
  });
}

//

function _CurratedRunWindowIsOpened()
{

  return _.Consequence.Try( () =>
  {
    let Cdp = require( 'chrome-remote-interface' );
    return Cdp({ port : this._CdpPortDefault })
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
  let cdp;

  o = _.routineOptions( _cdpConnect, o );

  if( o.port == null )
  o.port = session._cdpPort;

  try
  {
    cdp = await Cdp({ port : o.port });
  }
  catch( err )
  {
    if( o.throwing )
    throw session.errorEncounterEnd( err );
  }

  return cdp;
}

_cdpConnect.defaults =
{
  throwing : 1,
  port : null,
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

  session.cdp = await session._cdpConnect({ throwing : 1 });

  session._curatedRunLaunchEnd();
  session.cdp.on( 'close', () => session._curatedRunTerminateEnd() );
  session.cdp.on( 'end', () => session._curatedRunTerminateEnd() );

  _.time._periodic( session._cdpTrackingPeriod, async function( timer )
  {
    try
    {
      let history = await session.cdp.Page.getNavigationHistory();
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

  // console.log( '_cdpReconnectAndClose.a' );

  if( session._cdpClosing )
  return;

  // console.log( '_cdpReconnectAndClose.b' );

  if( session.curratedRunState !== 'terminated' )
  session.curratedRunState = 'terminating';

  if( session.cdp )
  try
  {
    // console.log( 'session.cdp.close():_cdpReconnectAndClose:1' );
    await session.cdp.close();
    session.cdp = null;
  }
  catch( err )
  {
    session.cdp = null;
  }

  try
  {
    session.cdp = await session._cdpConnect({ throwing : 0 });
    await session.cdp.Browser.close();
    debugger;
    // console.log( 'session.cdp.close():_cdpReconnectAndClose:2' );
    await session.cdp.close();
    session.cdp = null;
    session._curatedRunTerminateEnd();
  }
  catch( err )
  {
    session.cdp = null;
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
  let closed = 0;

  _.assert( !!session.cdp );

  // console.log( 'cdpClose.a' );

  if( session._cdpClosing )
  return ready;
  if( session.curratedRunState === 'terminated' || session.curratedRunState === 'terminating' )
  return ready;

  session._cdpClosing = 1;
  session.curratedRunState = 'terminating';

  if( session.cdp )
  ready.then( () =>
  {
    // console.log( 'cdpClose.b' );
    return new _.Consequence().take( null ).or([ browserCloseAttempt( 0 ), browserCloseAttempt( 10 ) ]);
    // return session.cdp.Browser.close(); /* qqq xxx : stuck here sometimes! */
  });

  ready.then( () =>
  {
    closed = true;
    // console.log( 'cdpClose.c' );
    // console.log( 'session.cdp.close():cdpClose' );
    return session.cdp.close();
  });

  ready.catch( ( err ) =>
  {
    session._cdpClosing = 0;
    session.cdp = null;
    return session.errorEncounterEnd( err );
  });

  ready.then( ( arg ) =>
  {
    // console.log( 'cdpClose.d' );
    session._cdpClosing = 0;
    session.cdp = null;
    session._curatedRunTerminateEnd();
    return arg;
  });

  return ready;

  function browserCloseAttempt( delay )
  {

    if( !delay )
    return browserClose();

    /* hack to fix bug */

    return _.time.out( 10, () =>
    {
      return browserClose();
    });
  }

  function browserClose()
  {
    if( session.cdp && session._cdpClosing && !closed )
    return session.cdp.Browser.close()
    return null
  }

}

// --
// relations
// --

let Bools =
{

  curating : 1, /* qqq : cover */
  headless : 0, /* qqq : cover? */
  loggingApplication : 1, /* qqq : cover */
  loggingConnection : 0, /* qqq : cover */
  loggingSessionEvents : 1, /* qqq : cover */
  loggingOptions : 0, /* qqq : cover */
  proceduring : 1, /* qqq : cover */
  catchingUncaughtErrors : 1, /* qqq : cover */
  naking : 0, /* qqq : cover */

}

let Composes =
{

  basePath : null,
  entryPath : null,
  allowedPath : null,
  templatePath : null,

  withModule : null, /* qqq : cover */
  withScripts : 'include', /* [ single, include, inline, 0, false ] */ /* qqq : cover */
  format : null, /* qqq : cover */
  timeOut : null, /* qqq : cover */

  ... Bools,

}

let InstanceDefaults =
{
  ... Composes,
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

  entryUri : null,
  entryWithQueryUri : null,

  _timeOutTimer : null,

  cdp : null,
  _cdpTrackingPeriod : 50,
  _cdpPort : null,
  _cdpClosing : 0,

}

let Statics =
{
  _CurratedRunWindowIsOpened,
  _CdpPortDefault : 19222,
}

let Events =
{
  'curatedRunLaunchBegin' : {},
  'curatedRunLaunchEnd' : {},
  'curatedRunTerminateEnd' : {},
  'timeOut' : {},
}

let Accessor =
{
}

// --
// prototype
// --

let Proto =
{

  // inter

  finit,
  init,
  instanceOptions,

  unform,
  form,

  pathsForm,
  entryFind,
  servletOpen,
  entryUriForm,

  // etc

  errorEncounterEnd,

  // export

  exportStructure,
  exportString,

  // time

  timerForm,
  timerCancel,
  _timerTimeOutEnd,

  // curated run

  curratedRunOpen,
  _curatedRunLaunchBegin,
  _curatedRunLaunchEnd,
  _curatedRunTerminateEnd,

  _curratedRunWindowClose,
  _curratedRunPageEmptyOpen,
  _curratedRunPageClose,
  _CurratedRunWindowIsOpened,

  // cdp

  _cdpConnect,
  cdpConnect,
  _cdpReconnectAndClose,
  cdpClose,

  // relations

  Bools,
  Composes,
  InstanceDefaults,
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
