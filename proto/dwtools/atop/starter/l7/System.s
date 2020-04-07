( function _System_s_( ) {

'use strict';

//

let _ = _global_.wTools;
let Parent = null;
let Self = function wStarterSystem( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'System';

// --
// inter
// --

function finit()
{
  if( this.formed )
  this.unform();
  return _.Copyable.prototype.finit.apply( this, arguments );
}

//

function init( o )
{
  let system = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !system.logger )
  system.logger = new _.Logger({ output : _global_.logger });

  _.workpiece.initFields( system );
  Object.preventExtensions( system );

  if( o )
  system.copy( o );

}

//

function unform()
{
  let system = this;

  _.assert( arguments.length === 0 );
  _.assert( !!system.formed );

  /* begin */

  /* end */

  system.formed = 0;
  return system;
}

//

function form()
{
  let system = this;

  if( system.formed )
  return system;

  system.formAssociates();

  _.assert( arguments.length === 0 );
  _.assert( !system.formed );

  system.formed = 1;
  return system;
}

//

function formAssociates()
{
  let system = this;
  let logger = system.logger;

  _.assert( arguments.length === 0 );
  _.assert( !system.formed );

  if( !system.logger )
  logger = system.logger = new _.Logger({ output : _global_.logger });

  if( !system.fileProvider )
  system.fileProvider = _.FileProvider.Default();

  let o2 = _.mapOnly( system, _.starter.Maker2.FieldsOfCopyableGroups );
  if( !system.maker )
  system.maker = _.starter.Maker2( o2 );

  return system;
}

//

function close()
{
  let system = this;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;
  let ready = _.after();

  for( let i = 0 ; i < system.sessionArray.length ; i++ ) (function()
  {
    let session = system.sessionArray[ i ];
    ready.then( ( arg ) =>
    {
      return session.unform();
    });
    ready.then( ( arg ) =>
    {
      return session.finit() || null;
    });
  })();

  ready.then( ( arg ) =>
  {
    _.assert( _.lengthOf( system.servletsMap ) === 0 );
    _.assert( _.lengthOf( system.sessionArray ) === 0 );
    return arg;
  });

  return ready;
}

//

function sourcesJoinFiles( o )
{
  let system = this;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;
  let maker = system.maker;

  let data = maker.sourcesJoinFiles( ... arguments );

  return data;
}

var defaults = sourcesJoinFiles.defaults = _.mapExtend( null, _.starter.Maker2.prototype.sourcesJoinFiles.defaults );

//

function htmlForFiles( o )
{
  let system = this;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;
  let maker = system.maker;

  let data = maker.htmlForFiles( ... arguments );

  return data;
}

var defaults = htmlForFiles.defaults = _.mapExtend( null, _.starter.Maker2.prototype.htmlForFiles.defaults );

//

function httpOpen( o )
{
  let system = this;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;
  let maker = system.maker;

  _.routineOptions( httpOpen, arguments );

  let opts =
  {
    system,
    curating : 0,
    fallbackPath : path.current(),
    ... o,
  }
  let session = new _.starter.Session( opts );

  return session.form();
}

httpOpen.defaults =
{
  basePath : null,
  allowedPath : null,
  templatePath : null,
  withModule : null,
  loggingApplication : 0,
  loggingConnection : 1,
  loggingSessionEvents : null,
  loggingOptions : null,
  proceduring : null,
  catchingUncaughtErrors : null,
  naking : null,
  withScripts : null,
  timeOut : null,
}

//

function start( o )
{
  let system = this;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;

  _.routineOptions( start, arguments );

  let opts =
  {
    system,
    fallbackPath : path.current(),
    ... o,
  }
  let session = new _.starter.Session( opts );

  return session.form();
}

var defaults = start.defaults = _.mapExtend( null, httpOpen.defaults );

defaults.loggingApplication = 1;
defaults.loggingConnection = 0;
defaults.entryPath = null;
defaults.curating = 1;
defaults.headless = 0;

// --
// relations
// --

let Composes =
{

  verbosity : 3,
  servletsMap : _.define.own({}),
  servletsArray : _.define.own([]),
  sessionArray : _.define.own([]),
  sessionCounter : 0,

}

let Aggregates =
{
}

let Associates =
{

  maker : null,
  fileProvider : null,
  logger : null,

}

let Restricts =
{
  formed : 0,
}

let Statics =
{
}

let Forbids =
{
  servlet : 'servlet',
}

// --
// declare
// --

let Proto =
{

  // inter

  finit,
  init,
  unform,
  form,
  formAssociates,

  close,
  sourcesJoinFiles,
  htmlForFiles,
  httpOpen,
  start,

  // ident

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
wTools.starter[ Self.shortName ] = Self;

})();