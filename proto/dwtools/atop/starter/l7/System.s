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

  if( !system.maker )
  system.maker = _.starter.Maker();

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

function sourcesJoin( o )
{
  let system = this;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;
  let maker = system.maker;

  o = _.routineOptions( sourcesJoin, arguments );

  /* */

  o.inPath = fileProvider.recordFilter( o.inPath );
  o.inPath.basePathUse( o.basePath );
  let basePath = o.inPath.basePathSimplest();

  o.inPath = fileProvider.filesFind
  ({
    filter : o.inPath,
    mode : 'distinct',
    outputFormat : 'absolute',
  });

  /* */

  o.outPath = o.outPath || sourcesJoin.defaults.outPath;
  o.outPath = path.resolve( o.basePath, o.outPath );

  /* */

  if( o.entryPath )
  {
    o.entryPath = fileProvider.recordFilter( o.entryPath );
    o.entryPath.basePath = path.resolve( o.entryPath.basePath || o.basePath || '.' );
    o.entryPath = fileProvider.filesFind
    ({
      filter : o.entryPath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
    if( !_.longHasAll( o.inPath, o.entryPath ) )
    throw _.errBrief
    (
      'List of source files should have all entry files' +
      '\nSource files\n' + _.toStrNice( o.inPath, { levels : 2 } ) +
      '\nEntry files\n' + _.toStrNice( o.entryPath, { levels : 2 } )
    );
  }

  /* */

  if( o.externalBeforePath )
  {
    o.externalBeforePath = fileProvider.recordFilter( o.externalBeforePath );
    o.externalBeforePath.basePath = path.resolve( o.externalBeforePath.basePath || o.basePath || '.' );
    o.externalBeforePath = fileProvider.filesFind
    ({
      filter : o.externalBeforePath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
  }

  /* */

  if( o.externalAfterPath )
  {
    o.externalAfterPath = fileProvider.recordFilter( o.externalAfterPath );
    o.externalAfterPath.basePath = path.resolve( o.externalAfterPath.basePath || o.basePath || '.' );
    o.externalAfterPath = fileProvider.filesFind
    ({
      filter : o.externalAfterPath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
  }

  /* */

  o.basePath = path.resolve( basePath || '.' );

  /* */

  let srcScriptsMap = Object.create( null );
  o.inPath = o.inPath.map( ( inPath ) =>
  {
    let srcRelativePath = inPath;
    srcScriptsMap[ srcRelativePath ] = fileProvider.fileRead( inPath );
  });

  let o2 = _.mapExtend( null, o )
  delete o2.inPath;
  o2.filesMap = srcScriptsMap;
  let data = maker.sourcesJoin( o2 )

  _.sure( !fileProvider.isDir( o.outPath ), () => 'Can rewrite directory ' + _.color.strFormat( o.outPath, 'path' ) );

  fileProvider.fileWrite
  ({
    filePath : o.outPath,
    data : data,
  });

  return data;
}

var defaults = sourcesJoin.defaults = _.mapBut( _.starter.Maker.prototype.sourcesJoin.defaults, { filesMap : null } );
defaults.inPath = null;
defaults.outPath = 'Index.js';

//

function htmlFor( o )
{
  let system = this;
  let fileProvider = system.fileProvider;
  let path = system.fileProvider.path;
  let logger = system.logger;
  let maker = system.maker;

  o = _.routineOptions( htmlFor, arguments );

  /* */

  let basePath = o.basePath;
  if( !_.arrayIs( o.inPath ) || o.inPath.length )
  {
    o.inPath = fileProvider.recordFilter( o.inPath );
    o.inPath.basePathUse( o.basePath );
    let basePath = o.inPath.basePathSimplest();
    o.inPath = fileProvider.filesFind
    ({
      filter : o.inPath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
  }

  /* */

  o.outPath = o.outPath || sourcesJoin.defaults.outPath;
  o.outPath = path.resolve( o.basePath, o.outPath );
  o.basePath = path.resolve( basePath || '.' );

  /* */

  let srcScriptsMap = Object.create( null );
  o.inPath = o.inPath.map( ( inPath ) =>
  {
    let srcRelativePath = inPath;
    if( o.relative && o.basePath )
    srcRelativePath = path.dot( path.relative( o.basePath, srcRelativePath ) );
    if( o.nativize )
    srcRelativePath = path.nativize( srcRelativePath );
    if( o.starterIncluding === 'inline' )
    srcScriptsMap[ srcRelativePath ] = fileProvider.fileRead( inPath );
    else
    srcScriptsMap[ srcRelativePath ] = null;
  });

  let o2 = _.mapOnly( o, maker.htmlFor.defaults );
  o2.srcScriptsMap = srcScriptsMap;
  let data = maker.htmlFor( o2 );

  _.sure( !fileProvider.isDir( o.outPath ), () => 'Can rewrite directory ' + _.color.strFormat( o.outPath, 'path' ) );

  fileProvider.fileWrite
  ({
    filePath : o.outPath,
    data : data,
  });

  return data;
}

var defaults = htmlFor.defaults = _.mapBut( _.starter.Maker.prototype.htmlFor.defaults, { srcScriptsMap : null } );
defaults.inPath = null;
defaults.outPath = 'Index.html';
defaults.basePath = null;
defaults.relative = 1;
defaults.nativize = 0;

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
  sourcesJoin,
  htmlFor,
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
