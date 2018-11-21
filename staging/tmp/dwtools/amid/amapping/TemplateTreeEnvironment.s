( function _TemplateTreeEnvironment_s_( ) {

'use strict';

/**
  @module Tools/base/TemplateTreeEnvironment - Class to resolve tree-like with links data structures or paths in the structure. TemplateTreeEnvironment extends TemplateTreeResolver to been able to resolve paths into a files system. Use the module to resolve template or path to value.
*/

/**
 * @file TemplateTreeEnvironment.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTemplateTreeResolver' );
  _.include( 'wPathFundamentals' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = wTemplateTreeResolver;
let Self = function wTemplateTreeEnvironment( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'TemplateTreeEnvironment';

// --
// inter
// --

function init( o )
{
  let self = this;

  Parent.prototype.init.call( self,o );

  if( self.constructor === Self )
  Object.preventExtensions( self );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( self.path === null )
  self.path = _.path;

}

//

function _valueGet( name )
{
  let self = this;
  let name2 = name;

  if( self.front !== null )
  name2 = _.entitySelect
  ({
    container : self.front,
    query : name,
  });

  let result = self._resolve( name2 );

  _.assert( arguments.length === 1 );

  // if( _.errIs( result ) )
  // return;

  if( result instanceof self.ErrorQuerying )
  return result;

  if( result === undefined )
  return;

  if( _.errIs( result ) )
  throw result;

  return result;
}

//

function valueTry( name,def )
{
  let self = this;
  let result = self._valueGet( name );

  _.assert( arguments.length === 1 || def !== undefined, 'def should not be undefined if used' );
  _.assert( arguments.length === 1 || arguments.length === 2, 'valueTry expects 1 or 2 arguments' );

  if( def !== undefined )
  if( result === undefined || _.errIs( result ) )
  result = def;

  if( self.verbosity )
  logger.debug( 'value :',name,'->',result );

  return result;
}

//

function valueGet( name )
{
  let self = this;
  let result = self._valueGet( name );

  _.assert( arguments.length === 1, 'valueGet expects 1 argument' );

  if( _.errIs( result ) )
  throw result;

  if( result === undefined )
  {
    debugger;
    throw _.err( 'Unknown variable', name );
  }

  return result;
}

//
//
// function _pathGet( name )
// {
//   let self = this;
//   let result = self.valueTry( name );
//
//   _.assert( arguments.length === 1 );
//
//   if( !result )
//   return;
//
//   result = self._pathNormalize( filePath );
//
//   if( self.verbosity )
//   logger.debug( 'path :',name,'->',result );
//
//   return result;
// }
//
//

function _pathNormalize( filePath )
{
  let self = this;

  filePath = self.path.join( self.rootDirPath, filePath );
  filePath = self.path.normalize( filePath );
  filePath = filePath.replace( /(?<!:|:\/)\/\//, '/' );

  return filePath;
}

//

function pathTry( name, def )
{
  let self = this;
  let result = self._valueGet( name );

  _.assert( arguments.length === 1 || arguments.length === 2, 'pathTry expects 1 or 2 arguments' );

  if( !result || _.errIs( result ) )
  result = def;

  result = self._pathNormalize( result );

  if( self.verbosity )
  logger.debug( 'path :', name, '->', result );

  return result;
}

//

function pathGet( name )
{
  let self = this;
  let result = self._valueGet( name );

  if( result === undefined )
  {
    debugger;
    throw _.err( 'Unknown variable', name );
  }

  result = self._pathNormalize( result );

  if( self.verbosity )
  logger.debug( 'path :', name, '->', result );

  return result;
}

//

function pathsNormalize()
{
  let self = this;

  for( let t in self.tree )
  {
    let src = self.tree[ t ];
    if( !_.strEnds( t,'Path' ) )
    continue;
    if( !_.strIs( src ) )
    continue;
    self.tree[ t ] = self.pathGet( src );
  }

  return self;
}

// --
// relations
// --

let Composes =
{
  verbosity : 0,
  rootDirPath : '',
}

let Associates =
{
  front : null,
  path : null,
}

let Restricts =
{
}

// --
// declare
// --

let Proto =
{

  init : init,

  _valueGet : _valueGet,
  valueTry : valueTry,
  valueGet : valueGet,
  value : valueGet,

  _pathNormalize : _pathNormalize,
  pathTry : pathTry,
  pathGet : pathGet,
  path : pathGet,

  pathsNormalize : pathsNormalize,

  // relations

  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

};

// define

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

_[ Self.shortName ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
