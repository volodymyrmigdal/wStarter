( function _MainBase_s_( ) {

'use strict';

/**
 * ...
  @module Tools/mid/Starter
*/

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );
  require( './IncludeMid.s' );

}

//

let _ = wTools;
let Parent = null;
let Self = function wStarter( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Starter';

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
  let starter = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !starter.logger )
  starter.logger = new _.Logger({ output : _global_.logger });

  _.workpiece.initFields( starter );
  Object.preventExtensions( starter );

  if( o )
  starter.copy( o );

}

//

function unform()
{
  let starter = this;

  _.assert( arguments.length === 0 );
  _.assert( !!starter.formed );

  /* begin */

  /* end */

  starter.formed = 0;
  return starter;
}

//

function form()
{
  let starter = this;

  if( starter.formed )
  return starter;

  starter.formAssociates();

  _.assert( arguments.length === 0 );
  _.assert( !starter.formed );

  starter.formed = 1;
  return starter;
}

//

function formAssociates()
{
  let starter = this;
  let logger = starter.logger;

  _.assert( arguments.length === 0 );
  _.assert( !starter.formed );

  if( !starter.logger )
  logger = starter.logger = new _.Logger({ output : _global_.logger });

  if( !starter.fileProvider )
  starter.fileProvider = _.FileProvider.Default();

  if( !starter.maker )
  starter.maker = _.StarterMakerLight();

  return starter;
}

//

function htmlFor( o )
{
  let starter = this;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let maker = starter.maker;

  o = _.routineOptions( htmlFor, arguments );

  if( o.basePath )
  o.dstPath = path.resolve( o.basePath, o.dstPath );

  o.srcPath = fileProvider.recordFilter( o.srcPath );
  o.srcPath.basePath = o.srcPath.basePath || o.basePath;
  o.srcPath = fileProvider.filesFind
  ({
    filter : o.srcPath,
    mode : 'distinct',
    outputFormat : 'absolute',
  });

  let srcScriptsMap = Object.create( null );
  o.srcPath = o.srcPath.map( ( srcPath ) =>
  {
    let srcRelativePath = srcPath;
    if( o.relative && o.basePath )
    srcRelativePath = path.relative( o.basePath, srcRelativePath );
    if( o.nativize )
    srcRelativePath = path.nativize( srcRelativePath );
    srcScriptsMap[ srcRelativePath ] = fileProvider.fileRead( srcPath );
  });

  let data = maker.htmlFor
  ({
    srcScriptsMap : srcScriptsMap,
    dstPath : o.dstPath,
  });

  debugger;
  if( o.dstPath )
  fileProvider.fileWrite
  ({
    filePath : o.dstPath,
    data : data,
  });

  return data;
}

var defaults = htmlFor.defaults = Object.create( null );
defaults.srcPath = null;
defaults.dstPath = null;
defaults.basePath = null;
defaults.relative = 1;
defaults.nativize = 1;

// --
// relations
// --

let Composes =
{

  verbosity : 3,

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

  htmlFor,

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
_global_[ Self.name ] = wTools[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
require( './IncludeMid.s' );

})();
