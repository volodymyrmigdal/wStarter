( function _WebUri_s_() {

'use strict';

/**
  @module Tools/base/WebUri - Collection of routines to operate web URIs ( URLs ) in the reliable and consistent way. Module WebUri extends Uri module to handle host and port parts of URI in a way appropriate for world wide web resources. This module leverages parsing, joining, extracting, normalizing, nativizing, resolving paths. Use the module to get uniform experience from playing with paths on different platforms.
*/

/**
 * @file WebUri.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  let _ = _global_.wTools;

  _.include( 'wPathFundamentals' );
  _.include( 'wUriFundamentals' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.uri;
let Self = _.weburi = _.weburi || Object.create( Parent );

// --
//
// --

function isAbsolute( path )
{
  let parent = this.path;
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ) );
  if( this.isGlobal( path ) )
  return true;
  return parent.isAbsolute( path );
}

//

let join = Parent._joining_functor( 'join', 1 );

//

let urisJoin = _.path._pathMultiplicator_functor
({
  routine : join,
});

//
//
// function resolve()
// {
//   let parent = this.path;
//   let result = Object.create( null );
//   let srcs = [];
//   let parsed = false;
//
//   for( let s = 0 ; s < arguments.length ; s++ )
//   {
//     if( this.isGlobal( arguments[ s ] ) )
//     {
//       parsed = true;
//       srcs[ s ] = this.parseConsecutive( arguments[ s ] );
//     }
//     else
//     {
//       srcs[ s ] = { longPath : arguments[ s ] };
//     }
//   }
//
//   for( let s = 0 ; s < srcs.length ; s++ )
//   {
//     let src = srcs[ s ];
//
//     if( !result.protocol && src.protocol !== undefined )
//     result.protocol = src.protocol;
//
//     // if( !result.host && src.host !== undefined )
//     // result.host = src.host;
//     //
//     // if( !result.port && src.port !== undefined )
//     // result.port = src.port;
//
//     if( !result.longPath && src.longPath !== undefined )
//     {
//       if( !_.strIsNotEmpty( src.longPath ) )
//       src.longPath = this._rootStr;
//
//       result.longPath = src.longPath;
//     }
//     else
//     {
//       result.longPath = parent.resolve( result.longPath, src.longPath );
//     }
//
//     if( src.query !== undefined )
//     if( !result.query )
//     result.query = src.query;
//     else
//     result.query = src.query + '&' + result.query;
//
//     if( !result.hash && src.hash !==undefined )
//     result.hash = src.hash;
//
//   }
//
//   if( !parsed )
//   return result.longPath;
//
//   return this.str( result );
// }

function resolve()
{
  let parent = this.path;
  let joined = this.join.apply( this, arguments );
  let parsed = this.parseAtomic( joined );
  parsed.localPath = parent.resolve( parsed.localPath );
  return this.str( parsed );
}

//

let urisResolve = _.path._pathMultiplicator_functor
({
  routine : resolve,
});

// --
// declare Fields
// --

let Fields =
{
  single : Self,
}

// --
// declare routines
// --

let Routines =
{

  isAbsolute : isAbsolute,

  join : join,
  urisJoin : urisJoin,

  resolve : resolve,
  urisResolve : urisResolve,

}

_.mapSupplementOwn( Self, Fields );
_.mapSupplementOwn( Self, Routines );

Self.Init();

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
