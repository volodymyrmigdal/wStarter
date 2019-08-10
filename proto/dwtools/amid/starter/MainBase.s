( function _MainBase_s_( ) {

'use strict';

/**
 * ...
  @module Tools/mid/Starter
*/

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

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

function filesWrap( o )
{
  let starter = this;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let maker = starter.maker;

  o = _.routineOptions( filesWrap, arguments );

  /* */

  o.basePath = path.resolve( o.basePath || '.' );

  /* */

  o.srcPath = fileProvider.recordFilter( o.srcPath );
  o.srcPath.basePathUse( o.basePath );

  o.srcPath = fileProvider.filesFind
  ({
    filter : o.srcPath,
    mode : 'distinct',
    outputFormat : 'absolute',
  });

  /* */

  o.dstPath = o.dstPath || filesWrap.defaults.dstPath;
  o.dstPath = path.resolve( o.basePath, o.dstPath );

  /* */

  if( o.entryPath )
  {
    o.entryPath = fileProvider.recordFilter( o.entryPath );
    o.entryPath.basePath = o.entryPath.basePath || o.basePath;
    o.entryPath = fileProvider.filesFind
    ({
      filter : o.entryPath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
    debugger;
    if( !_.arrayHasAll( o.srcPath, o.entryPath ) )
    throw _.errBriefly
    (
      'List of source files should have all entry files' +
      '\nSource files\n' + _.toStrNice( o.srcPath, { levels : 2 } ) +
      '\nEntry files\n' + _.toStrNice( o.entryPath, { levels : 2 } )
    );
  }

  /* */

  let srcScriptsMap = Object.create( null );
  o.srcPath = o.srcPath.map( ( srcPath ) =>
  {
    let srcRelativePath = srcPath;
    srcScriptsMap[ srcRelativePath ] = fileProvider.fileRead( srcPath );
  });

  let o2 = _.mapExtend( null, o )
  delete o2.srcPath;
  delete o2.dstPath;
  o2.filesMap = srcScriptsMap;
  debugger;
  let data = maker.filesWrap( o2 )

  _.sure( !fileProvider.isDir( o.dstPath ), () => 'Can rewrite directory ' + _.color.strFormat( o.dstPath, 'path' ) );

  fileProvider.fileWrite
  ({
    filePath : o.dstPath,
    data : data,
  });

  return data;
}

var defaults = filesWrap.defaults = _.mapBut( _.StarterMakerLight.prototype.filesWrap.defaults, { filesMap : null } );
defaults.srcPath = null;
defaults.dstPath = 'Index.js';

//

function htmlFor( o )
{
  let starter = this;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let maker = starter.maker;

  o = _.routineOptions( htmlFor, arguments );

  /* */

  o.basePath = path.resolve( o.basePath || '.' );

  /* */

  o.srcPath = fileProvider.recordFilter( o.srcPath );
  o.srcPath.basePathUse( o.basePath );

  o.srcPath = fileProvider.filesFind
  ({
    filter : o.srcPath,
    mode : 'distinct',
    outputFormat : 'absolute',
  });

  /* */

  o.dstPath = o.dstPath || filesWrap.defaults.dstPath;
  o.dstPath = path.resolve( o.basePath, o.dstPath );

  /* */

  // debugger;
  // o.basePath = o.basePath || path.current();
  // o.dstPath = o.dstPath || htmlFor.defaults.dstPath;
  // if( o.basePath )
  // o.dstPath = path.resolve( o.basePath, o.dstPath );
  //
  // o.srcPath = fileProvider.recordFilter( o.srcPath );
  // o.srcPath.basePath = o.srcPath.basePath || o.basePath;
  // o.srcPath = fileProvider.filesFind
  // ({
  //   filter : o.srcPath,
  //   mode : 'distinct',
  //   outputFormat : 'absolute',
  // });

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

  let o2 = _.mapOnly( o, maker.htmlFor.defaults );
  o2.srcScriptsMap = srcScriptsMap;
  let data = maker.htmlFor( o2 );

  _.sure( !fileProvider.isDir( o.dstPath ), () => 'Can rewrite directory ' + _.color.strFormat( o.dstPath, 'path' ) );

  fileProvider.fileWrite
  ({
    filePath : o.dstPath,
    data : data,
  });

  return data;
}

var defaults = htmlFor.defaults = _.mapBut( _.StarterMakerLight.prototype.htmlFor.defaults, { srcScriptsMap : null } );
defaults.srcPath = null;
defaults.dstPath = 'Index.html';
defaults.basePath = null;
defaults.relative = 1;
defaults.nativize = 0;

//

function serve( o )
{
  let starter = this;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let maker = starter.maker;

  o.rootPath = path.resolve( o.rootPath );
  o.starter = starter;

  let servlet = new starter.Servlet( o );

  servlet.form();

  return servlet;
}

serve.defaults =
{
  rootPath : null,
}

// --
// relations
// --

let Composes =
{

  verbosity : 3,
  servletsMap : _.define.own({}),

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

  filesWrap,
  htmlFor,
  serve,

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
{

  require( './IncludeMid.s' );

}

})();
