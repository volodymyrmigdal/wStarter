( function _Session_s_() {

'use strict';

let Open;

let _ = _global_.wTools;
let Parent = null;
let Self = function wStarterSessionAbstract( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Abstract';

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

  if( session.unforming )
  return;
  session.unforming = 1;

  let ready = _.Consequence.Try( () => session._unform() );

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

function _unform()
{
  let session = this;
  let system = session.system;
  let ready = new _.Consequence().take( null );

  session.timerCancel();

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
    session._form();
  }
  catch( err )
  {
    throw session.errorEncounterEnd( err );
  }

  return session;
}

//

function _form()
{
  let session = this;
  let system = session.system;
  let logger = system.logger;

  session.fieldsForm();

  if( session.loggingSessionEvents )
  session.on( _.anything, ( e ) =>
  {
    logger.log( ` . event::${e.kind}` );
  });

  // if( session._cdpPort === null )
  // session._cdpPort = session._CdpPortDefault;
  //
  // session.pathsForm();
  // if( !session.servlet )
  // session.servletOpen();

  if( session.entryPath )
  session.entryFind();

  // if( session.curating )
  // session.curratedRunOpen();

  session.timerForm();

  if( session.loggingOptions )
  logger.log( session.exportString() );

}

//

function fieldsForm()
{
  let session = this;
  let system = session.system;
  let logger = system.logger;

  session.instanceOptions();

  if( session.resolvingNpm === null )
  session.resolvingNpm = !!session.withNpm;
  if( session.withNpm === null )
  session.withNpm = !!session.resolvingNpm;

  for( let k in session.Bools )
  {
    _.assert( _.boolLike( session[ k ] ) );
  }

  _.assert( _.longHas( [ 'browser', 'njs' ], session.interpreter ), `sesssion::interpreter should be [ browser, njs ], but it is ${session.interpreter}` );

  if( _.boolLike( session.withStarter ) && session.withStarter )
  session.withStarter = 'include';

  if( _.boolLike( session.withScripts ) && session.withScripts )
  session.withScripts = 'include';

  if( session.withStarter === null )
  {
    if( session.withScripts === 'single' )
    session.withStarter = 0;
    else
    session.withStarter = 'include';
  }

  if( session.withScripts === null )
  {
    session.withScripts = 'include';
  }

  _.assert( session.error === null );
  _.assert( _.longHas( [ 'single', 'include', 'inline', 0, false ], session.withScripts ), `Unknown value of option::withScripts ${session.withScripts}` );
  _.assert( _.longHas( [ 'include', 'inline', 0, false ], session.withStarter ), `Unknown value of option::withStarter ${session.withStarter}` );

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

  allowedPathDeduce1();

  if( session.basePath === null )
  basePathDeduce();

  session.basePath = path.resolve( session.basePath || '.' );

  // if( session.templatePath )
  // session.templatePath = path.resolve( session.basePath, session.templatePath );

  allowedPathDeduce2();

  /* */

  function basePathDeduce() /* qqq : cover basePath deducing strategy. ask */
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
    if( session.allowedPath )
    {
      let allowedPath = _.path.mapExtend( null, session.allowedPath, true );
      for( let p in allowedPath )
      {
        common.push( path.canonize( path.resolve( p ) ) );
      }
    }
    if( session.fallbackPath )
    {
      common.push( session.fallbackPath );
    }
    session.basePath = path.canonize( path.common( common ) );
    if( session.basePath === session.entryPath )
    session.basePath = path.dir( session.basePath );
  }

  /* */

  function allowedPathDeduce1()
  {
    let basePath = path.resolve( session.basePath || '.' );

    if( session.allowedPath === null )
    session.allowedPath = '.';
    session.allowedPath = _.starter.pathAllowedNormalize( session.allowedPath );
    session.allowedPath = path.s.resolve( basePath, session.allowedPath );
  }

  /* */

  function allowedPathDeduce2()
  {

    if( session.withNpm )
    {
      let paths = path.traceToRoot( session.basePath );
      for( var i = paths.length - 1; i >= 0; i-- )
      {
        let p = paths[ i ];
        let modulesPath = path.join( p, 'node_modules' );
        if( fileProvider.isDir( modulesPath ) )
        session.allowedPath[ modulesPath ] = true;
      }
    }

    session.allowedPath = path.mapOptimize( session.allowedPath );

  }

  /* */

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

  // if( session.format === null )
  // {
  //   let exts = path.exts( session.entryPath );
  //   if( _.longHas( exts, 'html' ) || _.longHas( exts, 'htm' ) )
  //   session.format = 'html';
  //   if( session.format === null )
  //   session.format = 'js';
  // }
  //
  // if( session.servlet && path.isAbsolute( session.entryPath ) && session.format )
  // session.entryUriForm();

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
// relations
// --

let Bools =
{

  curating : 1, /* qqq : cover */
  headless : 0, /* qqq : cover? */
  loggingApplication : 1, /* qqq : cover */
  loggingRequestsAll : 0, /* qqq : cover */
  loggingRequests  : 0, /* qqq : cover */
  loggingSessionEvents : 0, /* qqq : cover */
  loggingOptions : 0, /* qqq : cover */
  loggingSourceFiles : 0, /* qqq : cover */
  loggingPathTranslations : 0, /* qqq : cover */
  proceduring : 1, /* qqq : cover */
  resolvingNpm : null, /* qqq : cover */
  withNpm : 1, /* qqq : cover */
  catchingUncaughtErrors : 1, /* qqq : cover */
  naking : 0, /* qqq : cover */

}

let Composes =
{

  basePath : null,
  entryPath : null,
  allowedPath : null,
  fallbackPath : null,
  // templatePath : null, xxx

  withModule : null, /* qqq : cover */
  withScripts : null, /* [ single, include, inline, 0, false ] */ /* qqq : cover */
  withStarter : null, /* [ include, inline, 0, false ] */ /* qqq : cover */
  format : null, /* qqq : cover */
  timeOut : null, /* qqq : cover */
  interpreter : 'browser',

  ... Bools,

}

let InstanceDefaults =
{
  ... Composes,
}

let Associates =
{

  system : null,
  // servlet : null, // xxx
  // process : null, // xxx

}

let Restricts =
{

  id : null,
  error : null,
  // curratedRunState : null, // xxx
  unforming : 0,

  // entryUri : null, // xxx
  // entryWithQueryUri : null, xxx

  _timeOutTimer : null,

  // cdp : null, // xxx
  // _cdpPollingPeriod : 250,
  // _cdpPort : null,
  // _cdpClosing : 0,

}

let Statics =
{
  // _CurratedRunWindowIsOpened, // xxx
  // _CdpPortDefault : 19222, // xxx
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

  unform,
  _unform,
  form,
  _form,
  fieldsForm,
  instanceOptions,

  pathsForm,
  entryFind,

  // etc

  errorEncounterEnd,

  // export

  exportStructure,
  exportString,

  // time

  timerForm,
  timerCancel,
  _timerTimeOutEnd,

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

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.starter.session[ Self.shortName ] = Self;

})();
