( function _ArraySparse_s_() {

'use strict';

/**
  @module Tools/base/ArraySparse - Collection of routines to operate effectively sparse array. A sparse array is an vector of intervals which split number space into two subsets, internal and external. ArraySparse leverage iterating, inverting, minimizing and other operations on a sparse array. Use the module to increase memory efficiency of your algorithms.
*/

/**
 * @file ArraySparse.s
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

}

//

let Self = _global_.wTools.sparse = _global_.wTools.sparse || Object.create( null );
let _global = _global_;
let _ = _global_.wTools;

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

let _arraySlice = _.longSlice;

// --
// sparse
// --

function is( sparse )
{
  _.assert( arguments.length === 1 );

  if( !_.longIs( sparse ) )
  return false;

  if( sparse.length % 2 !== 0 )
  return false;

  return true;
}

//

function eachRange( sparse, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( _.sparse.is( sparse ) );

  let index = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ], sparse[ s*2 + 1 ] ];
    onEach( range, s, sparse );
  }

}

//

function eachElement( sparse, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( _.sparse.is( sparse ) );

  let index = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ],sparse[ s*2 + 1 ] ];
    for( let key = range[ 0 ], kl = range[ 1 ] ; key < kl ; key++ )
    {
      onEach.call( this,key,index,range,1 );
      index += 1;
    }
  }

}

//

function eachElementEvenOutside( sparse,length,onEach )
{

  _.assert( arguments.length === 3 );
  _.assert( _.sparse.is( sparse ) );
  _.assert( _.numberIs( length ) );
  _.assert( _.routineIs( onEach ) );

  let index = 0;
  let was = 0;
  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ],sparse[ s*2 + 1 ] ];

    for( let key = was ; key < range[ 0 ] ; key++ )
    {
      onEach.call( this,key,index,range,0 );
      index += 1;
    }

    for( let key = range[ 0 ], kl = range[ 1 ] ; key < kl ; key++ )
    {
      onEach.call( this,key,index,range,1 );
      index += 1;
    }

    was = range[ 1 ];
  }

  for( let key = was ; key < length ; key++ )
  {
    onEach.call( this,key,index,range,0 );
    index += 1;
  }

}

//

function elementsTotal( sparse )
{
  let result = 0;

  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) );

  for( let s = 0, sl = sparse.length / 2 ; s < sl ; s++ )
  {
    let range = [ sparse[ s*2 + 0 ],sparse[ s*2 + 1 ] ];
    result += range[ 1 ] - range[ 0 ];
  }

  return result;
}

//

function minimize( sparse )
{

  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) )

  if( sparse.length === 0 )
  {
    return _.entityMake( sparse, 0 );
  }

  let l = 0;

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {

    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    if( e1 !== b2 )
    l += 2;

  }

  l += 2;

  let result = _.entityMake( sparse, l );
  let b = sparse[ 0 ];
  let e = sparse[ 1 ];
  let r = 0;

  /* */

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {

    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    if( e1 !== b2 )
    {
      result[ r+0 ] = b;
      result[ r+1 ] = e;
      b = b2;
      e = sparse[ i+1 ];
      r += 2;
    }
    else
    {
      e = sparse[ i+1 ];
    }

  }

  /* */

  result[ r+0 ] = b;
  result[ r+1 ] = e;
  r += 2;

  _.assert( r === l );

  return result;
}

//

function invertFinite( sparse )
{
  _.assert( arguments.length === 1 );
  _.assert( _.sparse.is( sparse ) )

  if( !sparse.length )
  return _.entityMake( sparse, 0 );

  if( sparse.length === 2 && sparse[ 0 ] === sparse[ 1 ] )
  return _.entityShallowClone( sparse );

  let needPre = 0;
  let needPost = 0;

  if( sparse.length >= 2 )
  {
    needPre = sparse[ 0 ] === sparse[ 1 ] ? 0 : 1;
    needPost = sparse[ sparse.length-2 ] === sparse[ sparse.length-1 ] ? 0 : 1;
  }

  let l = sparse.length + needPre*2 + needPost*2 - 2;
  let result = _.entityMake( sparse, l );
  let r = 0;

  _.assert( l % 2 === 0 );

  if( needPre )
  {
    result[ r+0 ] = sparse[ 0 ];
    result[ r+1 ] = sparse[ 0 ];
    r += 2;
  }

  if( needPost )
  {
    result[ result.length-2 ] = sparse[ sparse.length-1 ];
    result[ result.length-1 ] = sparse[ sparse.length-1 ];
  }

  for( let i = 2 ; i < sparse.length ; i += 2 )
  {
    let e1 = sparse[ i-1 ];
    let b2 = sparse[ i+0 ];

    result[ r+0 ] = e1;
    result[ r+1 ] = b2;
    r += 2;
  }

  return result;
}

// --
// declare
// --

let Proto =
{

  // sparse

  is : is,

  eachRange : eachRange,
  eachElement : eachElement,
  eachElementEvenOutside : eachElementEvenOutside,
  elementsTotal : elementsTotal,

  minimize : minimize,
  invertFinite : invertFinite,

}

_.mapExtend( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
