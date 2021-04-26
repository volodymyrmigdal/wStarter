( function _BrowserCdp_s_()
{

'use strict';

let Open, ChromeLauncher, ChromeDefaultFlags, Net;

const _ = _global_.wTools;
const Parent = _.starter.session.Abstract;
const Self = wStarterSessioBrowserCdp;
function wStarterSessioBrowserCdp( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'BrowserCdp';

// --
// routine
// --

function _unform()
{
  let session = this;
  let system = session.system;
  let ready = new _.Consequence().take( null );

  if( session.cdp )
  ready.then( () => session.cdpClose() );

  if( session.process )
  ready.then( async () =>
  {
    if( !_.process.isAlive( session.process.pid ) )
    return null;

    if( process.platform !== 'win32' )
    return _.process.kill({ pnd : session.process, withChildren : 1 });

    /* Workaround for windows xxx:remove later*/

    let children = await _.process.children({ pid : session.process.pid, format : 'list' });
    let filtered = children.filter( ( p ) => p.name === 'chrome.exe' );

    let childrenCons = filtered.map( ( p ) =>
    {
      return _.process.waitForDeath
      ({
        pid : p.pid,
        timeOut : session._waitForDeathTimeout
      })
    });

    let mainProcessCon = _.process.kill
    ({
      pnd : session.process,
      withChildren : 0,
      ignoringErrorPerm : 0
    })

    return _.Consequence.AndKeep( mainProcessCon, ... childrenCons );
  })

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

  if( !session.cleanupAfterStarterDeath )
  ready.then( () =>
  {
    if( !session._tempDirCleanProcess )
    return true;
    let pid = session._tempDirCleanProcess.pnd.pid;
    let timeOut = session._tempDirCleanProcessWaitTimeOut;
    if( !_.process.isAlive( pid ) )
    return true;
    return _.process.waitForDeath({ pid, timeOut })
  })

  ready.finally( ( err, arg ) =>
  {
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

function _form()
{
  let session = this;
  let system = session.system;
  let logger = system.logger;
  let ready = new _.Consequence().take( null );

  ready.then( async () =>
  {

    session.fieldsForm();
    session.pathsForm();
    session.loggingSessionEventsForm();
    session.timerForm();

    if( session.sessionPort === null )
    session.sessionPort = session._CdpPortDefault;

    if( session.sessionPort === 0 )
    session.sessionPort = await system._getRandomPort();
    else
    await system._checkIfPortIsOpen( session.sessionPort );

    if( !session.servlet )
    await session.servletOpen();

    if( session.entryPath )
    session.entryFind();

    if( session.loggingOptions ) /* qqq xxx : cover and move out to session.Abstract */
    logger.log( session.exportString() );

    if( session.curating )
    return session.curratedRunOpen();
    return session;
  })

  // if( session.curating )
  // ready.then( () => session.curratedRunOpen() )
  //
  // ready.then( () =>
  // {
  //   session.timerForm();
  //   if( session.loggingOptions ) /* qqq xxx : cover and move out to session.Abstract */
  //   logger.log( session.exportString() );
  //   return session;
  // })

  return ready;
}

// --
// forming
// --

// function pathsForm()
// {
//   let session = this;
//   let system = session.system;
//   const fileProvider = system.fileProvider;
//   let path = system.fileProvider.path;
//   let logger = system.logger;
//
//   Parent.prototype.pathsForm.call( session );
//
//   if( session.templatePath )
//   session.templatePath = path.resolve( session.basePath, session.templatePath );
//
// }

//

function entryFind()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;

  Parent.prototype.entryFind.call( session );

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

async function servletOpen()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( session.servlet === null );

  let o2 = _.mapOnly_( null, session, _.starter.Servlet.FieldsOfCopyableGroups );
  o2.session = session;
  session.servlet = new _.starter.Servlet( o2 );
  await session.servlet.form();

  if( session.servlet && path.isAbsolute( session.entryPath ) && session.format )
  session.entryUriForm();

}

//

function entryUriForm()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
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
// currated
// --

function curratedRunOpen()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  // console.log( 'curratedRunOpen:a' );

  session._curatedRunLaunchBegin();

  if( !ChromeLauncher )
  {
    ChromeLauncher = require( 'chrome-launcher' );
    ChromeDefaultFlags = require( 'chrome-launcher/dist/flags' ).DEFAULT_FLAGS
  }

  let tempDir = session._tempDir = path.resolve( path.dirTemp(), `wStarter/session/chrome`, _.idWithDateAndTime() );
  fileProvider.dirMake( tempDir );
  _.assert( fileProvider.isDir( tempDir ) );

  // let opts = Object.create( null );
  // opts.startingUrl = session.entryWithQueryUri;
  // opts.userDataDir = _.path.nativize( tempDir );
  // opts.port = session.sessionPort
  // opts.chromeFlags = [];

  // if( session.headless )
  // opts.chromeFlags.push( '--headless', '--disable-gpu' );

  // console.log( 'curratedRunOpen:b' );

  let installationPaths = ChromeLauncher.Launcher.getInstallations();

  let args = ChromeDefaultFlags.slice();

  args.push( `--remote-debugging-port=${session.sessionPort}` )
  args.push( `--user-data-dir=${_.path.nativize( tempDir )}` )

  if( session.headless )
  args.push( '--headless', '--disable-gpu' );

  if( process.platform === 'linux' )
  args.push( '--no-sandbox', '--disable-setuid-sandbox' );

  // args.push( session.entryWithQueryUri );

  let op =
  {
    execPath : _.strQuote( installationPaths[ 0 ] ),
    mode : 'spawn',
    detaching : 1,
    stdio : 'ignore',
    outputPiping : 0,
    inputMirroring : 0,
    throwingExitCode : 0,
    args
  }

  // return _.Consequence.Try( () => ChromeLauncher.launch( opts ) )
  _.process.start( op )

  op.conStart.finally( onStart );
  op.conTerminate.tap( () =>
  {
    session._tempDirCleanProcess =
    {
      execPath : _.strQuote( path.join( __dirname, 'BrowserUserDirClean.s' ) ),
      args : [ tempDir, process.pid, session.cleanupAfterStarterDeath ],
      currentPath : __dirname,
      mode : 'fork',
      detaching : 2,
      inputMirroring : 0
    }
    _.process.startSingle( session._tempDirCleanProcess );
  })

  return op.conStart;

  /* */

  function onStart( err, chrome )
  {
    // session.process = chrome.process;
    session.process = chrome.pnd;

    op.disconnect();

    /* xxx : chrome.process sometimes undefined if headless:1 aaa:fixed, used process.start to spawn chrome*/

    // console.log( 'curratedRunOpen:c' );

    if( err )
    {
      _.errAttend( err );
      _.fileProvider.filesDelete( tempDir );
      return session.errorEncounterEnd( err );
    }

    _.process.on( 'exit', async () =>
    {
      await session.unform();
    })

    // debugger;
    // session.process.on( 'exit', () =>
    // {
    // });

    if( system.verbosity >= 3 )
    {
      if( system.verbosity >= 7 )
      logger.log( session.process );
      if( system.verbosity >= 5 )
      logger.log( `Started ${_.ct.format( session.entryPath, 'path' )}` );
    }
    // session._curatedRunLaunchBegin();
    // return _.time.out( 500, () => /* xxx aaa:replaced with _waitForRemoteDebuggingPort */
    // {
    //   session.cdpConnect();
    //   // console.log( 'curratedRunOpen:d' );
    //   // return chrome.process;
    //   return chrome.pnd;
    // });

    return session._waitForRemoteDebuggingPort()
    .then( () =>
    {
      session.cdpConnect();
      return chrome.pnd;
    })
  }
}

//

function _curatedRunLaunchBegin()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( session.curratedRunState === null || session.curratedRunState === 'terminated' || session.curratedRunState === 'launching' );

  // console.log( '_curatedRunLaunchBegin' );

  if( session.curratedRunState === 'launching' )
  return;

  session.curratedRunState = 'launching';
  session.eventGive({ kind : 'curatedRunLaunchBegin' });
}

//

function _curatedRunLaunchEnd()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  session.curratedRunState = 'launched';
  session.eventGive({ kind : 'curatedRunLaunchEnd' });

}

//

function _curatedRunTerminateEnd()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

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
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
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
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
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
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
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
      let targets = await cdp.Target.getTargets();
      let filtered = _.filter_( null, targets.targetInfos, { url : session.entryWithQueryUri } );
      _.sure( filtered.length >= 1, `Found no tab with URI::${session.entryWithQueryUri}` );
      _.sure( filtered.length <= 1, `Found ${filtered.length} tabs with URI::${session.entryWithQueryUri}` );
      o.targetId = filtered[ 0 ].targetId;
    }
    return cdp.Target.closeTarget( o );
  });
}

//

function _CurratedRunWindowIsOpened( session )
{
  _.assert( !session || session instanceof Self );

  let port = session ? session.sessionPort : this._CdpPortDefault;

  return _.Consequence.Try( () =>
  {
    let Cdp = require( 'chrome-remote-interface' );
    return Cdp({ port })
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
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let Cdp = require( 'chrome-remote-interface' );
  let cdp;

  o = _.routine.options_( _cdpConnect, o );

  if( o.port === null )
  o.port = session.sessionPort;

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
  let logger = system.logger;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  _.assert( session.cdp === null );

  session.cdp = await session._cdpConnect({ throwing : 1 });

  await session.cdp.Page.enable();
  await session.cdp.Page.navigate({ url : session.entryWithQueryUri });
  await session.cdp.Page.loadEventFired();

  session._curatedRunLaunchEnd();
  session.cdp.on( 'close', () => session._curatedRunTerminateEnd() );
  session.cdp.on( 'end', () => session._curatedRunTerminateEnd() );

  _.time._periodic( session._cdpPollingPeriod, async function( timer )
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

  return true;
}

//

async function _cdpReconnectAndClose()
{
  let session = this;
  let system = session.system;
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;

  if( session._cdpClosing )
  return;

  if( session.curratedRunState !== 'terminated' )
  session.curratedRunState = 'terminating';

  if( session.cdp )
  try
  {
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
  const fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let ready = _.Consequence().take( null );
  let closed = 0;

  _.assert( !!session.cdp );

  if( session._cdpClosing )
  return ready;
  if( session.curratedRunState === 'terminated' || session.curratedRunState === 'terminating' )
  return ready;

  session._cdpClosing = 1;
  session.curratedRunState = 'terminating';

  if( session.cdp )
  ready.then( () =>
  {
    return new _.Consequence()
    .take( null )
    .or([ browserCloseAttempt( 0 ), browserCloseAttempt( 10 ) ]);
  });

  ready.then( () =>
  {
    closed = true;
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

//

function _waitForRemoteDebuggingPort()
{
  let session = this;
  let system = session.system;
  let logger = system.logger;

  if( !Net )
  Net = require( 'net' )
  let Cdp = require( 'chrome-remote-interface' );

  session._maxCdpConnectionAttempts = Math.floor( session._maxCdpConnectionWaitTime / session._cdpPollingPeriod );

  let tries = 0;

  let debuggerIsReady = _.Consequence().take( false );
  debuggerIsReady.finally( check )

  return debuggerIsReady;

  /* */

  async function check( err, connected )
  {
    tries++;

    if( session.loggingConnectionAttemtps )
    logger.log( `_waitForRemoteDebuggingPort attempt #${tries}` )

    if( connected )
    {
      if( session.loggingConnectionAttemtps )
      logger.log( `_waitForRemoteDebuggingPort ready` )
      return true;
    }

    if( err )
    {
      _.errAttend( err );
      if( session.loggingConnectionAttemtps )
      logger.log( `_waitForRemoteDebuggingPort failed, reason:\n`, err );
    }

    if( tries > session._maxCdpConnectionAttempts )
    {
      err = _.err( `Failed to wait for remote debugging port. Reason:\n`, err );
      throw session.errorEncounterEnd( err );
    }

    await _.time.out( session._cdpPollingPeriod );
    return isReady().finally( check );
  }

  /* */

  function isReady()
  {
    let ready = new _.Consequence();
    Cdp.List({ port : session.sessionPort }, ( err, targets ) =>
    {
      if( err )
      ready.error( err );
      else
      ready.take( !!targets.length );
    });
    return ready;
  }
}

// --
// relations
// --

let Composes =
{

  // templatePath : null,
}

let InstanceDefaults =
{
  ... Parent.prototype.InstanceDefaults,
  ... Composes,
}

let Associates =
{

  servlet : null,
  process : null,

}

let Restricts =
{

  curratedRunState : null,

  entryUri : null,
  entryWithQueryUri : null,

  cdp : null,
  _cdpPollingPeriod : 250,
  _cdpClosing : 0,

  _maxCdpConnectionAttempts : null,
  _maxCdpConnectionWaitTime : 60000,

  _tempDir : null,
  _tempDirCleanProcess : null,
  _tempDirCleanProcessWaitTimeOut : 30000,

  _waitForDeathTimeout : 10000,

}

let Statics =
{
  _CurratedRunWindowIsOpened,
  _CdpPortDefault : 19222,
}

let Events =
{
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

  _unform,
  _form,

  // pathsForm,
  entryFind,
  servletOpen,
  entryUriForm,

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

  _waitForRemoteDebuggingPort,

  // relations

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

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.starter.session[ Self.shortName ] = Self;

})();
