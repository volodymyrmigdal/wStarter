( function _aFundamental_s_() {

'use strict';

/**
  @module Tools/base/Fundamental - Collection of general purpose tools for solving problems. Fundamentally extend JavaScript without corrupting it, so may be used solely or in conjunction with another module of such kind. Tools contain hundreds of routines to operate effectively with Array, SortedArray, Map, RegExp, Buffer, Time, String, Number, Routine, Error and other fundamental types. The module provides advanced tools for diagnostics and errors handling. Use it to have a stronger foundation for the application.
*/

/**
 * @file aFundamental.s.
 */

/* experiment() */

// global

var _global = undefined;
if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
var _realGlobal = _global;
var _globalWas = _global._global_ || _global;
if( _global._global_ )
_global = _global._global_;
_global._global_ = _global;
_realGlobal._realGlobal_ = _realGlobal;

// veification

if( !_global_.WTOOLS_PRIVATE  )
{

  if( _global_.wBase )
  {
    if( _global_.wTools.usePath )
    _global_.wTools.usePath( __dirname + '/../..' );
    module[ 'exports' ] = _global_.wBase;
    return;
  }

  if( _global_.wBase )
  {
    throw new Error( 'wTools included several times' );
  }

}

// config

if( !_realGlobal.Config )
_realGlobal.Config = { debug : true }
if( _realGlobal.Config.debug === undefined )
_realGlobal.Config.debug = true;
if( _realGlobal.Config.platform === undefined )
_realGlobal.Config.platform = ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) ? 'nodejs' : 'browser';
if( _realGlobal.Config.isWorker === undefined )
_realGlobal.Config.isWorker = !!( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' );

if( !_global_.Config )
_global_.Config = { debug : true }
if( _global_.Config.debug === undefined )
_global_.Config.debug = true;
if( _global_.Config.platform === undefined )
_global_.Config.platform = ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) ? 'nodejs' : 'browser';
if( _global_.Config.isWorker === undefined )
_global_.Config.isWorker = !!( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' );

if(  !_global_.WTOOLS_PRIVATE  )
if( !_global_.Underscore && _global_._ )
_global_.Underscore = _global_._;

/**
 * wTools - Generic purpose tools of base level for solving problems in Java Script.
 * @class wTools
 */

if( _global !== _realGlobal_ && !!_global.wTools )
throw 'Multiple inclusions of Fundamental.s';

_global.wTools = _global.wTools || Object.create( null );
_realGlobal_.wTools = _realGlobal_.wTools || Object.create( null );
var Self = _global.wTools;
var _ = Self;

// specia globals

if( !_realGlobal_.def  )
{
  _realGlobal_.def = Symbol.for( 'default' );
  // _global_.all = Symbol.for( 'all' );
  // _global_.any = Symbol.for( 'any' );
  // _global_.none = Symbol.for( 'none' );
  _realGlobal_.nothing = Symbol.for( 'nothing' );
  _realGlobal_.dont = Symbol.for( 'dont' );
}

Self.def = _global_.def;
// Self.all = _global_.all;
// Self.any = _global_.any;
// Self.none = _global_.none;
Self.nothing = _global_.nothing;
Self.dont = _global_.dont;

// type aliases

_global_.U32x = Uint32Array;
_global_.U16x = Uint16Array;
_global_.U8x = Uint8Array;
_global_.Ux = _global_.U32x;

_global_.I32x = Int32Array;
_global_.I16x = Int16Array;
_global_.I8x = Int8Array;
_global_.Ix = _global_.I32x;

_global_.F64x = Float64Array;
_global_.F32x = Float32Array;
_global_.Fx = _global_.F32x;

//

var _ArrayIndexOf = Array.prototype.indexOf;
var _ArrayLastIndexOf = Array.prototype.lastIndexOf;
var _ArraySlice = Array.prototype.slice;
var _ArraySplice = Array.prototype.splice;
var _FunctionBind = Function.prototype.bind;
var _ObjectToString = Object.prototype.toString;
var _ObjectHasOwnProperty = Object.hasOwnProperty;
var _propertyIsEumerable = Object.propertyIsEnumerable;
var _ceil = Math.ceil;
var _floor = Math.floor;

// --
// multiplier
// --

function dup( ins, times, result )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( _.numberIs( times ) || _.longIs( times ),'dup expects times as number or array' );

  if( _.numberIs( times ) )
  {
    if( !result )
    result = new Array( times );
    for( var t = 0 ; t < times ; t++ )
    result[ t ] = ins;
    return result;
  }
  else if( _.longIs( times ) )
  {
    _.assert( times.length === 2 );
    var l = times[ 1 ] - times[ 0 ];
    if( !result )
    result = new Array( times[ 1 ] );
    for( var t = 0 ; t < l ; t++ )
    result[ times[ 0 ] + t ] = ins;
    return result;
  }
  else _.assert( 0,'unexpected' );

}

//

function multiple( src, times )
{
  _.assert( arguments.length === 2 );
  if( _.arrayLike( src ) )
  _.assert( src.length === times );
  else
  src = _.dup( src, times );
  return src;
}

//

function multipleAll( dsts )
{
  var length = undefined;

  _.assert( arguments.length === 1 );

  for( var d = 0 ; d < dsts.length ; d++ )
  if( _.arrayIs( dsts[ d ] ) )
  {
    length = dsts[ d ].length;
    break;
  }

  if( length === undefined )
  return dsts;

  for( var d = 0 ; d < dsts.length ; d++ )
  dsts[ d ] = _.multiple( dsts[ d ], length );

  return dsts;
}

// --
// entity iterator
// --

function eachSample( o )
{

  if( arguments.length === 2 || _.arrayLike( arguments[ 0 ] ) )
  {
    o =
    {
      sets : arguments[ 0 ],
      onEach : arguments[ 1 ],
    }
  }

  _.routineOptions( eachSample,o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.routineIs( o.onEach ) || o.onEach === null );
  _.assert( _.arrayIs( o.sets ) || _.mapLike( o.sets ) );
  _.assert( o.base === undefined && o.add === undefined );

  /* sample */

  if( !o.sample )
  o.sample = _.entityMakeTivial( o.sets );

  /* */

  var keys = _.longIs( o.sets ) ? _.arrayFromRange([ 0,o.sets.length ]) : _.mapKeys( o.sets );
  if( o.result && !_.arrayIs( o.result ) )
  o.result = [];
  var len = [];
  var indexnd = [];
  var index = 0;
  var l = _.entityLength( o.sets );

  /* sets */

  var sindex = 0;
  _.each( o.sets, function( e,k )
  {
    var set = o.sets[ k ];
    _.assert( _.longIs( set ) || _.primitiveIs( set ) );
    if( _.primitiveIs( set ) )
    o.sets[ k ] = [ set ];

    len[ sindex ] = _.entityLength( o.sets[ k ] );
    indexnd[ sindex ] = 0;
    sindex += 1;
  });

  /* */

  function firstSample()
  {

    var sindex = 0;
    _.each( o.sets, function( e,k )
    {
      o.sample[ k ] = o.sets[ k ][ indexnd[ sindex ] ];
      sindex += 1;
      if( !len[ k ] )
      return 0;
    });

    if( o.result )
    if( _.mapLike( o.sample ) )
    o.result.push( _.mapExtend( null, o.sample ) );
    else
    o.result.push( o.sample.slice() );

    return 1;
  }

  /* */

  function nextSample( i )
  {

    var k = keys[ i ];
    indexnd[ i ]++;

    if( indexnd[ i ] >= len[ i ] )
    {
      indexnd[ i ] = 0;
      o.sample[ k ] = o.sets[ k ][ indexnd[ i ] ];
    }
    else
    {
      o.sample[ k ] = o.sets[ k ][ indexnd[ i ] ];
      index += 1;

      if( o.result )
      if( _.mapLike( o.sample ) )
      o.result.push( _.mapExtend( null, o.sample ) );
      else
      o.result.push( o.sample.slice() );

      return 1;
    }

    return 0;
  }

  /* */

  function iterate()
  {

    if( o.leftToRight )
    for( var i = 0 ; i < l ; i++ )
    {
      if( nextSample( i ) )
      return 1;
    }
    else for( var i = l - 1 ; i >= 0 ; i-- )
    {
      if( nextSample( i ) )
      return 1;
    }

    return 0;
  }

  /* */

  if( !firstSample() )
  return o.result;

  do
  {
    if( o.onEach )
    o.onEach.call( o.sample, o.sample, index );
  }
  while( iterate() );

  if( o.result )
  return o.result;
  else
  return index;
}

eachSample.defaults =
{

  leftToRight : 1,
  onEach : null,

  sets : null,
  sample : null,

  result : 1,

}

//

function eachInRange( o )
{

  if( _.arrayIs( o ) )
  o = { range : o };

  _.routineOptions( eachInRange,o );
  if( _.numberIs( o.range ) )
  o.range = [ 0,o.range ];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.range.length === 2 );
  _.assert( o.increment >= 0 );

  var increment = o.increment;
  var range = o.range;
  var len = _.rangeNumberElements( range,o.increment );
  var value = range[ 0 ];

  if( o.estimate )
  {
    return { length : len };
  }

  if( o.result === null )
  o.result = new Float32Array( len );

  // if( o.batch === 0 )
  // o.batch = o.range[ 1 ] - o.range[ 0 ];

  /* begin */

  if( o.onBegin )
  o.onBegin.call( o );

  /* exec */

  function exec()
  {

    while( value < range[ 1 ] )
    {

      if( o.onEach )
      o.onEach.call( o,value,o.resultIndex );
      if( o.result )
      o.result[ o.resultIndex ] = value;

      value += increment;
      o.resultIndex += 1;
    }

  }

  if( len )
  exec();

  /* end */

  if( value > range[ 1 ] )
  if( o.onEnd )
  o.onEnd.call( o,o.result );

  /* return */

  if( o.result )
  return o.result;
  else
  return o.resultIndex;
}

eachInRange.defaults =
{
  result : null,
  resultIndex : 0,
  range : null,
  onBegin : null,
  onEnd : null,
  onEach : null,
  increment : 1,
  delay : 0,
  estimate : 0,
}

//

function eachInManyRanges( o )
{

  var len = 0;

  if( _.arrayIs( o ) )
  o = { range : o };

  _.routineOptions( eachInManyRanges,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.arrayIs( o.range ) );

  /* estimate */

  for( var r = 0 ; r < o.range.length ; r++ )
  {
    var range = o.range[ r ];
    if( _.numberIs( o.range ) )
    range = o.range[ r ] = [ 0,o.range ];
    len += _.rangeNumberElements( range,o.increment );
  }

  if( o.estimate )
  return { length : len };

  /* exec */

  if( o.result === null )
  o.result = new Float32Array( len );

  var ranges = o.range;
  for( var r = 0 ; r < ranges.length ; r++ )
  {
    o.range = ranges[ r ];
    _.eachInRange( o );
  }

  /* return */

  if( o.result )
  return o.result;
  else
  return o.resultIndex;

}

eachInManyRanges.defaults = Object.create( eachInRange.defaults )

//

function eachInMultiRange( o )
{

  if( !o.onEach )
  o.onEach = function( e )
  {
    console.log( e );
  }

  _.routineOptions( eachInMultiRange,o );
  _.assert( _.objectIs( o ) )
  _.assert( _.arrayIs( o.ranges ) || _.objectIs( o.ranges ),'eachInMultiRange :','expects o.ranges as array or object' )
  _.assert( _.routineIs( o.onEach ),'eachInMultiRange :','expects o.onEach as routine' )
  _.assert( !o.delta || _.strTypeOf( o.delta ) === _.strTypeOf( o.ranges ),'eachInMultiRange :','o.delta must be same type as ranges' );

  /* */

  var iterationNumber = 1;
  var l = 0;
  var delta = _.objectIs( o.delta ) ? [] : null;
  var ranges = [];
  var names = null;
  if( _.objectIs( o.ranges ) )
  {
    _.assert( _.objectIs( o.delta ) || !o.delta );

    names = [];
    var i = 0;
    for( var r in o.ranges )
    {
      names[ i ] = r;
      ranges[ i ] = o.ranges[ r ];
      if( o.delta )
      {
        if( !o.delta[ r ] )
        throw _.err( 'no delta for',r );
        delta[ i ] = o.delta[ r ];
      }
      i += 1;
    }

    l = names.length;

  }
  else
  {
    // ranges = o.ranges.slice();
    ranges = _.cloneJust( o.ranges );
    delta = _.longIs( o.delta ) ? o.delta.slice() : null;
    _.assert( !delta || ranges.length === delta.length, 'delta must be same length as ranges'  );
    l = o.ranges.length;
  }

  var last = ranges.length-1;

  /* adjust range */

  function adjustRange( r )
  {

    if( _.numberIs( ranges[ r ] ) )
    ranges[ r ] = [ 0,ranges[ r ] ];

    if( !_.longIs( ranges[ r ] ) )
    throw _.err( 'expects range as array :',ranges[ r ] );

    _.assert( ranges[ r ].length === 2 );
    _.assert( _.numberIs( ranges[ r ][ 0 ] ) );
    _.assert( _.numberIs( ranges[ r ][ 1 ] ) );

    if( _.numberIsInfinite( ranges[ r ][ 0 ] ) )
    ranges[ r ][ 0 ] = 1;
    if( _.numberIsInfinite( ranges[ r ][ 1 ] ) )
    ranges[ r ][ 1 ] = 1;

    iterationNumber *= ranges[ r ][ 1 ] - ranges[ r ][ 0 ];

  }

  if( _.objectIs( ranges ) )
  for( var r in ranges )
  adjustRange( r );
  else
  for( var r = 0 ; r < ranges.length ; r++ )
  adjustRange( r );

  /* estimate */

  if( o.estimate )
  {

    if( !ranges.length )
    return 0;

    return { length : iterationNumber };

  }

  /* */

  function getValue( arg ){ return arg.slice(); };
  if( names )
  getValue = function( arg )
  {
    var result = Object.create( null );
    for( var i = 0 ; i < names.length ; i++ )
    result[ names[ i ] ] = arg[ i ];
    return result;
  }

  /* */

  var indexFlat = 0;
  var indexNd = [];
  for( var r = 0 ; r < ranges.length ; r++ )
  {
    indexNd[ r ] = ranges[ r ][ 0 ];
    if( ranges[ r ][ 1 ] <= ranges[ r ][ 0 ] )
    return 0;
  }

  /* */


  while( indexNd[ last ] < ranges[ last ][ 1 ] )
  {

    var r = getValue( indexNd );
    if( o.result )
    o.result[ indexFlat ] = r;

    var res = o.onEach.call( o,r,indexFlat );

    if( res === false )
    break;

    indexFlat += 1;

    var c = 0;
    do
    {
      if( c >= ranges.length )
      break;
      if( c > 0 )
      indexNd[ c-1 ] = ranges[ c-1 ][ 0 ];
      if( delta )
      {
        _.assert( _.numberIsFinite( delta[ c ] ) && delta[ c ] > 0, 'delta must contain only positive numbers, incorrect element:', delta[ c ] );
        indexNd[ c ] += delta[ c ];
      }
      else
      indexNd[ c ] += 1;
      c += 1;
    }
    while( indexNd[ c-1 ] >= ranges[ c-1 ][ 1 ] );

  }

  /* */

  if( o.result )
  return o.result
  else
  return indexFlat;
}

eachInMultiRange.defaults =
{
  result : null,
  ranges : null,
  delta : null,
  onEach : null,
  estimate : 0,
}

//

function entityEach( src, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( onEach.length <= 2 );
  _.assert( _.routineIs( onEach ) );

  /* */

  if( _.longIs( src ) )
  {

    for( var k = 0 ; k < src.length ; k++ )
    {
      onEach( src[ k ], k, src );
    }

  }
  else if( _.objectLike( src ) )
  {

    for( var k in src )
    {
      onEach( src[ k ], k, src );
    }

  }
  else
  {
    onEach( src, undefined, undefined );
  }

  /* */

  return src;
}

//

function entityEachName( src, onEach )
{
  _.assert( arguments.length === 2 );
  _.assert( onEach.length <= 2 );
  _.assert( _.routineIs( onEach ) );

  /* */

  if( _.longIs( src ) )
  {

    for( var index = 0 ; index < src.length ; index++ )
    {
      onEach( src[ index ], undefined, index, src );
    }

  }
  else if( _.objectLike( src ) )
  {

    var index = 0;
    for( var k in src )
    {
      onEach( k, src[ k ], index, src );
      index += 1;
    }

  }
  else
  {
    onEach( src, undefined, undefined, undefined );
  }

  /* */

  return src;

  // if( arguments.length === 2 )
  // o = { src : arguments[ 0 ], onUp : arguments[ 1 ] }
  //
  // _.routineOptions( eachName, o );
  // _.assert( arguments.length === 1 || arguments.length === 2 );
  // _.assert( o.onUp && o.onUp.length <= 3 );
  //
  // /* */
  //
  // if( _.longIs( o.src ) )
  // {
  //
  //   for( var index = 0 ; index < o.src.length ; index++ )
  //   {
  //     o.onUp.call( o, o.src[ index ], undefined, index );
  //   }
  //
  // }
  // else if( _.objectLike( o.src ) )
  // {
  //
  //   var index = 0;
  //   for( var k in o.src )
  //   {
  //     o.onUp.call( o, k, o.src[ k ], index );
  //     index += 1;
  //   }
  //
  // }
  // else _.assert( 0, 'not container' );
  //
  // /* */
  //
  // return src;
}

var defaults = entityEachName.defaults = Object.create( null );

defaults.src = null;
defaults.onUp = function( e,k ){};

//

function entityEachOwn( src, onEach )
{

  _.assert( arguments.length === 2 );
  _.assert( onEach.length <= 2 );
  _.assert( _.routineIs( onEach ) );

  /* */

  if( _.longIs( src ) )
  {

    for( var k = 0 ; k < src.length ; k++ )
    {
      onEach( src[ k ], k, src );
    }

  }
  else if( _.objectLike( src ) )
  {

    for( var k in src )
    {
      if( !_ObjectHasOwnProperty.call( src, k ) )
      continue;
      onEach( src[ k ], k, src );
    }

  }
  else
  {
    onEach( src, undefined, undefined );
  }

  /* */

  return src;
}

//

function entityAll( src, onEach )
{
  let result = true;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( onEach === undefined || ( _.routineIs( onEach ) && onEach.length <= 2 ) );

  /* */

  if( _.routineIs( onEach ) )
  {

    if( _.longIs( src ) )
    {

      for( var k = 0 ; k < src.length ; k++ )
      {
        result = onEach( src[ k ], k, src );
        if( !result )
        return result;
      }

    }
    else if( _.objectLike( src ) )
    {

      for( var k in src )
      {
        result = onEach( src[ k ], k, src );
        if( !result )
        return result;
      }

    }
    else
    {
      result = onEach( src, undefined, undefined );
      if( !result )
      return result;
    }

  }
  else
  {

    if( _.longIs( src ) )
    {

      for( var k = 0 ; k < src.length ; k++ )
      {
        result = src[ k ];
        if( !result )
        return result;
      }

    }
    else if( _.objectLike( src ) )
    {

      for( var k in src )
      {
        result = src[ k ];
        if( !result )
        return result;
      }

    }
    else
    {
      result = src;
      if( !result )
      return result;
    }

  }

  /* */

  return true;
}

//

function entityAny( src, onEach )
{
  let result = false;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( onEach === undefined || ( _.routineIs( onEach ) && onEach.length <= 2 ) );

  /* */

  if( _.routineIs( onEach ) )
  {

    if( _.longIs( src ) )
    {

      for( var k = 0 ; k < src.length ; k++ )
      {
        result = onEach( src[ k ], k, undefined );
        if( result )
        return result;
      }

    }
    else if( _.objectLike( src ) )
    {

      for( var k in src )
      {
        result = onEach( src[ k ], k, undefined );
        if( result )
        return result;
      }

    }
    else
    {
      result = onEach( src, undefined, undefined );
      if( result )
      return result;
    }

  }
  else
  {

    if( _.longIs( src ) )
    {

      for( var k = 0 ; k < src.length ; k++ )
      {
        result = src[ k ];
        if( result )
        return result;
      }

    }
    else if( _.objectLike( src ) )
    {

      for( var k in src )
      {
        result = src[ k ];
        if( result )
        return result;
      }

    }
    else
    {
      result = src;
      if( result )
      return result;
    }

  }

  /* */

  return false;
}

//

function entityNone( src, onEach )
{
  let result = true;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( onEach === undefined || ( _.routineIs( onEach ) && onEach.length <= 2 ) );

  /* */

  if( _.routineIs( onEach ) )
  {

    if( _.longIs( src ) )
    {

      for( var k = 0 ; k < src.length ; k++ )
      {
        result = onEach( src[ k ], k, src );
        if( result )
        return !result;
      }

    }
    else if( _.objectLike( src ) )
    {

      for( var k in src )
      {
        result = onEach( src[ k ], k, src );
        if( result )
        return !result;
      }

    }
    else
    {
      result = onEach( src, undefined, undefined );
      if( result )
      return !result;
    }

  }
  else
  {

    if( _.longIs( src ) )
    {

      for( var k = 0 ; k < src.length ; k++ )
      {
        result = src[ k ];
        if( result )
        return !result;
      }

    }
    else if( _.objectLike( src ) )
    {

      for( var k in src )
      {
        result = src[ k ];
        if( result )
        return !result;
      }

    }
    else
    {
      result = src;
      if( result )
      return !result;
    }

  }

  /* */

  return true;
}

//

/**
 * Function that produces an elements for entityMap result
 * @callback wTools~onEach
 * @param {*} val - The current element being processed in the entity.
 * @param {string|number} key - The index (if entity is array) or key of processed element.
 * @param {Array|Object} src - The src passed to entityMap.
 */

/**
 * Creates new instance with same as( src ) type. Elements of new instance results of calling a provided ( onEach )
 * function on every element of src. If entity is array, the new array has the same length as source.
 *
 * @example
  var numbers = [ 3, 4, 6 ];

  function sqr( v )
  {
    return v * v
  };

  var res = wTools.entityMap(numbers, sqr);
  // [ 9, 16, 36 ]
  // numbers is still [ 3, 4, 6 ]

  function checkSidesOfTriangle( v, i, src )
  {
    var sumOthers = 0,
      l = src.length,
      j;

    for ( j = 0; j < l; j++ )
    {
      if ( i === j ) continue;
      sumOthers += src[ j ];
    }
    return v < sumOthers;
  }

  var res = wTools.entityMap( numbers, checkSidesOfTriangle );
 // [ true, true, true ]
 *
 * @param {ArrayLike|ObjectLike} src - Entity, on each elements of which will be called ( onEach ) function.
 * @param {wTools~onEach} onEach - Function that produces an element of the new entity.
 * @returns {ArrayLike|ObjectLike} New entity.
 * @thorws {Error} If number of arguments less or more than 2.
 * @thorws {Error} If( src ) is not Array or ObjectLike.
 * @thorws {Error} If( onEach ) is not function.
 * @function entityMap
 * @memberof wTools
 */

function entityMap( src,onEach )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.routineIs( onEach ) );

  var result;

  if( _.longIs( src ) )
  {
    result = _.entityMake( src );
    for( var s = 0 ; s < src.length ; s++ )
    {
      result[ s ] = onEach( src[ s ], s, src );
      _.assert( result[ s ] !== undefined,'{-entityMap-} onEach should return defined values, to been able return undefined to delete element use ( entityFilter )' )
    }
  }
  else if( _.objectLike( src ) )
  {
    result = _.entityMake( src );
    for( var s in src )
    {
      result[ s ] = onEach( src[ s ], s, src );
      _.assert( result[ s ] !== undefined,'{-entityMap-} onEach should return defined values, to been able return undefined to delete element use ( entityFilter )' )
    }
  }
  else
  {
    result = onEach( src, undefined, undefined );
    _.assert( result !== undefined,'{-entityMap-} onEach should return defined values, to been able return undefined to delete element use ( entityFilter )' )

  }

  return result;
}

//

function entityFilter( src, onEach )
{
  var result;
  onEach = _selectorMake( onEach, 1 );

  _.assert( arguments.length === 2 );
  _.assert( _.objectLike( src ) || _.longIs( src ), () => 'expects objectLike or longIs src, but got ' + _.strTypeOf( src ) );
  _.assert( _.routineIs( onEach ) );

  /* */

  if( _.longIs( src ) )
  {
    result = _.longMakeSimilar( src,0 );
    for( var s = 0, d = 0 ; s < src.length ; s++, d++ )
    {
      var r = onEach.call( src,src[ s ],s,src );
      if( r === undefined )
      d--;
      else
      result[ d ] = r;
    }
    if( d < src.length )
    result = _.arraySlice( result, 0, d );
  }
  else
  {
    result = _.entityMake( src );
    for( var s in src )
    {
      r = onEach.call( src,src[ s ],s,src );
      if( r !== undefined )
      result[ s ] = r;
    }
  }

  /* */

  return result;
}

//

function _entityFilterDeep( o )
{

  var result;
  var onEach = _selectorMake( o.onEach,o.conditionLevels );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectLike( o.src ) || _.longIs( o.src ),'entityFilter : expects objectLike or longIs src, but got',_.strTypeOf( o.src ) );
  _.assert( _.routineIs( onEach ) );

  /* */

  if( _.longIs( o.src ) )
  {
    result = _.longMakeSimilar( o.src,0 );
    for( var s = 0, d = 0 ; s < o.src.length ; s++, d++ )
    {
      var r = onEach.call( o.src,o.src[ s ],s,o.src );
      if( r === undefined )
      d--;
      else
      result[ d ] = r;
    }
    debugger;
    if( d < o.src.length )
    result = _.arraySlice( result, 0, d );
  }
  else
  {
    result = _.entityMake( o.src );
    for( var s in o.src )
    {
      r = onEach.call( o.src,o.src[ s ],s,o.src );
      if( r !== undefined )
      result[ s ] = r;
    }
  }

  /* */

  return result;
}

_entityFilterDeep.defaults =
{
  src : null,
  onEach : null,
  conditionLevels : 1,
}

//

function entityFilterDeep( src, onEach )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return _entityFilterDeep
  ({
    src : src,
    onEach : onEach,
    conditionLevels : 1024,
  });
}

// --
// entity modifier
// --

function enityExtend( dst, src )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.objectIs( src ) || _.longIs( src ) )
  {

    _.each( src,function( e,k )
    {
      dst[ k ] = e;
    });

  }
  else
  {

    dst = src;

  }

  return dst;
}

//

function enityExtendAppending( dst,src )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.objectIs( src ) )
  {

    _.each( src,function( e,k )
    {
      dst[ k ] = e;
    });

  }
  else if( _.longIs( src ) )
  {

    if( dst === null || dst === undefined )
    dst = _.longSlice( src );
    else
    _.arrayAppendArray( dst,src );

  }
  else
  {

    dst = src;

  }

  return dst;
}

//

function entityMake( src,length )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( _.arrayIs( src ) )
  {
    return new Array( length !== undefined ? length : src.length );
  }
  else if( _.longIs( src ) )
  {
    if( _.bufferTypedIs( src ) || _.bufferNodeIs( src ) )
    return new src.constructor( length !== undefined ? length : src.length );
    else
    return new Array( length !== undefined ? length : src.length );
  }
  else if( _.mapIs( src ) )
  {
    return Object.create( null );
  }
  else if( _.objectIs( src ) )
  {
    return new src.constructor();
  }
  else _.assert( 0,'unexpected' );

}

//

function entityMakeTivial( src,length )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( _.arrayIs( src ) )
  {
    return new Array( length !== undefined ? length : src.length );
  }
  else if( _.longIs( src ) )
  {
    if( _.bufferTypedIs( src ) || _.bufferNodeIs( src ) )
    return new src.constructor( length !== undefined ? length : src.length );
    else
    return new Array( length !== undefined ? length : src.length );
  }
  else if( _.objectIs( src ) )
  {
    return Object.create( null );
  }
  else _.assert( 0,'unexpected' );

}

//

/**
 * Copies entity( src ) into( dst ) or returns own copy of( src ).Result depends on several moments:
 * -If( src ) is a Object - returns clone of( src ) using ( onRecursive ) callback function if its provided;
 * -If( dst ) has own 'copy' routine - copies( src ) into( dst ) using this routine;
 * -If( dst ) has own 'set' routine - sets the fields of( dst ) using( src ) passed to( dst.set );
 * -If( src ) has own 'clone' routine - returns clone of( src ) using ( src.clone ) routine;
 * -If( src ) has own 'slice' routine - returns result of( src.slice ) call;
 * -Else returns a copy of entity( src ).
 *
 * @param {object} dst - Destination object.
 * @param {object} src - Source object.
 * @param {routine} onRecursive - The callback function to copy each [ key, value ].
 * @see {@link wTools.mapCloneAssigning} Check this function for more info about( onRecursive ) callback.
 * @returns {object} Returns result of entities copy operation.
 *
 * @example
 * var dst = { set : function( src ) { this.str = src.src } };
 * var src = { src : 'string' };
 *  _.entityAssign( dst, src );
 * console.log( dst.str )
 * //returns "string"
 *
 * @example
 * var dst = { copy : function( src ) { for( var i in src ) this[ i ] = src[ i ] } }
 * var src = { src : 'string', num : 123 }
 *  _.entityAssign( dst, src );
 * console.log( dst )
 * //returns Object {src: "string", num: 123}
 *
 * @example
 * //returns 'string'
 *  _.entityAssign( null, new String( 'string' ) );
 *
 * @function entityAssign
 * @throws {exception} If( arguments.length ) is not equal to 3 or 2.
 * @throws {exception} If( onRecursive ) is not a Routine.
 * @memberof wTools
 *
 */

function entityAssign( dst,src,onRecursive )
{
  var result;

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( arguments.length < 3 || _.routineIs( onRecursive ) );

  if( src === null )
  {

    result = src;

  }
  else if( dst && _.routineIs( dst.copy ) )
  {

    dst.copy( src );

  }
  else if( src && _.routineIs( src.clone ) )
  {

    if( dst instanceof src.constructor )
    {
      throw _.err( 'not tested' );
      result = src.clone( dst );
    }
    else if( _.primitiveIs( dst ) || _.longIs( dst ) )
    {
      result = src.clone();
    }
    else _.assert( 0,'unknown' );

  }
  else if( src && _.routineIs( src.slice ) )
  {

    result = src.slice();

  }
  else if( dst && _.routineIs( dst.set ) )
  {

    dst.set( src );

  }
  else if( _.objectIs( src ) )
  {

    if( onRecursive )
    result = _.mapCloneAssigning({ srcMap : src, dstMap : _.primitiveIs( dst ) ? Object.create( null ) : dst, onField : onRecursive } );
    else
    result = _.mapCloneAssigning({ srcMap : src });

  }
  else
  {

    result = src;

  }

  return result;
}

//

/**
 * Short-cut for entityAssign function. Copies specified( name ) field from
 * source container( srcContainer ) into( dstContainer ).
 *
 * @param {object} dstContainer - Destination object.
 * @param {object} srcContainer - Source object.
 * @param {string} name - Field name.
 * @param {mapCloneAssigning~onField} onRecursive - The callback function to copy each [ key, value ].
 * @see {@link wTools.mapCloneAssigning} Check this function for more info about( onRecursive ) callback.
 * @returns {object} Returns result of entities copy operation.
 *
 * @example
 * var dst = {};
 * var src = { a : 'string' };
 * var name = 'a';
 * _.entityAssignFieldFromContainer(dst, src, name );
 * console.log( dst.a === src.a );
 * //returns true
 *
 * @example
 * var dst = {};
 * var src = { a : 'string' };
 * var name = 'a';
 * function onRecursive( dstContainer,srcContainer,key )
 * {
 *   _.assert( _.strIs( key ) );
 *   dstContainer[ key ] = srcContainer[ key ];
 * };
 * _.entityAssignFieldFromContainer(dst, src, name, onRecursive );
 * console.log( dst.a === src.a );
 * //returns true
 *
 * @function entityAssignFieldFromContainer
 * @throws {exception} If( arguments.length ) is not equal to 3 or 4.
 * @memberof wTools
 *
 */

function entityAssignFieldFromContainer( dstContainer,srcContainer,name,onRecursive )
{
  var result;

  _.assert( _.strIs( name ) || _.symbolIs( name ) );
  _.assert( arguments.length === 3 || arguments.length === 4 );

  var dstValue = _ObjectHasOwnProperty.call( dstContainer,name ) ? dstContainer[ name ] : undefined;
  var srcValue = srcContainer[ name ];

  if( onRecursive )
  result = entityAssign( dstValue, srcValue, onRecursive );
  else
  result = entityAssign( dstValue, srcValue );

  if( result !== undefined )
  dstContainer[ name ] = result;

  return result;
}

//

/**
 * Short-cut for entityAssign function. Assigns value of( srcValue ) to container( dstContainer ) field specified by( name ).
 *
 * @param {object} dstContainer - Destination object.
 * @param {object} srcValue - Source value.
 * @param {string} name - Field name.
 * @param {mapCloneAssigning~onField} onRecursive - The callback function to copy each [ key, value ].
 * @see {@link wTools.mapCloneAssigning} Check this function for more info about( onRecursive ) callback.
 * @returns {object} Returns result of entity field assignment operation.
 *
 * @example
 * var dstContainer = { a : 1 };
 * var srcValue = 15;
 * var name = 'a';
 * _.entityAssignField( dstContainer, srcValue, name );
 * console.log( dstContainer.a );
 * //returns 15
 *
 * @function entityAssignField
 * @throws {exception} If( arguments.length ) is not equal to 3 or 4.
 * @memberof wTools
 *
 */

function entityAssignField( dstContainer,srcValue,name,onRecursive )
{
  var result;

  _.assert( _.strIs( name ) || _.symbolIs( name ) );
  _.assert( arguments.length === 3 || arguments.length === 4 );

  var dstValue = dstContainer[ name ];

  if( onRecursive )
  {
    throw _.err( 'not tested' );
    result = entityAssign( dstValue, srcValue,onRecursive );
  }
  else
  {
    result = entityAssign( dstValue, srcValue );
  }

  if( result !== undefined )
  dstContainer[ name ] = result;

  return result;
}

//

/**
 * Returns atomic entity( src ) casted into type of entity( ins ) to avoid unexpected implicit type casts.
 *
 * @param {object} src - Source object.
 * @param {object} ins - Type of( src ) depends on type of this object.
 * @returns {object} Returns object( src ) with  type of( ins ).
 *
 * @example
 * //returns "string"
 * typeof _.entityCoerceTo( 1, '1' )
 *
 * @example
 * //returns "number"
 * typeof _.entityCoerceTo( "1" , 1 )
 *
 * @example
 * //returns "boolean"
 * typeof _.entityCoerceTo( "1" , true )
 *
 * @function entityCoerceTo
 * @throws {exception} If only one or no arguments provided.
 * @throws {exception} If type of( ins ) is not supported.
 * @memberof wTools
 *
 */

function entityCoerceTo( src,ins )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.numberIs( ins ) )
  {

    return _.numberFrom( src );

  }
  else if( _.strIs( ins ) )
  {

    return _.strFrom( src );

  }
  else if( _.boolIs( ins ) )
  {

    return _.boolFrom( src );

  }
  else _.assert( 0,'unknown type to coerce to : ' + _.strTypeOf( ins ) );

}

//

function entityFreeze( src )
{
  var _src = src;

  if( _.bufferTypedIs( src ) )
  {
    src = src.buffer;
    debugger;
  }

  Object.freeze( src );

  return _src;
}

//

function entityShallowClone( src )
{

  if( _.primitiveIs( src ) )
  return src;
  else if( _.mapIs( src ) )
  return _.mapShallowClone( src )
  else if( _.longIs( src ) )
  return _.longShallowClone( src );
  else _.assert( 0, 'Not clear how to shallow clone', _.strTypeOf( src ) );

}

// --
// entity checker
// --

/**
 * Checks if object( src ) has any NaN. Also works with arrays and maps. Works recursively.
 *
 * @param {object} src - Source object.
 * @returns {boolean} Returns result of check for NaN.
 *
 * @example
 * //returns true
 * _.entityHasNan( NaN )
 *
 * @example
 * //returns true
 * var arr = [ NaN, 1, 2 ];
 * _.entityHasNan( arr );
 *
 * @function entityHasNan
 * @throws {exception} If no argument provided.
 * @memberof wTools
 *
 */

function entityHasNan( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  var result = false;
  if( src === undefined )
  {
    return true;
  }
  else if( _.numberIs( src ) )
  {
    return isNaN( src );
  }
  else if( _.arrayLike( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( entityHasNan( src[ s ] ) )
    {
      return true;
    }
  }
  else if( _.objectIs( src ) )
  {
    for( s in src )
    if( entityHasNan( src[ s ] ) )
    {
      return true;
    }
  }

  return result;
}

//

/**
 * Checks if object( src ) or array has any undefined property. Works recursively.
 *
 * @param {object} src - Source object.
 * @returns {boolean} Returns result of check for undefined.
 *
 * @example
 * //returns true
 * _.entityHasUndef( undefined )
 *
 * @example
 * //returns true
 * var arr = [ undefined, 1, 2 ];
 * _.entityHasUndef( arr );
 *
 * @function entityHasUndef
 * @throws {exception} If no argument provided.
 * @memberof wTools
 *
 */

function entityHasUndef( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  var result = false;
  if( src === undefined )
  {
    return true;
  }
  else if( _.arrayLike( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( entityHasUndef( src[ s ] ) )
    {
      return true;
    }
  }
  else if( _.objectIs( src ) )
  {
    for( s in src )
    if( entityHasUndef( src[ s ] ) )
    {
      return true;
    }
  }
  return result;

}

// --
// entity selector
// --

/**
 * Returns "length" of entity( src ). Representation of "length" depends on type of( src ):
 *  - For object returns number of it own enumerable properties;
 *  - For array or array-like object returns value of length property;
 *  - For undefined returns 0;
 *  - In other cases returns 1.
 *
 * @param {*} src - Source entity.
 * @returns {number} Returns "length" of entity.
 *
 * @example
 * //returns 3
 * _.entityLength( [ 1, 2, 3 ] );
 *
 * @example
 * //returns 1
 * _.entityLength( 'string' );
 *
 * @example
 * //returns 2
 * _.entityLength( { a : 1, b : 2 } );
 *
 * @example
 * //returns 0
 * var src = undefined;
 * _.entityLength( src );
 *
 * @function entityLength
 * @memberof wTools
*/

function entityLength( src )
{
  if( src === undefined ) return 0;
  if( _.longIs( src ) )
  return src.length;
  else if( _.objectLike( src ) )
  return _.mapOwnKeys( src ).length;
  else return 1;
}

//

/**
 * Returns "size" of entity( src ). Representation of "size" depends on type of( src ):
 *  - For string returns value of it own length property;
 *  - For array-like entity returns value of it own byteLength property for( ArrayBuffer, TypedArray, etc )
 *    or length property for other;
 *  - In other cases returns null.
 *
 * @param {*} src - Source entity.
 * @returns {number} Returns "size" of entity.
 *
 * @example
 * //returns 6
 * _.entitySize( 'string' );
 *
 * @example
 * //returns 3
 * _.entitySize( [ 1, 2, 3 ] );
 *
 * @example
 * //returns 8
 * _.entitySize( new ArrayBuffer( 8 ) );
 *
 * @example
 * //returns null
 * _.entitySize( 123 );
 *
 * @function entitySize
 * @memberof wTools
*/

function entitySize( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.strIs( src ) )
  return src.length;

  if( _.primitiveIs( src ) )
  return null;

  if( _.numberIs( src.byteLength ) )
  return src.byteLength;

  if( _.longIs( src ) )
  return src.length;

  return null;
}

//

/**
 * Returns value from entity( src ) using position provided by argument( index ).
 * For object routine iterates over all properties and returns value when counter reaches( index ).
 *
 * @param {*} src - Source entity.
 * @param {number} index - Specifies position of needed value.
 * @returns {*} Returns value at specified position.
 *
 * @example
 * //returns 1
 * _.entityValueWithIndex( [ 1, 2, 3 ], 0);
 *
 * @example
 * //returns 123
 * _.entityValueWithIndex( { a : 'str', b : 123 }, 1 )
 *
 * @example
 * //returns undefined
 * _.entityValueWithIndex( { a : 'str', b : 123 }, 2 )
 *
 * @function entityValueWithIndex
 * @memberof wTools
*/

function entityValueWithIndex( src,index )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.numberIs( index ) );

  if( _.arrayLike( src ) )
  {
    return src[ index ];
  }
  else if( _.objectIs( src ) )
  {
    var i = 0;
    for( var s in src )
    {
      if( i === index )
      return src[ s ];
      i++;
    }
  }
  else if( _.strIs( src ) )
  {
    return src[ index ];
  }
  else _.assert( 0,'unknown kind of argument',_.strTypeOf( src ) );

}

//

/**
 * Searchs value( value ) in entity( src ) and returns index/key that represent that value or
 * null if nothing finded.
 *
 * @param {*} src - Source entity.
 * @param {*} value - Specifies value to search.
 * @returns {*} Returns specific index/key or null.
 *
 * @example
 * //returns 2
 * _.entityKeyWithValue( [ 1, 2, 3 ], 3);
 *
 * @example
 * //returns null
 * _.entityKeyWithValue( { a : 'str', b : 123 }, 1 )
 *
 * @example
 * //returns "b"
 * _.entityKeyWithValue( { a : 'str', b : 123 }, 123 )
 *
 * @function entityKeyWithValue
 * @memberof wTools
*/

function entityKeyWithValue( src,value )
{
  var result = null;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.arrayLike( src ) )
  {
    result = src.indexOf( value );
  }
  else if( _.objectIs( src ) )
  {
    var i = 0;
    for( var s in src )
    {
      if( src[ s ] == value ) return s;
    }
  }
  else if( _.strIs( src ) )
  {
    result = src.indexOf( value );
  }
  else _.assert( 0,'unknown kind of argument',_.strTypeOf( src ) );

  if( result === -1 )
  result = null;

  return result;
}

//

/**
 * Returns generated function that takes single argument( e ) and can be called to check if object( e )
 * has at least one key/value pair that is represented in( condition ).
 * If( condition ) is provided as routine, routine uses it to check condition.
 * Generated function returns origin( e ) if conditions is true, else undefined.
 *
 * @param {object|function} condition - Map to compare with( e ) or custom function.
 * @returns {function} Returns condition check function.
 *
 * @example
 * //returns Object {a: 1}
 * var check = _._selectorMake( { a : 1, b : 1, c : 1 } );
 * check( { a : 1 } );
 *
 * @example
 * //returns false
 * function condition( src ){ return src.y === 1 }
 * var check = _._selectorMake( condition );
 * check( { a : 2 } );
 *
 * @function _selectorMake
 * @throws {exception} If no argument provided.
 * @throws {exception} If( condition ) is not a Routine or Object.
 * @memberof wTools
*/

function _selectorMake( condition, levels )
{
  var result;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.routineIs( condition ) || _.objectIs( condition ) );

  if( _.objectIs( condition ) )
  {
    var template = condition;
    condition = function selector( e )
    {
      if( e === template )
      return e;
      if( !_.objectLike( e ) )
      return;
      var satisfied = _.mapSatisfy
      ({
        template : template,
        src : e,
        levels : levels
      });
      if( satisfied )
      return e;
    };
  }

  return condition;
}

//

function entityVals( src )
{
  var result = [];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( !_.primitiveIs( src ) );

  if( _.longIs( src ) )
  return src;

  for( var s in src )
  result.push( src[ s ] );

  return result;
}

//

/**
 * The result of _entityMost routine object.
 * @typedef {Object} wTools~entityMostResult
 * @property {Number} index - Index of found element.
 * @property {String|Number} key - If the search was on map, the value of this property sets to key of found element.
 * Else if search was on array - to index of found element.
 * @property {Number} value - The found result of onEvaluate, if onEvaluate don't set, this value will be same as element.
 * @property {Number} element - The appropriate element for found value.
 */

/**
 * Returns object( wTools~entityMostResult ) that contains min or max element of entity, it depends on( returnMax ).
 *
 * @param {ArrayLike|Object} src - Source entity.
 * @param {Function} onEvaluate  - ( onEach ) function is called for each element of( src ).If undefined routine uses it own function.
 * @param {Boolean} returnMax  - If true - routine returns maximum, else routine returns minimum value from entity.
 * @returns {wTools~entityMostResult} Object with result of search.
 *
 * @example
 * //returns { index: 0, key: 0, value: 1, element: 1 }
 * _._entityMost([ 1, 3, 3, 9, 10 ], undefined, 0 );
 *
 * @example
 * //returns { index: 4, key: 4, value: 10, element: 10 }
 * _._entityMost( [ 1, 3, 3, 9, 10 ], undefined, 1 );
 *
 * @example
 * //returns { index: 4, key: 4, value: 10, element: 10 }
 * _._entityMost( { a : 1, b : 2, c : 3 }, undefined, 0 );
 *
 * @private
 * @function _entityMost
 * @throws {Exception} If( arguments.length ) is not equal 3.
 * @throws {Exception} If( onEvaluate ) function is not implemented.
 * @memberof wTools
 */

function _entityMost( src, onEvaluate, returnMax )
{

  if( onEvaluate === undefined )
  onEvaluate = function( element ){ return element; }

  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( onEvaluate.length === 1,'not mplemented' );

  var onCompare = null;

  if( returnMax )
  onCompare = function( a,b )
  {
    return a-b;
  }
  else
  onCompare = function( a,b )
  {
    return b-a;
  }

  _.assert( onEvaluate.length === 1 );
  _.assert( onCompare.length === 2 );

  var result = { index : -1, key : undefined, value : undefined, element : undefined };

  if( _.longIs( src ) )
  {

    if( src.length === 0 )
    return result;
    result.key = 0;
    result.value = onEvaluate( src[ 0 ] );
    result.element = src[ 0 ];

    for( var s = 0 ; s < src.length ; s++ )
    {
      var value = onEvaluate( src[ s ] );
      if( onCompare( value,result.value ) > 0 )
      {
        result.key = s;
        result.value = value;
        result.element = src[ s ];
      }
    }
    result.index = result.key;

  }
  else
  {

    debugger;
    for( var s in src )
    {
      result.index = 0;
      result.key = s;
      result.value = onEvaluate( src[ s ] );
      result.element = src[ s ]
      break;
    }

    var index = 0;
    for( var s in src )
    {
      var value = onEvaluate( src[ s ] );
      if( onCompare( value,result.value ) > 0 )
      {
        result.index = index;
        result.key = s;
        result.value = value;
        result.element = src[ s ];
      }
      index += 1;
    }

  }

  return result;
}

//

/**
 * Short-cut for _entityMost() routine. Returns object( wTools~entityMostResult ) with smallest value from( src ).
 *
 * @param {ArrayLike|Object} src - Source entity.
 * @param {Function} onEvaluate  - ( onEach ) function is called for each element of( src ).If undefined routine uses it own function.
 * @returns {wTools~entityMostResult} Object with result of search.
 *
 * @example
 *  //returns { index : 2, key : 'c', value 3: , element : 9  };
 *  var obj = { a : 25, b : 16, c : 9 };
 *  var min = wTools.entityMin( obj, Math.sqrt );
 *
 * @see wTools~onEach
 * @see wTools~entityMostResult
 * @function entityMin
 * @throws {Exception} If missed arguments.
 * @throws {Exception} If passed extra arguments.
 * @memberof wTools
 */

function entityMin( src,onEvaluate )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return _entityMost( src,onEvaluate,0 );
}

//

/**
 * Short-cut for _entityMost() routine. Returns object( wTools~entityMostResult ) with biggest value from( src ).
 *
 * @param {ArrayLike|Object} src - Source entity.
 * @param {Function} onEvaluate  - ( onEach ) function is called for each element of( src ).If undefined routine uses it own function.
 * @returns {wTools~entityMostResult} Object with result of search.
 *
 * @example
 *  //returns { index: 0, key: "a", value: 25, element: 25 };
 *  var obj = { a: 25, b: 16, c: 9 };
 *  var max = wTools.entityMax( obj );
 *
 * @see wTools~onEach
 * @see wTools~entityMostResult
 * @function entityMax
 * @throws {Exception} If missed arguments.
 * @throws {Exception} If passed extra arguments.
 * @memberof wTools
 */

function entityMax( src,onEvaluate )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  return _entityMost( src, onEvaluate, 1 );
}

// --
// error
// --

function errIs( src )
{
  return src instanceof Error || _ObjectToString.call( src ) === '[object Error]';
}

//

function errIsRefined( src )
{
  if( _.errIs( src ) === false )
  return false;
  return src.originalMessage !== undefined;
}

//

function errIsAttended( src )
{
  if( _.errIs( src ) === false )
  return false;
  return src.attentionGiven;
}

//

function errIsAttentionRequested( src )
{
  if( _.errIs( src ) === false )
  return false;
  return src.attentionRequested;
}

//

function errAttentionRequest( err )
{

  _.assert( _.errIs( err ) );

  Object.defineProperty( err, 'attentionGiven',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : 0,
  });

  Object.defineProperty( err, 'attentionRequested',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : 1,
  });

  return err;
}

//

/**
 * Creates Error object based on passed options.
 * Result error contains in message detailed stack trace and error description.
 * @param {Object} o Options for creating error.
 * @param {String[]|Error[]} o.args array with messages or errors objects, from which will be created Error obj.
 * @param {number} [o.level] using for specifying in error message on which level of stack trace was caught error.
 * @returns {Error} Result Error. If in `o.args` passed Error object, result will be reference to it.
 * @private
 * @throws {Error} Expects single argument if pass les or more than one argument
 * @throws {Error} o.args should be array like, if o.args is not array.
 * @function _err
 * @memberof wTools
 */

function _err( o )
{
  var result;

  if( arguments.length !== 1 )
  throw Error( '_err : expects single argument' );

  if( !_.longIs( o.args ) )
  throw Error( '_err : o.args should be array like' );

  if( o.usingSourceCode === undefined )
  o.usingSourceCode = _err.defaults.usingSourceCode;

  if( o.purifingStack === undefined )
  o.purifingStack = _err.defaults.purifingStack;

  if( o.args[ 0 ] === 'not implemented' || o.args[ 0 ] === 'not tested' || o.args[ 0 ] === 'unexpected' )
  debugger;

  /* var */

  var originalMessage = '';
  var catches = '';
  var sourceCode = '';
  var errors = [];
  var attentionGiven = 0;

  /* Error.stackTraceLimit = 99; */

  /* find error in arguments */

  for( var a = 0 ; a < o.args.length ; a++ )
  {
    var arg = o.args[ a ];

    if( _.routineIs( arg ) )
    {
      if( arg.length === 0 )
      {}
      else
      debugger;
      if( arg.length === 0 )
      arg = o.args[ a ] = arg();
      if( _.argumentsArrayIs( arg ) )
      {
        o.args = _.longButRange( o.args, [ a,a+1 ], arg );
        a -= 1;
        continue;
      }
    }

    if( arg instanceof Error )
    {

      if( !result )
      {
        result = arg;
        catches = result.catches || '';
        sourceCode = result.sourceCode || '';
        if( o.args.length === 1 )
        attentionGiven = result.attentionGiven;
      }

      if( arg.attentionRequested === undefined )
      {
        Object.defineProperty( arg, 'attentionRequested',
        {
          enumerable : false,
          configurable : true,
          writable : true,
          value : 0,
        });
      }

      if( arg.originalMessage !== undefined )
      {
        o.args[ a ] = arg.originalMessage;
      }
      else
      {
        o.args[ a ] = arg.message || arg.msg || arg.constructor.name || 'unknown error';
        var fields = _.mapFields( arg );
        if( Object.keys( fields ).length )
        o.args[ a ] += '\n' + _.toStr( fields,{ wrap : 0, multiline : 1, levels : 2 } );
      }

      if( errors.length > 0 )
      o.args[ a ] = '\n' + o.args[ a ];
      errors.push( arg );

      o.location = _.diagnosticLocation({ error : arg, location : o.location });

    }

  }

  /* look into non-error arguments to find location */

  if( !result )
  for( var a = 0 ; a < o.args.length ; a++ )
  {
    var arg = o.args[ a ];

    if( !_.primitiveIs( arg ) && _.objectLike( arg ) )
    {
      o.location = _.diagnosticLocation({ error : arg, location : o.location });
    }

  }

  o.location = o.location || Object.create( null );

  /* level */

  // if( !_.numberIs( o.level ) )
  // o.level = result.level;
  if( !_.numberIs( o.level ) )
  o.level = _err.defaults.level;

  /* make new one if no error in arguments */

  var stack = o.stack;
  var stackPurified = '';

  if( !result )
  {
    if( !stack )
    stack = o.fallBackStack;
    result = new Error( originalMessage + '\n' );
    if( !stack )
    {
      stack = _.diagnosticStack( result,o.level,-1 );
      if( o.location.full && stack.indexOf( '\n' ) === -1 )
      stack = o.location.full;
    }
  }
  else
  {
    if( result.stack !== undefined )
    {
      if( result.originalMessage !== undefined )
      {
        stack = result.stack;
        stackPurified = result.stackPurified;
      }
      else
      {
        stack = _.diagnosticStack( result );
      }
    }
    else
    {
      stack = _.diagnosticStack( o.level,-1 );
    }
  }

  if( !stack )
  stack = o.fallBackStack;

  if( stack && !stackPurified )
  {
    stackPurified = _.diagnosticStackPurify( stack );
  }

  /* collect data */

  for( var a = 0 ; a < o.args.length ; a++ )
  {
    var argument = o.args[ a ];
    var str;

    if( argument && !_.primitiveIs( argument ) )
    {

      if( _.primitiveIs( argument ) ) str = String( argument );
      else if( _.routineIs( argument.toStr ) ) str = argument.toStr();
      else if( _.errIs( argument ) || _.strIs( argument.message ) )
      {
        if( _.strIs( argument.originalMessage ) ) str = argument.originalMessage;
        else if( _.strIs( argument.message ) ) str = argument.message;
        else str = _.toStr( argument );
      }
      else str = _.toStr( argument,{ levels : 2 } );

    }
    else if( argument === undefined )
    {
      str = '\n' + String( argument ) + '\n';
    }
    else
    {
      str = String( argument );
    }

    if( _.strIs( str ) && str[ str.length-1 ] === '\n' )
    originalMessage += str;
    else
    originalMessage += str + ' ';

  }

  /* line number */

  if( o.location.line !== undefined )
  {
    Object.defineProperty( result, 'lineNumber',
    {
      enumerable : false,
      configurable : true,
      writable : true,
      value : o.location.line,
    });
  }

  /* file name */

  // if( o.location.path !== undefined && !result.fileName )
  // {
  //   Object.defineProperty( result, 'fileName',
  //   {
  //     enumerable : false,
  //     configurable : true,
  //     writable : true,
  //     value : o.location.path,
  //   });
  //   Object.defineProperty( result, 'LocationFull',
  //   {
  //     enumerable : false,
  //     configurable : true,
  //     writable : true,
  //     value : o.location.full,
  //   });
  // }

  /* source code */

  if( o.usingSourceCode )
  if( result.sourceCode === undefined )
  {
    var c = '';
    o.location = _.diagnosticLocation
    ({
      error : result,
      stack : stack,
      location : o.location,
    });
    c = _.diagnosticCode
    ({
      location : o.location,
      sourceCode : o.sourceCode,
    });
    if( c && c.length < 400 )
    {
      sourceCode += '\n';
      sourceCode += c;
      sourceCode += '\n ';
    }
  }

  /* where it was caught */

  var floc = _.diagnosticLocation( o.level );
  // if( floc.fullWithRoutine.indexOf( 'errLogOnce' ) !== -1 )
  // debugger;
  if( !floc.service || floc.service === 1 )
  catches = '    caught at ' + floc.fullWithRoutine + '\n' + catches;

  /* message */

  var message = '';

  var briefly = result.briefly && ( result.briefly === undefined || result.briefly === null || result.briefly );
  briefly = briefly || o.briefly;
  if( briefly )
  {
    message += originalMessage;
  }
  else
  {
    message += '\n* Catches\n' + catches + '\n';
    message += '* Message\n' + originalMessage + '\n';
    if( o.purifingStack )
    message += '\n* Stack ( purified )\n' + stackPurified + '\n';
    else
    message += '\n* Stack :\n' + stack + '\n';
  }

  if( sourceCode && !briefly )
  message += '\n' + sourceCode;

  try
  {
    Object.defineProperty( result, 'message',
    {
      enumerable : false,
      configurable : true,
      writable : true,
      value : message,
    });
  }
  catch( e )
  {
    debugger;
    result = new Error( message );
  }

  /* original message */

  Object.defineProperty( result, 'originalMessage',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : originalMessage,
  });

  /* level */

  Object.defineProperty( result, 'level',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : o.level,
  });

  /* stack */

  try
  {
    Object.defineProperty( result, 'stack',
    {
      enumerable : false,
      configurable : true,
      writable : true,
      value : stack,
    });
  }
  catch( err )
  {
  }

  Object.defineProperty( result, 'stackPurified',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : stackPurified,
  });

  /* briefly */

  if( o.briefly )
  Object.defineProperty( result, 'briefly',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : o.briefly,
  });

  /* source code */

  Object.defineProperty( result, 'sourceCode',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : sourceCode || null,
  });

  /* location */

  if( result.location === undefined )
  Object.defineProperty( result, 'location',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : o.location,
  });

  Object.defineProperty( result, 'attentionGiven',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : attentionGiven,
  });

  /* catches */

  Object.defineProperty( result, 'catches',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : catches,
  });

  /* catch count */

  Object.defineProperty( result, 'catchCounter',
  {
    enumerable : false,
    configurable : true,
    writable : true,
    value : result.catchCounter ? result.catchCounter+1 : 1,
  });

  if( originalMessage.indexOf( 'caught at' ) !== -1 )
  {
    debugger;
    // console.error( '-' );
    // console.error( result.toString() );
    // console.error( '-' );
    // throw Error( 'err : originalMessage should have no "caught at"' );
  }

  return result;
}

_err.defaults =
{
  /* to make catch stack work properly it should be 1 */
  level : 1,
  usingSourceCode : 1,
  purifingStack : 1,
  location : null,
  sourceCode : null,
  briefly : null,
  args : null,
  stack : null,
  fallBackStack : null,
}

//

/**
 * Creates error object, with message created from passed `msg` parameters and contains error trace.
 * If passed several strings (or mixed error and strings) as arguments, the result error message is created by
 concatenating them.
 *
 * @example
  function divide( x, y )
  {
    if( y == 0 )
      throw wTools.err( 'divide by zero' )
    return x / y;
  }
  divide( 3, 0 );

 // Error:
 // caught     at divide (<anonymous>:2:29)
 // divide by zero
 // Error
 //   at _err (file:///.../wTools/staging/Base.s:1418:13)
 //   at wTools.err (file:///.../wTools/staging/Base.s:1449:10)
 //   at divide (<anonymous>:2:29)
 //   at <anonymous>:1:1
 *
 * @param {...String|Error} msg Accepts list of messeges/errors.
 * @returns {Error} Created Error. If passed existing error as one of parameters, routine modified it and return
 * reference.
 * @function err
 * @memberof wTools
 */

function err()
{
  return _err
  ({
    args : arguments,
    level : 2,
  });
}

//

function errBriefly()
{
  return _err
  ({
    args : arguments,
    level : 2,
    briefly : 1,
  });
}

//

function errAttend( err )
{

  if( arguments.length !== 1 || !_.errIsRefined( err ) )
  err = _err
  ({
    args : arguments,
    level : 2,
  });

  /* */

  try
  {

    Object.defineProperty( err, 'attentionRequested',
    {
      enumerable : false,
      configurable : true,
      writable : true,
      value : 0,
    });

    Object.defineProperty( err, 'attentionGiven',
    {
      enumerable : false,
      configurable : true,
      writable : true,
      value : Config.debug ? _.diagnosticStack( 1,-1 ) : 1,
    });

  }
  catch( err )
  {
    c.warn( 'cant assign attentionRequested / attentionGiven properties' );
  }

  /* */

  return err;
}

//

function errRestack( err,level )
{
  if( level === undefined )
  level = 1;

  var err2 = _._err
  ({
    args : [],
    level : level+1,
  });

  return _.err( err2,err );
}

//

/**
 * Creates error object, with message created from passed `msg` parameters and contains error trace.
 * If passed several strings (or mixed error and strings) as arguments, the result error message is created by
 concatenating them. Prints the created error.
 * If _global_.logger defined, routine will use it to print error, else uses console
 * @see wTools.err
 *
 * @example
   function divide( x, y )
   {
      if( y == 0 )
        throw wTools.errLog( 'divide by zero' )
      return x / y;
   }
   divide( 3, 0 );

   // Error:
   // caught     at divide (<anonymous>:2:29)
   // divide by zero
   // Error
   //   at _err (file:///.../wTools/staging/Base.s:1418:13)
   //   at wTools.errLog (file:///.../wTools/staging/Base.s:1462:13)
   //   at divide (<anonymous>:2:29)
   //   at <anonymous>:1:1
 *
 * @param {...String|Error} msg Accepts list of messeges/errors.
 * @returns {Error} Created Error. If passed existing error as one of parameters, routine modified it and return
 * @function errLog
 * @memberof wTools
 */

function errLog()
{

  var c = _global.logger || _global.console;
  var err = _err
  ({
    args : arguments,
    level : 2,
  });

  /* */

  if( _.routineIs( err.toString ) )
  {
    var str = err.toString();
    if( _.loggerIs( c ) )
    c.error( '#inputRaw : 1#\n' + str + '\n#inputRaw : 0#' )
    else
    c.error( str );
  }
  else
  {
    debugger;
    c.error( 'Error does not have toString' );
    c.error( err );
  }

  /* */

  _.errAttend( err );

  /* */

  return err;
}

//

function errLogOnce( err )
{
  var c = _global.logger || _global.console;
  var err = _err
  ({
    args : arguments,
    level : 2,
  });

  if( err.attentionGiven )
  return err;

  /* */

  if( _.routineIs( err.toString ) )
  {
    c.error( err.toString() );
  }
  else
  {
    c.error( err );
  }

  /* */

  _.errAttend( err );
  return err;
}

// --
// sure
// --

function _sureDebugger( condition )
{
  debugger;
}

//

function sure( condition )
{

  if( !condition || !boolLike( condition ) )
  {
    _sureDebugger( condition );
    if( arguments.length === 1 )
    throw _err
    ({
      args : [ 'Assertion failed' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _err
    ({
      args : _.longSlice( arguments,1 ),
      level : 2,
    });
  }

  return;

  function boolLike( src )
  {
    var type = _ObjectToString.call( src );
    return type === '[object Boolean]' || type === '[object Number]';
  }

}

//

function sureWithoutDebugger( condition )
{

  if( !condition || !boolLike( condition ) )
  {
    if( arguments.length === 1 )
    throw _err
    ({
      args : [ 'Assertion failed' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _err
    ({
      args : _.longSlice( arguments,1 ),
      level : 2,
    });
  }

  return;

  function boolLike( src )
  {
    var type = _ObjectToString.call( src );
    return type === '[object Boolean]' || type === '[object Number]';
  }

}

// --
// assert
// --

/**
 * Checks condition passed by argument( condition ). Works only in debug mode. Uses StackTrace level 2. @see wTools.err
 * If condition is true routine returns without exceptions, otherwise routine generates and throws exception. By default generates error with message 'Assertion failed'.
 * Also generates error using message(s) or existing error object(s) passed after first argument.
 *
 * @param {*} condition - condition to check.
 * @param {String|Error} [ msgs ] - error messages for generated exception.
 *
 * @example
 * var x = 1;
 * wTools.assert( wTools.strIs( x ), 'incorrect variable type->', typeof x, 'expects string' );
 *
 * // caught eval (<anonymous>:2:8)
 * // incorrect variable type-> number expects string
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:3707)
 * //   at assert (file://.../wTools/staging/Base.s:4041)
 * //   at add (<anonymous>:2)
 * //   at <anonymous>:1
 *
 * @example
 * function add( x, y )
 * {
 *   wTools.assert( arguments.length === 2, 'incorrect arguments count' );
 *   return x + y;
 * }
 * add();
 *
 * // caught add (<anonymous>:3:14)
 * // incorrect arguments count
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:3707)
 * //   at assert (file://.../wTools/staging/Base.s:4035)
 * //   at add (<anonymous>:3:14)
 * //   at <anonymous>:6
 *
 * @example
 *   function divide ( x, y )
 *   {
 *      wTools.assert( y != 0, 'divide by zero' );
 *      return x / y;
 *   }
 *   divide( 3, 0 );
 *
 * // caught     at divide (<anonymous>:2:29)
 * // divide by zero
 * // Error
 * //   at _err (file:///.../wTools/staging/Base.s:1418:13)
 * //   at wTools.errLog (file://.../wTools/staging/Base.s:1462:13)
 * //   at divide (<anonymous>:2:29)
 * //   at <anonymous>:1:1
 * @throws {Error} If passed condition( condition ) fails.
 * @function assert
 * @memberof wTools
 */

function _assertDebugger( condition, args )
{
  var err = _err
  ({
    args : _.longSlice( args,1 ),
    level : 3,
  });
  // console.error( 'Assert failed' );
  console.error( 'Assert failed :', _.errBriefly( err ).toString() );
  debugger;
}

//

function assert( condition )
{

  /*return;*/

  if( Config.debug === false )
  return true;

  /*
    assert is going to become stricter
    assert will treat as true only bool like argument
  */
  if( !boolLike( condition ) )
  debugger;

  // if( !condition || !boolLike( condition ) )
  if( !condition )
  {
    _assertDebugger( condition, arguments );
    if( arguments.length === 1 )
    throw _err
    ({
      args : [ 'Assertion failed' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _err
    ({
      args : _.longSlice( arguments,1 ),
      level : 2,
    });
  }

  return;

  function boolLike( src )
  {
    var type = _ObjectToString.call( src );
    return type === '[object Boolean]' || type === '[object Number]';
  }

}

//

function assertWithoutBreakpoint( condition )
{

  /*return;*/

  if( Config.debug === false )
  return true;

  if( !condition || !_.boolLike( condition ) )
  {
    if( arguments.length === 1 )
    throw _err
    ({
      args : [ 'Assertion failed' ],
      level : 2,
    });
    else if( arguments.length === 2 )
    throw _err
    ({
      args : [ arguments[ 1 ] ],
      level : 2,
    });
    else
    throw _err
    ({
      args : _.longSlice( arguments,1 ),
      level : 2,
    });
  }

  return;
}

//

function assertNotTested( src )
{

  debugger;
  _.assert( false,'not tested : ' + stack( 1 ) );

}

//

/**
 * If condition failed, routine prints warning messages passed after condition argument
 * @example
  function checkAngles( a, b, c )
  {
     wTools.assertWarn( (a + b + c) === 180, 'triangle with that angles does not exists' );
  };
  checkAngles( 120, 23, 130 );

 // triangle with that angles does not exists
 * @param condition Condition to check.
 * @param messages messages to print.
 * @function assertWarn
 * @memberof wTools
 */



function assertWarn( condition )
{

  if( Config.debug )
  return;

  if( !condition || !_.boolLike( condition ) )
  {
    console.warn.apply( console,[].slice.call( arguments,1 ) );
  }

}

// --
// type test
// --

function nothingIs( src )
{
  if( src === null )
  return true;
  if( src === undefined )
  return true;
  if( src === _.nothing )
  return true;
  return false;
}

//

function definedIs( src )
{
  return src !== undefined && src !== null && src !== NaN && src !== _.nothing;
}

//

function primitiveIs( src )
{
  if( !src )
  return true;
  var t = _ObjectToString.call( src );
  return t === '[object Symbol]' || t === '[object Number]' || t === '[object BigInt]' || t === '[object Boolean]' || t === '[object String]';
}

//

function containerIs( src )
{
  if( _.arrayLike( src ) )
  return true;
  if( _.objectIs( src ) )
  return true;
  return false;
}

//

function containerLike( src )
{
  if( _.longIs( src ) )
  return true;
  if( _.objectLike( src ) )
  return true;
  return false;
}

//

function symbolIs( src )
{
  var result = _ObjectToString.call( src ) === '[object Symbol]';
  return result;
}

//

function bigIntIs( src )
{
  var result = _ObjectToString.call( src ) === '[object BigInt]';
  return result;
}

//

function vectorIs( src )
{
  if( !_.objectIs( src ) )
  return false;
  if( !( '_vectorBuffer' in src ) )
  return false;

  if( _ObjectHasOwnProperty.call( src, 'constructor' ) )
  {
    debugger;
    return false;
  }

  return true;
}

//

function constructorIsVector( src )
{
  if( !src )
  return false;
  return '_vectorBuffer' in src.prototype;
}

//

function spaceIs( src )
{
  if( !src )
  return false;
  if( !_.Space )
  return false;
  if( src instanceof _.Space )
  return true;
}

//

function constructorIsSpace( src )
{
  if( !_.Space )
  return false;
  if( src === _.Space )
  return true;
  return false;
}

//

function consequenceIs( src )
{
  if( !src )
  return false;

  var prototype = Object.getPrototypeOf( src );
  if( !prototype )
  return false;

  return prototype.shortName === 'Consequence';
}

//

function consequenceLike( src )
{
  if( _.consequenceIs( src ) )
  return true;

  if( _.promiseIs( src ) )
  return true;

  return false;
}

//

function promiseIs( src )
{
  if( !src )
  return false;

  var prototype = Object.getPrototypeOf( src );

  if( !prototype )
  return false;

  return prototype.constructor.name === 'Promise' && src instanceof Promise;
}

//

function typeOf( src )
{
  if( src === null || src === undefined )
  return null
  else if( numberIs( src ) || boolIs( src ) || strIs( src ) )
  {
    return src.constructor;
  }
  else if( src.constructor )
  {
    _.assert( _.routineIs( src.constructor ) && src instanceof src.constructor );
    return src.constructor;
  }
  else
  {
    return null;
  }
}

//

function prototypeHas( src, prototype )
{
  _.assert( arguments.length === 2, 'expects single argument' );
  if( src === prototype )
  return true;
  return Object.isPrototypeOf.call( prototype, src );
}

//

/**
 * Is prototype.
 * @function prototypeIs
 * @param {object} src - entity to check
 * @memberof wTools#
 */

function prototypeIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  if( _.primitiveIs( src ) )
  return false;
  return _ObjectHasOwnProperty.call( src, 'constructor' );
}

//

function prototypeIsStandard( src )
{

  if( !_.prototypeIs( src ) )
  return false;

  if( !_ObjectHasOwnProperty.call( src, 'Composes' ) )
  return false;

  return true;
}

//

/**
 * Is constructor.
 * @function constructorIs
 * @param {object} cls - entity to check
 * @memberof wTools#
 */

function constructorIs( cls )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  return _.routineIs( cls ) && !instanceIs( cls );
}

//

function constructorIsStandard( cls )
{

  _.assert( _.constructorIs( cls ) );

  var prototype = _.prototypeGet( cls );

  return _.prototypeIsStandard( prototype );
}

/**
 * Is instance.
 * @function instanceIs
 * @param {object} src - entity to check
 * @memberof wTools#
 */

function instanceIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.primitiveIs( src ) )
  return false;

  if( _ObjectHasOwnProperty.call( src,'constructor' ) )
  return false;
  else if( _ObjectHasOwnProperty.call( src,'prototype' ) && src.prototype )
  return false;

  if( Object.getPrototypeOf( src ) === Object.prototype )
  return false;
  if( Object.getPrototypeOf( src ) === null )
  return false;

  return true;
}

//

function instanceIsStandard( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.instanceIs( src ) )
  return false;

  var proto = _.prototypeGet( src );

  if( !proto )
  return false;

  return _.prototypeIsStandard( proto );
}

//

function instanceLike( src )
{
  if( _.primitiveIs( src ) )
  return false;
  if( src.Composes )
  return true;
  return false;
}

//

function workerIs( src )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( arguments.length === 1 )
  {
    if( typeof WorkerGlobalScope !== 'undefined' && src instanceof WorkerGlobalScope )
    return true;
    if( typeof Worker !== 'undefined' && src instanceof Worker )
    return true;
    return false;
  }
  else
  {
    return typeof WorkerGlobalScope !== 'undefined';
  }
}

//

function streamIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  return _.objectIs( src ) && _.routineIs( src.pipe )
}

//

function consoleIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( console.Console )
  if( src && src instanceof console.Console )
  return true;

  if( src !== console )
  return false;

  var result = Object.prototype.toString.call( src );
  if( result === '[object Console]' || result === '[object Object]' )
  return true;

  return false;
}

//

function printerLike( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( printerIs( src ) )
  return true;

  if( consoleIs( src ) )
  return true;

  return false;
}


//

function printerIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( !src )
  return false;

  var prototype = Object.getPrototypeOf( src );
  if( !prototype )
  return false;

  if( src.MetaType === 'Printer' )
  return true;

  return false;
}

//

function loggerIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.Logger )
  return false;

  if( src instanceof _.Logger )
  return true;

  return false;
}

//

function processIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  var typeOf = _.strTypeOf( src );
  if( typeOf === 'ChildProcess' || typeOf === 'process' )
  return true;

  return false;
}

//

function processIsDebugged()
{
  _.assert( arguments.length === 0 );

  if( typeof process === 'undefined' )
  return false;

  if( !process.execArgv.length )
  return false;

  let execArgv = process.execArgv.join();
  return _.strHas( execArgv, '--inspect' );

}

//

function definitionIs( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( !src )
  return false;

  if( !_.define )
  return false;

  return src instanceof _.define.Definition;
}

// --
// routine
// --

function routineIs( src )
{
  return _ObjectToString.call( src ) === '[object Function]';
}

//

function routinesAre( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.longIs( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( !_.routineIs( src[ s ] ) )
    return false;
    return true;
  }

  return routineIs( src );
}

//

function routineIsPure( src )
{
  if( !src )
  return false;
  if( !( Object.getPrototypeOf( src ) === Function.__proto__ ) )
  return false;
  return true;
}

//

function routineHasName( src )
{
  if( !routineIs( src ) )
  return false;
  if( !src.name )
  return false;
  return true;
}

//

/**
 * Internal implementation.
 * @param {object} object - object to check.
 * @return {object} object - name in key/value format.
 * @function _routineJoin
 * @memberof wTools
 */

function _routineJoin( o )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.boolIs( o.seal ) );
  _.assert( _.routineIs( o.routine ),'expects routine' );
  _.assert( _.longIs( o.args ) || o.args === undefined );

  var routine = o.routine;
  var args = o.args;
  var context = o.context;

  if( _FunctionBind )
  {

    if( context !== undefined && args === undefined )
    {
      if( o.seal === true )
      {
        return function __sealedContext()
        {
          return routine.call( context );
        }
      }
      else
      {
        return _FunctionBind.call( routine, context );
      }
    }
    else if( context !== undefined )
    {
      if( o.seal === true )
      {
        return function __sealedContextAndArguments()
        {
          return routine.apply( context, args );
        }
      }
      else
      {
        var a = _.arrayAppendArray( [ context ],args );
        return _FunctionBind.apply( routine, a );
      }
    }
    else if( args === undefined && !o.seal )
    {
      return routine;
    }
    else
    {
      if( !args )
      args = [];

      if( o.seal === true )
      return function __sealedArguments()
      {
        return routine.apply( undefined, args );
      }
      else
      return function __joinedArguments()
      {
        var a = args.slice();
        _.arrayAppendArray( a,arguments );
        return routine.apply( this, a );
      }

    }

  }

  /* */

  _.assert( 0,'not implemented' );

}

//

/**
 * The routineJoin() routine creates a new function with its 'this' ( context ) set to the provided `context`
 value. Argumetns `args` of target function which are passed before arguments of binded function during
 calling of target function. Unlike bind routine, position of `context` parameter is more intuitive.
 * @example
   var o = {
        z: 5
    };

   var y = 4;

   function sum(x, y) {
       return x + y + this.z;
    }
   var newSum = wTools.routineJoin(o, sum, [3]);
   newSum(y); // 12

   function f1(){ console.log( this ) };
   var f2 = f1.bind( undefined ); // context of new function sealed to undefined (or global object);
   f2.call( o ); // try to call new function with context set to { z: 5 }
   var f3 = _.routineJoin( undefined,f1 ); // new function.
   f3.call( o ) // print  { z: 5 }

 * @param {Object} context The value that will be set as 'this' keyword in new function
 * @param {Function} routine Function which will be used as base for result function.
 * @param {Array<*>} args Argumetns of target function which are passed before arguments of binded function during
 calling of target function. Must be wraped into array.
 * @returns {Function} New created function with preceding this, and args.
 * @throws {Error} When second argument is not callable throws error with text 'first argument must be a routine'
 * @thorws {Error} If passed arguments more than 3 throws error with text 'expects 3 or less arguments'
 * @function routineJoin
 * @memberof wTools
 */

function routineJoin( context, routine, args )
{

  _.assert( _.routineIs( routine ),'routineJoin :','second argument must be a routine' );
  _.assert( arguments.length <= 3,'routineJoin :','expects 3 or less arguments' );

  return _routineJoin
  ({
    routine : routine,
    context : context,
    args : args,
    seal : false,
  });

}

//

  /**
   * Return new function with sealed context and arguments.
   *
   * @example
   var o = {
        z: 5
    };

   function sum(x, y) {
       return x + y + this.z;
    }
   var newSum = wTools.routineSeal(o, sum, [3, 4]);
   newSum(y); // 12
   * @param {Object} context The value that will be set as 'this' keyword in new function
   * @param {Function} routine Function which will be used as base for result function.
   * @param {Array<*>} args Arguments wrapped into array. Will be used as argument to `routine` function
   * @returns {Function} Result function with sealed context and arguments.
   * @function routineJoin
   * @memberof wTools
   */

function routineSeal( context, routine, args )
{

  _.assert( _.routineIs( routine ),'routineSeal :','second argument must be a routine' );
  _.assert( arguments.length <= 3,'routineSeal :','expects 3 or less arguments' );

  return _routineJoin
  ({
    routine : routine,
    context : context,
    args : args,
    seal : true,
  });

}

//

/**
 * Return function that will call passed routine function with delay.
 * @param {number} delay delay in milliseconds
 * @param {Function} routine function that will be called with delay.
 * @returns {Function} result function
 * @throws {Error} If arguments less then 2
 * @throws {Error} If `delay` is not a number
 * @throws {Error} If `routine` is not a function
 * @function routineDelayed
 * @memberof wTools
 */

function routineDelayed( delay,routine )
{

  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  _.assert( _.numberIs( delay ) );
  _.assert( _.routineIs( routine ) );

  if( arguments.length > 2 )
  {
    _.assert( arguments.length <= 4 );
    routine = _.routineJoin.call( _,arguments[ 1 ],arguments[ 2 ],arguments[ 3 ] );
  }

  return function delayed()
  {
    _.timeOut( delay,this,routine,arguments );
  }

}

//

function routineCall( context, routine, args )
{
  var result;

  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  /* */

  if( arguments.length === 1 )
  {
    var routine = arguments[ 0 ];
    result = routine();
  }
  else if( arguments.length === 2 )
  {
    var context = arguments[ 0 ];
    var routine = arguments[ 1 ];
    result = routine.call( context );
  }
  else if( arguments.length === 3 )
  {
    var context = arguments[ 0 ];
    var routine = arguments[ 1 ];
    var args = arguments[ 2 ];
    _.assert( _.longIs( args ) );
    result = routine.apply( context,args );
  }
  else _.assert( 0,'unexpected' );

  return result;
}

//

function routineTolerantCall( context,routine,options )
{

  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( _.routineIs( routine ) );
  _.assert( _.objectIs( routine.defaults ) );
  _.assert( _.objectIs( options ) );

  options = _.mapOnly( options, routine.defaults );
  var result = routine.call( context,options );

  return result;
}

//

function routinesJoin()
{
  var result,routines,index;
  var args = _.longSlice( arguments );

  _.assert( arguments.length >= 1 && arguments.length <= 3  );

  /* */

  function makeResult()
  {

    _.assert( _.objectIs( routines ) || _.arrayIs( routines ) || _.routineIs( routines ) );

    if( _.routineIs( routines ) )
    routines = [ routines ];

    result = _.entityMake( routines );

  }

  /* */

  if( arguments.length === 1 )
  {
    routines = arguments[ 0 ];
    index = 0;
    makeResult();
  }
  else if( arguments.length === 2 )
  {
    routines = arguments[ 1 ];
    index = 1;
    makeResult();
  }
  else if( arguments.length === 3 )
  {
    routines = arguments[ 1 ];
    index = 1;
    makeResult();
  }
  else _.assert( 0,'unexpected' );

  /* */

  if( _.arrayIs( routines ) )
  for( var r = 0 ; r < routines.length ; r++ )
  {
    args[ index ] = routines[ r ];
    result[ r ] = _.routineJoin.apply( this,args );
  }
  else
  for( var r in routines )
  {
    args[ index ] = routines[ r ];
    result[ r ] = _.routineJoin.apply( this,args );
  }

  /* */

  return result;
}

//

function _routinesCall( o )
{
  var result;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.args.length >= 1 && o.args.length <= 3 );

  /* */

  if( o.args.length === 1 )
  {
    var routines = o.args[ 0 ];

    makeResult();

    if( _.arrayIs( routines ) )
    for( var r = 0 ; r < routines.length ; r++ )
    {
      result[ r ] = routines[ r ]();
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }
    else
    for( var r in routines )
    {
      result[ r ] = routines[ r ]();
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }

  }
  else if( o.args.length === 2 )
  {
    var context = o.args[ 0 ];
    var routines = o.args[ 1 ];

    makeResult();

    if( _.arrayIs( routines ) )
    for( var r = 0 ; r < routines.length ; r++ )
    {
      result[ r ] = routines[ r ].call( context );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }
    else
    for( var r in routines )
    {
      result[ r ] = routines[ r ].call( context );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }

  }
  else if( o.args.length === 3 )
  {
    var context = o.args[ 0 ];
    var routines = o.args[ 1 ];
    var args = o.args[ 2 ];

    _.assert( _.longIs( args ) );

    makeResult();

    if( _.arrayIs( routines ) )
    for( var r = 0 ; r < routines.length ; r++ )
    {
      result[ r ] = routines[ r ].apply( context,args );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }
    else
    for( var r in routines )
    {
      result[ r ] = routines[ r ].apply( context,args );
      if( o.whileTrue && result[ r ] === false )
      {
        result = false;
        break;
      }
    }

  }
  else _.assert( 0,'unexpected' );

  return result;

  /* */

  function makeResult()
  {

    _.assert
    (
      _.objectIs( routines ) || _.arrayIs( routines ) || _.routineIs( routines ),
      'expects object, array or routine (-routines-), but got',_.strTypeOf( routines )
    );

    if( _.routineIs( routines ) )
    routines = [ routines ];

    result = _.entityMake( routines );

  }

}

_routinesCall.defaults =
{
  args : null,
  whileTrue : 0,
}

//

/**
 * Call each routines in array with passed context and arguments.
    The context and arguments are same for each called functions.
    Can accept only routines without context and args.
    Can accept single routine instead array.
 * @example
    var x = 2, y = 3,
        o { z : 6 };

    function sum( x, y )
    {
        return x + y + this.z;
    },
    prod = function( x, y )
    {
        return x * y * this.z;
    },
    routines = [ sum, prod ];
    var res = wTools.routinesCall( o, routines, [ x, y ] );
 // [ 11, 36 ]
 * @param {Object} [context] Context in which calls each function.
 * @param {Function[]} routines Array of called function
 * @param {Array<*>} [args] Arguments that will be passed to each functions.
 * @returns {Array<*>} Array with results of functions invocation.
 * @function routinesCall
 * @memberof wTools
 */

function routinesCall()
{
  var result;

  result = _routinesCall
  ({
    args : arguments,
    whileTrue : 0,
  });

  return result;
}

//

function routinesCallEvery()
{
  var result;

  result = _routinesCall
  ({
    args : arguments,
    whileTrue : 1,
  });

  return result;
}

//

function methodsCall( contexts,methods,args )
{
  var result = [];

  if( args === undefined )
  args = [];

  var isContextsArray = _.longIs( contexts );
  var isMethodsArray = _.longIs( methods );
  var l1 = isContextsArray ? contexts.length : 1;
  var l2 = isMethodsArray ? methods.length : 1;
  var l = Math.max( l1,l2 );

  _.assert( l >= 0 );
  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );

  if( !l )
  return result;

  var contextGet;
  if( isContextsArray )
  contextGet = ( i ) => contexts[ i ];
  else
  contextGet = ( i ) => contexts;

  var methodGet;
  if( isMethodsArray )
  methodGet = ( i ) => methods[ i ];
  else
  methodGet = ( i ) => methods;

  for( var i = 0 ; i < l ; i++ )
  {
    var context = contextGet( i );
    var routine = context[ methodGet( i ) ];
    _.assert( _.routineIs( routine ) );
    result[ i ] = routine.apply( context,args )
  }

  return result;
}

//

function _routinesComposeWithSingleArgument_pre( routine, args )
{
  var srcs = _.arrayAppendArrays( [], [ args[ 0 ] ] );

  srcs = srcs.filter( ( e ) => e === null ? false : e );

  _.assert( _.routinesAre( srcs ) );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  _.assert( args.length === 1 );
  // _.assert( args.length === 1 || args.length === 2 );
  _.assert( _.arrayIs( srcs ) || _.routineIs( srcs ) );
  // _.assert( _.routineIs( args[ 1 ] ) || args[ 1 ] === undefined );

  // return { srcs : srcs, joiner : args[ 1 ] || null };
  return { srcs : srcs };
}

//

function _routinesCompose_pre( routine, args )
{
  var srcs = _.arrayAppendArrays( [], [ args[ 0 ] ] );

  srcs = srcs.filter( ( e ) => e === null ? false : e );

  _.assert( _.routinesAre( srcs ) );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  // _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( args.length === 1 || args.length === 2);
  _.assert( _.arrayIs( srcs ) || _.routineIs( srcs ) );
  _.assert( _.routineIs( args[ 1 ] ) || args[ 1 ] === undefined || args[ 1 ] === null );
  // _.assert( _.routineIs( args[ 2 ] ) || args[ 2 ] === undefined || args[ 2 ] === null );

  return { srcs : srcs, chainer : args[ 1 ] || null };
  // return { srcs : srcs, joiner : args[ 1 ] || null, chainer : args[ 2 ] || null };
}

//

function _routinesCompose_body( o )
{

  if( o.srcs.length === 0 )
  return function empty(){ return [] }

  // if( o.srcs.length === 0 )
  // debugger;
  // else if( o.srcs.length === 1 )
  // {}
  // else
  // {}

  /* */

  if( !o.chainer )
  o.chainer = function chainer( e, k, args, op )
  {
    return args;
  }

  let chainer = o.chainer;

  _.assert( _.routineIs( chainer ) );

  /* */

  if( o.srcs.length === 0 )
  return function empty()
  {
    throw _.err( 'not tested' );
  }
  else if( o.srcs.length === 1 )
  {
    return o.srcs[ 0 ];
  }
  else return function composition()
  {
    var result = [];
    var args = _.unrollAppend( null, arguments );
    for( var k = 0 ; k < o.srcs.length ; k++ )
    {
      _.assert( _.unrollIs( args ), () => 'Expects unroll, but got', _.strTypeOf( args ) );
      var r = o.srcs[ k ].apply( this, args );
      _.assert( !_.argumentsArrayIs( r ) );
      if( r !== undefined )
      _.arrayAppendUnrolling( result, r );
      args = chainer( r, k, args, o );
      if( args === undefined )
      break;
      args = _.unrollFrom( args );
    }
    return result;
  }

}

_routinesCompose_body.defaults =
{
  srcs : null,
  chainer : null,
}

//

function routinesCompose()
{
  var o = _.routinesCompose.pre( routinesCompose, arguments );
  var result = _.routinesCompose.body( o );
  return result;
}

routinesCompose.pre = _routinesCompose_pre;
routinesCompose.body = _routinesCompose_body;
routinesCompose.defaults = Object.create( routinesCompose.body.defaults );

//

function _routinesComposeReturningLast_body( o )
{

  if( o.srcs.length === 1 )
  {
    return o.srcs[ 0 ];
  }

  var routine = _.routinesCompose.body( o );

  return function returnLast()
  {
    var result = routine.apply( this, arguments );
    return result[ result.length-1 ];
  }

  return returnLast;
}

_routinesComposeReturningLast_body.defaults = Object.create( routinesCompose.defaults );

//

function routinesComposeReturningLast()
{
  var o = _.routinesComposeReturningLast.pre( routinesComposeReturningLast, arguments );
  var result = _.routinesComposeReturningLast.body( o );
  return result;
}

routinesComposeReturningLast.pre = _routinesCompose_pre;
routinesComposeReturningLast.body = _routinesComposeReturningLast_body;
routinesComposeReturningLast.defaults = Object.create( routinesComposeReturningLast.body.defaults );

/*xxx : autogenerate*/

//

function _routinesComposeReturningBeforeLast_body( o )
{

  if( o.srcs.length === 1 )
  {
    return o.srcs[ 0 ];
  }

  var routine = _.routinesCompose.body( o );

  return function returnLast()
  {
    var result = routine.apply( this, arguments );
    return result[ result.length-1 ];
  }

  return returnLast;
}

_routinesComposeReturningBeforeLast_body.defaults = Object.create( routinesCompose.defaults );

//

function routinesComposeReturningBeforeLast()
{
  var o = _.routinesComposeReturningBeforeLast.pre( routinesComposeReturningBeforeLast, arguments );
  var result = _.routinesComposeReturningBeforeLast.body( o );
  return result;
}

routinesComposeReturningBeforeLast.pre = _routinesCompose_pre;
routinesComposeReturningBeforeLast.body = _routinesComposeReturningBeforeLast_body;
routinesComposeReturningBeforeLast.defaults = Object.create( routinesComposeReturningBeforeLast.body.defaults );

//

function _routinesComposeEvery_body( o )
{

  if( o.srcs.length === 0 )
  debugger;

  if( o.srcs.length === 1 )
  {
    _.assert( _.routineIs( o.srcs[ 0 ] ) );
    return o.srcs[ 0 ];
  }

  o.chainer = function chainer( e, k, args, o )
  {
    _.assert( e !== false );
    if( e === dont )
    return undefined;
    return args;
  }

  var routine = _.routinesCompose.body( o );

  function returnNotEmpty()
  {
    var result = routine.apply( this, arguments );
    if( !result.length )
    return;
    if( result[ result.length-1 ] === dont )
    return;
    return result;
  }

  return returnNotEmpty;

  // if( o.srcs.length === 0 )
  // return function empty()
  // {
  // }
  // else if( o.srcs.length === 1 )
  // {
  //   return o.srcs[ 0 ];
  // }
  // else return function composition()
  // {
  //   var result = [];
  //   for( var s = 0 ; s < o.srcs.length ; s++ )
  //   {
  //     var r = o.srcs[ s ].apply( this, arguments );
  //     _.assert( r !== false );
  //     if( r === dont )
  //     return;
  //     // if( r === false )
  //     // return false;
  //     else if( r !== undefined )
  //     result.push( r );
  //   }
  //   if( !result.length )
  //   return;
  //   return result;
  // }

}

_routinesComposeEvery_body.defaults = Object.create( routinesCompose.defaults );

//

function routinesComposeEvery()
{
  var o = _.routinesComposeEvery.pre( routinesComposeEvery, arguments );
  var result = _.routinesComposeEvery.body( o );
  return result;
}

routinesComposeEvery.pre = _routinesComposeWithSingleArgument_pre;
routinesComposeEvery.body = _routinesComposeEvery_body;
routinesComposeEvery.defaults = Object.create( routinesComposeEvery.body.defaults );

//

function _routinesComposeEveryReturningLast_body( o )
{

  if( o.srcs.length === 0 )
  debugger;

  if( o.srcs.length === 1 )
  {
    _.assert( _.routineIs( o.srcs[ 0 ] ) );
    return o.srcs[ 0 ];
  }

  o.chainer = function chainer( e, k, args, o )
  {
    _.assert( e !== false );
    if( e === dont )
    return undefined;
    return args;
  }

  var routine = _.routinesCompose.body( o );

  function returnNotEmpty()
  {
    var result = routine.apply( this, arguments );
    return result[ result.length-1 ];
  }

  return returnNotEmpty;
}

_routinesComposeEveryReturningLast_body.defaults = Object.create( routinesCompose.defaults );

//

function routinesComposeEveryReturningLast()
{
  var o = _.routinesComposeEveryReturningLast.pre( routinesComposeEveryReturningLast, arguments );
  var result = _.routinesComposeEveryReturningLast.body( o );
  return result;
}

routinesComposeEveryReturningLast.pre = _routinesComposeWithSingleArgument_pre;
routinesComposeEveryReturningLast.body = _routinesComposeEveryReturningLast_body;
routinesComposeEveryReturningLast.defaults = Object.create( routinesComposeEveryReturningLast.body.defaults );

//

function _routinesChain_body( o )
{

  if( o.srcs.length === 0 )
  debugger;
  else if( o.srcs.length === 1 )
  debugger;
  else
  {};

  o.chainer = function chainer( e, k, args, o )
  {
    if( e === undefined )
    return args;
    if( e === _.dont )
    return undefined;
    return _.unrollFrom( e );
  }

  let routine = _.routinesCompose.body( o );
  return function routinesChain()
  {
    let result = routine.apply( this, arguments );
    if( result[ result.length-1 ] === _.dont )
    result.pop();
    return result;
  }
}

_routinesChain_body.defaults =
{
  srcs : null,
}

//

function routinesChain()
{
  var o = _.routinesChain.pre( routinesChain, arguments );
  var result = _.routinesChain.body( o );
  return result;
}

routinesChain.pre = _routinesComposeWithSingleArgument_pre;
routinesChain.body = _routinesChain_body;
routinesChain.defaults = Object.create( routinesChain.body.defaults );

//

function routineOptions( routine, args, defaults )
{

  if( !_.argumentsArrayIs( args ) )
  args = [ args ];
  var options = args[ 0 ];
  if( options === undefined )
  options = Object.create( null );
  defaults = defaults || routine.defaults;

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects 2 or 3 arguments' );
  _.assert( _.routineIs( routine ), 'expects routine' );
  _.assert( _.objectIs( defaults ), 'expects routine with defined defaults or defaults in third argument' );
  _.assert( _.objectIs( options ), 'expects object' );
  _.assert( args.length === 0 || args.length === 1, 'expects single options map, but got',args.length,'arguments' );

  _.assertMapHasOnly( options, defaults );
  _.mapComplement( options, defaults );
  _.assertMapHasNoUndefine( options );

  return options;
}

//

function assertRoutineOptions( routine,args,defaults )
{

  if( !_.argumentsArrayIs( args ) )
  args = [ args ];
  var options = args[ 0 ];
  defaults = defaults || routine.defaults;

  _.assert( arguments.length === 2 || arguments.length === 3,'expects 2 or 3 arguments' );
  _.assert( _.routineIs( routine ),'expects routine' );
  _.assert( _.objectIs( defaults ),'expects routine with defined defaults or defaults in third argument' );
  _.assert( _.objectIs( options ),'expects object' );
  _.assert( args.length === 0 || args.length === 1, 'expects single options map, but got',args.length,'arguments' );

  _.assertMapHasOnly( options, defaults );
  _.assertMapHasAll( options, defaults );
  _.assertMapHasNoUndefine( options );

  return options;
}

//

function routineOptionsPreservingUndefines( routine, args, defaults )
{

  if( !_.argumentsArrayIs( args ) )
  args = [ args ];
  var options = args[ 0 ];
  if( options === undefined )
  options = Object.create( null );
  defaults = defaults || routine.defaults;

  _.assert( arguments.length === 2 || arguments.length === 3,'expects 2 or 3 arguments' );
  _.assert( _.routineIs( routine ),'expects routine' );
  _.assert( _.objectIs( defaults ),'expects routine with defined defaults' );
  _.assert( _.objectIs( options ),'expects object' );
  _.assert( args.length === 0 || args.length === 1, 'routineOptions : expects single options map, but got',args.length,'arguments' );

  _.assertMapHasOnly( options, defaults );
  _.mapComplementPreservingUndefines( options, defaults );

  return options;
}

//

function routineOptionsReplacingUndefines( routine, args, defaults )
{

  if( !_.argumentsArrayIs( args ) )
  args = [ args ];
  var options = args[ 0 ];
  if( options === undefined )
  options = Object.create( null );
  defaults = defaults || routine.defaults;

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects 2 or 3 arguments' );
  _.assert( _.routineIs( routine ), 'expects routine' );
  _.assert( _.objectIs( defaults ), 'expects routine with defined defaults or defaults in third argument' );
  _.assert( _.objectIs( options ), 'expects object' );
  _.assert( args.length === 0 || args.length === 1, 'expects single options map, but got',args.length,'arguments' );

  _.assertMapHasOnly( options, defaults );
  _.mapComplementReplacingUndefines( options, defaults );

  return options;
}

//

function assertRoutineOptionsPreservingUndefines( routine, args, defaults )
{

  if( !_.argumentsArrayIs( args ) )
  args = [ args ];
  var options = args[ 0 ];
  defaults = defaults || routine.defaults;

  _.assert( arguments.length === 2 || arguments.length === 3,'expects 2 or 3 arguments' );
  _.assert( _.routineIs( routine ),'expects routine' );
  _.assert( _.objectIs( defaults ),'expects routine with defined defaults or defaults in third argument' );
  _.assert( _.objectIs( options ),'expects object' );
  _.assert( args.length === 0 || args.length === 1, 'expects single options map, but got',args.length,'arguments' );

  _.assertMapHasOnly( options,defaults );
  _.assertMapHasAll( options,defaults );

  return options;
}

//

function routineOptionsFromThis( routine, _this, constructor )
{

  _.assert( arguments.length === 3,'routineOptionsFromThis : expects 3 arguments' );

  var options = _this || Object.create( null );
  if( Object.isPrototypeOf.call( constructor,_this ) || constructor === _this )
  options = Object.create( null );

  return _.routineOptions( routine,options );
}

//

function routineExtend( dst )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.routineIs( dst ) || dst === null );

  /* generate dst routine */

  if( dst === null )
  {

    let dstMap = Object.create( null );
    for( var a = 0 ; a < arguments.length ; a++ )
    {
      let src = arguments[ a ];
      if( src === null )
      continue
      _.mapExtend( dstMap, src )
    }

    if( dstMap.pre && dstMap.body )
    dst = _.routineForPreAndBody( dstMap.pre, dstMap.body );
    else
    _.assert( 0, 'Not clear how to construct the routine' );
  }

  /* shallow clone properties of dst routine */

  for( var s in dst )
  {
    var property = dst[ s ];
    if( _.mapIs( property ) )
    {
      property = _.mapExtend( null, property );
      dst[ s ] = property;
    }
  }

  /* extend dst routine */

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    if( src === null )
    continue;
    for( var s in src )
    {
      var property = src[ s ];
      let d = Object.getOwnPropertyDescriptor( dst, s );
      if( d && !d.wratable )
      continue;
      if( _.objectIs( property ) )
      {
        _.assert( !_.mapHas( dst, s ) || _.mapIs( dst[ s ] ) );
        property = Object.create( property );
        if( dst[ s ] )
        _.mapExtend( property, dst[ s ] );
      }
      dst[ s ] = property;
    }
  }

  return dst;
}

// function routineExtend( dst )
// {
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( _.routineIs( dst ) || dst === null );
//
//   /* */
//
//   let originalDst = dst;
//   if( dst === null )
//   {
//     dst = Object.create( null );
//   }
//
//   /* */
//
//   for( var s in dst )
//   {
//     var el = dst[ s ];
//     if( _.mapIs( el ) )
//     {
//       el = _.mapExtend( null, el );
//       dst[ s ] = el;
//     }
//   }
//
//   /* */
//
//   for( var a = 1 ; a < arguments.length ; a++ )
//   {
//     var src = arguments[ a ];
//     _.assert( _.routineIs( src ) || _.mapIs( src ) );
//     for( var s in src )
//     {
//       var el = src[ s ];
//       if( _.objectIs( el ) )
//       {
//         _.assert( !_.mapHas( dst, s ) || _.mapIs( dst[ s ] ) );
//         el = Object.create( el );
//         if( dst[ s ] )
//         _.mapExtend( el, dst[ s ] );
//       }
//       dst[ s ] = el;
//     }
//   }
//
//   /* */
//
//   if( originalDst === null )
//   {
//     let routine, result;
//
//     for( var a = 1 ; a < arguments.length ; a++ )
//     if( _.routineIs( arguments[ a ] ) )
//     {
//       routine = arguments[ a ];
//       break;
//     }
//
//     if( dst.pre && dst.body )
//     result = _.routineForPreAndBody( dst.pre, dst.body );
//     else
//     _.assert( 0, 'Not clear how to construct the routine' );
//
//     _.mapExtend( result, dst );
//
//     dst = result;
//   }
//
//   /* */
//
//   return dst;
// }

//

function routineForPreAndBody_pre( routine, args )
{
  let o = args[ 0 ];

  if( args[ 1 ] !== undefined )
  {
    o = { pre : args[ 0 ], body : args[ 1 ] };
  }

  _.routineOptions( routine, o );
  _.assert( args.length === 1 || args.length === 2, 'expects exactly two arguments' );
  _.assert( arguments.length === 2 );
  _.assert( _.routineIs( o.pre ) || _.routinesAre( o.pre ) );
  _.assert( _.routineIs( o.body ) );
  _.assert( !!o.body.defaults, 'body should have defaults' );
  // _.assertMapHasOnly( o.pre, o.preProperties, '{-pre-} should not have such properties' );
  // _.assertMapHasOnly( o.body, o.bodyProperties, '{-body-} should not have such properties' );

  return o;
}

//

function routineForPreAndBody_body( o )
{

  _.assert( arguments.length === 1 );

  if( !_.routineIs( o.pre ) )
  {
    // o.pre = _.routinesChain( o.pre );
    let _pre = _.routinesCompose( o.pre, function( element, index, args, op )
    {
      // debugger;
      _.assert( arguments.length === 4 );
      _.assert( !_.unrollIs( element ) );
      _.assert( _.objectIs( element ) );
      return _.unrollAppend([ callPreAndBody, [ element ] ]);
      // return args;
    });
    o.pre = function pre()
    {
      let result = _pre.apply( this, arguments );
      return result[ result.length-1 ];
    }
  }

  let pre = o.pre;
  let body = o.body;

  _.routineExtend( callPreAndBody, o.body );

  callPreAndBody.pre = o.pre;
  callPreAndBody.body = o.body;

  return callPreAndBody;

  /* */

  function callPreAndBody()
  {
    let result;
    let o = pre.call( this, callPreAndBody, arguments );
    _.assert( !_.argumentsArrayIs( o ), 'does not expect arguments array' );
    if( _.unrollIs( o ) )
    result = body.apply( this, o );
    else
    result = body.call( this, o );
    return result;
  }

}

routineForPreAndBody_body.defaults =
{
  pre : null,
  body : null,
  preProperties : {},
  bodyProperties : { defaults : null },
}

//

function routineForPreAndBody()
{
  let o = routineForPreAndBody.pre.call( this, routineForPreAndBody, arguments );
  let result = routineForPreAndBody.body.call( this, o );
  return result;
}

routineForPreAndBody.pre = routineForPreAndBody_pre;
routineForPreAndBody.body = routineForPreAndBody_body;
routineForPreAndBody.defaults = routineForPreAndBody_body.defaults;

//

function routineVectorize_functor( o )
{

  if( routineIs( o ) || strIs( o ) )
  o = { routine : o }
  o = routineOptions( routineVectorize_functor, o );

  if( _.arrayIs( o.routine ) && o.routine.length === 1 )
  o.routine = o.routine[ 0 ];

  var routine = o.routine;
  var fieldFilter = o.fieldFilter;
  var bypassingFilteredOut = o.bypassingFilteredOut;
  var vectorizingArray = o.vectorizingArray;
  var vectorizingMap = o.vectorizingMap;
  var vectorizingKeys = o.vectorizingKeys;
  var pre = null;
  var select = o.select === null ? 1 : o.select;
  var selectAll = o.select === Infinity;
  var multiply = select > 1 ? multiplyReally : multiplyNo;

  routine = normalizeRoutine( routine );

  _.assert( routineIs( routine ), 'expects routine {-o.routine-}, but got', _.strTypeOf( routine ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( select >= 1 || _.strIs( select ) || _.arrayIs( select ), 'expects {-o.select-} as number >= 1, string or array, but got', select );

  /* */

  var resultRoutine = vectorizeArray;

  if( _.numberIs( select ) )
  {
    if( !vectorizingArray && !vectorizingMap && !vectorizingKeys )
    resultRoutine = routine;
    else if( fieldFilter )
    resultRoutine = vectorizeWithFilters;
    else if( vectorizingKeys )
    {
      _.assert( !vectorizingMap, '{-o.vectorizingKeys-} and {-o.vectorizingMap-} should not be enabled at same time' );
      resultRoutine = vectorizeKeysOrArray;
    }
    else if( !vectorizingArray || vectorizingMap )
    resultRoutine = vectorizeMapOrArray;
    else if( multiply === multiplyNo )
    resultRoutine = vectorizeArray;
    else
    resultRoutine = vectorizeArrayMultiplying;

    /*
      vectorizeWithFilters : multiply + array/map vectorizing + filter
      vectorizeArray : array vectorizing
      vectorizeArrayMultiplying :  multiply + array vectorizing
      vectorizeMapOrArray :  multiply +  array/map vectorizing
    */

  }
  else
  {
    _.assert( multiply === multiplyNo, 'not implemented' );
    if( routine.pre )
    {
      pre = routine.pre;
      routine = routine.body;
    }
    if( fieldFilter )
    _.assert( 0, 'not implemented' );
    else if( vectorizingArray || !vectorizingMap )
    {
      if( _.strIs( select ) )
      resultRoutine = vectorizeForOptionsMap;
      else
      resultRoutine = vectorizeForOptionsMapForKeys;
    }
    else
    _.assert( 0, 'not implemented' );
  }

  /* */

  _.routineExtend( resultRoutine, routine );

  /* */

  return resultRoutine;

  /* - */

  function normalizeRoutine( routine )
  {

    if( _.strIs( routine ) )
    {
      return function methodCall()
      {
        return this[ routine ].apply( this, arguments );
      }
    }
    else if( _.arrayIs( routine ) )
    {
      _.assert( routine.length === 2 );
      return function methodCall()
      {
        let c = this[ routine[ 0 ] ];
        return c[ routine[ 1 ] ].apply( c, arguments );
      }
    }

    return routine;
  }

  /* - */

  function multiplyNo( args )
  {
    return args;
  }

  /* - */

  function multiplyReally( args )
  {
    var length;
    var keys;

    args = _.longSlice( args );

    if( selectAll )
    select = args.length;

    _.assert( args.length === select, 'expects', select, 'arguments but got:', args.length );

    for( var d = 0 ; d < select ; d++ )
    {
      if( vectorizingArray && _.arrayIs( args[ d ] ) )
      {
        length = args[ d ].length;
        break;
      }
      if( vectorizingMap && _.mapIs( args[ d ] ) )
      {
        keys = _.mapOwnKeys( args[ d ] );
        break;
      }
    }

    if( length !== undefined )
    {
      for( var d = 0 ; d < select ; d++ )
      {
        if( vectorizingMap /* || vectorizingKeys  */)
        _.assert( !_.mapIs( args[ d ] ), 'Arguments should have only arrays or only maps, but not both. Incorrect argument:', args[ d ] ); // qqq
        else if( vectorizingKeys && _.mapIs( args[ d ] ) )
        continue;

        args[ d ] = _.multiple( args[ d ], length );
      }

    }
    else if( keys !== undefined )
    {
      for( var d = 0 ; d < select ; d++ )
      if( _.mapIs( args[ d ] ) )
      _.assert( _.arraySetIdentical( _.mapOwnKeys( args[ d ] ), keys ), 'Maps should have same keys:', keys );
      else
      {
        if( vectorizingArray )
        _.assert( !_.longIs( args[ d ] ), 'Arguments should have only arrays or only maps, but not both. Incorrect argument:', args[ d ] );

        let arg = Object.create( null );
        _.mapSetWithKeys( arg, keys, args[ d ] );
        args[ d ] = arg;
      }
    }

    return args;
  }

  /* - */

  function vectorizeArray()
  {

    // _.assert( arguments.length === 1, 'expects single argument' );

    let args = arguments;
    let src = args[ 0 ];

    if( _.longIs( src ) )
    {
      let args2 = _.longSlice( args );
      var result = [];
      for( var r = 0 ; r < src.length ; r++ )
      {
        args2[ 0 ] = src[ r ];
        result[ r ] = routine.apply( this, args2 );
      }
      return result;
    }

    return routine.apply( this, args );
  }

  /* - */

  function vectorizeArrayMultiplying()
  {

    // _.assert( arguments.length === 1, 'expects single argument' );

    let args = multiply( arguments );
    let src = args[ 0 ];

    if( _.longIs( src ) )
    {
      let args2 = _.longSlice( args );
      var result = [];
      for( var r = 0 ; r < src.length ; r++ )
      {
        for( var m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ];
        result[ r ] = routine.apply( this, args2 );
      }
      return result;
    }

    return routine.apply( this, args );
  }

  /* - */

  function vectorizeForOptionsMap( srcMap )
  {
    var src = srcMap[ select ];

    _.assert( arguments.length === 1, 'expects single argument' );

    if( _.longIs( src ) )
    {
      var args = _.longSlice( arguments );
      if( pre )
      {
        args = pre( routine, args );
        _.assert( _.arrayLikeResizable( args ) );
      }
      var result = [];
      for( var r = 0 ; r < src.length ; r++ )
      {
        args[ 0 ] = _.mapExtend( null, srcMap );
        args[ 0 ][ select ] = src[ r ];
        result[ r ] = routine.apply( this, args );
      }
      return result;
    }

    return routine.apply( this, arguments );
  }

  /* - */

  function vectorizeForOptionsMapForKeys()
  {
    var result = [];

    for( var i = 0; i < o.select.length; i++ )
    {
      select = o.select[ i ];
      result[ i ] = vectorizeForOptionsMap.apply( this, arguments );
    }
    return result;
  }

  /* - */

  function vectorizeMapOrArray()
  {

    // _.assert( arguments.length === 1, 'expects single argument' );
    let args = multiply( arguments );
    let src = args[ 0 ];

    if( vectorizingArray && _.longIs( src ) )
    {
      let args2 = _.longSlice( args );
      var result = [];
      for( var r = 0 ; r < src.length ; r++ )
      {
        for( var m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ];
        // args2[ 0 ] = src[ r ];
        result[ r ] = routine.apply( this, args2 );
      }
      return result;
    }
    else if( vectorizingMap && _.mapIs( src ) )
    {
      let args2 = _.longSlice( args );
      // debugger;
      // _.assert( 0, 'not tested' );
      // _.assert( select === 1, 'not implemented' );
      var result = Object.create( null );
      for( var r in src )
      {
        for( var m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ];

        // args2[ 0 ] = src[ r ];
        result[ r ] = routine.apply( this, args2 );
      }
      return result;
    }

    return routine.apply( this, arguments );
  }

  /* - */

  function vectorizeWithFilters( src )
  {

    _.assert( 0, 'not tested' );
    _.assert( arguments.length === 1, 'expects single argument' );

    let args = multiply( arguments );

    // {
    //   args[ 0 ] = src[ r ];
    //   result[ r ] = routine.apply( this, args );
    // }

    if( vectorizingArray && _.longIs( src ) )
    {
      args = _.longSlice( args );
      var result = [];
      throw _.err( 'not tested' );
      for( var r = 0 ; r < src.length ; r++ )
      {
        if( fieldFilter( src[ r ],r,src ) )
        {
          args[ 0 ] = src[ r ];
          result.push( routine.apply( this,args ) );
        }
        else if( bypassingFilteredOut )
        {
          result.push( src[ r ] );
        }
      }
      return result;
    }
    else if( vectorizingMap && _.mapIs( src ) )
    {
      args = _.longSlice( args );
      var result = Object.create( null );
      throw _.err( 'not tested' );
      for( var r in src )
      {
        if( fieldFilter( src[ r ],r,src ) )
        {
          args[ 0 ] = src[ r ];
          result[ r ] = routine.apply( this, args );
        }
        else if( bypassingFilteredOut )
        {
          result[ r ] = src[ r ];
        }
      }
      return result;
    }

    return routine.call( this,src );
  }

  /* - */

  function vectorizeKeysOrArray()
  {
    let args = multiply( arguments );
    let src = args[ 0 ];
    let args2;
    let result;
    let map;
    let mapIndex;
    let arr;

    _.assert( args.length === select, 'expects', select, 'arguments but got:', args.length );

    if( vectorizingKeys )
    {
      for( let d = 0; d < select; d++ )
      {
        if( vectorizingArray && _.arrayIs( args[ d ] ) )
        arr = args[ d ];
        else if( _.mapIs( args[ d ] ) )
        {
          _.assert( map === undefined, 'Arguments should have only single map. Incorrect argument:', args[ d ] ); // qqq
          map = args[ d ];
          mapIndex = d;
        }
      }
    }

    if( map )
    {
      result = Object.create( null );
      args2 = _.longSlice( args );

      if( vectorizingArray && _.arrayIs( arr ) )
      {
        for( var i = 0; i < arr.length; i++ )
        {
          for( var m = 0 ; m < select ; m++ )
          args2[ m ] = args[ m ][ i ];

          for( let k in map )
          {
            args2[ mapIndex ] = k;
            let key = routine.apply( this, args2 );
            result[ key ] = map[ k ];
          }
        }
      }
      else
      {
        for( let k in map )
        {
          args2[ mapIndex ] = k;
          let key = routine.apply( this, args2 );
          result[ key ] = map[ k ];
        }
      }

      return result;
    }
    else if( vectorizingArray && _.longIs( src ) )
    {
      args2 = _.longSlice( args );
      result = [];
      for( var r = 0 ; r < src.length ; r++ )
      {
        for( var m = 0 ; m < select ; m++ )
        args2[ m ] = args[ m ][ r ];
        // args2[ 0 ] = src[ r ];
        result[ r ] = routine.apply( this, args2 );
      }
      return result;
    }

    return routine.apply( this, arguments );
  }

}

routineVectorize_functor.defaults =
{
  routine : null,
  fieldFilter : null,
  bypassingFilteredOut : 1,
  vectorizingArray : 1,
  vectorizingMap : 0,
  vectorizingKeys : 0,
  select : 1,
}

//

function _equalizerFromMapper( mapper )
{

  if( mapper === undefined )
  mapper = function mapper( a,b ){ return a === b };

  _.assert( 0,'not tested' )
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( mapper.length === 1 || mapper.length === 2 );

  if( mapper.length === 1 )
  {
    var equalizer = function equalizerFromMapper( a,b )
    {
      return mapper( a ) === mapper( b );
    }
    return equalizer;
  }

  return mapper;
}

//

function _comparatorFromEvaluator( evaluator )
{

  if( evaluator === undefined )
  evaluator = function comparator( a,b ){ return a-b };

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( evaluator.length === 1 || evaluator.length === 2 );

  if( evaluator.length === 1 )
  {
    var comparator = function comparatorFromEvaluator( a,b )
    {
      return evaluator( a ) - evaluator( b );
    }
    return comparator;
  }

  return evaluator;
}

// --
// bool
// --

function boolIs( src )
{
  return src === true || src === false;
}

//

function boolLike( src )
{
  var type = _ObjectToString.call( src );
  return type === '[object Boolean]' || type === '[object Number]';
}

//

function boolFrom( src )
{
  if( strIs( src ) )
  {
    src = src.toLowerCase();
    if( src == '0' ) return false;
    if( src == 'false' ) return false;
    if( src == 'null' ) return false;
    if( src == 'undefined' ) return false;
    if( src == '' ) return false;
    return true;
  }
  return Boolean( src );
}

// --
// number
// --

/**
 * Function numberIs checks incoming param whether it is number.
 * Returns "true" if incoming param is object. Othervise "false" returned.
 *
 * @example
 * //returns true
 * numberIs( 5 );
 * @example
 * // returns false
 * numberIs( 'song' );
 *
 * @param {*} src.
 * @return {Boolean}.
 * @function numberIs.
 * @memberof wTools
 */

function numberIs( src )
{
  return typeof src === 'number';
  return _ObjectToString.call( src ) === '[object Number]';
}

//

function numberIsNotNan( src )
{
  return _.numberIs( src ) && !isNaN( src );
}

//

function numberIsFinite( src )
{

  if( !_.numberIs( src ) )
  return false;

  return isFinite( src );
}

//

function numberIsInfinite( src )
{

  if( !_.numberIs( src ) )
  return false;

  return src === +Infinity || src === -Infinity;
}

//

function numberIsInt( src )
{

  if( !_.numberIs( src ) )
  return false;

  return Math.floor( src ) === src;
}

//

function numbersAre( src )
{
  _.assert( arguments.length === 1 );

  if( _.bufferTypedIs( src ) )
  return true;

  if( _.arrayLike( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( !_.numberIs( src[ s ] ) )
    return false;
    return true;
  }

  return false;
}

//

function numbersAreIdentical( src1, src2 )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return Object.is( src1, src2 );
}

//

function numbersAreEquivalent( src1, src2, accuracy )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  if( accuracy === undefined )
  accuracy = _.accuracy;
  return Math.abs( src1-src2 ) <= accuracy;
}

//

function numbersAreFinite( src )
{

  if( _.longIs( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( !numbersAreFinite( src[ s ] ) )
    return false;
    return true;
  }

  if( !_.numberIs( src ) )
  return false;

  return isFinite( src );
}

//

function numbersArePositive( src )
{

  if( _.longIs( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( !numbersArePositive( src[ s ] ) )
    return false;
    return true;
  }

  if( !_.numberIs( src ) )
  return false;

  return src >= 0;
}

//

function numbersAreInt( src )
{

  if( _.longIs( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( !numbersAreInt( src[ s ] ) )
    return false;
    return true;
  }

  if( !_.numberIs( src ) )
  return false;

  return Math.floor( src ) === src;
}

//

function numberInRange( n,range )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( range.length === 2 );
  return range[ 0 ] <= n && n <= range[ 1 ];
}

//

function numbersTotal( numbers )
{
  var result = 0;
  _.assert( _.longIs( numbers ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  for( var n = 0 ; n < numbers.length ; n++ )
  {
    var number = numbers[ n ];
    _.assert( _.numberIs( number ) )
    result += number;
  }
  return result;
}

//

function numberFrom( src )
{
  if( strIs( src ) )
  {
    return parseFloat( src );
  }
  return Number( src );
}

//

function numbersFrom( src )
{
  if( _.strIs( src ) )
  return _.numberFrom( src );

  if( _.longIs( src ) )
  {
    var result = [];
    for( var s = 0 ; s < src.length ; s++ )
    result[ s ] = _.numberFrom( src[ s ] );
  }
  else if( _.objectIs( src ) )
  {
    var result = Object.create( null );
    for( var s in src )
    result[ s ] = _.numberFrom( src[ s ] );
  }

  return result;
}

//

function numbersSlice( src,f,l )
{
  if( _.numberIs( src ) )
  return src;
  return _.longSlice( src,f,l );
}

//

function numberRandomInRange( range )
{

  _.assert( arguments.length === 1 && _.arrayIs( range ),'numberRandomInRange :','expects range( array ) as argument' );
  _.assert( range.length === 2 );

  return _random()*( range[ 1 ] - range[ 0 ] ) + range[ 0 ];

}

//

function numberRandomInt( range )
{

  if( _.numberIs( range ) )
  range = range >= 0 ? [ 0,range ] : [ range,0 ];
  else if( _.arrayIs( range ) )
  range = range;
  else _.assert( 0,'numberRandomInt','expects range' );

  _.assert( _.arrayIs( range ) || _.numberIs( range ) );
  _.assert( range.length === 2 );

  var result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );

  return result;
}

//

function numberRandomIntBut( range )
{
  var result;
  var attempts = 50;

  if( _.numberIs( range ) )
  range = [ 0,range ];
  else if( _.arrayIs( range ) )
  range = range;
  else throw _.err( 'numberRandomInt','unexpected argument' );

  for( var attempt = 0 ; attempt < attempts ; attempt++ )
  {
    // if( attempt === attempts-2 )
    // debugger;
    // if( attempt === attempts-1 )
    // debugger;

    /*result = _.numberRandomInt( range ); */
    var result = Math.floor( range[ 0 ] + Math.random()*( range[ 1 ] - range[ 0 ] ) );

    var bad = false;
    for( var a = 1 ; a < arguments.length ; a++ )
    if( _.routineIs( arguments[ a ] ) )
    {
      if( !arguments[ a ]( result ) )
      bad = true;
    }
    else
    {
      if( result === arguments[ a ] )
      bad = true;
    }

    if( bad )
    continue;
    return result;
  }

  // debugger;
  // console.warn( 'numberRandomIntBut :','NaN' );
  // throw _.err( 'numberRandomIntBut :','NaN' );

  result = NaN;
  return result;
}

//

function numbersMake( src,length )
{
  var result;

  if( _.vectorIs( src ) )
  src = _.vector.slice( src );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.numberIs( src ) || _.arrayLike( src ) );

  if( _.arrayLike( src ) )
  {
    _.assert( src.length === length );
    var result = _.array.makeArrayOfLength( length );
    for( var i = 0 ; i < length ; i++ )
    result[ i ] = src[ i ];
  }
  else
  {
    var result = _.array.makeArrayOfLength( length );
    for( var i = 0 ; i < length ; i++ )
    result[ i ] = src;
  }

  return result;
}

//

function numbersFromNumber( src,length )
{

  if( _.vectorIs( src ) )
  src = _.vector.slice( src );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.numberIs( src ) || _.arrayLike( src ) );

  if( _.arrayLike( src ) )
  {
    _.assert( src.length === length );
    return src;
  }

  var result = _.array.makeArrayOfLength( length );
  for( var i = 0 ; i < length ; i++ )
  result[ i ] = src;

  return result;
}

// {
//
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//   _.assert( _.numberIs( dst ) || _.arrayIs( dst ),'expects array of number as argument' );
//   _.assert( length >= 0 );
//
//   if( _.numberIs( dst ) )
//   {
//     dst = _.arrayFillTimes( [], length , dst );
//   }
//   else
//   {
//     for( var i = 0 ; i < dst.length ; i++ )
//     _.assert( _.numberIs( dst[ i ] ) );
//     _.assert( dst.length === length,'expects array of length',length,'but got',dst );
//   }
//
//   return dst;
// }

//

function numbersFromInt( dst,length )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.numberIsInt( dst ) || _.arrayIs( dst ),'expects array of number as argument' );
  _.assert( length >= 0 );

  if( _.numberIs( dst ) )
  {
    dst = _.arrayFillTimes( [], length , dst );
  }
  else
  {
    for( var i = 0 ; i < dst.length ; i++ )
    _.assert( _.numberIsInt( dst[ i ] ),'expects integer, but got',dst[ i ] );
    _.assert( dst.length === length,'expects array of length',length,'but got',dst );
  }

  return dst;
}

//

function numbersMake_functor( length )
{
  var _ = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.numberIs( length ) );

  function numbersMake( src )
  {
    return _.numbersMake( src,length );
  }

  return numbersMake;
}

//

function numbersFrom_functor( length )
{
  var _ = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.numberIs( length ) );

  function numbersFromNumber( src )
  {
    return _.numbersFromNumber( src,length );
  }

  return numbersFrom;
}

//

function numberClamp( src,low,high )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );

  if( arguments.length === 2 )
  {
    _.assert( arguments[ 1 ].length === 2 );
    low = arguments[ 1 ][ 0 ];
    high = arguments[ 1 ][ 1 ];
  }

  if( src > high )
  return high;

  if( src < low )
  return low;

  return src;
}

//

function numberMix( ins1, ins2, progress )
{
  _.assert( arguments.length === 3, 'expects exactly three argument' );
  return ins1*( 1-progress ) + ins2*( progress );
}

// --
// str
// --

/**
 * Function strIs checks incoming param whether it is string.
 * Returns "true" if incoming param is string. Othervise "false" returned
 *
 * @example
 * //returns true
 * strIsIs( 'song' );
 * @example
 * // returns false
 * strIs( 5 );
 *
 * @param {*} src.
 * @return {Boolean}.
 * @function strIs.
 * @memberof wTools
 */

function strIs( src )
{
  var result = _ObjectToString.call( src ) === '[object String]';
  return result;
}

//

function strsAre( src )
{
  _.assert( arguments.length === 1 );

  if( _.arrayLike( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( !_.strIs( src[ s ] ) )
    return false;
    return true;
  }

  return false;
}

//

function strIsNotEmpty( src )
{
  if( !src )
  return false;
  var result = _ObjectToString.call( src ) === '[object String]';
  return result;
}

//

function strsAreNotEmpty( src )
{
  if( _.arrayLike( src ) )
  {
    for( var s = 0 ; s < src.length ; s++ )
    if( !_.strIsNotEmpty( src[ s ] ) )
    return false;
    return true;
  }
  return false;
}

//

/**
  * Return type of src.
  * @example
      var str = _.strTypeOf( 'testing' );
  * @param {*} src
  * @return {string}
  * string name of type src
  * @function strTypeOf
  * @memberof wTools
  */

function strTypeOf( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.primitiveIs( src ) )
  if( src.constructor && src.constructor.name )
  return src.constructor.name;

  var result = _.strPrimitiveTypeOf( src );

  if( result === 'Object' )
  {
    if( Object.getPrototypeOf( src ) === null )
    result = 'Map:Pure';
    else if( src.__proto__ !== Object.__proto__ )
    result = 'Object:Special';
  }

  return result;
}

//

/**
  * Return primitive type of src.
  * @example
      var str = _.strPrimitiveTypeOf( 'testing' );
  * @param {*} src
  * @return {string}
  * string name of type src
  * @function strPrimitiveTypeOf
  * @memberof wTools
  */

function strPrimitiveTypeOf( src )
{

  var name = _ObjectToString.call( src );
  var result = /\[(\w+) (\w+)\]/.exec( name );

  if( !result )
  throw _.err( 'strTypeOf :','unknown type',name );
  return result[ 2 ];
}

//

/**
  * Return in one string value of all arguments.
  * @example
   var args = _.str( 'test2' );
  * @return {string}
  * If no arguments return empty string
  * @function str
  * @memberof wTools
  */

function str()
{
  var result = '';
  var line;

  if( !arguments.length )
  return result;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var src = arguments[ a ];

    if( src && src.toStr && !_ObjectHasOwnProperty.call( src, 'constructor' ) )
    line = src.toStr();
    else try
    {
      line = String( src );
    }
    catch( err )
    {
      line = _.strTypeOf( src );
    }

    result += line + ' ';
  }

  return result;
}

str.fields = str;
str.routines = str;

//

function _strFirst( src, ent )
{

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( src ) );

  ent = _.arrayAs( ent );

  let result = Object.create( null );
  result.index = src.length;
  result.entry = undefined;

  for( var k = 0, len = ent.length ; k < len ; k++ )
  {
    let entry = ent[ k ];
    if( _.strIs( entry ) )
    {
      let found = src.indexOf( entry );
      if( found >= 0 && ( found < result.index || result.entry === undefined ) )
      {
        result.index = found;
        result.entry = entry;
      }
    }
    else if( _.regexpIs( entry ) )
    {
      let found = src.match( entry );
      if( found && ( found.index < result.index || result.entry === undefined ) )
      {
        result.index = found.index;
        result.entry = found[ 0 ];
      }
    }
    else _.assert( 0, 'expects string or regexp' );
  }

  return result;
}

//

function strFirst( src, ent )
{

  _.assert( arguments.length === 2 );

  if( _.arrayLike( src ) )
  {
    let result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _._strFirst( src[ s ], ent );
    return result;
  }
  else
  {
    return _._strFirst( src, ent );
  }

}

//

/*

(bb)(?!(?=.).*(?:bb))
aaa_bbb_|bb|b_ccc_ccc

.*(bb)
aaa_bbb_b|bb|_ccc_ccc

(b+)(?!(?=.).*(?:b+))
aaa_bbb_|bbb|_ccc_ccc

.*(b+)
aaa_bbb_bb|b|_ccc_ccc

*/

function _strLast( src, ent )
{

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( src ) );

  ent = _.arrayAs( ent );

  let result = Object.create( null );
  result.index = -1;
  result.entry = undefined;

  for( var k = 0, len = ent.length ; k < len ; k++ )
  {
    let entry = ent[ k ];
    if( _.strIs( entry ) )
    {
      let found = src.lastIndexOf( entry );
      if( found >= 0 && found > result.index )
      {
        result.index = found;
        result.entry = entry;
      }
    }
    else if( _.regexpIs( entry ) )
    {

      // entry = _.regexpsJoin([ entry, '(?!(?=.).*(?:))' ]);
      // debugger;

      let regexp1 = _.regexpsJoin([ '.*', '(', entry, ')' ]);
      let match1 = src.match( regexp1 );
      if( !match1 )
      continue;

      let regexp2 = _.regexpsJoin([ entry, '(?!(?=.).*', entry, ')' ]);
      let match2 = src.match( regexp2 );
      _.assert( !!match2 );

      let found;
      let found1 = match1[ 1 ];
      let found2 = match2[ 0 ];
      let index;
      let index1 = match1.index + match1[ 0 ].length;
      let index2 = match2.index + match2[ 0 ].length;

      if( index1 === index2 )
      {
        if( found1.length < found2.length )
        {
          debugger;
          found = found2;
          index = index2 - found.length;
        }
        else
        {
          debugger;
          found = found1;
          index = index1 - found.length;
        }
      }
      else if( index1 < index2 )
      {
        found = found2;
        index = index2 - found.length;
      }
      else
      {
        debugger;
        found = found1;
        index = index1 - found.length;
      }

      if( index > result.index )
      {
        result.index = index;
        result.entry = found;
      }

    }
    else _.assert( 0, 'expects string or regexp' );
  }

  return result;
}

//

function strLast( src, ent )
{

  _.assert( arguments.length === 2 );

  if( _.arrayLike( src ) )
  {
    let result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _._strLast( src[ s ], ent );
    return result;
  }
  else
  {
    return _._strLast( src, ent );
  }

}

//

/**
  * Returns part of a source string( src ) between first occurrence of( begin ) and last occurrence of( end ).
  * Returns result if ( begin ) and ( end ) exists in source( src ) and index of( end ) is bigger the index of( begin ).
  * Otherwise returns undefined.
  *
  * @param { String } src - The source string.
  * @param { String } begin - String to find from begin of source.
  * @param { String } end - String to find from end source.
  *
  * @example
  * _.strIsolateInsideOrNone( 'abcd', 'a', 'd' );
  * //returns 'bc'
  *
  * @example
  * _.strIsolateInsideOrNone( 'aabcc', 'a', 'c' );
  * //returns 'aabcc'
  *
  * @example
  * _.strIsolateInsideOrNone( 'aabcc', 'a', 'a' );
  * //returns 'a'
  *
  * @example
  * _.strIsolateInsideOrNone( 'abc', 'a', 'a' );
  * //returns undefined
  *
  * @example
  * _.strIsolateInsideOrNone( 'abcd', 'x', 'y' )
  * //returns undefined
  *
  * @example
  * //index of begin is bigger then index of end
  * _.strIsolateInsideOrNone( 'abcd', 'c', 'a' )
  * //returns undefined
  *
  * @returns { string } Returns part of source string between ( begin ) and ( end ) or undefined.
  * @throws { Exception } If all arguments are not strings;
  * @throws { Exception } If ( argumets.length ) is not equal 3.
  * @function strIsolateInsideOrNone
  * @memberof wTools
  */

function _strIsolateInsideOrNone( src, begin, end )
{

  _.assert( _.strIs( src ), 'expects string {-src-}' );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  var b = _.strFirst( src, begin );

  if( b.entry === undefined )
  return;

  var e = _.strLast( src, end );

  if( e.entry === undefined )
  return;

  if( e.index < b.index + b.entry.length )
  return;

  var result = [ src.substring( 0, b.index ), b.entry, src.substring( b.index + b.entry.length, e.index ), e.entry, src.substring( e.index+e.entry.length, src.length ) ];

  return result;
}

//

function strIsolateInsideOrNone( src, begin, end )
{

  _.assert( arguments.length === 3, 'expects exactly three argument' );

  if( _.arrayLike( src ) )
  {
    let result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _._strIsolateInsideOrNone( src[ s ], begin, end );
    return result;
  }
  else
  {
    return _._strIsolateInsideOrNone( src, begin, end );
  }

}

//

function _strIsolateInsideOrAll( src, begin, end )
{

  _.assert( _.strIs( src ), 'expects string {-src-}' );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  var b = _.strFirst( src, begin );

  if( b.entry === undefined )
  b = { entry : '', index : 0 }

  var e = _.strLast( src, end );

  if( e.entry === undefined )
  e = { entry : '', index : src.length }

  if( e.index < b.index + b.entry.length )
  {
    e.index = src.length;
    e.entry = '';
  }

  var result = [ src.substring( 0, b.index ), b.entry, src.substring( b.index + b.entry.length, e.index ), e.entry, src.substring( e.index+e.entry.length, src.length ) ];

  return result;
}

//

function strIsolateInsideOrAll( src, begin, end )
{

  _.assert( arguments.length === 3, 'expects exactly three argument' );

  if( _.arrayLike( src ) )
  {
    let result = [];
    for( let s = 0 ; s < src.length ; s++ )
    result[ s ] = _._strIsolateInsideOrAll( src[ s ], begin, end );
    return result;
  }
  else
  {
    return _._strIsolateInsideOrAll( src, begin, end );
  }

}

//

function _strBeginOf( src,begin )
{

  _.assert( _.strIs( src ), 'expects string' );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.strIs( begin ) )
  {
    if( src.lastIndexOf( begin,0 ) === 0 )
    return begin;
  }
  else if( _.regexpIs( begin ) )
  {
    var matched = begin.exec( src );
    if( matched && matched.index === 0 )
    return matched[ 0 ];
  }
  else _.assert( 0,'expects string or regexp' );

  return false;
}

//

function _strEndOf( src, end )
{

  _.assert( _.strIs( src ), 'expects string' );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.strIs( end ) )
  {
    if( src.indexOf( end, src.length - end.length ) !== -1 )
    return end;
  }
  else if( _.regexpIs( end ) )
  {
    // var matched = end.exec( src );
    var newEnd = RegExp( end.toString().slice(1,-1) + '$' );
    var matched = newEnd.exec( src );
    debugger;
    //if( matched && matched.index === 0 )
    if( matched && matched.index + matched[ 0 ].length === src.length )
    return matched[ 0 ];
  }
  else _.assert( 0, 'expects string or regexp' );

  return false;
}

//

/**
  * Compares two strings.
  * @param { String } src - Source string.
  * @param { String } begin - String to find at begin of source.
  *
  * @example
  * var scr = _.strBegins( "abc","a" );
  * // returns true
  *
  * @example
  * var scr = _.strBegins( "abc","b" );
  * // returns false
  *
  * @returns { Boolean } Returns true if param( begin ) is match with first chars of param( src ), otherwise returns false.
  * @function strBegins
  * @throws { Exception } If one of arguments is not a String.
  * @throws { Exception } If( arguments.length ) is not equal 2.
  * @memberof wTools
  */

function strBegins( src, begin )
{

  _.assert( _.strIs( src ),'expects string {-src-}' );
  _.assert( _.strIs( begin ) || _.regexpIs( begin ) || _.longIs( begin ),'expects string/regexp or array of strings/regexps {-begin-}' );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( !_.longIs( begin ) )
  {
    var result = _._strBeginOf( src, begin );
    return result === false ? result : true;
  }

  for( var b = 0, blen = begin.length ; b < blen; b++ )
  {
    let result = _._strBeginOf( src, begin[ b ] );
    if( result !== false )
    return true;
  }

  return false;
}

//

/**
  * Compares two strings.
  * @param { String } src - Source string.
  * @param { String } end - String to find at end of source.
  *
  * @example
  * var scr = _.strEnds( "abc","c" );
  * // returns true
  *
  * @example
  * var scr = _.strEnds( "abc","b" );
  * // returns false
  *
  * @return { Boolean } Returns true if param( end ) is match with last chars of param( src ), otherwise returns false.
  * @function strEnds
  * @throws { Exception } If one of arguments is not a String.
  * @throws { Exception } If( arguments.length ) is not equal 2.
  * @memberof wTools
  */

function strEnds( src, end )
{

  _.assert( _.strIs( src ),'expects string {-src-}' );
  _.assert( _.strIs( end ) || _.regexpIs( end ) || _.longIs( end ),'expects string/regexp or array of strings/regexps {-end-}' );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( !_.longIs( end ) )
  {
    var result = _._strEndOf( src, end );
    return result === false ? result : true;
  }

  for( var b = 0, blen = end.length ; b < blen; b++ )
  {
    let result = _._strEndOf( src, end[ b ] );
    if( result !== false )
    return true;
  }

  return false;
}

//

/**
  * Finds occurrence of( end ) at the end of source( src ) and removes it if exists.
  * Returns begin part of a source string if occurrence was finded or empty string if arguments are equal, otherwise returns undefined.
  *
  * @param { String } src - The source string.
  * @param { String } end - String to find.
  *
  * @example
  * _.strBeginOf( 'abc', 'c' );
  * //returns 'ab'
  *
  * @example
  * _.strBeginOf( 'abc', 'x' );
  * //returns undefined
  *
  * @returns { String } Returns part of source string without tail( end ) or undefined.
  * @throws { Exception } If all arguments are not strings;
  * @throws { Exception } If ( argumets.length ) is not equal 2.
  * @function strBeginOf
  * @memberof wTools
  */

function strBeginOf( src, begin )
{

  _.assert( _.strIs( src ),'expects string {-src-}' );
  _.assert( _.strIs( begin ) || _.regexpIs( begin ) || _.longIs( begin ),'expects string/regexp or array of strings/regexps {-begin-}' );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );


  if( !_.longIs( begin ) )
  {
    var result = _._strBeginOf( src, begin );
    if( result )
    debugger;
    return result;
  }

  debugger;
  for( var b = 0, blen = begin.length ; b < blen; b++ )
  {
    let result = _._strBeginOf( src, begin[ b ] );
    if( result !== false )
    return result;
  }

  return false;
}

//

/**
  * Finds occurrence of( begin ) at the begining of source( src ) and removes it if exists.
  * Returns end part of a source string if occurrence was finded or empty string if arguments are equal, otherwise returns undefined.
  * otherwise returns undefined.
  *
  * @param { String } src - The source string.
  * @param { String } begin - String to find.
  *
  * @example
  * _.strEndOf( 'abc', 'a' );
  * //returns 'bc'
  *
  * @example
  * _.strEndOf( 'abc', 'c' );
  * //returns undefined
  *
  * @returns { String } Returns part of source string without head( begin ) or undefined.
  * @throws { Exception } If all arguments are not strings;
  * @throws { Exception } If ( argumets.length ) is not equal 2.
  * @function strEndOf
  * @memberof wTools
  */

function strEndOf( src, end )
{

  _.assert( _.strIs( src ),'expects string {-src-}' );
  _.assert( _.strIs( end ) || _.regexpIs( end ) || _.longIs( end ),'expects string/regexp or array of strings/regexps {-end-}' );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  debugger;

  if( !_.longIs( end ) )
  {
    var result = _._strEndOf( src, end );
    return result;
  }

  for( var b = 0, blen = end.length ; b < blen; b++ )
  {
    let result = _._strEndOf( src, end[ b ] );
    if( result !== false )
    return result;
  }

  return false;
}

//

/**
  * Returns part of a source string( src ) between first occurrence of( begin ) and last occurrence of( end ).
  * Returns result if ( begin ) and ( end ) exists in source( src ) and index of( end ) is bigger the index of( begin ).
  * Otherwise returns undefined.
  *
  * @param { String } src - The source string.
  * @param { String } begin - String to find from begin of source.
  * @param { String } end - String to find from end source.
  *
  * @example
  * _.strInsideOf( 'abcd', 'a', 'd' );
  * //returns 'bc'
  *
  * @example
  * _.strInsideOf( 'aabcc', 'a', 'c' );
  * //returns 'aabcc'
  *
  * @example
  * _.strInsideOf( 'aabcc', 'a', 'a' );
  * //returns 'a'
  *
  * @example
  * _.strInsideOf( 'abc', 'a', 'a' );
  * //returns undefined
  *
  * @example
  * _.strInsideOf( 'abcd', 'x', 'y' )
  * //returns undefined
  *
  * @example
  * //index of begin is bigger then index of end
  * _.strInsideOf( 'abcd', 'c', 'a' )
  * //returns undefined
  *
  * @returns { string } Returns part of source string between ( begin ) and ( end ) or undefined.
  * @throws { Exception } If all arguments are not strings;
  * @throws { Exception } If ( argumets.length ) is not equal 3.
  * @function strInsideOf
  * @memberof wTools
  */

function strInsideOf( src, begin, end )
{

  _.assert( _.strIs( src ), 'expects string {-src-}' );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  let beginOf, endOf;

  beginOf = _.strBeginOf( src, begin );
  if( beginOf === false )
  return false;

  debugger;

  endOf = _.strEndOf( src, end );
  if( endOf === false )
  return false;

  debugger;

  var result = src.substring( beginOf.length, src.length - endOf.length );

  return result;
}

//

function strOutsideOf( src, begin, end )
{

  _.assert( _.strIs( src ), 'expects string {-src-}' );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  let beginOf, endOf;

  beginOf = _.strBeginOf( src, begin );
  if( beginOf === false )
  return false;

  endOf = _.strEndOf( src, end );
  if( endOf === false )
  return false;

  var result = beginOf + endOf;

  return result;
}

// --
// regexp
// --

function regexpIs( src )
{
  return _ObjectToString.call( src ) === '[object RegExp]';
}

//

function regexpObjectIs( src )
{
  if( !_.RegexpObject )
  return false;
  return src instanceof _.RegexpObject;
}

//

function regexpLike( src )
{
  if( _.regexpIs( src ) || _.strIs( src ) )
  return true;
  return false;
}

//

function regexpsLike( srcs )
{
  if( !_.arrayIs( srcs ) )
  return false;
  for( var s = 0 ; s < srcs.length ; s++ )
  if( !_.regexpLike( srcs[ s ] ) )
  return false;
  return true;
}

//

function regexpsAreIdentical( src1,src2 )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( !_.regexpIs( src1 ) || !_.regexpIs( src2 ) )
  return false;

  return src1.source === src2.source && src1.flags === src2.flags;
}

//

function _regexpTest( regexp, str )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );
  _.assert( _.strIs( str ) );

  if( _.strIs( regexp ) )
  return regexp === str;
  else
  return regexp.test( str );

}

//

function regexpTest( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return _._regexpTest( regexp, strs );
  else if( _.arrayLike( strs ) )
  return strs.map( ( str ) => _._regexpTest( regexp, str ) )
  else _.assert( 0 );

}

//

function regexpTestAll( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return _._regexpTest( regexp, strs );
  else if( _.arrayLike( strs ) )
  return strs.every( ( str ) => _._regexpTest( regexp, str ) )
  else _.assert( 0 );

}

//

function regexpTestAny( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return _._regexpTest( regexp, strs );
  else if( _.arrayLike( strs ) )
  return strs.some( ( str ) => _._regexpTest( regexp, str ) )
  else _.assert( 0 );

}

//

function regexpTestNone( regexp, strs )
{
  _.assert( arguments.length === 2 );
  _.assert( _.regexpLike( regexp ) );

  if( _.strIs( strs ) )
  return !_._regexpTest( regexp, strs );
  else if( _.arrayLike( strs ) )
  return !strs.some( ( str ) => _._regexpTest( regexp, str ) )
  else _.assert( 0 );

}

//

/*
qqq : add test coverage
*/

//

function regexpsTestAll( regexps, strs )
{
  _.assert( arguments.length === 2 );

  if( !_.arrayIs( regexps ) )
  return _.regexpTestAll( regexps, strs );

  _.assert( _.regexpsLike( regexps ) );

  return regexps.every( ( regexp ) => _.regexpTestAll( regexp, strs ) );
}

//

function regexpsTestAny( regexps, strs )
{
  _.assert( arguments.length === 2 );

  if( !_.arrayIs( regexps ) )
  return _.regexpTestAny( regexps, strs );

  _.assert( _.regexpsLike( regexps ) );

  return regexps.some( ( regexp ) => _.regexpTestAny( regexp, strs ) );
}

//

function regexpsTestNone( regexps, strs )
{
  _.assert( arguments.length === 2 );

  if( !_.arrayIs( regexps ) )
  return _.regexpTestNone( regexps, strs );

  _.assert( _.regexpsLike( regexps ) );

  return regexps.every( ( regexp ) => _.regexpTestNone( regexp, strs ) );
}

//

/**
 * Escapes special characters with a slash ( \ ). Supports next set of characters : .*+?^=! :${}()|[]/\
 *
 * @example
 * wTools.regexpEscape( 'Hello. How are you?' ); // "Hello\. How are you\?"
 * @param {String} src Regexp string
 * @returns {String} Escaped string
 * @function regexpEscape
 * @memberof wTools
 */

function regexpEscape( src )
{
  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  return src.replace( /([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1" );
}

/* qqq : /(\s*)var _global \= _global_; var _ \= _global_\.wTools;/g */

//

var regexpsEscape = null;

//

/**
 * Make regexp from string.
 *
 * @example
 * wTools.regexpFrom( 'Hello. How are you?' ); // /Hello\. How are you\?/
 * @param {String} src - string or regexp
 * @returns {String} Regexp
 * @throws {Error} Throw error with message 'unknown type of expression, expects regexp or string, but got' error
 if src not string or regexp
 * @function regexpFrom
 * @memberof wTools
 */

function regexpFrom( src, flags )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( flags === undefined || _.strIs( flags ) );

  if( _.regexpIs( src ) )
  return src;

  _.assert( _.strIs( src ) );

  return new RegExp( _.regexpEscape( src ),flags );
}

//
//
// function regexpMaybeFrom( src, flags )
// {
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//   _.assert( flags === undefined || _.strIs( flags ) );
//
//   if( !_.strIs( src ) )
//   return src;
//
//   if( !_.strBegins( src,'/' ) || !_.strEnds( src,'/' ) )
//   return src;
//
//   src = _.strRemoveBegin( src,'/' );
//   src = _.strRemoveEnd( src,'/' );
//
//   return new RegExp( src,flags );
// }
//
//

function regexpMaybeFrom( o )
{
  if( !_.objectIs( o ) )
  o = { srcStr : arguments[ 0 ] }

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( o.srcStr ) || _.regexpIs( o.srcStr ) );
  _.routineOptions( regexpMaybeFrom, o );

  var result = o.srcStr;

  if( _.strIs( result ) )
  {

    // var optionsExtract =
    // {
    //   prefix : '//',
    //   postfix : '//',
    //   src : result,
    // }
    // var strips = _.strExtractInlinedStereo( optionsExtract );

    if( o.stringWithRegexp )
    {

      var optionsExtract =
      {
        delimeter : '//',
        src : result,
      }
      var strips = _.strExtractInlined( optionsExtract );

      // if( strips.length > 1 )
      // debugger;

    }
    else
    {
      var strips = [ result ];
    }

    for( var s = 0 ; s < strips.length ; s++ )
    {
      var strip = strips[ s ];

      if( s % 2 === 0 )
      {
        strip = _.regexpEscape( strip );
        if( o.toleratingSpaces )
        strip = strip.replace( /\s+/g,'\\s*' );
      }

      strips[ s ] = strip;
    }

    result = RegExp( strips.join( '' ), o.flags );
  }

  return result;
}

regexpMaybeFrom.defaults =
{
  srcStr : null,
  stringWithRegexp : 1,
  toleratingSpaces : 1,
  flags : 'g',
}

//

var regexpsMaybeFrom = null;

//

function regexpsSources( o )
{
  if( _.arrayIs( arguments[ 0 ] ) )
  {
    var o = Object.create( null );
    o.sources = arguments[ 0 ];
  }

  // o.sources = o.sources ? _.longSlice( o.sources ) : [];
  o.sources = _.longSlice( o.sources );
  if( o.flags === undefined )
  o.flags = null;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( regexpsSources, o );

  /* */

  for( var s = 0 ; s < o.sources.length ; s++ )
  {
    var src = o.sources[ s ];
    if( _.regexpIs( src ) )
    {
      o.sources[ s ] = src.source;
      _.assert( o.flags === null || src.flags === o.flags, () => 'All RegExps should have flags field with the same value ' + _.strQuote( src.flags ) + ' != ' + _.strQuote( o.flags ) );
      if( o.flags === null )
      o.flags = src.flags;
    }
    else
    {
      if( o.escaping )
      o.sources[ s ] = _.regexpEscape( src );
    }
    _.assert( _.strIs( o.sources[ s ] ) );
  }

  /* */

  return o;
}

regexpsSources.defaults =
{
  sources : null,
  flags : null,
  escaping : 0,
}

//

function regexpsJoin( o )
{
  if( !_.objectIs( o ) )
  o = { sources : o }

  _.routineOptions( regexpsJoin, o );
  _.assert( arguments.length === 1, 'expects single argument' );

  var src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  var result = o.sources.join( '' );

  return new RegExp( result, o.flags || '' );
}

regexpsJoin.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsJoinEscaping( o )
{
  if( !_.objectIs( o ) )
  o = { sources : o }

  _.routineOptions( regexpsJoinEscaping, o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( !!o.escaping );

  return _.regexpsJoin( o );
}

var defaults = regexpsJoinEscaping.defaults = Object.create( regexpsJoin.defaults );

defaults.escaping = 1;

//

function regexpsAtLeastFirst( o )
{

  if( !_.objectIs( o ) )
  o = { sources : o }

  _.routineOptions( regexpsAtLeastFirst, o );
  _.assert( arguments.length === 1, 'expects single argument' );

  var src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  var result = '';
  var prefix = '';
  var postfix = '';

  for( var s = 0 ; s < o.sources.length ; s++ )
  {
    var src = o.sources[ s ];

    if( s === 0 )
    {
      prefix = prefix + src;
    }
    else
    {
      prefix = prefix + '(?:' + src;
      postfix =  ')?' + postfix
    }

  }

  result = prefix + postfix;
  return new RegExp( result, o.flags || '' );
}

regexpsAtLeastFirst.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsAtLeastFirstOnly( o )
{

  if( !_.objectIs( o ) )
  o = { sources : o }

  _.routineOptions( regexpsAtLeastFirst, o );
  _.assert( arguments.length === 1, 'expects single argument' );

  var src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  var result = '';

  if( o.sources.length === 1 )
  {
    result = o.sources[ 0 ]
  }
  else for( var s = 0 ; s < o.sources.length ; s++ )
  {
    var src = o.sources[ s ];
    if( s < o.sources.length-1 )
    result += '(?:' + o.sources.slice( 0, s+1 ).join( '' ) + '$)|';
    else
    result += '(?:' + o.sources.slice( 0, s+1 ).join( '' ) + ')';
  }

  return new RegExp( result, o.flags || '' );
}

regexpsAtLeastFirst.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

/**
 *  Generates "but" regular expression pattern. Accepts a list of words, which will be used in regexp.
 *  The result regexp matches the strings that do not contain any of those words.
 *
 * @example
 * wTools.regexpsNone( 'yellow', 'red', 'green' ); //   /^(?:(?!yellow|red|green).)+$/
 *
 * var options =
 * {
 *    but : [ 'yellow', 'red', 'green' ],
 *    atLeastOnce : false
 * };
 * wTools.regexpsNone(options); // /^(?:(?!yellow|red|green).)*$/
 *
 * @param {Object} [options] options for generate regexp. If this argument omitted then default options will be used
 * @param {String[]} [options.but=null] a list of words,from each will consist regexp
 * @param {boolean} [options.atLeastOne=true] indicates whether search matches at least once
 * @param {...String} [words] a list of words, from each will consist regexp. This arguments can be used instead
 * options object.
 * @returns {RegExp} Result regexp
 * @throws {Error} If passed arguments are not strings or options object.
 * @throws {Error} If options contains any different from 'but' or 'atLeastOnce' properties.
 * @function regexpsNone
 * @memberof wTools
 */

function regexpsNone( o )
{
  if( !_.objectIs( o ) )
  o = { sources : o }

  _.routineOptions( regexpsNone, o );
  _.assert( arguments.length === 1, 'expects single argument' );

  o = _.regexpsSources( o );

  /* ^(?:(?!(?:abc)).)+$ */

  var result = '^(?:(?!(?:';
  result += o.sources.join( ')|(?:' );
  result += ')).)+$';

  return new RegExp( result, o.flags || '' );
}

regexpsNone.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsAny( o )
{
  if( !_.objectIs( o ) )
  o = { sources : o }

  _.routineOptions( regexpsAny, o );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.regexpIs( o.sources ) )
  {
    _.assert( o.sources.flags === o.flags || o.flags === null );
    return o.sources;
  }

  _.assert( !!o.sources );
  var src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  var result = '(?:';
  result += o.sources.join( ')|(?:' );
  result += ')';

  return new RegExp( result, o.flags || '' );
}

regexpsAny.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

function regexpsAll( o )
{
  if( !_.objectIs( o ) )
  o = { sources : o }

  _.routineOptions( regexpsAll, o );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.regexpIs( o.sources ) )
  {
    _.assert( o.sources.flags === o.flags || o.flags === null );
    return o.sources;
  }

  var src = o.sources[ 0 ];
  o = _.regexpsSources( o );
  if( o.sources.length === 1 && _.regexpIs( src ) )
  return src;

  var result = ''

  if( o.sources.length > 0 )
  {

    if( o.sources.length > 1 )
    {
      result += '(?=';
      result += o.sources.slice( 0, o.sources.length-1 ).join( ')(?=' );
      result += ')';
    }

    result += '(?:';
    result += o.sources[ o.sources.length-1 ];
    result += ')';

  }

  return new RegExp( result, o.flags || '' );
}

regexpsAll.defaults =
{
  flags : null,
  sources : null,
  escaping : 0,
}

//

/**
 * Wraps regexp(s) into array and returns it. If in `src` passed string - turn it into regexp
 *
 * @example
 * wTools.regexpArrayMake( ['red', 'white', /[a-z]/] ); // [ /red/, /white/, /[a-z]/ ]
 * @param {String[]|String} src - array of strings/regexps or single string/regexp
 * @returns {RegExp[]} Array of regexps
 * @throw {Error} if `src` in not string, regexp, or array
 * @function regexpArrayMake
 * @memberof wTools
 */

function regexpArrayMake( src )
{

  _.assert( _.regexpLike( src ) || _.arrayLike( src ), 'expects array/regexp/string, got ' + _.strTypeOf( src ) );

  src = _.arrayFlatten( [], _.arrayAs( src ) );

  for( var k = src.length-1 ; k >= 0 ; k-- )
  {
    var e = src[ k ]

    if( e === null )
    {
      src.splice( k,1 );
      continue;
    }

    src[ k ] = _.regexpFrom( e );

  }

  return src;
}

//

/**
 * regexpArrayIndex() returns the index of the first regular expression that matches substring
  Otherwise, it returns -1.
 * @example
 *
   var str = "The RGB color model is an additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors";
   var regArr1 = [/white/, /green/, /blue/];
   wTools.regexpArrayIndex(regArr1, str); // 1

 * @param {RegExp[]} arr Array for regular expressions.
 * @param {String} ins String, inside which will be execute search
 * @returns {number} Index of first matching or -1.
 * @throws {Error} If first argument is not array.
 * @throws {Error} If second argument is not string.
 * @throws {Error} If element of array is not RegExp.
 * @function regexpArrayIndex
 * @memberof wTools
 */

function regexpArrayIndex( arr,ins )
{
  _.assert( _.arrayIs( arr ) );
  _.assert( _.strIs( ins ) );

  for( var a = 0 ; a < arr.length ; a++ )
  {
    var regexp = arr[ a ];
    _.assert( _.regexpIs( regexp ) );
    if( regexp.test( ins ) )
    return a;
  }

  return -1;
}

//

/**
 * Checks if any regexp passed in `arr` is found in string `ins`
 * If match was found - returns match index
 * If no matches found and regexp array is not empty - returns false
 * If regexp array is empty - returns some default value passed in the `ifEmpty` input param
 *
 * @example
 * var str = "The RGB color model is an additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors";
 *
 * var regArr2 = [/yellow/, /blue/, /red/];
 * wTools.regexpArrayAny(regArr2, str, false); // 1
 *
 * var regArr3 = [/yellow/, /white/, /greey/]
 * wTools.regexpArrayAny(regArr3, str, false); // false
 * @param {String[]} arr Array of regular expressions strings
 * @param {String} ins - string that is tested by regular expressions passed in `arr` parameter
 * @param {*} none - Default return value if array is empty
 * @returns {*} Returns the first match index, false if input array of regexp was empty or default value otherwise
 * @thows {Error} If missed one of arguments
 * @function regexpArrayAny
 * @memberof wTools
 */

function regexpArrayAny( arr, ins, ifEmpty )
{

  _.assert( _.arrayIs( arr ) || _.regexpIs( src ) );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  var arr = _.arrayAs( arr );
  for( var m = 0 ; m < arr.length ; m++ )
  {
    _.assert( _.routineIs( arr[ m ].test ) );
    if( arr[ m ].test( ins ) )
    return m;
  }

  return arr.length ? false : ifEmpty;
}

//

/**
 * Checks if all regexps passed in `arr` are found in string `ins`
 * If any of regex was not found - returns match index
 * If regexp array is not empty and all regexps passed test - returns true
 * If regexp array is empty - returns some default value passed in the `ifEmpty` input param
 *
 * @example
 * var str = "The RGB color model is an additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors";
 *
 * var regArr1 = [/red/, /green/, /blue/];
 * wTools.regexpArrayAll(regArr1, str, false); // true
 *
 * var regArr2 = [/yellow/, /blue/, /red/];
 * wTools.regexpArrayAll(regArr2, str, false); // 0
 * @param {String[]} arr Array of regular expressions strings
 * @param {String} ins - string that is tested by regular expressions passed in `arr` parameter
 * @param {*} none - Default return value if array is empty
 * @returns {*} Returns the first match index, false if input array of regexp was empty or default value otherwise
 * @thows {Error} If missed one of arguments
 * @function regexpArrayAll
 * @memberof wTools
 */

function regexpArrayAll( arr, ins, ifEmpty )
{
  _.assert( _.arrayIs( arr ) || _.regexpIs( src ) );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  var arr = _.arrayAs( arr );
  for( var m = 0 ; m < arr.length ; m++ )
  {
    if( !arr[ m ].test( ins ) )
    return m;
  }

  return arr.length ? true : ifEmpty;
}

//

function regexpArrayNone( arr, ins, ifEmpty )
{

  _.assert( _.arrayIs( arr ) || _.regexpIs( src ) );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  var arr = _.arrayAs( arr );
  for( var m = 0 ; m < arr.length ; m++ )
  {
    _.assert( _.routineIs( arr[ m ].test ) );
    if( arr[ m ].test( ins ) )
    return false;
  }

  return arr.length ? true : ifEmpty;
}

// //
//
// /**
//  * Make RegexpObject from different type sources.
//     If passed RegexpObject or map with properties similar to RegexpObject but with string in values, then the second
//  parameter is not required;
//     All strings in sources will be turned into RegExps.
//     If passed single RegExp/String or array of RegExps/Strings, then routine will return RegexpObject with
//  `defaultMode` as key, and array of RegExps created from first parameter as value.
//     If passed array of RegexpObject, mixed with ordinary RegExps/Strings, the result object will be created by merging
//  with shrinking (see [shrink]{@link wTools#shrink}) RegexpObjects and RegExps that associates
//  with `defaultMode` key.
//  *
//  * @example
//    var src = [
//        /hello/,
//        'world',
//        {
//           includeAny : ['yellow', 'blue', 'red'],
//           includeAll : [/red/, /green/, /brown/],
//           excludeAny : [/yellow/, /white/, /grey/],
//           excludeAll : [/red/, /green/, /blue/]
//        }
//    ];
//    wTools.regexpMakeObject(src, 'excludeAll');
//
//    // {
//    //    includeAny: [/yellow/, /blue/, /red/],
//    //    includeAll: [/red/, /green/, /brown/],
//    //    excludeAny: [/yellow/, /white/, /grey/],
//    //    excludeAll: [/hello/, /world/]
//    // }
//  * @param {RegexpObject|String|RegExp|RegexpObject[]|String[]|RegExp[]} src Source for making RegexpObject
//  * @param {String} [defaultMode] key for result RegexpObject map. Can be one of next strings: 'includeAny',
//  'includeAll','excludeAny' or 'excludeAll'.
//  * @returns {RegexpObject} Result RegexpObject
//  * @throws {Error} Missing arguments if call without argument
//  * @throws {Error} Missing arguments if passed array without `defaultMode`
//  * @throws {Error} Unknown mode `defaultMode`
//  * @throws {Error} Unknown src if first argument is not array, map, string or regexp.
//  * @throws {Error} Unexpected if type of array element is not string regexp or RegexpObject.
//  * @throws {Error} Unknown regexp filters if passed map has unexpected properties (see RegexpObject).
//  * @function regexpMakeObject
//  * @memberof wTools
//  */
//
// function regexpMakeObject( src,defaultMode )
// {
//   _.assert( _.routineIs( _.RegexpObject ) );
//   return _.RegexpObject( src,defaultMode );
// }

// --
// time
// --

function dateIs( src )
{
  return _ObjectToString.call( src ) === '[object Date]';
}

//

function datesAreIdentical( src1, src2 )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( !_.dateIs( src1 ) )
  return false;
  if( !_.dateIs( src2 ) )
  return false;

  var src1 = src1.getTime();
  var src2 = src2.getTime();

  return src1 === src2;
}

//

function timeReady( onReady )
{

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( arguments[ 0 ] ) || _.routineIs( arguments[ 0 ] ) || arguments[ 0 ] === undefined );

  var time = 0;
  if( _.numberIs( arguments[ 0 ] ) )
  {
    time = arguments[ 0 ];
    onReady = arguments[ 1 ];
  }

  if( typeof window !== 'undefined' && typeof document !== 'undefined' && document.readyState != 'complete' )
  {
    var con = _.Consequence ? new _.Consequence() : null;

    function handleReady()
    {
      if( _.Consequence )
      return _.timeOut( time,onReady ).doThen( con );
      else if( onReady )
      setTimeout( onReady,time );
      else _.assert( 0 );
    }

    window.addEventListener( 'load',handleReady );
    return con;
  }
  else
  {
    if( _.Consequence )
    return _.timeOut( time,onReady );
    else if( onReady )
    setTimeout( onReady,time );
    else _.assert( 0 );
  }

}

//

function timeReadyJoin( context,routine,args )
{

  routine = _.routineJoin( context,routine,args );

  var result = _.routineJoin( undefined,_.timeReady,[ routine ] );

  function _timeReady()
  {
    var args = arguments;
    routine = _.routineJoin( context === undefined ? this : this,routine,args );
    return _.timeReady( routine );
  }

  return _timeReady;
}

//

function timeOnce( delay,onBegin,onEnd )
{
  var con = _.Consequence ? new _.Consequence() : undefined;
  var taken = false;
  var options;
  var optionsDefault =
  {
    delay : null,
    onBegin : null,
    onEnd : null,
  }

  if( _.objectIs( delay ) )
  {
    options = delay;
    _.assert( arguments.length === 1, 'expects single argument' );
    _.assertMapHasOnly( options,optionsDefault );
    delay = options.delay;
    onBegin = options.onBegin;
    onEnd = options.onEnd;
  }
  else
  {
    _.assert( 2 <= arguments.length && arguments.length <= 3 );
  }

  _.assert( delay >= 0 );
  _.assert( _.primitiveIs( onBegin ) || _.routineIs( onBegin ) || _.objectIs( onBegin ) );
  _.assert( _.primitiveIs( onEnd ) || _.routineIs( onEnd ) || _.objectIs( onEnd ) );

  return function timeOnce()
  {

    if( taken )
    {
      /*console.log( 'timeOnce :','was taken' );*/
      return;
    }
    taken = true;

    if( onBegin )
    {
      if( _.routineIs( onBegin ) ) onBegin.apply( this,arguments );
      else if( _.objectIs( onBegin ) ) onBegin.give( arguments );
      if( con )
      con.give();
    }

    _.timeOut( delay,function()
    {

      if( onEnd )
      {
        if( _.routineIs( onEnd ) ) onEnd.apply( this,arguments );
        else if( _.objectIs( onEnd ) ) onEnd.give( arguments );
        if( con )
        con.give();
      }
      taken = false;

    });

    return con;
  }

}

//

/**
 * Routine creates timer that executes provided routine( onReady ) after some amout of time( delay ).
 * Returns wConsequence instance. @see {@link https://github.com/Wandalen/wConsequence }
 *
 * If ( onReady ) is not provided, timeOut returns consequence that gives empty message after ( delay ).
 * If ( onReady ) is a routine, timeOut returns consequence that gives message with value returned or error throwed by ( onReady ).
 * If ( onReady ) is a consequence or routine that returns it, timeOut returns consequence and waits until consequence from ( onReady ) resolves the message, then
 * timeOut gives that resolved message throught own consequence.
 * If ( delay ) <= 0 timeOut performs all operations on nextTick in node
 * @see {@link https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/#the-node-js-event-loop-timers-and-process-nexttick }
 * or after 1 ms delay in browser.
 * Returned consequence controls the timer. Timer can be easly stopped by giving an error from than consequence( see examples below ).
 * Important - Error that stops timer is returned back as regular message inside consequence returned by timeOut.
 * Also timeOut can run routine with different context and arguments( see example below ).
 *
 * @param {Number} delay - Delay in ms before ( onReady ) is fired.
 * @param {Function|wConsequence} onReady - Routine that will be executed with delay.
 *
 * @example
 * // Simplest, just timer
 * var t = _.timeOut( 1000 );
 * t.got( () => console.log( 'Message with 1000ms delay' ) )
 * console.log( 'Normal message' )
 *
 * @example
 * // Run routine with delay
 * var routine = () => console.log( 'Message with 1000ms delay' );
 * var t = _.timeOut( 1000, routine );
 * t.got( () => console.log( 'Routine finished work' ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // Routine returns consequence
 * var routine = () => new _.Consequence().give( 'msg' );
 * var t = _.timeOut( 1000, routine );
 * t.got( ( err, got ) => console.log( 'Message from routine : ', got ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // timeOut waits for long time routine
 * var routine = () => _.timeOut( 1500, () => 'work done' ) ;
 * var t = _.timeOut( 1000, routine );
 * t.got( ( err, got ) => console.log( 'Message from routine : ', got ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // how to stop timer
 * var routine = () => console.log( 'This message never appears' );
 * var t = _.timeOut( 5000, routine );
 * t.error( 'stop' );
 * t.got( ( err, got ) => console.log( 'Error returned as regular message : ', got ) );
 * console.log( 'Normal message' )
 *
 * @example
 * // running routine with different context and arguments
 * function routine( y )
 * {
 *   var self = this;
 *   return self.x * y;
 * }
 * var context = { x : 5 };
 * var arguments = [ 6 ];
 * var t = _.timeOut( 100, context, routine, arguments );
 * t.got( ( err, got ) => console.log( 'Result of routine execution : ', got ) );
 *
 * @returns {wConsequence} Returns wConsequence instance that resolves message when work is done.
 * @throws {Error} If ( delay ) is not a Number.
 * @throws {Error} If ( onEnd ) is not a routine or wConsequence instance.
 * @function timeOut
 * @memberof wTools
 */

function timeOut( delay, onEnd )
{
  var con = _.Consequence ? new _.Consequence() : undefined;
  var timer = null;
  var handleCalled = false;

  /* */

  if( con )
  con.got( function timeGot( err,arg )
  {
    // if( err )
    // debugger;

    if( err )
    clearTimeout( timer );

    // if( err && !handleCalled )
    // {
    //   arg = err;
    //   err = undefined;
    // }

    con.give( err,arg );
  });

  /* */

  _.assert( arguments.length <= 4 );
  _.assert( _.numberIs( delay ) );

  if( arguments[ 1 ] !== undefined && arguments[ 2 ] === undefined && arguments[ 3 ] === undefined )
  _.assert( _.routineIs( onEnd ) || _.consequenceIs( onEnd ) );
  else if( arguments[ 2 ] !== undefined || arguments[ 3 ] !== undefined )
  _.assert( _.routineIs( arguments[ 2 ] ) );

  function timeEnd()
  {
    var result;

    handleCalled = true;

    if( con )
    {
      if( onEnd )
      con.first( onEnd );
      else
      con.give( timeOut );
    }
    else
    {
      onEnd();
    }

  }

  if( arguments[ 2 ] !== undefined || arguments[ 3 ] !== undefined )
  {
    onEnd = _.routineJoin.call( _,arguments[ 1 ],arguments[ 2 ],arguments[ 3 ] );
  }

  if( delay > 0 )
  timer = setTimeout( timeEnd,delay );
  else
  timeSoon( timeEnd );

  return con;
}

//

var timeSoon = typeof process === 'undefined' ? function( h ){ return setTimeout( h,0 ) } : process.nextTick;

//

/**
 * Routine works moslty same like {@link wTools~timeOut} but has own small features:
 *  Is used to set execution time limit for async routines that can run forever or run too long.
 *  wConsequence instance returned by timeOutError always give an error:
 *  - Own 'timeOut' error message if ( onReady ) was not provided or it execution dont give any error.
 *  - Error throwed or returned in consequence by ( onRead ) routine.
 *
 * @param {Number} delay - Delay in ms before ( onReady ) is fired.
 * @param {Function|wConsequence} onReady - Routine that will be executed with delay.
 *
 * @example
 * // timeOut error after delay
 * var t = _.timeOutError( 1000 );
 * t.got( ( err, got ) => { throw err; } )
 *
 * @example
 * // using timeOutError with long time routine
 * var time = 5000;
 * var timeOut = time / 2;
 * function routine()
 * {
 *   return _.timeOut( time );
 * }
 * // eitherThenSplit waits until one of provided consequences will resolve the message.
 * // In our example single timeOutError consequence was added, so eitherThenSplit adds own context consequence to the queue.
 * // Consequence returned by 'routine' resolves message in 5000 ms, but timeOutError will do the same in 2500 ms and 'timeOut'.
 * routine()
 * .eitherThenSplit( _.timeOutError( timeOut ) )
 * .got( function( err, got )
 * {
 *   if( err )
 *   throw err;
 *   console.log( got );
 * })
 *
 * @returns {wConsequence} Returns wConsequence instance that resolves error message when work is done.
 * @throws {Error} If ( delay ) is not a Number.
 * @throws {Error} If ( onReady ) is not a routine or wConsequence instance.
 * @function timeOutError
 * @memberof wTools
 */

function timeOutError( delay,onReady )
{
  _.assert( _.routineIs( _.Consequence ) );

  var result = _.timeOut.apply( this,arguments );

  result.doThen( function( err,arg )
  {

    if( err )
    return _.Consequence().error( err );

    var err = _.err( 'Time out!' );

    Object.defineProperty( err, 'timeOut',
    {
      enumerable : false,
      configurable : false,
      writable : false,
      value : 1,
    });

    return _.Consequence().error( err );
  });

  return result;
}

//

function timePeriodic( delay,onReady )
{
  _.assert( _.routineIs( _.Consequence ) );
  var con = new _.Consequence();
  var id;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  // if( arguments.length > 2 )
  // {
  //   throw _.err( 'Not tested' );
  //   _.assert( arguments.length <= 4 );
  //   onReady = _.routineJoin( arguments[ 2 ],onReady[ 3 ],arguments[ 4 ] );
  // }

  _.assert( _.numberIs( delay ) );

  function handlePeriodicCon( err )
  {
    if( err ) clearInterval( id );
  }

  var _onReady = null;

  if( _.routineIs( onReady ) )
  _onReady = function()
  {
    var result = onReady.call();
    if( result === false )
    clearInterval( id );
    _.Consequence.give( con, undefined );
    con.doThen( handlePeriodicCon );
  }
  else if( onReady instanceof wConsquence )
  _onReady = function()
  {
    var result = onReady.ping();
    if( result === false )
    clearInterval( id );
    _.Consequence.give( con, undefined );
    con.doThen( handlePeriodicCon );
  }
  else if( onReady === undefined )
  _onReady = function()
  {
    _.Consequence.give( con, undefined );
    con.doThen( handlePeriodicCon );
  }
  else throw _.err( 'unexpected type of onReady' );

  id = setInterval( _onReady,delay );

  return con;
}

//

function _timeNow_functor()
{
  var now;

  // _.assert( arguments.length === 0 );

  if( typeof performance !== 'undefined' && performance.now !== undefined )
  now = _.routineJoin( performance,performance.now );
  else if( Date.now )
  now = _.routineJoin( Date,Date.now );
  else
  now = function(){ return Date().getTime() };

  return now;
}

//

function timeFewer_functor( perTime, routine )
{
  let lastTime = _.timeNow() - perTime;

  _.assert( arguments.length === 2 );
  _.assert( _.numberIs( perTime ) );
  _.assert( _.routineIs( routine ) );

  return function fewer()
  {
    let now = _.timeNow();
    let elapsed = now - lastTime;
    if( elapsed < perTime )
    return;
    lastTime = now;
    return routine.apply( this, arguments );
  }

}

//

function timeFrom( time )
{
  _.assert( arguments.length === 1 );
  if( _.numberIs( time ) )
  return time;
  if( _.dateIs( time ) )
  return time.getTime()
  _.assert( 0, 'Not clear how to coerce to time', _.strTypeOf( time ) );
}

//

function timeSpent( description,time )
{
  var now = _.timeNow();

  if( arguments.length === 1 )
  {
    time = arguments[ 0 ];
    description = 'Spent ';
  }

  _.assert( 1 <= arguments.length && arguments.length <= 2 );
  _.assert( _.numberIs( time ) );
  _.assert( _.strIs( description ) );

  if( description && description !== ' ' )
  description = description;

  var result = description + _.timeSpentFormat( now-time );

  return result;
}

//

function timeSpentFormat( spent )
{
  var now = _.timeNow();

  _.assert( 1 === arguments.length );
  _.assert( _.numberIs( spent ) );

  var result = ( 0.001*( spent ) ).toFixed( 3 ) + 's';

  return result;
}

//

function dateToStr( date )
{
  var y = date.getFullYear();
  var m = date.getMonth() + 1;
  var d = date.getDate();
  if( m < 10 ) m = '0' + m;
  if( d < 10 ) d = '0' + d;
  var result = [ y,m,d ].join( '.' );
  return result;
}

// --
// buffer
// --

function bufferRawIs( src )
{
  var type = _ObjectToString.call( src );
  var result = type === '[object ArrayBuffer]';
  return result;
}

//

function bufferTypedIs( src )
{
  var type = _ObjectToString.call( src );
  if( !/\wArray/.test( type ) )
  return false;
  if( _.bufferNodeIs( src ) )
  return false;
  return true;
}

//

function bufferViewIs( src )
{
  var type = _ObjectToString.call( src );
  var result = type === '[object DataView]';
  return result;
}

//

function bufferNodeIs( src )
{
  if( typeof Buffer !== 'undefined' )
  return src instanceof Buffer;
  return false;
}

//

function bufferAnyIs( src )
{
  if( !src )
  return false;
  return src.byteLength >= 0;
  // return bufferTypedIs( src ) || bufferViewIs( src )  || bufferRawIs( src ) || bufferNodeIs( src );
}

//

function bufferBytesIs( src )
{
  if( _.bufferNodeIs( src ) )
  return false;
  return src instanceof Uint8Array;
}

//

function constructorIsBuffer( src )
{
  if( !src )
  return false;
  if( !_.numberIs( src.BYTES_PER_ELEMENT ) )
  return false;
  if( !_.strIs( src.name ) )
  return false;
  return src.name.indexOf( 'Array' ) !== -1;
}

//

function buffersTypedAreEquivalent( src1, src2, accuracy )
{

  if( !_.bufferTypedIs( src1 ) )
  return false;
  if( !_.bufferTypedIs( src2 ) )
  return false;

  if( src1.length !== src2.length )
  debugger;
  if( src1.length !== src2.length )
  return false;

  debugger;
  if( accuracy === null || accuracy === undefined )
  accuracy = _.accuracy;

  for( var i = 0 ; i < src1.length ; i++ )
  if( Math.abs( src1[ i ] - src2[ i ] ) > accuracy )
  return false;

  return true;
}

//

function buffersTypedAreIdentical( src1, src2 )
{

  if( !_.bufferTypedIs( src1 ) )
  return false;
  if( !_.bufferTypedIs( src2 ) )
  return false;

  var t1 = _ObjectToString.call( src1 );
  var t2 = _ObjectToString.call( src2 );
  if( t1 !== t2 )
  return false;

  if( src1.length !== src2.length )
  debugger;
  if( src1.length !== src2.length )
  return false;

  for( var i = 0 ; i < src1.length ; i++ )
  if( !Object.is( src1[ i ], src2[ i ] ) )
  return false;

  return true;
}

//

function buffersRawAreIdentical( src1, src2 )
{

  if( !_.bufferRawIs( src1 ) )
  return false;
  if( !_.bufferRawIs( src2 ) )
  return false;

  if( src1.byteLength !== src2.byteLength )
  debugger;
  if( src1.byteLength !== src2.byteLength )
  return false;

  src1 = new Uint8Array( src1 );
  src2 = new Uint8Array( src2 );

  for( var i = 0 ; i < src1.length ; i++ )
  if( src1[ i ] !== src2[ i ] )
  return false;

  return true;
}

//

function buffersViewAreIdentical( src1, src2 )
{

  debugger;

  if( !_.bufferViewIs( src1 ) )
  return false;
  if( !_.bufferViewIs( src2 ) )
  return false;

  if( src1.byteLength !== src2.byteLength )
  debugger;
  if( src1.byteLength !== src2.byteLength )
  return false;

  for( var i = 0 ; i < src1.byteLength ; i++ )
  if( src1.getUint8( i ) !== src2.getUint8( i ) )
  return false;

  return true;
}

//

function buffersNodeAreIdentical( src1, src2 )
{

  debugger;

  if( !_.bufferNodeIs( src1 ) )
  return false;
  if( !_.bufferNodeIs( src2 ) )
  return false;

  return src1.equals( src2 );
}

//

function buffersAreEquivalent( src1, src2, accuracy )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );

  if( _.bufferTypedIs( src1 ) )
  return _.buffersTypedAreEquivalent( src1 ,src2, accuracy );
  else if( _.bufferRawIs( src1 ) )
  return _.buffersRawAreIdentical( src1, src2 );
  else if( _.bufferViewIs( src1 ) )
  return _.buffersViewAreIdentical( src1, src2 );
  else if( _.bufferNodeIs( src1 ) )
  return _.buffersNodeAreIdentica( src1, src2 );
  else return false;

}

//

function buffersAreIdentical( src1, src2 )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var t1 = _ObjectToString.call( src1 );
  var t2 = _ObjectToString.call( src2 );
  if( t1 !== t2 )
  return false;

  if( _.bufferTypedIs( src1 ) )
  return _.buffersTypedAreIdentical( src1, src2 );
  else if( _.bufferRawIs( src1 ) )
  return _.buffersRawAreIdentical( src1, src2 );
  else if( _.bufferViewIs( src1 ) )
  return _.buffersViewAreIdentical( src1, src2 );
  else if( _.bufferNodeIs( src1 ) )
  return _.buffersNodeAreIdentical( src1, src2 );
  else return false;

}

//

/**
 * The bufferMakeSimilar() routine returns a new array or a new TypedArray with length equal (length)
 * or new TypedArray with the same length of the initial array if second argument is not provided.
 *
 * @param { longIs } ins - The instance of an array.
 * @param { Number } [ length = ins.length ] - The length of the new array.
 *
 * @example
 * // returns [ , ,  ]
 * var arr = _.bufferMakeSimilar( [ 1, 2, 3 ] );
 *
 * @example
 * // returns [ , , ,  ]
 * var arr = _.bufferMakeSimilar( [ 1, 2, 3 ], 4 );
 *
 * @returns { longIs }  Returns an array with a certain (length).
 * @function bufferMakeSimilar
 * @throws { Error } If the passed arguments is less than two.
 * @throws { Error } If the (length) is not a number.
 * @throws { Error } If the first argument in not an array like object.
 * @throws { Error } If the (length === undefined) and (_.numberIs(ins.length)) is not a number.
 * @memberof wTools
 */

/* qqq : implement */

function bufferMakeSimilar( ins,src )
{
  var result, length;

  throw _.err( 'not tested' );

  if( _.routineIs( ins ) )
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( src === undefined )
  {
    length = _.definedIs( ins.length ) ? ins.length : ins.byteLength;
  }
  else
  {
    if( _.longIs( src ) )
    length = src.length;
    else if( _.bufferRawIs( src ) )
    length = src.byteLength;
    else if( _.numberIs( src ) )
    length = src;
    else _.assert( 0 );
  }

  if( _.argumentsArrayIs( ins ) )
  ins = [];

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIsFinite( length ) );
  _.assert( _.routineIs( ins ) || _.longIs( ins ) || _.bufferRawIs( ins ),'unknown type of array',_.strTypeOf( ins ) );

  if( _.longIs( src ) || _.bufferAnyIs( src ) )
  {

    if( ins.constructor === Array )
    {
      result = new( _.routineJoin( ins.constructor, ins.constructor, src ) );
    }
    else if( _.routineIs( ins ) )
    {
      if( ins.prototype.constructor.name === 'Array' )
      result = _ArraySlice.call( src );
      else
      result = new ins( src );
    }
    else
    result = new ins.constructor( src );

  }
  else
  {
    if( _.routineIs( ins ) )
    result = new ins( length );
    else
    result = new ins.constructor( length );
  }

  return result;
}

//

/* qqq : implement */

function bufferButRange( src, range, ins )
{
  var result;
  var range = _.rangeFrom( range );

  _.assert( _.bufferTypedIs( src ) );
  _.assert( ins === undefined || _.longIs( ins ) );
  _.assert( arguments.length === 2 || arguments.length === 3 );

  throw _.err( 'not implemented' )

  if( range[ 1 ] - range[ 0 ] <= 0 )
  return _.bufferSlice( src );

  // if( size > src.byteLength )
  // {
  //   result = longMakeSimilar( src, size );
  //   var resultTyped = new Uint8Array( result,0,result.byteLength );
  //   var srcTyped = new Uint8Array( src,0,src.byteLength );
  //   resultTyped.set( srcTyped );
  // }
  // else if( size < src.byteLength )
  // {
  //   result = src.slice( 0,size );
  // }

  return result;
}

//

/**
 * The bufferRelen() routine returns a new or the same typed array {-srcMap-} with a new or the same length (len).
 *
 * It creates the variable (result) checks, if (len) is more than (src.length),
 * if true, it creates and assigns to (result) a new typed array with the new length (len) by call the function(longMakeSimilar(src, len))
 * and copies each element from the {-srcMap-} into the (result) array while ensuring only valid data types, if data types are invalid they are replaced with zero.
 * Otherwise, if (len) is less than (src.length) it returns a new typed array from 0 to the (len) indexes, but not including (len).
 * Otherwise, it returns an initial typed array.
 *
 * @see {@link wTools.longMakeSimilar} - See for more information.
 *
 * @param { typedArray } src - The source typed array.
 * @param { Number } len - The length of a typed array.
 *
 * @example
 * // returns [ 3, 7, 13, 0 ]
 * var ints = new Int8Array( [ 3, 7, 13 ] );
 * _.bufferRelen( ints, 4 );
 *
 * @example
 * // returns [ 3, 7, 13 ]
 * var ints2 = new Int16Array( [ 3, 7, 13, 33, 77 ] );
 * _.bufferRelen( ints2, 3 );
 *
 * @example
 * // returns [ 3, 0, 13, 0, 77, 0 ]
 * var ints3 = new Int32Array( [ 3, 7, 13, 33, 77 ] );
 * _.bufferRelen( ints3, 6 );
 *
 * @returns { typedArray } - Returns a new or the same typed array {-srcMap-} with a new or the same length (len).
 * @function bufferRelen
 * @memberof wTools
 */

function bufferRelen( src,len )
{

  _.assert( _.bufferTypedIs( src ) );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.numberIs( len ) );

  var result = src;

  if( len > src.length )
  {
    result = longMakeSimilar( src, len );
    result.set( src );
  }
  else if( len < src.length )
  {
    result = src.subarray( 0,len );
  }

  return result;
}

//

/* qqq : implement for 2 other types of buffer and do code test coverage */

function bufferResize( srcBuffer, size )
{
  var result = srcBuffer;

  _.assert( _.bufferRawIs( srcBuffer ) || _.bufferTypedIs( srcBuffer ) );
  _.assert( srcBuffer.byteLength >= 0 );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( size > srcBuffer.byteLength )
  {
    result = _.longMakeSimilar( srcBuffer, size );
    var resultTyped = new Uint8Array( result,0,result.byteLength );
    var srcTyped = new Uint8Array( srcBuffer,0,srcBuffer.byteLength );
    resultTyped.set( srcTyped );
  }
  else if( size < srcBuffer.byteLength )
  {
    result = srcBuffer.slice( 0,size );
  }

  return result;
}

//

function bufferBytesGet( src )
{

  if( src instanceof ArrayBuffer )
  {
    return new Uint8Array( src );
  }
  else if( typeof Buffer !== 'undefined' && src instanceof Buffer )
  {
    return new Uint8Array( src.buffer, src.byteOffset, src.byteLength );
  }
  else if( _.bufferTypedIs( src ) )
  {
    return new Uint8Array( src.buffer, src.byteOffset, src.byteLength );
  }
  else if( _.strIs( src ) )
  {
    if( _global_.Buffer )
    return new Uint8Array( _.bufferRawFrom( Buffer.from( src, 'utf8' ) ) );
    else
    return new Uint8Array( _.encode.utf8ToBuffer( src ) );
  }
  else _.assert( 0, 'wrong argument' );

}

//

  /**
   * The bufferRetype() routine converts and returns a new instance of (bufferType) constructor.
   *
   * @param { typedArray } src - The typed array.
   * @param { typedArray } bufferType - The type of typed array.
   *
   * @example
   * // returns [ 513, 1027, 1541 ]
   * var view1 = new Int8Array( [ 1, 2, 3, 4, 5, 6 ] );
   * _.bufferRetype(view1, Int16Array);
   *
   * @example
   * // returns [ 1, 2, 3, 4, 5, 6 ]
   * var view2 = new Int16Array( [ 513, 1027, 1541 ] );
   * _.bufferRetype(view2, Int8Array);
   *
   * @returns { typedArray } Returns a new instance of (bufferType) constructor.
   * @function bufferRetype
   * @throws { Error } Will throw an Error if {-srcMap-} is not a typed array object.
   * @throws { Error } Will throw an Error if (bufferType) is not a type of the typed array.
   * @memberof wTools
   */

function bufferRetype( src,bufferType )
{

  _.assert( _.bufferTypedIs( src ) );
  _.assert( _.constructorIsBuffer( bufferType ) );

  var o = src.byteOffset;
  var l = Math.floor( src.byteLength / bufferType.BYTES_PER_ELEMENT );
  var result = new bufferType( src.buffer,o,l );

  return result;
}

//

function bufferJoin()
{

  if( arguments.length < 2 )
  return arguments[ 0 ] || null;

  var srcs = [];
  var size = 0;
  var firstSrc;
  for( var s = 0 ; s < arguments.length ; s++ )
  {
    var src = arguments[ s ];

    if( src === null )
    continue;

    if( !firstSrc )
    firstSrc = src;

    if( _.bufferRawIs( src ) )
    {
      srcs.push( new Uint8Array( src ) );
    }
    else if( src instanceof Uint8Array )
    {
      srcs.push( src );
    }
    else
    {
      srcs.push( new Uint8Array( src.buffer,src.byteOffset,src.byteLength ) );
    }

    _.assert( src.byteLength >= 0,'expects buffers, but got',_.strTypeOf( src ) );

    size += src.byteLength;
  }

  if( srcs.length === 0 )
  return null;

  // if( srcs.length < 2 )
  // return firstSrc || null;

  /* */

  var resultBuffer = new ArrayBuffer( size );
  var result = _.bufferRawIs( firstSrc ) ? resultBuffer : new firstSrc.constructor( resultBuffer );
  var resultBytes = result.constructor === Uint8Array ? result : new Uint8Array( resultBuffer );

  /* */

  var offset = 0;
  for( var s = 0 ; s < srcs.length ; s++ )
  {
    var src = srcs[ s ];
    if( resultBytes.set )
    resultBytes.set( src , offset );
    else
    for( var i = 0 ; i < src.length ; i++ )
    resultBytes[ offset+i ] = src[ i ];
    offset += src.byteLength;
  }

  return result;
}

//

function bufferMove( dst,src )
{

  if( arguments.length === 2 )
  {

    _.assert( _.longIs( dst ) );
    _.assert( _.longIs( src ) );

    if( dst.length !== src.length )
    throw _.err( '_.bufferMove :','"dst" and "src" must have same length' );

    if( dst.set )
    {
      dst.set( src );
      return dst;
    }

    for( var s = 0 ; s < src.length ; s++ )
    dst[ s ] = src[ s ];

  }
  else if( arguments.length === 1 )
  {

    var options = arguments[ 0 ];
    _.assertMapHasOnly( options,bufferMove.defaults );

    var src = options.src;
    var dst = options.dst;

    if( _.bufferRawIs( dst ) )
    {
      dst = new Uint8Array( dst );
      if( _.bufferTypedIs( src ) && !( src instanceof Uint8Array ) )
      src = new Uint8Array( src.buffer,src.byteOffset,src.byteLength );
    }

    _.assert( _.longIs( dst ) );
    _.assert( _.longIs( src ) );

    options.dstOffset = options.dstOffset || 0;

    if( dst.set )
    {
      dst.set( src,options.dstOffset );
      return dst;
    }

    for( var s = 0, d = options.dstOffset ; s < src.length ; s++, d++ )
    dst[ d ] = src[ s ];

  }
  else _.assert( 0,'unexpected' );

  return dst;
}

bufferMove.defaults =
{
  dst : null,
  src : null,
  dstOffset : null,
}

//

function bufferToStr( src )
{
  var result = '';

  if( src instanceof ArrayBuffer )
  src = new Uint8Array( src,0,src.byteLength );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.bufferAnyIs( src ) );

  if( bufferNodeIs( src ) )
  return src.toString( 'utf8' );

  try
  {
    result = String.fromCharCode.apply( null, src );
  }
  catch( e )
  {
    for( var i = 0 ; i < src.byteLength ; i++ )
    {
      result += String.fromCharCode( src[i] );
    }
  }

  return result;
}

//

function bufferToDom( xmlBuffer ) {

  var result;

  if( typeof DOMParser !== 'undefined' && DOMParser.prototype.parseFromBuffer )
  {

    var parser = new DOMParser();
    result = parser.parseFromBuffer( xmlBuffer,xmlBuffer.byteLength,'text/xml' );
    throw _.err( 'not tested' );

  }
  else
  {

    var xmlStr = _.bufferToStr( xmlBuffer );
    result = this.strToDom( xmlStr );

  }

  return result;
}

//

function bufferLeft( src,del )
{

  if( !_.bufferRawIs( src ) )
  src = _.bufferBytesGet( src );

  if( !_.bufferRawIs( del ) )
  del = _.bufferBytesGet( del );

  _.assert( src.indexOf );
  _.assert( del.indexOf );

  var index = src.indexOf( del[ 0 ] );
  while( index !== -1 )
  {

    for( var i = 0 ; i < del.length ; i++ )
    if( src[ index+i ] !== del[ i ] )
    break;

    if( i === del.length )
    return index;

    index += 1;
    index = src.indexOf( del[ 0 ],index );

  }

  return -1;
}

//

function bufferSplit( src,del )
{

  if( !_.bufferRawIs( src ) )
  src = _.bufferBytesGet( src );

  if( !_.bufferRawIs( del ) )
  del = _.bufferBytesGet( del );

  _.assert( src.indexOf );
  _.assert( del.indexOf );

  var result = [];
  var begin = 0;
  var index = src.indexOf( del[ 0 ] );
  while( index !== -1 )
  {

    for( var i = 0 ; i < del.length ; i++ )
    if( src[ index+i ] !== del[ i ] )
    break;

    if( i === del.length )
    {
      result.push( src.slice( begin,index ) );
      index += i;
      begin = index;
    }
    else
    {
      index += 1;
    }

    index = src.indexOf( del[ 0 ],index );

  }

  if( begin === 0 )
  result.push( src );
  else
  result.push( src.slice( begin,src.length ) );

  return result;
}

//

function bufferCutOffLeft( src,del )
{

  if( !_.bufferRawIs( src ) )
  src = _.bufferBytesGet( src );

  if( !_.bufferRawIs( del ) )
  del = _.bufferBytesGet( del );

  _.assert( src.indexOf );
  _.assert( del.indexOf );

  var result = [];
  var index = src.indexOf( del[ 0 ] );
  while( index !== -1 )
  {

    for( var i = 0 ; i < del.length ; i++ )
    if( src[ index+i ] !== del[ i ] )
    break;

    if( i === del.length )
    {
      result.push( src.slice( 0,index ) );
      result.push( src.slice( index,index+i ) );
      result.push( src.slice( index+i,src.length ) );
      return result;
    }
    else
    {
      index += 1;
    }

    index = src.indexOf( del[ 0 ],index );

  }

  result.push( null );
  result.push( null );
  result.push( src );

  return result;
}

//

function bufferFromArrayOfArray( array,options )
{

  if( _.objectIs( array ) )
  {
    options = array;
    array = options.buffer;
  }

  var options = options || Object.create( null );
  var array = options.buffer = array || options.buffer;

  //

  if( options.BufferType === undefined ) options.BufferType = Float32Array;
  if( options.sameLength === undefined ) options.sameLength = 1;
  if( !options.sameLength ) throw _.err( '_.bufferFromArrayOfArray :','differemt length of arrays is not implemented' );

  if( !array.length ) return new options.BufferType();

  var atomsPerElement = _.numberIs( array[ 0 ].length ) ? array[ 0 ].length : array[ 0 ].len;

  if( !_.numberIs( atomsPerElement ) ) throw _.err( '_.bufferFromArrayOfArray :','cant find out element length' );

  var length = array.length * atomsPerElement;
  var result = new options.BufferType( length );
  var i = 0;

  for( var a = 0 ; a < array.length ; a++ )
  {

    var element = array[ a ];

    for( var e = 0 ; e < atomsPerElement ; e++ )
    {

      result[ i ] = element[ e ];
      i += 1;

    }

  }

  return result;
}

//

function bufferFrom( o )
{
  var result;

  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( o ) );
  _.assert( _.routineIs( o.bufferConstructor ),'expects bufferConstructor' );
  _.assertMapHasOnly( o,bufferFrom.defaults );

  /* same */

  if( o.src.constructor )
  if( o.src.constructor === o.bufferConstructor  )
  return o.src;

  /* number */

  if( _.numberIs( o.src ) )
  o.src = [ o.src ];

  if( o.bufferConstructor.name === 'ArrayBuffer' )
  return _.bufferRawFrom( o.src );

  if( o.bufferConstructor.name === 'Buffer' )
  return _.bufferNodeFrom( o.src );

  /* str / buffer.node / buffer.raw */

  if( _.strIs( o.src ) || _.bufferNodeIs( o.src ) || _.bufferRawIs( o.src ) )
  o.src = _.bufferBytesFrom( o.src );

  /* buffer.typed */

  if( _.bufferTypedIs( o.src ) )
  {
    if( o.src.constructor === o.bufferConstructor  )
    return o.src;

    result = new o.bufferConstructor( o.src );
    return result;
  }

  /* verification */

  _.assert( _.objectLike( o.src ) || _.longIs( o.src ),'bufferFrom expects object-like or array-like as o.src' );

  /* length */

  var length = o.src.length;
  if( !_.numberIs( length ) )
  {

    var length = 0;
    while( o.src[ length ] !== undefined )
    length += 1;

  }

  /* make */

  if( _.arrayIs( o.src ) )
  {
    result = new o.bufferConstructor( o.src );
  }
  else if ( _.longIs( o.src ) )
  {
    result = new o.bufferConstructor( o.src );
    throw _.err( 'not tested' );
  }
  else
  {
    result = new o.bufferConstructor( length );
    for( var i = 0 ; i < length ; i++ )
    result[ i ] = o.src[ i ];
  }

  return result;
}

bufferFrom.defaults =
{
  src : null,
  bufferConstructor : null,
}

//

/**
 * The bufferRawFromTyped() routine returns a new ArrayBuffer from (buffer.byteOffset) to the end of an ArrayBuffer of a typed array (buffer)
 * or returns the same ArrayBuffer of the (buffer), if (buffer.byteOffset) is not provided.
 *
 * @param { typedArray } buffer - Entity to check.
 *
 * @example
 * // returns [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
 * var buffer1 = new ArrayBuffer( 10 );
 * var view1 = new Int8Array( buffer1 );
 * _.bufferRawFromTyped( view1 );
 *
 * @example
 * // returns [ 0, 0, 0, 0, 0, 0 ]
 * var buffer2 = new ArrayBuffer( 10 );
 * var view2 = new Int8Array( buffer2, 2 );
 * _.bufferRawFromTyped( view2 );
 *
 * @returns { ArrayBuffer } Returns a new or the same ArrayBuffer.
 * If (buffer) is instance of '[object ArrayBuffer]', it returns buffer.
 * @function bufferRawFromTyped
 * @throws { Error } Will throw an Error if (arguments.length) is not equal to the 1.
 * @throws { Error } Will throw an Error if (buffer) is not a typed array.
 * @memberof wTools
 */

function bufferRawFromTyped( buffer )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.bufferTypedIs( buffer ) || _.bufferRawIs( buffer ) );

  if( _.bufferRawIs( buffer ) )
  return buffer;

  var result = buffer.buffer;

  if( buffer.byteOffset || buffer.byteLength !== result.byteLength )
  result = result.slice( buffer.byteOffset || 0,buffer.byteLength );

  _.assert( _.bufferRawIs( result ) );

  return result;
}

//

function bufferRawFrom( buffer )
{
  var result;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( buffer instanceof ArrayBuffer )
  return buffer;

  if( _.bufferNodeIs( buffer ) || _.arrayIs( buffer ) )
  {

    // result = buffer.buffer;
    result = new Uint8Array( buffer ).buffer;

  }
  else if( _.bufferTypedIs( buffer ) || _.bufferViewIs( buffer ) )
  {

    debugger;
    // _.assert( 0, 'not implemented' );
    result = buffer.buffer;
    if( buffer.byteOffset || buffer.byteLength !== result.byteLength )
    result = result.slice( buffer.byteOffset || 0,buffer.byteLength );

  }
  else if( _.strIs( buffer ) )
  {

    if( _global_.Buffer )
    {
      result = _.bufferRawFrom( Buffer.from( buffer, 'utf8' ) );
    }
    else
    {
      result = _.encode.utf8ToBuffer( buffer ).buffer;
    }

  }
  else if( _global.File && buffer instanceof File )
  {
    var fileReader = new FileReaderSync();
    result = fileReader.readAsArrayBuffer( buffer );
    _.assert( 0, 'not tested' );
  }
  else _.assert( 0, () => 'Unknown type of source ' + _.strTypeOf( buffer ) );

  _.assert( _.bufferRawIs( result ) );

  return result;
}

//

function bufferBytesFrom( buffer )
{
  var result;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.bufferNodeIs( buffer ) )
  {

    _.assert( _.bufferRawIs( buffer.buffer ) )
    result = new U8x( buffer.buffer, buffer.byteOffset, buffer.byteLength );

  }
  else if( _.bufferRawIs( buffer ) )
  {

    result = new U8x( buffer, 0, buffer.byteLength );

  }
  else if( _.bufferTypedIs( buffer ) )
  {

    result = new U8x( buffer.buffer, buffer.byteOffset, buffer.byteLength );

  }
  else if( _.bufferViewIs( buffer ) )
  {

    debugger;
    // _.assert( 0, 'not tested' );
    result = new U8x( buffer.buffer, buffer.byteOffset, buffer.byteLength );

  }
  else
  {

    return _.bufferBytesFrom( _.bufferRawFrom( buffer ) );

  }

  _.assert( _.bufferBytesIs( result ) );

  return result;
}

//

function bufferBytesFromNode( src )
{
  _.assert( _.bufferNodeIs( src ) );
  var result = new Uint8Array( buffer );
  return result;
}

//

/*
qqq : cover it
*/

function bufferNodeFrom( buffer )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.bufferViewIs( buffer ) || _.bufferTypedIs( buffer ) || _.bufferRawIs( buffer ) || _.bufferNodeIs( buffer ) || _.strIs( buffer ) || _.arrayIs( buffer ), 'expects typed or raw buffer, but got',_.strTypeOf( buffer ) );

  if( _.bufferNodeIs( buffer ) )
  return buffer;

  /* */

  // if( toBuffer === null )
  // try
  // {
  //   toBuffer = require( 'typedarray-to-buffer' );
  // }
  // catch( err )
  // {
  //   toBuffer = false;
  // }

  /* */

  let result;

  if( buffer.length === 0 || buffer.byteLength === 0 )
  {
    // _.assert( 0, 'not tested' );
    // result = new Buffer([]);
    result = Buffer.from([]);
  }
  else if( _.strIs( buffer ) )
  {
    debugger;
    result = _.bufferNodeFrom( _.bufferRawFrom( buffer ) );
  }
  else if( buffer.buffer )
  {
    result = Buffer.from( buffer.buffer, buffer.byteOffset, buffer.byteLength );
  }
  else
  {
    // _.assert( 0, 'not tested' );
    result = Buffer.from( buffer );
  }

  // if( !buffer.length && !buffer.byteLength )
  // {
  //   buffer = new Buffer([]);
  // }
  // else if( toBuffer )
  // try
  // {
  //   buffer = toBuffer( buffer );
  // }
  // catch( err )
  // {
  //   debugger;
  //   buffer = toBuffer( buffer );
  // }
  // else
  // {
  //   if( _.bufferTypedIs( buffer ) )
  //   buffer = Buffer.from( buffer.buffer );
  //   else
  //   buffer = Buffer.from( buffer );
  // }

  _.assert( _.bufferNodeIs( result ) );

  return result;
}

//

function buffersSerialize( o )
{
  var self = this;
  var size = 0;
  var o = o || Object.create( null );

  _.assertMapHasNoUndefine( o );
  _.assertMapHasOnly( o,buffersSerialize.defaults );
  _.mapComplement( o,buffersSerialize.defaults );
  _.assert( _.objectIs( o.store ) );

  var store = o.store;
  var storeAttributes = store[ 'attributes' ] = store[ 'attributes' ] || Object.create( null );
  var attributes = o.onAttributesGet.call( o.context );
  var buffers = [];

  /* eval size */

  for( var a = 0 ; a < attributes.length ; a++ )
  {

    var name = attributes[ a ][ 0 ];
    var attribute = attributes[ a ][ 1 ];
    var buffer = o.onBufferGet.call( o.context,attribute );

    _.assert( _.bufferTypedIs( buffer ) || buffer === null,'expects buffer or null, got : ' + _.strTypeOf( buffer ) );

    var bufferSize = buffer ? buffer.length*buffer.BYTES_PER_ELEMENT : 0;

    if( o.dropAttribute && o.dropAttribute[ name ] )
    continue;

    var descriptor = Object.create( null );
    descriptor.attribute = attribute;
    descriptor.name = name;
    descriptor.buffer = buffer;
    descriptor.bufferSize = bufferSize;
    descriptor.sizeOfAtom = buffer ? buffer.BYTES_PER_ELEMENT : 0;
    buffers.push( descriptor );

    size += bufferSize;

  }

  /* make buffer */

  if( !store[ 'buffer' ] )
  store[ 'buffer' ] = new ArrayBuffer( size );

  var dstBuffer = _.bufferBytesGet( store[ 'buffer' ] );

  _.assert( store[ 'buffer' ].byteLength === size );
  if( store[ 'buffer' ].byteLength < size )
  throw _.err( 'buffersSerialize :','buffer does not have enough space' );

  /* sort by atom size */

  buffers.sort( function( a,b )
  {
    return b.sizeOfAtom - a.sizeOfAtom;
  });

  /* store into single buffer */

  var offset = 0;
  for( var b = 0 ; b < buffers.length ; b++ )
  {

    var name = buffers[ b ].name;
    var attribute = buffers[ b ].attribute;
    var buffer = buffers[ b ].buffer;
    var bytes = buffer ? _.bufferBytesGet( buffer ) : new Uint8Array();
    var bufferSize = buffers[ b ].bufferSize;

    if( o.dropAttribute && o.dropAttribute[ name ] )
    continue;

    _.bufferMove( dstBuffer.subarray( offset,offset+bufferSize ),bytes );

    var serialized = store[ 'attributes' ][ name ] =
    {
      'bufferConstructorName' : buffer ? buffer.constructor.name : 'null',
      'sizeOfAtom' : buffer ? buffer.BYTES_PER_ELEMENT : 0,
      'offsetInCommonBuffer' : offset,
      'size' : bytes.length,
    }

    if( attribute.copyCustom )
    serialized[ 'fields' ] = attribute.copyCustom
    ({

      dst : Object.create( null ),
      src : attribute,

      copyingComposes : 3,
      copyingAggregates : 3,
      copyingAssociates : 1,

      technique : 'data',

    });

    offset += bufferSize;

  }

  /* return */

  return store;
}

buffersSerialize.defaults =
{

  context : null,
  store : null,

  dropAttribute : {},

  onAttributesGet : function()
  {
    return _.mapPairs( this.attributes );
  },
  onBufferGet : function( attribute )
  {
    return attribute.buffer;
  },

}

//

function buffersDeserialize( o )
{
  var o = o || Object.create( null );
  var store = o.store;
  var commonBuffer = store[ 'buffer' ];

  _.assertMapHasNoUndefine( o );
  _.assertMapHasOnly( o,buffersDeserialize.defaults );
  _.mapComplement( o,buffersDeserialize.defaults );
  _.assert( _.objectIs( o.store ) );
  _.assert( _.bufferRawIs( commonBuffer ) || _.bufferTypedIs( commonBuffer ) );

  commonBuffer = _.bufferRawFromTyped( commonBuffer );

  for( var a in store[ 'attributes' ] )
  {
    var attribute = store[ 'attributes' ][ a ];

    var bufferConstructor = attribute[ 'bufferConstructorName' ] === 'null' ? null : _global[ attribute[ 'bufferConstructorName' ] ];
    var offset = attribute[ 'offsetInCommonBuffer' ];
    var size = attribute[ 'size' ];
    var sizeOfAtom = attribute[ 'sizeOfAtom' ];
    var fields = attribute[ 'fields' ];

    _.assert( _.routineIs( bufferConstructor ) || bufferConstructor === null,'unknown attribute\' constructor :',attribute[ 'bufferConstructorName' ] )
    _.assert( _.numberIs( offset ),'unknown attribute\' offset in common buffer :',offset )
    _.assert( _.numberIs( size ),'unknown attribute\' size of buffer :',size )
    _.assert( _.numberIs( sizeOfAtom ),'unknown attribute\' sizeOfAtom of buffer :',sizeOfAtom )

    if( attribute.offset+size > commonBuffer.byteLength )
    throw _.err( 'cant deserialize attribute','"'+a+'"','it is out of common buffer' );

    /* logger.log( 'bufferConstructor( ' + commonBuffer + ',' + offset + ',' + size / sizeOfAtom + ' )' ); */

    var buffer = bufferConstructor ? new bufferConstructor( commonBuffer,offset,size / sizeOfAtom ) : null;

    o.onAttribute.call( o.context,fields,buffer,a );

  }

}

buffersDeserialize.defaults =
{
  store : null,
  context : null,
  onAttribute : function( attributeOptions,buffer )
  {
    attributeOptions.buffer = buffer;
    new this.AttributeOfGeometry( attributeOptions ).addTo( this );
  },
}

// --
// long
// --

/**
 * The longMakeSimilar() routine returns a new array or a new TypedArray with length equal (length)
 * or new TypedArray with the same length of the initial array if second argument is not provided.
 *
 * @param { longIs } ins - The instance of an array.
 * @param { Number } [ length = ins.length ] - The length of the new array.
 *
 * @example
 * // returns [ , ,  ]
 * var arr = _.longMakeSimilar( [ 1, 2, 3 ] );
 *
 * @example
 * // returns [ , , ,  ]
 * var arr = _.longMakeSimilar( [ 1, 2, 3 ], 4 );
 *
 * @returns { longIs }  Returns an array with a certain (length).
 * @function longMakeSimilar
 * @throws { Error } If the passed arguments is less than two.
 * @throws { Error } If the (length) is not a number.
 * @throws { Error } If the first argument in not an array like object.
 * @throws { Error } If the (length === undefined) and (_.numberIs(ins.length)) is not a number.
 * @memberof wTools
 */

function longMakeSimilar( ins,src )
{
  var result, length;

  if( _.routineIs( ins ) )
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( src === undefined )
  {
    length = _.definedIs( ins.length ) ? ins.length : ins.byteLength;
  }
  else
  {
    if( _.longIs( src ) )
    length = src.length;
    // else if( _.bufferRawIs( src ) )
    // length = src.byteLength;
    else if( _.numberIs( src ) )
    length = src;
    else _.assert( 0 );
  }

  if( _.argumentsArrayIs( ins ) )
  ins = [];

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIsFinite( length ) );
  _.assert( _.routineIs( ins ) || _.longIs( ins ) || _.bufferRawIs( ins ),'unknown type of array',_.strTypeOf( ins ) );

  if( _.longIs( src ) )
  {

    // if( ins.constructor === Array )
    // debugger;
    // else
    // debugger;

    if( ins.constructor === Array )
    result = new( _.routineJoin( ins.constructor, ins.constructor, src ) );
    else if( _.routineIs( ins ) )
    {
      if( ins.prototype.constructor.name === 'Array' )
      result = _ArraySlice.call( src );
      else
      result = new ins( src );
    }
    else
    result = new ins.constructor( src );

  }
  else
  {
    if( _.routineIs( ins ) )
    result = new ins( length );
    else
    result = new ins.constructor( length );
  }

  return result;
}

//

function longMakeSimilarZeroed( ins,src )
{
  var result, length;

  if( _.routineIs( ins ) )
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( src === undefined )
  {
    length = _.definedIs( ins.length ) ? ins.length : ins.byteLength;
  }
  else
  {
    if( _.longIs( src ) )
    length = src.length;
    else if( _.bufferRawIs( src ) )
    length = src.byteLength;
    else
    length = src
  }

  if( _.argumentsArrayIs( ins ) )
  ins = [];

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( length ) );
  _.assert( _.routineIs( ins ) || _.longIs( ins ) || _.bufferRawIs( ins ),'unknown type of array',_.strTypeOf( ins ) );

  // if( _.longIs( src ) )
  // {
  //
  //   if( ins.constructor === Array )
  //   debugger;
  //   else
  //   debugger;
  //
  //   if( ins.constructor === Array )
  //   {
  //     result = new( _.routineJoin( ins.constructor, ins.constructor, src ) );
  //   }
  //   else
  //   {
  //     result = new ins.constructor( length );
  //     for( var i = 0 ; i < length ; i++ )
  //     result[ i ] = 0;
  //   }
  //
  // }
  // else
  // {

    if( _.routineIs( ins ) )
    {
      result = new ins( length );
    }
    else
    {
      result = new ins.constructor( length );
    }

    if( !_.bufferTypedIs( result ) && !_.bufferRawIs( result )  )
    for( var i = 0 ; i < length ; i++ )
    result[ i ] = 0;

  // }

  return result;
}

//

/**
 * Returns a copy of original array( array ) that contains elements from index( f ) to index( l ),
 * but not including ( l ).
 *
 * If ( l ) is omitted or ( l ) > ( array.length ), longSlice extracts through the end of the sequence ( array.length ).
 * If ( f ) > ( l ), end index( l ) becomes equal to begin index( f ).
 * If ( f ) < 0, zero is assigned to begin index( f ).

 * @param { Array/Buffer } array - Source array or buffer.
 * @param { Number } [ f = 0 ] f - begin zero-based index at which to begin extraction.
 * @param { Number } [ l = array.length ] l - end zero-based index at which to end extraction.
 *
 * @example
 * _.longSlice( [ 1, 2, 3, 4, 5, 6, 7 ], 2, 6 );
 * // returns [ 3, 4, 5, 6 ]
 *
 * @example
 * // begin index is less then zero
 * _.longSlice( [ 1, 2, 3, 4, 5, 6, 7 ], -1, 2 );
 * // returns [ 1, 2 ]
 *
 * @example
 * //end index is bigger then length of array
 * _.longSlice( [ 1, 2, 3, 4, 5, 6, 7 ], 5, 100 );
 * // returns [ 6, 7 ]
 *
 * @returns { Array } Returns a shallow copy of elements from the original array.
 * @function longSlice
 * @throws { Error } Will throw an Error if ( array ) is not an Array or Buffer.
 * @throws { Error } Will throw an Error if ( f ) is not a Number.
 * @throws { Error } Will throw an Error if ( l ) is not a Number.
 * @throws { Error } Will throw an Error if no arguments provided.
 * @memberof wTools
*/

function longSlice( array,f,l )
{

  if( _.argumentsArrayIs( array ) )
  if( f === undefined && l === undefined )
  {
    if( array.length === 2 )
    return [ array[ 0 ],array[ 1 ] ];
    else if( array.length === 1 )
    return [ array[ 0 ] ];
    else if( array.length === 0 )
    return [];
  }

  _.assert( _.longIs( array ) );
  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  if( _.arrayLikeResizable( array ) )
  {
    _.assert( f === undefined || _.numberIs( f ) );
    _.assert( l === undefined || _.numberIs( l ) );
    result = array.slice( f,l );
    return result;
  }

  var result;
  var f = f !== undefined ? f : 0;
  var l = l !== undefined ? l : array.length;

  _.assert( _.numberIs( f ) );
  _.assert( _.numberIs( l ) );

  if( f < 0 )
  f = array.length + f;
  if( l < 0 )
  l = array.length + l;

  if( f < 0 )
  f = 0;
  if( l > array.length )
  l = array.length;
  if( l < f )
  l = f;

  if( _.bufferTypedIs( array ) )
  result = new array.constructor( l-f );
  else
  result = new Array( l-f );

  for( var r = f ; r < l ; r++ )
  result[ r-f ] = array[ r ];

  return result;
}

//

function longButRange( src, range, ins )
{

  _.assert( _.longIs( src ) );
  _.assert( ins === undefined || _.longIs( ins ) );
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( _.arrayIs( src ) )
  return _.arrayButRange( src, range, ins );

  var result;
  var range = _.rangeFrom( range );

  _.rangeClamp( range, [ 0, src.length ] );
  var d = range[ 1 ] - range[ 0 ];
  var l = src.length - d + ( ins ? ins.length : 0 );

  var result = _.longMakeSimilar( src, l );

  debugger;
  _.assert( 0,'not tested' )

  for( var i = 0 ; i < range[ 0 ] ; i++ )
  result[ i ] = src[ i ];

  for( var i = range[ 1 ] ; i < l ; i++ )
  result[ i-d ] = src[ i ];

  return result;

  // else if( _.bufferTypedIs( src ) )
  // result = _.bufferButRange( src, range, ins );
  // else _.assert( 0 );

  // if( size > src.byteLength )
  // {
  //   result = longMakeSimilar( src, size );
  //   var resultTyped = new Uint8Array( result,0,result.byteLength );
  //   var srcTyped = new Uint8Array( src,0,src.byteLength );
  //   resultTyped.set( srcTyped );
  // }
  // else if( size < src.byteLength )
  // {
  //   result = src.slice( 0,size );
  // }

  return result;
}

// --
// arguments array
// --

function argumentsArrayIs( src )
{
  return _ObjectToString.call( src ) === '[object Arguments]';
}

//

function _argumentsArrayMake()
{
  return arguments;
}

//

function argumentsArrayOfLength( length )
{
  debugger; xxx
  var a = new Arguments( length );
  return a;
}

//

function argumentsArrayFrom( args )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  if( _.argumentsArrayIs( args ) )
  return args;
  return _argumentsArrayMake.apply( this, args );
}

// --
// unroll
// --

function unrollFrom( unrollMaybe )
{
  _.assert( arguments.length === 1 );
  if( _.unrollIs( unrollMaybe ) )
  return unrollMaybe;
  return _.unrollAppend( null, unrollMaybe );
}

//

function unrollPrepend( dstArray )
{
  _.assert( arguments.length >= 1 );
  _.assert( _.arrayIs( dstArray ) || dstArray === null, 'expects array' );

  dstArray = dstArray || [];

  for( var a = arguments.length - 1 ; a >= 1 ; a-- )
  {
    if( _.longIs( arguments[ a ] ) )
    {
      dstArray.unshift.apply( dstArray, arguments[ a ] );
    }
    else
    {
      dstArray.unshift( arguments[ a ] );
    }
  }

  dstArray[ unrollSymbol ] = true;

  return dstArray;
}

//

function unrollAppend( dstArray )
{
  _.assert( arguments.length >= 1 );
  _.assert( _.arrayIs( dstArray ) || dstArray === null, 'expects array' );

  dstArray = dstArray || [];

  for( var a = 1, len = arguments.length ; a < len; a++ )
  {
    if( _.longIs( arguments[ a ] ) )
    {
      dstArray.push.apply( dstArray, arguments[ a ] );
    }
    else
    {
      dstArray.push( arguments[ a ] );
    }
  }

  dstArray[ unrollSymbol ] = true;

  return dstArray;
}

// --
// array checker
// --

/**
 * The arrayIs() routine determines whether the passed value is an Array.
 *
 * If the {-srcMap-} is an Array, true is returned,
 * otherwise false is.
 *
 * @param { * } src - The object to be checked.
 *
 * @example
 * // returns true
 * arrayIs( [ 1, 2 ] );
 *
 * @example
 * // returns false
 * arrayIs( 10 );
 *
 * @returns { boolean } Returns true if {-srcMap-} is an Array.
 * @function arrayIs
 * @memberof wTools
 */

function arrayIs( src )
{
  return _ObjectToString.call( src ) === '[object Array]';
}

//

function arrayLikeResizable( src )
{
  if( _ObjectToString.call( src ) === '[object Array]' )
  return true;
  return false;
}

//

function arrayLike( src )
{
  if( _.arrayIs( src ) )
  return true;
  if( _.argumentsArrayIs( src ) )
  return true;
  return false;
}

//

/**
 * The longIs() routine determines whether the passed value is an array-like or an Array.
 * Imortant : longIs returns false for Object, even if the object has length field.
 *
 * If {-srcMap-} is an array-like or an Array, true is returned,
 * otherwise false is.
 *
 * @param { * } src - The object to be checked.
 *
 * @example
 * // returns true
 * longIs( [ 1, 2 ] );
 *
 * @example
 * // returns false
 * longIs( 10 );
 *
 * @example
 * // returns true
 * var isArr = ( function() {
 *   return _.longIs( arguments );
 * } )( 'Hello there!' );
 *
 * @returns { boolean } Returns true if {-srcMap-} is an array-like or an Array.
 * @function longIs.
 * @memberof wTools
 */

function longIs( src )
{
  if( _.primitiveIs( src ) )
  return false;
  if( _.routineIs( src ) )
  return false;
  if( _.objectIs( src ) )
  return false;
  if( _.strIs( src ) )
  return false;

  if( Object.propertyIsEnumerable.call( src, 'length' ) )
  return false;
  if( !_.numberIs( src.length ) )
  return false;

  return true;
}

//

function unrollIs( src )
{
  if( !_.arrayIs( src ) )
  return false;
  return !!src[ unrollSymbol ];
}

//

function constructorLikeArray( src )
{
  if( !src )
  return false;

  if( src === Function )
  return false;
  if( src === Object )
  return false;
  if( src === String )
  return false;

  if( _.primitiveIs( src ) )
  return false;

  if( !( 'length' in src.prototype ) )
  return false;
  if( Object.propertyIsEnumerable.call( src.prototype,'length' ) )
  return false;

  return true;
}

//

/**
 * The hasLength() routine determines whether the passed value has the property (length).
 *
 * If {-srcMap-} is equal to the (undefined) or (null) false is returned.
 * If {-srcMap-} has the property (length) true is returned.
 * Otherwise false is.
 *
 * @param { * } src - The object to be checked.
 *
 * @example
 * // returns true
 * hasLength( [ 1, 2 ] );
 *
 * @example
 * // returns true
 * hasLength( 'Hello there!' );
 *
 * @example
 * // returns true
 * var isLength = ( function() {
 *   return _.hasLength( arguments );
 * } )( 'Hello there!' );
 *
 * @example
 * // returns false
 * hasLength( 10 );
 *
 * @example
 * // returns false
 * hasLength( { } );
 *
 * @returns { boolean } Returns true if {-srcMap-} has the property (length).
 * @function hasLength
 * @memberof wTools
 */

function hasLength( src )
{
  if( src === undefined || src === null )
  return false;
  if( _.numberIs( src.length ) )
  return true;
  return false;
}

//

function arrayHasArray( arr )
{

  if( !_.arrayLike( arr ) )
  return false;

  for( let a = 0 ; a < arr.length ; a += 1 )
  if( _.arrayLike( arr[ a ] ) )
  return true;

  return false;
}

//

/**
 * The arrayCompare() routine returns the first difference between the values of the first array from the second.
 *
 * @param { longIs } src1 - The first array.
 * @param { longIs } src2 - The second array.
 *
 * @example
 * // returns 3
 * var arr = _.arrayCompare( [ 1, 5 ], [ 1, 2 ] );
 *
 * @returns { Number } - Returns the first difference between the values of the two arrays.
 * @function arrayCompare
 * @throws { Error } Will throw an Error if (arguments.length) is less or more than two.
 * @throws { Error } Will throw an Error if (src1 and src2) are not the array-like.
 * @throws { Error } Will throw an Error if (src2.length) is less or not equal to the (src1.length).
 * @memberof wTools
 */

function arrayCompare( src1,src2 )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( src1 ) && _.longIs( src2 ) );
  _.assert( src2.length >= src1.length );

  var result = 0;

  for( var s = 0 ; s < src1.length ; s++ )
  {

    result = src1[ s ] - src2[ s ];
    if( result !== 0 )
    return result;

  }

  return result;
}

//

/**
 * The arrayIdentical() routine checks the equality of two arrays.
 *
 * @param { longIs } src1 - The first array.
 * @param { longIs } src2 - The second array.
 *
 * @example
 * // returns true
 * var arr = _.arrayIdentical( [ 1, 2, 3 ], [ 1, 2, 3 ] );
 *
 * @returns { Boolean } - Returns true if all values of the two arrays are equal. Otherwise, returns false.
 * @function arrayIdentical
 * @throws { Error } Will throw an Error if (arguments.length) is less or more than two.
 * @memberof wTools
 */

function arrayIdentical( src1,src2 )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( src1 ) );
  _.assert( _.longIs( src2 ) );

  var result = true;

  if( src1.length !== src2.length )
  return false;

  for( var s = 0 ; s < src1.length ; s++ )
  {

    result = src1[ s ] === src2[ s ];

    if( result === false )
    return false;

  }

  return result;
}

//

function arrayHas( array, value, evaluator1, evaluator2 )
{
  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayLike( array ) );

  if( evaluator1 === undefined )
  {
    return _ArrayIndexOf.call( array, value ) !== -1;
  }
  else
  {
    if( _.arrayLeftIndex( array, value, evaluator1, evaluator2 ) >= 0 )
    return true;
    return false;
  }

}

//

/**
 * The arrayHasAny() routine checks if the {-srcMap-} array has at least one value of the following arguments.
 *
 * It iterates over array-like (arguments[]) copies each argument to the array (ins) by the routine
 * [arrayAs()]{@link wTools.arrayAs}
 * Checks, if {-srcMap-} array has at least one value of the (ins) array.
 * If true, it returns true.
 * Otherwise, it returns false.
 *
 * @see {@link wTools.arrayAs} - See for more information.
 *
 * @param { longIs } src - The source array.
 * @param {...*} arguments - One or more argument(s).
 *
 * @example
 * // returns true
 * var arr = _.arrayHasAny( [ 5, 'str', 42, false ], false, 7 );
 *
 * @returns { Boolean } - Returns true, if {-srcMap-} has at least one value of the following argument(s), otherwise false is returned.
 * @function arrayHasAny
 * @throws { Error } If the first argument in not an array.
 * @memberof wTools
 */

function arrayHasAny( src )
{
  var empty = true;
  empty = false;

  _.assert( arguments.length >= 1, 'expects at least one argument' );
  _.assert( _.arrayLike( src ) || _.bufferTypedIs( src ),'arrayHasAny :','array expected' );

  for( var a = 1 ; a < arguments.length ; a++ )
  {
    empty = false;

    var ins = _.arrayAs( arguments[ a ] );
    for( var i = 0 ; i < ins.length ; i++ )
    {
      if( src.indexOf( ins[ i ] ) !== -1 )
      return true;
    }

  }

  return empty;
}

//

function arrayHasAll( src )
{
  _.assert( arguments.length >= 1, 'expects at least one argument' );
  _.assert( _.arrayLike( src ) || _.bufferTypedIs( src ),'arrayHasAll :','array expected' );

  for( var a = 1 ; a < arguments.length ; a++ )
  {

    var ins = _.arrayAs( arguments[ a ] );
    for( var i = 0 ; i < ins.length ; i++ )
    if( src.indexOf( ins[ i ] ) === -1 )
    return false;

  }

  return true;
}

//

function arrayHasNone( src )
{
  _.assert( arguments.length >= 1, 'expects at least one argument' );
  _.assert( _.arrayLike( src ) || _.bufferTypedIs( src ),'arrayHasNone :','array expected' );

  for( var a = 1 ; a < arguments.length ; a++ )
  {

    var ins = _.arrayAs( arguments[ a ] );
    for( var i = 0 ; i < ins.length ; i++ )
    if( src.indexOf( ins[ i ] ) !== -1 )
    return false;

  }

  return true;
}

//

function arrayAll( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( src ) );

  for( var s = 0 ; s < src.length ; s += 1 )
  {
    if( !src[ s ] )
    return false;
  }

  return true;
}

//

function arrayAny( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( src ) );

  debugger;
  for( var s = 0 ; s < src.length ; s += 1 )
  if( src[ s ] )
  return true;

  debugger;
  return false;
}

//

function arrayNone( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( src ) );

  for( var s = 0 ; s < src.length ; s += 1 )
  if( src[ s ] )
  return false;

  return true;
}

// --
// array
// --

/*

alteration Routines :

- array { Op } { Tense } { How }
- array { Op } { Tense } Array { How }
- array { Op } { Tense } Arrays { How }
- arrayFlatten { Tense } { How }

alteration Op : Append , Prepend , Remove
alteration Tense : - , ed
alteration How : - , Once , OnceStrictly

// 60 routines

*/

// --
// array maker
// --

/**
 * The arrayMakeRandom() routine returns an array which contains random numbers.
 *
 * @param { Object } o - The options for getting random numbers.
 * @param { Number } o.length - The length of an array.
 * @param { Array } [ o.range = [ 0, 1 ] ] - The range of numbers.
 * @param { Boolean } [ o.int = false ] - Floating point numbers or not.
 *
 * @example
 * // returns [ 6, 2, 4, 7, 8 ]
 * var arr = _.arrayMakeRandom
 * ({
 *   length : 5,
 *   range : [ 1, 9 ],
 *   int : true,
 * });
 *
 * @returns { Array } - Returns an array of random numbers.
 * @function arrayMakeRandom
 * @memberof wTools
 */

function arrayMakeRandom( o )
{
  var result = [];

  if( _.numberIs( o ) )
  {
    o = { length : o };
  }

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( arrayMakeRandom,o );

  debugger;

  for( var i = 0 ; i < o.length ; i++ )
  {
    result[ i ] = o.range[ 0 ] + Math.random()*( o.range[ 1 ] - o.range[ 0 ] );
    if( o.int )
    result[ i ] = Math.floor( result[ i ] );
  }

  return result;
}

arrayMakeRandom.defaults =
{
  int : 0,
  range : [ 0,1 ],
  length : 1,
}

//

// /**
//  * The arrayNewOfSameLength() routine returns a new empty array
//  * or a new TypedArray with the same length as in (ins).
//  *
//  * @param { longIs } ins - The instance of an array.
//  *
//  * @example
//  * // returns [ , , , , ]
//  * var arr = _.arrayNewOfSameLength( [ 1, 2, 3, 4, 5 ] );
//  *
//  * @returns { longIs } - The new empty array with the same length as in (ins).
//  * @function arrayNewOfSameLength
//  * @throws { Error } If missed argument, or got more than one argument.
//  * @throws { Error } If the first argument in not array like object.
//  * @memberof wTools
//  */

// function arrayNewOfSameLength( ins )
// {
//
//   _.assert( arguments.length === 1, 'expects single argument' );
//
//   if( _.primitiveIs( ins ) ) return;
//   if( !_.arrayIs( ins ) && !_.bufferTypedIs( ins ) ) return;
//   var result = longMakeSimilar( ins,ins.length );
//   return result;
// }

//

/**
 * The arrayFromNumber() routine returns a new array
 * which containing the static elements only type of Number.
 *
 * It takes two arguments (dst) and (length)
 * checks if the (dst) is a Number, If the (length) is greater than or equal to zero.
 * If true, it returns the new array of static (dst) numbers.
 * Otherwise, if the first argument (dst) is an Array,
 * and its (dst.length) is equal to the (length),
 * it returns the original (dst) Array.
 * Otherwise, it throws an Error.
 *
 * @param { ( Number | Array ) } dst - A number or an Array.
 * @param { Number } length - The length of the new array.
 *
 * @example
 * // returns [ 3, 3, 3, 3, 3, 3, 3 ]
 * var arr = _.arrayFromNumber( 3, 7 );
 *
 * @example
 * // returns [ 3, 7, 13 ]
 * var arr = _.arrayFromNumber( [ 3, 7, 13 ], 3 );
 *
 * @returns { Number[] | Array } - Returns the new array of static numbers or the original array.
 * @function arrayFromNumber
 * @throws { Error } If missed argument, or got less or more than two arguments.
 * @throws { Error } If type of the first argument is not a number or array.
 * @throws { Error } If the second argument is less than 0.
 * @throws { Error } If (dst.length) is not equal to the (length).
 * @memberof wTools
 */

function arrayFromNumber( dst,length )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.numberIs( dst ) || _.arrayIs( dst ),'expects array of number as argument' );
  _.assert( length >= 0 );

  if( _.numberIs( dst ) )
  {
    dst = _.arrayFillTimes( [] , length , dst );
  }
  else
  {
    _.assert( dst.length === length,'expects array of length',length,'but got',dst );
  }

  return dst;
}

//

/**
 * The arrayFrom() routine converts an object-like {-srcMap-} into Array.
 *
 * @param { * } src - To convert into Array.
 *
 * @example
 * // returns [ 3, 7, 13, 'abc', false, undefined, null, {} ]
 * _.arrayFrom( [ 3, 7, 13, 'abc', false, undefined, null, {} ] );
 *
 * @example
 * // returns [ [ 'a', 3 ], [ 'b', 7 ], [ 'c', 13 ] ]
 * _.arrayFrom( { a : 3, b : 7, c : 13 } );
 *
 * @example
 * // returns [ 3, 7, 13, 3.5, 5, 7.5, 13 ]
 * _.arrayFrom( "3, 7, 13, 3.5abc, 5def, 7.5ghi, 13jkl" );
 *
 * @example
 * // returns [ 3, 7, 13, 'abc', false, undefined, null, { greeting: 'Hello there!' } ]
 * var args = ( function() {
 *   return arguments;
 * } )( 3, 7, 13, 'abc', false, undefined, null, { greeting: 'Hello there!' } );
 * _.arrayFrom( args );
 *
 * @returns { Array } Returns an Array.
 * @function arrayFrom
 * @throws { Error } Will throw an Error if {-srcMap-} is not an object-like.
 * @memberof wTools
 */

function arrayFrom( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.arrayIs( src ) )
  return src;

  if( _.objectIs( src ) )
  return _.mapToArray( src );

  if( _.longIs( src ) )
  return _ArraySlice.call( src );

  if( _.strIs( src ) )
  return src.split(/[, ]+/).map( function( s ){ if( s.length ) return parseFloat(s); } );

  if( _.argumentsArrayIs( src ) )
  return _ArraySlice.call( src );

  _.assert( 0,'arrayFrom : unknown source : ' + _.strTypeOf( src ) );
}

//

/**
 * The arrayFromRange() routine generate array of arithmetic progression series,
 * from the range[ 0 ] to the range[ 1 ] with increment 1.
 *
 * It iterates over loop from (range[0]) to the (range[ 1 ] - range[ 0 ]),
 * and assigns to the each index of the (result) array (range[ 0 ] + 1).
 *
 * @param { longIs } range - The first (range[ 0 ]) and the last (range[ 1 ] - range[ 0 ]) elements of the progression.
 *
 * @example
 * // returns [ 1, 2, 3, 4 ]
 * var range = _.arrayFromRange( [ 1, 5 ] );
 *
 * @example
 * // returns [ 0, 1, 2, 3, 4 ]
 * var range = _.arrayFromRange( 5 );
 *
 * @returns { array } Returns an array of numbers for the requested range with increment 1.
 * May be an empty array if adding the step would not converge toward the end value.
 * @function arrayFromRange
 * @throws { Error } If passed arguments is less than one or more than one.
 * @throws { Error } If the first argument is not an array-like object.
 * @throws { Error } If the length of the (range) is not equal to the two.
 * @memberof wTools
 */

function arrayFromRange( range )
{

  if( _.numberIs( range ) )
  range = [ 0,range ];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( range.length === 2 );
  _.assert( _.longIs( range ) );

  var step = range[ 0 ] <= range[ 1 ] ? +1 : -1;

  return this.arrayFromRangeWithStep( range,step );
}

//

function arrayFromProgressionArithmetic( progression, numberOfSteps )
{
  var result;

  debugger;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( progression ) )
  _.assert( isFinite( progression[ 0 ] ) );
  _.assert( isFinite( progression[ 1 ] ) );
  _.assert( isFinite( numberOfSteps ) );
  _.assert( _.routineIs( this.ArrayType ) );

  debugger;

  if( numberOfSteps === 0 )
  return new this.ArrayType();

  if( numberOfSteps === 1 )
  return new this.ArrayType([ progression[ 0 ] ]);

  var range = [ progression[ 0 ],progression[ 0 ]+progression[ 1 ]*(numberOfSteps+1) ];
  var step = ( range[ 1 ]-range[ 0 ] ) / ( numberOfSteps-1 );

  return this.arrayFromRangeWithStep( range,step );
}

//

function arrayFromRangeWithStep( range,step )
{
  var result;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( isFinite( range[ 0 ] ) );
  _.assert( isFinite( range[ 1 ] ) );
  _.assert( step === undefined || step < 0 || step > 0 );
  _.assert( _.routineIs( this.ArrayType ) );

  if( range[ 0 ] === range[ 1 ] )
  return new this.ArrayType();

  if( range[ 0 ] < range[ 1 ] )
  {

    if( step === undefined )
    step = 1;

    _.assert( step > 0 );

    result = new this.ArrayType( Math.round( ( range[ 1 ]-range[ 0 ] ) / step ) );

    var i = 0;
    while( range[ 0 ] < range[ 1 ] )
    {
      result[ i ] = range[ 0 ];
      range[ 0 ] += step;
      i += 1;
    }

  }
  else
  {

    debugger;

    if( step === undefined )
    step = -1;

    _.assert( step < 0 );

    result = new this.ArrayType( Math.round( range[ 0 ]-range[ 1 ] / step ) );

    var i = 0;
    while( range[ 0 ] > range[ 1 ] )
    {
      result[ i ] = range[ 0 ];
      range[ 0 ] += step;
      i += 1;
    }

  }

  return result;
}

//

function arrayFromRangeWithNumberOfSteps( range , numberOfSteps )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( isFinite( range[ 0 ] ) );
  _.assert( isFinite( range[ 1 ] ) );
  _.assert( numberOfSteps >= 0 );
  _.assert( _.routineIs( this.ArrayType ) );

  if( numberOfSteps === 0 )
  return new this.ArrayType();

  if( numberOfSteps === 1 )
  return new this.ArrayType( range[ 0 ] );

  var step;

  if( range[ 0 ] < range[ 1 ] )
  step = ( range[ 1 ]-range[ 0 ] ) / (numberOfSteps-1);
  else
  step = ( range[ 0 ]-range[ 1 ] ) / (numberOfSteps-1);

  return this.arrayFromRangeWithStep( range , step );
}

//

/**
 * The arrayAs() routine copies passed argument to the array.
 *
 * @param { * } src - The source value.
 *
 * @example
 * // returns [ false ]
 * var arr = _.arrayAs( false );
 *
 * @example
 * // returns [ { a : 1, b : 2 } ]
 * var arr = _.arrayAs( { a : 1, b : 2 } );
 *
 * @returns { Array } - If passed null or undefined than return the empty array. If passed an array then return it.
 * Otherwise return an array which contains the element from argument.
 * @function arrayAs
 * @memberof wTools
 */

function arrayAs( src )
{
  _.assert( arguments.length === 1 );
  _.assert( src !== undefined );

  if( src === null )
  return [];
  else if( _.arrayLike( src ) )
  return src;
  else
  return [ src ];

}

//

function _longClone( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( src ) || _.bufferAnyIs( src ) );
  _.assert( !_.bufferNodeIs( src ), 'not tested' );

  if( _.bufferViewIs( src ) )
  debugger;

  if( _.bufferRawIs( src ) )
  return new Uint8Array( new Uint8Array( src ) ).buffer;
  else if( _.bufferTypedIs( src ) || _.bufferNodeIs( src ) )
  return new src.constructor( src );
  else if( _.arrayIs( src ) )
  return src.slice();
  else if( _.bufferViewIs( src ) )
  return new src.constructor( src.buffer,src.byteOffset,src.byteLength );

  _.assert( 0, 'unknown kind of buffer', _.strTypeOf( src ) );
}

//

function longShallowClone()
{
  var result;
  var length = 0;

  if( arguments.length === 1 )
  {
    return _._longClone( arguments[ 0 ] );
  }

  /* eval length */

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var argument = arguments[ a ];

    if( argument === undefined )
    throw _.err( 'longShallowClone','argument is not defined' );

    if( _.longIs( argument ) ) length += argument.length;
    else if( _.bufferRawIs( argument ) ) length += argument.byteLength;
    else length += 1;
  }

  /* make result */

  if( _.arrayIs( arguments[ 0 ] ) || _.bufferTypedIs( arguments[ 0 ] ) )
  result = longMakeSimilar( arguments[ 0 ],length );
  else if( _.bufferRawIs( arguments[ 0 ] ) )
  result = new ArrayBuffer( length );

  var bufferDst;
  var offset = 0;
  if( _.bufferRawIs( arguments[ 0 ] ) )
  {
    bufferDst = new Uint8Array( result );
  }

  /* copy */

  for( var a = 0, c = 0 ; a < arguments.length ; a++ )
  {
    var argument = arguments[ a ];
    if( _.bufferRawIs( argument ) )
    {
      bufferDst.set( new Uint8Array( argument ), offset );
      offset += argument.byteLength;
    }
    else if( _.bufferTypedIs( arguments[ 0 ] ) )
    {
      result.set( argument, offset );
      offset += argument.length;
    }
    else if( _.longIs( argument ) )
    for( var i = 0 ; i < argument.length ; i++ )
    {
      result[ c ] = argument[ i ];
      c += 1;
    }
    else
    {
      result[ c ] = argument;
      c += 1;
    }
  }

  return result;
}

// --
// array converter
// --

/**
 * The arrayToMap() converts an (array) into Object.
 *
 * @param { longIs } array - To convert into Object.
 *
 * @example
 * // returns {  }
 * _.arrayToMap( [  ] );
 *
 * @example
 * // returns { '0' : 3, '1' : [ 1, 2, 3 ], '2' : 'abc', '3' : false, '4' : undefined, '5' : null, '6' : {} }
 * _.arrayToMap( [ 3, [ 1, 2, 3 ], 'abc', false, undefined, null, {} ] );
 *
 * @example
 * // returns { '0' : 3, '1' : 'abc', '2' : false, '3' : undefined, '4' : null, '5' : { greeting: 'Hello there!' } }
 * var args = ( function() {
 *   return arguments;
 * } )( 3, 'abc', false, undefined, null, { greeting: 'Hello there!' } );
 * _.arrayToMap( args );
 *
 * @returns { Object } Returns an Object.
 * @function arrayToMap
 * @throws { Error } Will throw an Error if (array) is not an array-like.
 * @memberof wTools
 */

function arrayToMap( array )
{
  var result = Object.create( null );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( array ) );

  for( var a = 0 ; a < array.length ; a++ )
  result[ a ] = array[ a ];
  return result;
}

//

/**
 * The arrayToStr() routine joins an array {-srcMap-} and returns one string containing each array element separated by space,
 * only types of integer or floating point.
 *
 * @param { longIs } src - The source array.
 * @param { objectLike } [ options = {  } ] options - The options.
 * @param { Number } [ options.precision = 5 ] - The precision of numbers.
 * @param { String } [ options.type = 'mixed' ] - The type of elements.
 *
 * @example
 * // returns "1 2 3 "
 * _.arrayToStr( [ 1, 2, 3 ], { type : 'int' } );
 *
 * @example
 * // returns "3.500 13.77 7.330"
 * _.arrayToStr( [ 3.5, 13.77, 7.33 ], { type : 'float', precission : 4 } );
 *
 * @returns { String } Returns one string containing each array element separated by space,
 * only types of integer or floating point.
 * If (src.length) is empty, it returns the empty string.
 * @function arrayToStr
 * @throws { Error } Will throw an Error If (options.type) is not the number or float.
 * @memberof wTools
 */

function arrayToStr( src,options )
{

  var result = '';
  var options = options || Object.create( null );

  if( options.precission === undefined ) options.precission = 5;
  if( options.type === undefined ) options.type = 'mixed';

  if( !src.length ) return result;

  if( options.type === 'float' )
  {
    for( var s = 0 ; s < src.length-1 ; s++ )
    {
      result += src[ s ].toPrecision( options.precission ) + ' ';
    }
    result += src[ s ].toPrecision( options.precission );
  }
  else if( options.type === 'int' )
  {
    for( var s = 0 ; s < src.length-1 ; s++ )
    {
      result += String( src[ s ] ) + ' ';
    }
    result += String( src[ s ] ) + ' ';
  }
  else
  {
    throw _.err( 'not tested' );
    for( var s = 0 ; s < src.length-1 ; s++ )
    {
      result += String( src[ s ] ) + ' ';
    }
    result += String( src[ s ] ) + ' ';
  }

  return result;
}

// --
// array transformer
// --

/**
 * The arraySub() routine returns a shallow copy of a portion of an array
 * or a new TypedArray that contains
 * the elements from (begin) index to the (end) index,
 * but not including (end).
 *
 * @param { Array } src - Source array.
 * @param { Number } begin - Index at which to begin extraction.
 * @param { Number } end - Index at which to end extraction.
 *
 * @example
 * // returns [ 3, 4 ]
 * var arr = _.arraySub( [ 1, 2, 3, 4, 5 ], 2, 4 );
 *
 * @example
 * // returns [ 2, 3 ]
 * _.arraySub( [ 1, 2, 3, 4, 5 ], -4, -2 );
 *
 * @example
 * // returns [ 1, 2, 3, 4, 5 ]
 * _.arraySub( [ 1, 2, 3, 4, 5 ] );
 *
 * @returns { Array } - Returns a shallow copy of a portion of an array into a new Array.
 * @function arraySub
 * @throws { Error } If the passed arguments is more than three.
 * @throws { Error } If the first argument is not an array.
 * @memberof wTools
 */

/* xxx : not array */
function arraySub( src,begin,end )
{

  _.assert( arguments.length <= 3 );
  _.assert( _.longIs( src ),'unknown type of (-src-) argument' );
  _.assert( _.routineIs( src.slice ) || _.routineIs( src.subarray ) );

  if( _.routineIs( src.subarray ) )
  return src.subarray( begin,end );

  return src.slice( begin,end );
}

//

function arrayButRange( src, range, ins )
{
  _.assert( _.arrayLikeResizable( src ) );
  _.assert( ins === undefined || _.longIs( ins ) );
  _.assert( arguments.length === 2 || arguments.length === 3 );

  var args = [ range[ 0 ], range[ 1 ]-range[ 0 ] ];

  if( ins )
  _.arrayAppendArray( args, ins );

  var result = src.slice();
  result.splice.apply( result, args );
  return result;
}

//

/* qqq : requires good test coverage */

function arraySlice( srcArray,f,l )
{

  _.assert( _.arrayLikeResizable( srcArray ) );
  _.assert( 1 <= arguments.length && arguments.length <= 3 );

  return srcArray.slice( f,l );
}

//

/**
 * Changes length of provided array( array ) by copying it elements to newly created array using begin( f ),
 * end( l ) positions of the original array and value to fill free space after copy( val ). Length of new array is equal to ( l ) - ( f ).
 * If ( l ) < ( f ) - value of index ( f ) will be assigned to ( l ).
 * If ( l ) === ( f ) - returns empty array.
 * If ( l ) > ( array.length ) - returns array that contains elements with indexies from ( f ) to ( array.length ),
 * and free space filled by value of ( val ) if it was provided.
 * If ( l ) < ( array.length ) - returns array that contains elements with indexies from ( f ) to ( l ).
 * If ( l ) < 0 and ( l ) > ( f ) - returns array filled with some amount of elements with value of argument( val ).
 * If ( f ) < 0 - prepends some number of elements with value of argument( var ) to the result array.
 * @param { Array/Buffer } array - source array or buffer;
 * @param { Number } [ f = 0 ] - index of a first element to copy into new array;
 * @param { Number } [ l = array.length ] - index of a last element to copy into new array;
 * @param { * } val - value used to fill the space left after copying elements of the original array.
 *
 * @example
 * //Just partial copy of origin array
 * var arr = [ 1, 2, 3, 4 ]
 * var result = _.arrayGrow( arr, 0, 2 );
 * console.log( result );
 * //[ 1, 2 ]
 *
 * @example
 * //Increase size, fill empty with zeroes
 * var arr = [ 1 ]
 * var result = _.arrayGrow( arr, 0, 5, 0 );
 * console.log( result );
 * //[ 1, 0, 0, 0, 0 ]
 *
 * @example
 * //Take two last elements from original, other fill with zeroes
 * var arr = [ 1, 2, 3, 4, 5 ]
 * var result = _.arrayGrow( arr, 3, 8, 0 );
 * console.log( result );
 * //[ 4, 5, 0, 0, 0 ]
 *
 * @example
 * //Add two zeroes at the beginning
 * var arr = [ 1, 2, 3, 4, 5 ]
 * var result = _.arrayGrow( arr, -2, arr.length, 0 );
 * console.log( result );
 * //[ 0, 0, 1, 2, 3, 4, 5 ]
 *
 * @example
 * //Add two zeroes at the beginning and two at end
 * var arr = [ 1, 2, 3, 4, 5 ]
 * var result = _.arrayGrow( arr, -2, arr.length + 2, 0 );
 * console.log( result );
 * //[ 0, 0, 1, 2, 3, 4, 5, 0, 0 ]
 *
 * @example
 * //Source can be also a Buffer
 * var buffer = Buffer.from( '123' );
 * var result = _.arrayGrow( buffer, 0, buffer.length + 2, 0 );
 * console.log( result );
 * //[ 49, 50, 51, 0, 0 ]
 *
 * @returns { Array } Returns resized copy of a part of an original array.
 * @function arrayGrow
 * @throws { Error } Will throw an Error if( array ) is not a Array or Buffer.
 * @throws { Error } Will throw an Error if( f ) or ( l ) is not a Number.
 * @throws { Error } Will throw an Error if not enough arguments provided.
 * @memberof wTools
 */

function arrayGrow( array,f,l,val )
{
  _.assert( _.longIs( array ) );

  var result;
  var f = f !== undefined ? f : 0;
  var l = l !== undefined ? l : array.length;

  _.assert( _.numberIs( f ) );
  _.assert( _.numberIs( l ) );
  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( l < f )
  l = f;

  if( _.bufferTypedIs( array ) )
  result = new array.constructor( l-f );
  else
  result = new Array( l-f );

  /* */

  var lsrc = Math.min( array.length,l );
  for( var r = Math.max( f,0 ) ; r < lsrc ; r++ )
  result[ r-f ] = array[ r ];

  /* */

  if( val !== undefined )
  {
    for( var r = 0 ; r < -f ; r++ )
    {
      result[ r ] = val;
    }
    for( var r = lsrc - f; r < result.length ; r++ )
    {
      result[ r ] = val;
    }
  }

  return result;
}

//

/**
 * Routine performs two operations: slice and grow.
 * "Slice" means returning a copy of original array( array ) that contains elements from index( f ) to index( l ),
 * but not including ( l ).
 * "Grow" means returning a bigger copy of original array( array ) with free space supplemented by elements with value of ( val )
 * argument.
 *
 * Returns result of operation as new array with same type as original array, original array is not modified.
 *
 * If ( f ) > ( l ), end index( l ) becomes equal to begin index( f ).
 * If ( l ) === ( f ) - returns empty array.
 *
 * To run "Slice", first ( f ) and last ( l ) indexes must be in range [ 0, array.length ], otherwise routine will run "Grow" operation.
 *
 * Rules for "Slice":
 * If ( f ) >= 0  and ( l ) <= ( array.length ) - returns array that contains elements with indexies from ( f ) to ( l ) but not including ( l ).
 *
 * Rules for "Grow":
 *
 * If ( f ) < 0 - prepends some number of elements with value of argument( val ) to the result array.
 * If ( l ) > ( array.length ) - returns array that contains elements with indexies from ( f ) to ( array.length ),
 * and free space filled by value of ( val ) if it was provided.
 * If ( l ) < 0, ( l ) > ( f ) - returns array filled with some amount of elements with value of argument( val ).
 *
 * @param { Array/Buffer } array - Source array or buffer.
 * @param { Number } [ f = 0 ] f - begin zero-based index at which to begin extraction.
 * @param { Number } [ l = array.length ] l - end zero-based index at which to end extraction.
 * @param { * } val - value used to fill the space left after copying elements of the original array.
 *
 * @example
 * _.arrayResize( [ 1, 2, 3, 4, 5, 6, 7 ], 2, 6 );
 * // returns [ 3, 4, 5, 6 ]
 *
 * @example
 * // begin index is less then zero
 * _.arrayResize( [ 1, 2, 3, 4, 5, 6, 7 ], -1, 2 );
 * // returns [ 1, 2 ]
 *
 * @example
 * //end index is bigger then length of array
 * _.arrayResize( [ 1, 2, 3, 4, 5, 6, 7 ], 5, 100 );
 * // returns [ 6, 7 ]
 *
 * @example
 * //Increase size, fill empty with zeroes
 * var arr = [ 1 ]
 * var result = _.arrayResize( arr, 0, 5, 0 );
 * console.log( result );
 * //[ 1, 0, 0, 0, 0 ]
 *
 * @example
 * //Take two last elements from original, other fill with zeroes
 * var arr = [ 1, 2, 3, 4, 5 ]
 * var result = _.arrayResize( arr, 3, 8, 0 );
 * console.log( result );
 * //[ 4, 5, 0, 0, 0 ]
 *
 * @example
 * //Add two zeroes at the beginning
 * var arr = [ 1, 2, 3, 4, 5 ]
 * var result = _.arrayResize( arr, -2, arr.length, 0 );
 * console.log( result );
 * //[ 0, 0, 1, 2, 3, 4, 5 ]
 *
 * @example
 * //Add two zeroes at the beginning and two at end
 * var arr = [ 1, 2, 3, 4, 5 ]
 * var result = _.arrayResize( arr, -2, arr.length + 2, 0 );
 * console.log( result );
 * //[ 0, 0, 1, 2, 3, 4, 5, 0, 0 ]
 *
 * @example
 * //Source can be also a Buffer
 * var buffer = Buffer.from( '123' );
 * var result = _.arrayResize( buffer, 0, buffer.length + 2, 0 );
 * console.log( result );
 * //[ 49, 50, 51, 0, 0 ]
 *
 * @returns { Array } Returns a shallow copy of elements from the original array supplemented with value of( val ) if needed.
 * @function arrayResize
 * @throws { Error } Will throw an Error if ( array ) is not an Array-like or Buffer.
 * @throws { Error } Will throw an Error if ( f ) is not a Number.
 * @throws { Error } Will throw an Error if ( l ) is not a Number.
 * @throws { Error } Will throw an Error if no arguments provided.
 * @memberof wTools
*/

function arrayResize( array,f,l,val )
{
  _.assert( _.longIs( array ) );

  var result;
  var f = f !== undefined ? f : 0;
  var l = l !== undefined ? l : array.length;

  _.assert( _.numberIs( f ) );
  _.assert( _.numberIs( l ) );
  _.assert( 1 <= arguments.length && arguments.length <= 4 );

  if( l < f )
  l = f;
  var lsrc = Math.min( array.length,l );

  if( _.bufferTypedIs( array ) )
  result = new array.constructor( l-f );
  else
  result = new Array( l-f );

  for( var r = Math.max( f,0 ) ; r < lsrc ; r++ )
  result[ r-f ] = array[ r ];

  if( val !== undefined )
  if( f < 0 || l > array.length )
  {
    for( var r = 0 ; r < -f ; r++ )
    {
      result[ r ] = val;
    }
    var r = Math.max( lsrc-f, 0 );
    for( ; r < result.length ; r++ )
    {
      result[ r ] = val;
    }
  }

  return result;
}

//

/* srcBuffer = _.arrayMultislice( [ originalBuffer,f ],[ originalBuffer,0,srcAttribute.atomsPerElement ] ); */

function arrayMultislice()
{
  var length = 0;

  if( arguments.length === 0 )
  return [];

  for( var a = 0 ; a < arguments.length ; a++ )
  {

    var src = arguments[ a ];
    var f = src[ 1 ];
    var l = src[ 2 ];

    _.assert( _.longIs( src ) && _.longIs( src[ 0 ] ),'expects array of array' );
    var f = f !== undefined ? f : 0;
    var l = l !== undefined ? l : src[ 0 ].length;
    if( l < f )
    l = f;

    _.assert( _.numberIs( f ) );
    _.assert( _.numberIs( l ) );

    src[ 1 ] = f;
    src[ 2 ] = l;

    length += l-f;

  }

  var result = new arguments[ 0 ][ 0 ].constructor( length );
  var r = 0;

  for( var a = 0 ; a < arguments.length ; a++ )
  {

    var src = arguments[ a ];
    var f = src[ 1 ];
    var l = src[ 2 ];

    for( var i = f ; i < l ; i++, r++ )
    result[ r ] = src[ 0 ][ i ];

  }

  return result;
}

//

/**
 * The arrayDuplicate() routine returns an array with duplicate values of a certain number of times.
 *
 * @param { objectLike } [ o = {  } ] o - The set of arguments.
 * @param { longIs } o.src - The given initial array.
 * @param { longIs } o.result - To collect all data.
 * @param { Number } [ o.numberOfAtomsPerElement = 1 ] o.numberOfAtomsPerElement - The certain number of times
 * to append the next value from (srcArray or o.src) to the (o.result).
 * If (o.numberOfAtomsPerElement) is greater that length of a (srcArray or o.src) it appends the 'undefined'.
 * @param { Number } [ o.numberOfDuplicatesPerElement = 2 ] o.numberOfDuplicatesPerElement = 2 - The number of duplicates per element.
 *
 * @example
 * // returns [ 'a', 'a', 'b', 'b', 'c', 'c' ]
 * _.arrayDuplicate( [ 'a', 'b', 'c' ] );
 *
 * @example
 * // returns [ 'abc', 'def', 'abc', 'def', 'abc', 'def' ]
 * var options = {
 *   src : [ 'abc', 'def' ],
 *   result : [  ],
 *   numberOfAtomsPerElement : 2,
 *   numberOfDuplicatesPerElement : 3
 * };
 * _.arrayDuplicate( options, {} );
 *
 * @example
 * // returns [ 'abc', 'def', undefined, 'abc', 'def', undefined, 'abc', 'def', undefined ]
 * var options = {
 *   src : [ 'abc', 'def' ],
 *   result : [  ],
 *   numberOfAtomsPerElement : 3,
 *   numberOfDuplicatesPerElement : 3
 * };
 * _.arrayDuplicate( options, { a : 7, b : 13 } );
 *
 * @returns { Array } Returns an array with duplicate values of a certain number of times.
 * @function arrayDuplicate
 * @throws { Error } Will throw an Error if ( o ) is not an objectLike.
 * @memberof wTools
 */

function arrayDuplicate( o )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  {
    o = { src : arguments[ 0 ], numberOfDuplicatesPerElement : arguments[ 1 ] };
  }
  else
  {
    if( !_.objectIs( o ) )
    o = { src : o };
  }

  _.assert( _.numberIs( o.numberOfDuplicatesPerElement ) || o.numberOfDuplicatesPerElement === undefined );
  _.routineOptions( arrayDuplicate,o );
  _.assert( _.longIs( o.src ), 'arrayDuplicate expects o.src as longIs entity' );
  _.assert( _.numberIsInt( o.src.length / o.numberOfAtomsPerElement ) );

  if( o.numberOfDuplicatesPerElement === 1 )
  {
    if( o.result )
    {
      _.assert( _.longIs( o.result ) || _.bufferTypedIs( o.result ), 'Expects o.result as longIs or TypedArray if numberOfDuplicatesPerElement equals 1' );

      if( _.bufferTypedIs( o.result ) )
      o.result = _.longShallowClone( o.result, o.src );
      else if( _.longIs( o.result ) )
      o.result.push.apply( o.result, o.src );
    }
    else
    {
      o.result = o.src;
    }
    return o.result;
  }

  var length = o.src.length * o.numberOfDuplicatesPerElement;
  var numberOfElements = o.src.length / o.numberOfAtomsPerElement;

  if( o.result )
  _.assert( o.result.length >= length );

  o.result = o.result || longMakeSimilar( o.src,length );

  var rlength = o.result.length;

  for( var c = 0, cl = numberOfElements ; c < cl ; c++ )
  {

    for( var d = 0, dl = o.numberOfDuplicatesPerElement ; d < dl ; d++ )
    {

      for( var e = 0, el = o.numberOfAtomsPerElement ; e < el ; e++ )
      {
        var indexDst = c*o.numberOfAtomsPerElement*o.numberOfDuplicatesPerElement + d*o.numberOfAtomsPerElement + e;
        var indexSrc = c*o.numberOfAtomsPerElement+e;
        o.result[ indexDst ] = o.src[ indexSrc ];
      }

    }

  }

  _.assert( o.result.length === rlength );

  return o.result;
}

arrayDuplicate.defaults =
{
  src : null,
  result : null,
  numberOfAtomsPerElement : 1,
  numberOfDuplicatesPerElement : 2,
}

//

/**
 * The arrayMask() routine returns a new instance of array that contains the certain value(s) from array (srcArray),
 * if an array (mask) contains the truth-value(s).
 *
 * The arrayMask() routine checks, how much an array (mask) contain the truth value(s),
 * and from that amount of truth values it builds a new array, that contains the certain value(s) of an array (srcArray),
 * by corresponding index(es) (the truth value(s)) of the array (mask).
 * If amount is equal 0, it returns an empty array.
 *
 * @param { longIs } srcArray - The source array.
 * @param { longIs } mask - The target array.
 *
 * @example
 * // returns [  ]
 * _.arrayMask( [ 1, 2, 3, 4 ], [ undefined, null, 0, '' ] );
 *
 * @example
 * // returns [ "c", 4, 5 ]
 * _arrayMask( [ 'a', 'b', 'c', 4, 5 ], [ 0, '', 1, 2, 3 ] );
 *
 * @example
 * // returns [ 'a', 'b', 5, 'd' ]
 * _.arrayMask( [ 'a', 'b', 'c', 4, 5, 'd' ], [ 3, 7, 0, '', 13, 33 ] );
 *
 * @returns { longIs } Returns a new instance of array that contains the certain value(s) from array (srcArray),
 * if an array (mask) contains the truth-value(s).
 * If (mask) contains all falsy values, it returns an empty array.
 * Otherwise, it returns a new array with certain value(s) of an array (srcArray).
 * @function arrayMask
 * @throws { Error } Will throw an Error if (arguments.length) is less or more that two.
 * @throws { Error } Will throw an Error if (srcArray) is not an array-like.
 * @throws { Error } Will throw an Error if (mask) is not an array-like.
 * @throws { Error } Will throw an Error if length of both (srcArray and mask) is not equal.
 * @memberof wTools
 */

function arrayMask( srcArray, mask )
{

  var atomsPerElement = mask.length;
  var length = srcArray.length / atomsPerElement;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( srcArray ),'arrayMask :','expects array-like as srcArray' );
  _.assert( _.longIs( mask ),'arrayMask :','expects array-like as mask' );
  _.assert
  (
    _.numberIsInt( length ),
    'arrayMask :','expects mask that has component for each atom of srcArray',
    _.toStr
    ({
      'atomsPerElement' : atomsPerElement,
      'srcArray.length' : srcArray.length,
    })
  );

  var preserve = 0;
  for( var m = 0 ; m < mask.length ; m++ )
  if( mask[ m ] )
  preserve += 1;

  var dstArray = new srcArray.constructor( length*preserve );

  if( !preserve )
  return dstArray;

  var c = 0;
  for( var i = 0 ; i < length ; i++ )
  for( var m = 0 ; m < mask.length ; m++ )
  if( mask[ m ] )
  {
    dstArray[ c ] = srcArray[ i*atomsPerElement + m ];
    c += 1;
  }

  return dstArray;
}

//

function arrayUnmask( o )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  o =
  {
    src : arguments[ 0 ],
    mask : arguments[ 1 ],
  }

  _.assertMapHasOnly( o,arrayUnmask.defaults );
  _.assert( _.longIs( o.src ),'arrayUnmask : expects o.src as ArrayLike' );

  var atomsPerElement = o.mask.length;

  var atomsPerElementPreserved = 0;
  for( var m = 0 ; m < o.mask.length ; m++ )
  if( o.mask[ m ] )
  atomsPerElementPreserved += 1;

  var length = o.src.length / atomsPerElementPreserved;
  if( Math.floor( length ) !== length )
  throw _.err( 'arrayMask :','expects mask that has component for each atom of o.src',_.toStr({ 'atomsPerElementPreserved' : atomsPerElementPreserved, 'o.src.length' : o.src.length  }) );

  var dstArray = new o.src.constructor( atomsPerElement*length );

  var e = [];
  for( var i = 0 ; i < length ; i++ )
  {

    for( var m = 0, p = 0 ; m < o.mask.length ; m++ )
    if( o.mask[ m ] )
    {
      e[ m ] = o.src[ i*atomsPerElementPreserved + p ];
      p += 1;
    }
    else
    {
      e[ m ] = 0;
    }

    if( o.onEach )
    o.onEach( e,i );

    for( var m = 0 ; m < o.mask.length ; m++ )
    dstArray[ i*atomsPerElement + m ] = e[ m ];

  }

  return dstArray;
}

arrayUnmask.defaults =
{
  src : null,
  mask : null,
  onEach : null,
}

//

function arrayInvestigateUniqueMap( o )
{

  if( _.longIs( o ) )
  o = { src : o };

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( o.src ) );
  _.assertMapHasOnly( o,arrayInvestigateUniqueMap.defaults );

  /**/

  if( o.onEvaluate )
  {
    o.src = _.entityMap( o.src,( e ) => o.onEvaluate( e ) );
  }

  /**/

  var number = o.src.length;
  var isUnique = _.longMakeSimilar( o.src );
  var index;

  for( var i = 0 ; i < o.src.length ; i++ )
  isUnique[ i ] = 1;

  for( var i = 0 ; i < o.src.length ; i++ )
  {

    index = i;

    if( !isUnique[ i ] )
    continue;

    var currentUnique = 1;
    do
    {
      var index = o.src.indexOf( o.src[ i ],index+1 );
      if( index !== -1 )
      {
        isUnique[ index ] = 0;
        number -= 1;
        currentUnique = 0;
      }
    }
    while( index !== -1 );

    if( !o.includeFirst )
    if( !currentUnique )
    {
      isUnique[ i ] = 0;
      number -= 1;
    }

  }

  return { number : number, array : isUnique };
}

arrayInvestigateUniqueMap.defaults =
{
  src : null,
  onEvaluate : null,
  includeFirst : 0,
}

//

function arrayUnique( src, onEvaluate )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var isUnique = arrayInvestigateUniqueMap
  ({
    src : src,
    onEvaluate : onEvaluate,
    includeFirst : 1,
  });

  var result = longMakeSimilar( src,isUnique.number );

  var c = 0;
  for( var i = 0 ; i < src.length ; i++ )
  if( isUnique.array[ i ] )
  {
    result[ c ] = src[ i ];
    c += 1;
  }

  return result;
}

//

/**
 * The arraySelect() routine selects elements from (srcArray) by indexes of (indicesArray).
 *
 * @param { longIs } srcArray - Values for the new array.
 * @param { ( longIs | object ) } [ indicesArray = indicesArray.indices ] - Indexes of elements from the (srcArray) or options object.
 *
 * @example
 * // returns [ 3, 4, 5 ]
 * var arr = _.arraySelect( [ 1, 2, 3, 4, 5 ], [ 2, 3, 4 ] );
 *
 * @example
 * // returns [ undefined, undefined ]
 * var arr = _.arraySelect( [ 1, 2, 3 ], [ 4, 5 ] );
 *
 * @returns { longIs } - Returns a new array with the length equal (indicesArray.length) and elements from (srcArray).
   If there is no element with necessary index than the value will be undefined.
 * @function arraySelect
 * @throws { Error } If passed arguments is not array like object.
 * @throws { Error } If the atomsPerElement property is not equal to 1.
 * @memberof wTools
 */

function arraySelect( srcArray,indicesArray )
{
  var atomsPerElement = 1;

  if( _.objectIs( indicesArray ) )
  {
    atomsPerElement = indicesArray.atomsPerElement || 1;
    indicesArray = indicesArray.indices;
  }

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.bufferTypedIs( srcArray ) || _.arrayIs( srcArray ) );
  _.assert( _.bufferTypedIs( indicesArray ) || _.arrayIs( indicesArray ) );

  var result = new srcArray.constructor( indicesArray.length );

  if( atomsPerElement === 1 )
  for( var i = 0, l = indicesArray.length ; i < l ; i += 1 )
  {
    result[ i ] = srcArray[ indicesArray[ i ] ];
  }
  else
  for( var i = 0, l = indicesArray.length ; i < l ; i += 1 )
  {
    // throw _.err( 'not tested' );
    for( var a = 0 ; a < atomsPerElement ; a += 1 )
    result[ i*atomsPerElement+a ] = srcArray[ indicesArray[ i ]*atomsPerElement+a ];
  }

  return result;
}

// --
// array mutator
// --

function arraySet( dst, index, value )
{
  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( dst.length > index );
  dst[ index ] = value;
  return dst;
}

//

/**
 * The arraySwap() routine reverses the elements by indices (index1) and (index2) in the (dst) array.
 *
 * @param { Array } dst - The initial array.
 * @param { Number } index1 - The first index.
 * @param { Number } index2 - The second index.
 *
 * @example
 * // returns [ 5, 2, 3, 4, 1 ]
 * var arr = _.arraySwap( [ 1, 2, 3, 4, 5 ], 0, 4 );
 *
 * @returns { Array } - Returns the (dst) array that has been modified in place by indexes (index1) and (index2).
 * @function arraySwap
 * @throws { Error } If the first argument in not an array.
 * @throws { Error } If the second argument is less than 0 and more than a length initial array.
 * @throws { Error } If the third argument is less than 0 and more than a length initial array.
 * @memberof wTools
 */

function arraySwap( dst,index1,index2 )
{

  if( arguments.length === 1 )
  {
    index1 = 0;
    index2 = 1;
  }

  _.assert( arguments.length === 1 || arguments.length === 3 );
  _.assert( _.longIs( dst ),'arraySwap :','argument must be array' );
  _.assert( 0 <= index1 && index1 < dst.length,'arraySwap :','index1 is out of bound' );
  _.assert( 0 <= index2 && index2 < dst.length,'arraySwap :','index2 is out of bound' );

  var e = dst[ index1 ];
  dst[ index1 ] = dst[ index2 ];
  dst[ index2 ] = e;

  return dst;
}

//

/**
 * Removes range( range ) of elements from provided array( dstArray ) and adds elements from array( srcArray )
 * at the start position of provided range( range ) if( srcArray ) was provided.
 * On success returns array with deleted element(s), otherwise returns empty array.
 * For TypedArray's and buffers returns modified copy of ( dstArray ) or original array if nothing changed.
 *
 * @param { Array|TypedArray|Buffer } dstArray - The target array, TypedArray( Int8Array,Int16Array,Uint8Array ... etc ) or Buffer( ArrayBuffer, Buffer ).
 * @param { Array|Number } range - The range of elements or index of single element to remove from ( dstArray ).
 * @param { Array } srcArray - The array of elements to add to( dstArray ) at the start position of provided range( range ).
 * If one of ( range ) indexies is not specified it will be setted to zero.
 * If ( range ) start index is greater than the length of the array ( dstArray ), actual starting index will be set to the length of the array ( dstArray ).
 * If ( range ) start index is negative, will be setted to zero.
 * If ( range ) start index is greater than end index, the last will be setted to value of start index.
 *
 * @example
 * _.arrayCutin( [ 1, 2, 3, 4 ], 2 );
 * // returns [ 3 ]
 *
 * @example
 * _.arrayCutin( [ 1, 2, 3, 4 ], [ 1, 2 ] );
 * // returns [ 2 ]
 *
 * @example
 * _.arrayCutin( [ 1, 2, 3, 4 ], [ 0, 5 ] );
 * // returns [ 1, 2, 3, 4 ]
 *
 * @example
 * _.arrayCutin( [ 1, 2, 3, 4 ], [ -1, 5 ] );
 * // returns [ 1, 2, 3, 4 ]
 *
 * @example
 * var dst = [ 1, 2, 3, 4 ];
 * _.arrayCutin( dst, [ 0, 3 ], [ 0, 0, 0 ] );
 * console.log( dst );
 * // returns [ 0, 0, 0, 4 ]
 *
 * @example
 * var dst = new Int32Array( 4 );
 * dst.set( [ 1, 2, 3, 4 ] )
 * _.arrayCutin( dst, 0 );
 * // returns [ 2, 3, 4 ]
 *
 * @returns { Array|TypedArray|Buffer } For array returns array with deleted element(s), otherwise returns empty array.
 * For other types returns modified copy or origin( dstArray ).
 * @function arrayCutin
 * @throws { Error } If ( arguments.length ) is not equal to two or three.
 * @throws { Error } If ( dstArray ) is not an Array.
 * @throws { Error } If ( srcArray ) is not an Array.
 * @throws { Error } If ( range ) is not an Array.
 * @memberof wTools
 */

function arrayCutin( dstArray, range, srcArray )
{

  if( _.numberIs( range ) )
  range = [ range, range + 1 ];

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( _.arrayIs( dstArray ) || _.bufferAnyIs( dstArray ) );
  _.assert( _.arrayIs( range ) );
  _.assert( srcArray === undefined || _.arrayIs( srcArray ) );

  var length = _.definedIs( dstArray.length ) ? dstArray.length : dstArray.byteLength;
  var first = range[ 0 ] !== undefined ? range[ 0 ] : 0;
  var last = range[ 1 ] !== undefined ? range[ 1 ] : length;
  var result;

  if( first < 0 )
  first = 0;
  if( first > length)
  first = length;
  if( last > length)
  last = length;
  if( last < first )
  last = first;

  if( _.bufferAnyIs( dstArray ) )
  {
    if( first === last )
    return dstArray;

    var newLength = length - last + first;
    var srcArrayLength = 0;

    if( srcArray )
    {
      srcArrayLength = _.definedIs( srcArray.length ) ? srcArray.length : srcArray.byteLength;
      newLength += srcArrayLength;
    }

    if( _.bufferRawIs( dstArray ) )
    {
      result = new ArrayBuffer( newLength );
    }
    else if( _.bufferNodeIs( dstArray ) )
    {
      result = Buffer.alloc( newLength );
    }
    else
    {
      result = longMakeSimilar( dstArray, newLength );
    }

    if( first > 0 )
    for( var i = 0; i < first; ++i )
    result[ i ] = dstArray[ i ];

    if( srcArray )
    for( var i = first, j = 0; j < srcArrayLength; )
    result[ i++ ] = srcArray[ j++ ];

    for( var j = last, i = first + srcArrayLength; j < length; )
    result[ i++ ] = dstArray[ j++ ];

    return result;
  }
  else
  {

    var args = srcArray ? srcArray.slice() : [];
    args.unshift( last-first );
    args.unshift( first );

    result = dstArray.splice.apply( dstArray,args );
  }

  return result;
}

//

/**
 * The arrayPut() routine puts all values of (arguments[]) after the second argument to the (dstArray)
 * in the position (dstOffset) and changes values of the following index.
 *
 * @param { longIs } dstArray - The source array.
 * @param { Number } [ dstOffset = 0 ] dstOffset - The index of element where need to put the new values.
 * @param {*} arguments[] - One or more argument(s).
 * If the (argument) is an array it iterates over array and adds each element to the next (dstOffset++) index of the (dstArray).
 * Otherwise, it adds each (argument) to the next (dstOffset++) index of the (dstArray).
 *
 * @example
 * // returns [ 1, 2, 'str', true, 7, 8, 9 ]
 * var arr = _.arrayPut( [ 1, 2, 3, 4, 5, 6, 9 ], 2, 'str', true, [ 7, 8 ] );
 *
 * @example
 * // returns [ 'str', true, 7, 8, 5, 6, 9 ]
 * var arr = _.arrayPut( [ 1, 2, 3, 4, 5, 6, 9 ], 0, 'str', true, [ 7, 8 ] );
 *
 * @returns { longIs } - Returns an array containing the changed values.
 * @function arrayPut
 * @throws { Error } Will throw an Error if (arguments.length) is less than one.
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (dstOffset) is not a Number.
 * @memberof wTools
 */

function arrayPut( dstArray, dstOffset )
{
  _.assert( arguments.length >= 1, 'expects at least one argument' );
  _.assert( _.longIs( dstArray ) );
  _.assert( _.numberIs( dstOffset ) );

  dstOffset = dstOffset || 0;

  for( var a = 2 ; a < arguments.length ; a++ )
  {
    var argument = arguments[ a ];
    var aIs = _.arrayIs( argument ) || _.bufferTypedIs( argument );

    if( aIs && _.bufferTypedIs( dstArray ) )
    {
      dstArray.set( argument,dstOffset );
      dstOffset += argument.length;
    }
    else if( aIs )
    for( var i = 0 ; i < argument.length ; i++ )
    {
      dstArray[ dstOffset ] = argument[ i ];
      dstOffset += 1;
    }
    else
    {
      dstArray[ dstOffset ] = argument;
      dstOffset += 1;
    }

  }

  return dstArray;
}

//

/**
 * The arrayFill() routine fills all the elements of the given or a new array from the 0 index to an (options.times) index
 * with a static value.
 *
 * @param { ( Object | Number | Array ) } o - The options to fill the array.
 * @param { Number } [ o.times = result.length ] o.times - The count of repeats.
   If in the function passed an Array, the times will be equal the length of the array. If Number than this value.
 * @param { Number } [ o.value = 0 ] - The value for the filling.
 *
 * @example
 * // returns [ 3, 3, 3, 3, 3 ]
 * var arr = _.arrayFill( { times : 5, value : 3 } );
 *
 * @example
 * // returns [ 0, 0, 0, 0 ]
 * var arr = _.arrayFill( 4 );
 *
 * @example
 * // returns [ 0, 0, 0 ]
 * var arr = _.arrayFill( [ 1, 2, 3 ] );
 *
 * @returns { Array } - Returns an array filled with a static value.
 * @function arrayFill
 * @throws { Error } If missed argument, or got more than one argument.
 * @throws { Error } If passed argument is not an object.
 * @throws { Error } If the last element of the (o.result) is not equal to the (o.value).
 * @memberof wTools
 */

function arrayFillTimes( result,times,value )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( _.longIs( result ) );

  if( value === undefined )
  value = 0;

  if( result.length < times )
  result = _.arrayGrow( result , 0 , times );

  if( _.routineIs( result.fill ) )
  {
    result.fill( value,0,times );
  }
  else
  {
    debugger;
    if( times < 0 )
    times = result.length + times;

    for( var t = 0 ; t < times ; t++ )
    result[ t ] = value;
  }

  _.assert( times <= 0 || result[ times-1 ] === value );

  return result;
}

//

function arrayFillWhole( result,value )
{
  _.assert( _.longIs( result ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( value === undefined )
  value = 0;
  return _.arrayFillTimes( result,result.length,value );
}

// {
//   _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
//   _.assert( _.objectIs( o ) || _.numberIs( o ) || _.arrayIs( o ),'arrayFill :','"o" must be object' );
//
//   if( arguments.length === 1 )
//   {
//     if( _.numberIs( o ) )
//     o = { times : o };
//     else if( _.arrayIs( o ) )
//     o = { result : o };
//   }
//   else
//   {
//     o = { result : arguments[ 0 ], value : arguments[ 1 ] };
//   }
//
//   _.assertMapHasOnly( o,arrayFill.defaults );
//   if( o.result )
//   _.assert( _.longIs( o.result ) );
//
//   var result = o.result || [];
//   var times = o.times !== undefined ? o.times : result.length;
//   var value = o.value !== undefined ? o.value : 0;
//
//   if( _.routineIs( result.fill ) )
//   {
//     if( result.length < times )
//     result.length = times;
//     result.fill( value,0,times );
//   }
//   else
//   {
//     for( var t = 0 ; t < times ; t++ )
//     result[ t ] = value;
//   }
//
//   _.assert( result[ times-1 ] === value );
//   return result;
// }
//
// arrayFill.defaults =
// {
//   result : null,
//   times : null,
//   value : null,
// }

//

/**
 * The arraySupplement() routine returns an array (dstArray), that contains values from following arrays only type of numbers.
 * If the initial (dstArray) isn't contain numbers, they are replaced.
 *
 * It finds among the arrays the biggest array, and assigns to the variable (length), iterates over from 0 to the (length),
 * creates inner loop that iterates over (arguments[...]) from the right (arguments.length - 1) to the (arguments[0]) left,
 * checks each element of the arrays, if it contains only type of number.
 * If true, it adds element to the array (dstArray) by corresponding index.
 * Otherwise, it skips and checks following array from the last executable index, previous array.
 * If the last executable index doesn't exist, it adds 'undefined' to the array (dstArray).
 * After that it returns to the previous array, and executes again, until (length).
 *
 * @param { longIs } dstArray - The initial array.
 * @param { ...longIs } arguments[...] - The following array(s).
 *
 * @example
 * // returns ?
 * _.arraySupplement( [ 4, 5 ], [ 1, 2, 3 ], [ 6, 7, 8, true, 9 ], [ 'a', 'b', 33, 13, 'e', 7 ] );
 * @returns { longIs } - Returns an array that contains values only type of numbers.
 * @function arraySupplement
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments[...]) is/are not the array-like.
 * @memberof wTools
 */

function arraySupplement( dstArray )
{
  var result = dstArray;
  if( result === null )
  result = [];

  var length = result.length;
  _.assert( _.longIs( result ) || _.numberIs( result ),'expects object as argument' );

  for( a = arguments.length-1 ; a >= 1 ; a-- )
  {
    _.assert( _.longIs( arguments[ a ] ),'argument is not defined :',a );
    length = Math.max( length,arguments[ a ].length );
  }

  if( _.numberIs( result ) )
  result = arrayFill
  ({
    value : result,
    times : length,
  });

  for( var k = 0 ; k < length ; k++ )
  {

    if( k in dstArray && isFinite( dstArray[ k ] ) )
    continue;

    var a;
    for( a = arguments.length-1 ; a >= 1 ; a-- )
    if( k in arguments[ a ] && !isNaN( arguments[ a ][ k ] ) )
    break;

    if( a === 0 )
    continue;

    result[ k ] = arguments[ a ][ k ];

  }

  return result;
}

//

/**
 * The arrayExtendScreening() routine iterates over (arguments[...]) from the right to the left (arguments[1]),
 * and returns a (dstArray) containing the values of the following arrays,
 * if the following arrays contains the indexes of the (screenArray).
 *
 * @param { longIs } screenArray - The source array.
 * @param { longIs } dstArray - To add the values from the following arrays,
 * if the following arrays contains indexes of the (screenArray).
 * If (dstArray) contains values, the certain values will be replaced.
 * @param { ...longIs } arguments[...] - The following arrays.
 *
 * @example
 * // returns [ 5, 6, 2 ]
 * _.arrayExtendScreening( [ 1, 2, 3 ], [  ], [ 0, 1, 2 ], [ 3, 4 ], [ 5, 6 ] );
 *
 * @example
 * // returns [ 'a', 6, 2, 13 ]
 * _.arrayExtendScreening( [ 1, 2, 3 ], [ 3, 'abc', 7, 13 ], [ 0, 1, 2 ], [ 3, 4 ], [ 'a', 6 ] );
 *
 * @example
 * // returns [ 3, 'abc', 7, 13 ]
 * _.arrayExtendScreening( [  ], [ 3, 'abc', 7, 13 ], [ 0, 1, 2 ], [ 3, 4 ], [ 'a', 6 ] )
 *
 * @returns { longIs } Returns a (dstArray) containing the values of the following arrays,
 * if the following arrays contains the indexes of the (screenArray).
 * If (screenArray) is empty, it returns a (dstArray).
 * If (dstArray) is equal to the null, it creates a new array,
 * and returns the corresponding values of the following arrays by the indexes of a (screenArray).
 * @function arrayExtendScreening
 * @throws { Error } Will throw an Error if (screenArray) is not an array-like.
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments[...]) is/are not an array-like.
 * @memberof wTools
 */

function arrayExtendScreening( screenArray,dstArray )
{
  var result = dstArray;
  if( result === null ) result = [];

  _.assert( _.longIs( screenArray ),'expects object as screenArray' );
  _.assert( _.longIs( result ),'expects object as argument' );
  for( a = arguments.length-1 ; a >= 2 ; a-- )
  _.assert( arguments[ a ],'argument is not defined :',a );

  for( var k = 0 ; k < screenArray.length ; k++ )
  {

    if( screenArray[ k ] === undefined )
    continue;

    var a;
    for( a = arguments.length-1 ; a >= 2 ; a-- )
    if( k in arguments[ a ] ) break;
    if( a === 1 )
    continue;

    result[ k ] = arguments[ a ][ k ];

  }

  return result;
}

//

function arrayShuffle( dst,times )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.longIs( dst ) );

  if( times === undefined )
  times = dst.length;

  var l = dst.length;
  var e1,e2;
  for( var t1 = 0 ; t1 < times ; t1++ )
  {
    var t2 = Math.floor( Math.random() * l );
    e1 = dst[ t1 ];
    e2 = dst[ t2 ];
    dst[ t1 ] = e2;
    dst[ t2 ] = e1;
  }

  return dst;
}

//

function arraySort( srcArray, onEvaluate )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( onEvaluate === undefined || _.routineIs( onEvaluate ) );

  if( onEvaluate === undefined )
  {
    debugger;
    srcArray.sort();
  }
  else if( onEvaluate.length === 2 )
  {
    srcArray.sort( onEvaluate );
  }
  else if( onEvaluate.length === 1 )
  {
    srcArray.sort( function( a,b )
    {
      a = onEvaluate( a );
      b = onEvaluate( b );
      if( a > b ) return +1;
      else if( a < b ) return -1;
      else return 0;
    });
  }
  else _.assert( 0, 'Expects signle-arguments evaluator or two-argument comparator' );

  return srcArray;
}

//

// function arraySpliceArray( dstArray,srcArray,first,replace )
// {
//   debugger;
//
//   _.assert( arguments.length === 4 );
//   _.assert( _.arrayIs( dstArray ) );
//   _.assert( _.arrayIs( srcArray ) );
//   _.assert( _.numberIs( first ) );
//   _.assert( _.numberIs( replace ) );
//
//   var args = [ first,replace ];
//   args.push.apply( args,srcArray );
//
//   dstArray.splice.apply( dstArray,args );
//
//   return dstArray;
// }
//
// //
//
// function arraySplice( dstArray,first,replace,srcArray )
// {
//
//   _.assert( _.arrayIs( dstArray ) );
//   _.assert( _.arrayIs( srcArray ) );
//
//   var first = first !== undefined ? first : 0;
//   var replace = replace !== undefined ? replace : dstArray.length;
//   var result = dstArray.slice( first,first+replace );
//
//   var srcArray = srcArray.slice();
//   srcArray.unshift( replace );
//   srcArray.unshift( first );
//
//   dstArray.splice.apply( dstArray,srcArray );
//
//   return result;
// }

// --
// array sequential search
// --

function arrayLeftIndex( arr, ins, evaluator1, evaluator2 )
{

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.longIs( arr ) );
  _.assert( !evaluator1 || evaluator1.length === 1 || evaluator1.length === 2 );
  _.assert( !evaluator1 || _.routineIs( evaluator1 ) );
  _.assert( !evaluator2 || evaluator2.length === 1 );
  _.assert( !evaluator2 || _.routineIs( evaluator2 ) );

  if( !evaluator1 )
  {
    _.assert( !evaluator2 );
    return _ArrayIndexOf.call( arr, ins );
  }
  else if( evaluator1.length === 2 )
  {
    _.assert( !evaluator2 );
    for( var a = 0 ; a < arr.length ; a++ )
    {

      if( evaluator1( arr[ a ],ins ) )
      return a;

    }
  }
  else
  {

    if( evaluator2 )
    ins = evaluator2( ins );
    else
    ins = evaluator1( ins );

    for( var a = 0 ; a < arr.length ; a++ )
    {
      if( evaluator1( arr[ a ] ) === ins )
      return a;
    }

  }

  return -1;
}

//

function arrayRightIndex( arr, ins, evaluator1, evaluator2 )
{

  if( ins === undefined )
  debugger;

  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( !evaluator1 || evaluator1.length === 1 || evaluator1.length === 2 );
  _.assert( !evaluator1 || _.routineIs( evaluator1 ) );
  _.assert( !evaluator2 || evaluator2.length === 1 );
  _.assert( !evaluator2 || _.routineIs( evaluator2 ) );

  if( !evaluator1 )
  {
    _.assert( !evaluator2 );
    if( !_.arrayIs( arr ) )
    debugger;
    return _ArrayLastIndexOf.call( arr, ins );
  }
  else if( evaluator1.length === 2 )
  {
    _.assert( !evaluator2 );
    for( var a = arr.length-1 ; a >= 0 ; a-- )
    {
      if( evaluator1( arr[ a ],ins ) )
      return a;
    }
  }
  else
  {

    if( evaluator2 )
    ins = evaluator2( ins );
    else
    ins = evaluator1( ins );

    for( var a = arr.length-1 ; a >= 0 ; a-- )
    {
      if( evaluator1( arr[ a ] ) === ins )
      return a;
    }

  }

  return -1;
}

//
//
// /**
//  * The arrayLeftIndex() routine returns the index of the first matching (ins) element in a array (arr)
//  * that corresponds to the condition in the callback function.
//  *
//  * It iterates over an array (arr) from the left to the right,
//  * and checks by callback function( evaluator1( arr[ a ], ins ) ).
//  * If callback function returns true, it returns corresponding index.
//  * Otherwise, it returns -1.
//  *
//  * @param { longIs } arr - The target array.
//  * @param { * } ins - The value to compare.
//  * @param { wTools~compareCallback } [equalizer] evaluator1 - A callback function.
//  * By default, it checks the equality of two arguments.
//  *
//  * @example
//  * // returns 0
//  * _.arrayLeftIndex( [ 1, 2, 3 ], 1 );
//  *
//  * @example
//  * // returns -1
//  * _.arrayLeftIndex( [ 1, 2, 3 ], 4 );
//  *
//  * @example
//  * // returns 3
//  * _.arrayLeftIndex( [ 1, 2, 3, 4 ], 3, function( el, ins ) { return el > ins } );
//  *
//  * @example
//  * // returns 3
//  * _.arrayLeftIndex( 'abcdef', 'd' );
//  *
//  * @example
//  * // returns 2
//  * function arr() {
//  *   return arguments;
//  * }( 3, 7, 13 );
//  * _.arrayLeftIndex( arr, 13 );
//  *
//  * @returns { Number } Returns the corresponding index, if a callback function ( evaluator1 ) returns true.
//  * Otherwise, it returns -1.
//  * @function arrayLeftIndex
//  * @throws { Error } Will throw an Error if (arguments.length) is not equal to the 2 or 3.
//  * @throws { Error } Will throw an Error if (evaluator1.length) is not equal to the 1 or 2.
//  * @throws { Error } Will throw an Error if (evaluator1) is not a Function.
//  * @memberof wTools
//  */
//
// function arrayLeftIndex( arr, ins, evaluator1, evaluator2 )
// {
//
//   _.assert( 2 <= arguments.length || arguments.length <= 4 );
//   _.assert( !evaluator1 || evaluator1.length === 1 || evaluator1.length === 2 );
//   _.assert( !evaluator1 || _.routineIs( evaluator1 ) );
//   _.assert( !evaluator2 || evaluator2.length === 1 );
//   _.assert( !evaluator2 || _.routineIs( evaluator2 ) );
//
//   if( !evaluator1 )
//   {
//     _.assert( !evaluator2 );
//     if( !_.arrayIs( arr ) )
//     debugger;
//     return _ArrayIndexOf.call( arr, ins );
//     // if( _.argumentsArrayIs( arr ) )
//     // {
//     //   var array = _ArraySlice.call( arr );
//     //   return array.indexOf( ins );
//     // }
//     // return arr.indexOf( ins );
//   }
//   else if( evaluator1.length === 2 )
//   {
//     _.assert( !evaluator2 );
//     for( var a = 0 ; a < arr.length ; a++ )
//     {
//
//       if( evaluator1( arr[ a ],ins ) )
//       return a;
//
//     }
//   }
//   else
//   {
//
//     debugger;
//     if( evaluator2 )
//     ins = evaluator2( ins );
//
//     debugger;
//     for( var a = 0 ; a < arr.length ; a++ )
//     {
//       if( evaluator1( arr[ a ] ) === evaluator1( ins ) )
//       return a;
//     }
//
//   }
//
//   return -1;
// }
//
// //
//
// function arrayRightIndex( arr, ins, evaluator1, evaluator2 )
// {
//
//   if( ins === undefined )
//   debugger;
//
//   debugger;
//
//   _.assert( 2 <= arguments.length || arguments.length <= 4 );
//   _.assert( !evaluator1 || evaluator1.length === 1 || evaluator1.length === 2 );
//   _.assert( !evaluator1 || _.routineIs( evaluator1 ) );
//
//   if( !evaluator1 )
//   {
//     _.assert( !evaluator2 );
//     if( !_.arrayIs( arr ) )
//     debugger;
//     return _ArrayLastIndexOf.call( arr, ins );
//     // if( _.argumentsArrayIs( arr ) )
//     // {
//     //   var array = _ArraySlice.call( arr );
//     //   return array.lastIndexOf( ins );
//     // }
//     // return arr.lastIndexOf( ins );
//   }
//   else if( evaluator1.length === 2 )
//   {
//     _.assert( !evaluator2 );
//     for( var a = arr.length-1 ; a >= 0 ; a-- )
//     {
//
//       if( evaluator1( arr[ a ],ins ) )
//       return a;
//
//     }
//   }
//   else
//   {
//
//     debugger;
//     for( var a = arr.length-1 ; a >= 0 ; a-- )
//     {
//       if( evaluator1( arr[ a ] ) === evaluator1 ( ins ) )
//       return a;
//     }
//
//   }
//
//   return -1;
// }

//

/**
 * The arrayLeft() routine returns a new object containing the properties, (index, element),
 * corresponding to a found value (ins) from an array (arr).
 *
 * It creates the variable (i), assigns and calls to it the function( _.arrayLeftIndex( arr, ins, evaluator1 ) ),
 * that returns the index of the value (ins) in the array (arr).
 * [wTools.arrayLeftIndex()]{@link wTools.arrayLeftIndex}
 * If (i) is more or equal to the zero, it returns the object containing the properties ({ index : i, element : arr[ i ] }).
 * Otherwise, it returns the empty object.
 *
 * @see {@link wTools.arrayLeftIndex} - See for more information.
 *
 * @param { longIs } arr - Entity to check.
 * @param { * } ins - Element to locate in the array.
 * @param { wTools~compareCallback } evaluator1 - A callback function.
 *
 * @example
 * // returns { index : 3, element : 'str' }
 * _.arrayLeft( [ 1, 2, false, 'str', 5 ], 'str', function( a, b ) { return a === b } );
 *
 * @example
 * // returns {  }
 * _.arrayLeft( [ 1, 2, 3, 4, 5 ], 6 );
 *
 * @returns { Object } Returns a new object containing the properties, (index, element),
 * corresponding to the found value (ins) from the array (arr).
 * Otherwise, it returns the empty object.
 * @function arrayLeft
 * @throws { Error } Will throw an Error if (evaluator1) is not a Function.
 * @memberof wTools
 */

function arrayLeft( arr, ins, evaluator1, evaluator2 )
{
  var result = Object.create( null );
  var i = _.arrayLeftIndex( arr, ins, evaluator1, evaluator2 );

  _.assert( 2 <= arguments.length && arguments.length <= 4 );

  if( i >= 0 )
  {
    result.index = i;
    result.element = arr[ i ];
  }

  return result;
}

//

function arrayRight( arr, ins, evaluator1, evaluator2 )
{
  var result = Object.create( null );
  var i = _.arrayRightIndex( arr, ins, evaluator1, evaluator2 );

  _.assert( 2 <= arguments.length && arguments.length <= 4 );

  if( i >= 0 )
  {
    result.index = i;
    result.element = arr[ i ];
  }

  return result;
}

//

function arrayLeftDefined( arr )
{

  _.assert( arguments.length === 1, 'expects single argument' );

  return _.arrayLeft( arr,true,function( e ){ return e !== undefined; } );
}

//

function arrayRightDefined( arr )
{

  _.assert( arguments.length === 1, 'expects single argument' );

  return _.arrayRight( arr,true,function( e ){ return e !== undefined; } );
}

//

/**
 * The arrayCount() routine returns the count of matched elements in the {-srcMap-} array.
 *
 * @param { Array } src - The source array.
 * @param { * } instance - The value to search.
 *
 * @example
 * // returns 2
 * var arr = _.arrayCount( [ 1, 2, 'str', 10, 10, true ], 10 );
 *
 * @returns { Number } - Returns the count of matched elements in the {-srcMap-}.
 * @function arrayCount
 * @throws { Error } If passed arguments is less than two or more than two.
 * @throws { Error } If the first argument is not an array-like object.
 * @memberof wTools
 */

function arrayCount( src,instance )
{
  var result = 0;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( src ),'arrayCount :','expects ArrayLike' );

  var index = src.indexOf( instance );
  while( index !== -1 )
  {
    result += 1;
    index = src.indexOf( instance,index+1 );
  }

  return result;
}

//

/**
 * The arrayCountUnique() routine returns the count of matched pairs ([ 1, 1, 2, 2, ., . ]) in the array {-srcMap-}.
 *
 * @param { longIs } src - The source array.
 * @param { Function } [ onEvaluate = function( e ) { return e } ] - A callback function.
 *
 * @example
 * // returns 3
 * _.arrayCountUnique( [ 1, 1, 2, 'abc', 'abc', 4, true, true ] );
 *
 * @example
 * // returns 0
 * _.arrayCountUnique( [ 1, 2, 3, 4, 5 ] );
 *
 * @returns { Number } - Returns the count of matched pairs ([ 1, 1, 2, 2, ., . ]) in the array {-srcMap-}.
 * @function arrayCountUnique
 * @throws { Error } If passed arguments is less than one or more than two.
 * @throws { Error } If the first argument is not an array-like object.
 * @throws { Error } If the second argument is not a Function.
 * @memberof wTools
 */

function arrayCountUnique( src, onEvaluate )
{
  var found = [];
  var onEvaluate = onEvaluate || function( e ){ return e };

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.longIs( src ),'arrayCountUnique :','expects ArrayLike' );
  _.assert( _.routineIs( onEvaluate ) );
  _.assert( onEvaluate.length === 1 );

  for( var i1 = 0 ; i1 < src.length ; i1++ )
  {
    var element1 = onEvaluate( src[ i1 ] );
    if( found.indexOf( element1 ) !== -1 )
    continue;

    for( var i2 = i1+1 ; i2 < src.length ; i2++ )
    {

      var element2 = onEvaluate( src[ i2 ] );
      if( found.indexOf( element2 ) !== -1 )
      continue;

      if( element1 === element2 )
      found.push( element1 );

    }

  }

  return found.length;
}

// --
// array etc
// --

function arrayIndicesOfGreatest( srcArray,numberOfElements,comparator )
{
  var result = [];
  var l = srcArray.length;

  debugger;
  throw _.err( 'not tested' );

  comparator = _._comparatorFromEvaluator( comparator );

  function rcomparator( a,b )
  {
    return comparator( srcArray[ a ],srcArray[ b ] );
  };

  for( var i = 0 ; i < l ; i += 1 )
  {

    if( result.length < numberOfElements )
    {
      _.sorted.add( result, i, rcomparator );
      continue;
    }

    _.sorted.add( result, i, rcomparator );
    result.splice( result.length-1,1 );

  }

  return result;
}

//

/**
 * The arraySum() routine returns the sum of an array {-srcMap-}.
 *
 * @param { longIs } src - The source array.
 * @param { Function } [ onEvaluate = function( e ) { return e } ] - A callback function.
 *
 * @example
 * // returns 15
 * _.arraySum( [ 1, 2, 3, 4, 5 ] );
 *
 * @example
 * // returns 29
 * _.arraySum( [ 1, 2, 3, 4, 5 ], function( e ) { return e * 2 } );
 *
 * @example
 * // returns 94
 * _.arraySum( [ true, false, 13, '33' ], function( e ) { return e * 2 } );
 *
 * @returns { Number } - Returns the sum of an array {-srcMap-}.
 * @function arraySum
 * @throws { Error } If passed arguments is less than one or more than two.
 * @throws { Error } If the first argument is not an array-like object.
 * @throws { Error } If the second argument is not a Function.
 * @memberof wTools
 */

function arraySum( src,onEvaluate )
{
  var result = 0;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.longIs( src ),'arraySum :','expects ArrayLike' );

  if( onEvaluate === undefined )
  onEvaluate = function( e ){ return e; };

  _.assert( _.routineIs( onEvaluate ) );

  for( var i = 0 ; i < src.length ; i++ )
  {
    result += onEvaluate( src[ i ],i,src );
  }

  return result;
}

// --
// array prepend
// --

function _arrayPrependUnrolling( dstArray, srcArray )
{
  _.assert( arguments.length === 2 );
  _.assert( _.arrayIs( dstArray ), 'expects array' );

  for( var a = srcArray.length - 1 ; a >= 0 ; a-- )
  {
    if( _.unrollIs( srcArray[ a ] ) )
    {
      _arrayPrependUnrolling( dstArray, srcArray[ a ] );
    }
    else
    {
      dstArray.unshift( srcArray[ a ] );
    }
  }

  return dstArray;
}

//

function arrayPrependUnrolling( dstArray )
{
  _.assert( arguments.length >= 1 );
  _.assert( _.arrayIs( dstArray ) || dstArray === null, 'expects array' );

  dstArray = dstArray || [];

  _._arrayPrependUnrolling( dstArray, _.longSlice( arguments, 1 ) );

  return dstArray;
}

//

function arrayPrepend_( dstArray )
{
  _.assert( arguments.length >= 1 );
  _.assert( _.arrayIs( dstArray ) || dstArray === null, 'expects array' );

  dstArray = dstArray || [];

  for( var a = arguments.length - 1 ; a >= 1 ; a-- )
  {
    if( _.longIs( arguments[ a ] ) )
    {
      dstArray.unshift.apply( dstArray, arguments[ a ] );
    }
    else
    {
      dstArray.unshift( arguments[ a ] );
    }
  }

  return dstArray;
}

//

/**
 * Routine adds a value of argument( ins ) to the beginning of an array( dstArray ).
 *
 * @param { Array } dstArray - The destination array.
 * @param { * } ins - The element to add.
 *
 * @example
 * // returns [ 5, 1, 2, 3, 4 ]
 * _.arrayPrependElement( [ 1, 2, 3, 4 ], 5 );
 *
 * @example
 * // returns [ 5, 1, 2, 3, 4, 5 ]
 * _.arrayPrependElement( [ 1, 2, 3, 4, 5 ], 5 );
 *
 * @returns { Array } Returns updated array, that contains new element( ins ).
 * @function arrayPrependElement
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( arguments.length ) is less or more than two.
 * @memberof wTools
 */

function arrayPrependElement( dstArray, ins )
{
  arrayPrependedElement.apply( this,arguments );
  return dstArray;
}

//

/**
 * Method adds a value of argument( ins ) to the beginning of an array( dstArray )
 * if destination( dstArray ) doesn't have the value of ( ins ).
 * Additionaly takes callback( onEqualize ) that checks if element from( dstArray ) is equal to( ins ).
 *
 * @param { Array } dstArray - The destination array.
 * @param { * } ins - The value to add.
 * @param { wTools~compareCallback } onEqualize - A callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns [ 5, 1, 2, 3, 4 ]
 * _.arrayPrependOnce( [ 1, 2, 3, 4 ], 5 );
 *
 * @example
 * // returns [ 1, 2, 3, 4, 5 ]
 * _.arrayPrependOnce( [ 1, 2, 3, 4, 5 ], 5 );
 *
 * @example
 * // returns [ 'Dmitry', 'Petre', 'Mikle', 'Oleg' ]
 * _.arrayPrependOnce( [ 'Petre', 'Mikle', 'Oleg' ], 'Dmitry' );
 *
 * @example
 * // returns [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ]
 * _.arrayPrependOnce( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], 'Dmitry' );
 *
 * @example
 * function onEqualize( a, b )
 * {
 *  return a.value === b.value;
 * };
 * _.arrayPrependOnce( [ { value : 1 }, { value : 2 } ], { value : 1 }, onEqualize );
 * // returns [ { value : 1 }, { value : 2 } ]
 *
 * @returns { Array } If an array ( dstArray ) doesn't have a value ( ins ) it returns the updated array ( dstArray ) with the new length,
 * otherwise, it returns the original array ( dstArray ).
 * @function arrayPrependOnce
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( onEqualize ) is not an Function.
 * @throws { Error } An Error if ( arguments.length ) is not equal two or three.
 * @memberof wTools
 */

function arrayPrependOnce( dstArray, ins, evaluator1, evaluator2 )
{
  arrayPrependedOnce.apply( this,arguments );
  return dstArray;
}

//

/**
 * Method adds a value of argument( ins ) to the beginning of an array( dstArray )
 * if destination( dstArray ) doesn't have the value of ( ins ).
 * Additionaly takes callback( onEqualize ) that checks if element from( dstArray ) is equal to( ins ).
 * Returns updated array( dstArray ) if( ins ) was added, otherwise throws an Error.
 *
 * @param { Array } dstArray - The destination array.
 * @param { * } ins - The value to add.
 * @param { wTools~compareCallback } onEqualize - A callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns [ 5, 1, 2, 3, 4 ]
 * _.arrayPrependOnceStrictly( [ 1, 2, 3, 4 ], 5 );
 *
 * @example
 * // throws error
 * _.arrayPrependOnceStrictly( [ 1, 2, 3, 4, 5 ], 5 );
 *
 * @example
 * // returns [ 'Dmitry', 'Petre', 'Mikle', 'Oleg' ]
 * _.arrayPrependOnceStrictly( [ 'Petre', 'Mikle', 'Oleg' ], 'Dmitry' );
 *
 * @example
 * // throws error
 * _.arrayPrependOnceStrictly( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], 'Dmitry' );
 *
 * @example
 * function onEqualize( a, b )
 * {
 *  return a.value === b.value;
 * };
 * _.arrayPrependOnceStrictly( [ { value : 1 }, { value : 2 } ], { value : 0 }, onEqualize );
 * // returns [ { value : 0 }, { value : 1 }, { value : 2 } ]
 *
 * @returns { Array } If an array ( dstArray ) doesn't have a value ( ins ) it returns the updated array ( dstArray ) with the new length,
 * otherwise, it throws an Error.
 * @function arrayPrependOnceStrictly
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( onEqualize ) is not an Function.
 * @throws { Error } An Error if ( arguments.length ) is not equal two or three.
 * @throws { Error } An Error if ( ins ) already exists on( dstArray ).
 * @memberof wTools
 */

function arrayPrependOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
{

  var result = arrayPrependedOnce.apply( this, arguments );
  _.assert( result >= 0,'array should have only unique elements, but has several',ins );

  return dstArray;
}

//

/**
 * Method adds a value of argument( ins ) to the beginning of an array( dstArray )
 * and returns zero if value was succesfully added.
 *
 * @param { Array } dstArray - The destination array.
 * @param { * } ins - The element to add.
 *
 * @example
 * // returns 0
 * _.arrayPrependedElement( [ 1, 2, 3, 4 ], 5 );
 *
 * @returns { Array } Returns updated array, that contains new element( ins ).
 * @function arrayPrependedElement
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( arguments.length ) is not equal to two.
 * @memberof wTools
 */

function arrayPrependedElement( dstArray, ins )
{
  _.assert( arguments.length === 2  );
  _.assert( _.arrayIs( dstArray ) );

  dstArray.unshift( ins );
  return 0;
}

//

/**
 * Method adds a value of argument( ins ) to the beginning of an array( dstArray )
 * if destination( dstArray ) doesn't have the value of ( ins ).
 * Additionaly takes callback( onEqualize ) that checks if element from( dstArray ) is equal to( ins ).
 *
 * @param { Array } dstArray - The destination array.
 * @param { * } ins - The value to add.
 * @param { wTools~compareCallback } onEqualize - A callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns 0
 * _.arrayPrependedOnce( [ 1, 2, 3, 4 ], 5 );
 *
 * @example
 * // returns -1
 * _.arrayPrependedOnce( [ 1, 2, 3, 4, 5 ], 5 );
 *
 * @example
 * // returns 0
 * _.arrayPrependedOnce( [ 'Petre', 'Mikle', 'Oleg' ], 'Dmitry' );
 *
 * @example
 * // returns -1
 * _.arrayPrependedOnce( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], 'Dmitry' );
 *
 * @example
 * function onEqualize( a, b )
 * {
 *  return a.value === b.value;
 * };
 * _.arrayPrependedOnce( [ { value : 1 }, { value : 2 } ], { value : 1 }, onEqualize );
 * // returns -1
 *
 * @returns { Array } Returns zero if elements was succesfully added, otherwise returns -1.
 *
 * @function arrayPrependedOnce
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( onEqualize ) is not an Function.
 * @throws { Error } An Error if ( arguments.length ) is not equal two or three.
 * @memberof wTools
 */

function arrayPrependedOnce( dstArray, ins, evaluator1, evaluator2 )
{
  _.assert( _.arrayIs( dstArray ) );

  var i = _.arrayLeftIndex.apply( _, arguments );

  if( i === -1 )
  {
    dstArray.unshift( ins );
    return 0;
  }
  return -1;
}

//

/**
 * Method adds all elements from array( insArray ) to the beginning of an array( dstArray ).
 *
 * @param { Array } dstArray - The destination array.
 * @param { ArrayLike } insArray - The source array.
 *
 * @example
 * // returns [ 5, 1, 2, 3, 4 ]
 * _.arrayPrependArray( [ 1, 2, 3, 4 ], [ 5 ] );
 *
 * @example
 * // returns [ 5, 1, 2, 3, 4, 5 ]
 * _.arrayPrependArray( [ 1, 2, 3, 4, 5 ], [ 5 ] );
 *
 * @returns { Array } Returns updated array, that contains elements from( insArray ).
 * @function arrayPrependArray
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( insArray ) is not an ArrayLike entity.
 * @throws { Error } An Error if ( arguments.length ) is less or more than two.
 * @memberof wTools
 */

function arrayPrependArray( dstArray, insArray )
{
  arrayPrependedArray.apply( this, arguments );
  return dstArray;
}

//

/**
 * Method adds all unique elements from array( insArray ) to the beginning of an array( dstArray )
 * Additionaly takes callback( onEqualize ) that checks if element from( dstArray ) is equal to( ins ).
 *
 * @param { Array } dstArray - The destination array.
 * @param { ArrayLike } insArray - The source array.
 * @param { wTools~compareCallback } onEqualize - A callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns [ 0, 1, 2, 3, 4 ]
 * _.arrayPrependArrayOnce( [ 1, 2, 3, 4 ], [ 0, 1, 2, 3, 4 ] );
 *
 * @example
 * // returns [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ]
 * _.arrayPrependArrayOnce( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], [ 'Dmitry' ] );
 *
 * @example
 * function onEqualize( a, b )
 * {
 *  return a.value === b.value;
 * };
 * _.arrayPrependArrayOnce( [ { value : 1 }, { value : 2 } ], [ { value : 1 } ], onEqualize );
 * // returns [ { value : 1 }, { value : 2 } ]
 *
 * @returns { Array } Returns updated array( dstArray ) or original if nothing added.
 * @function arrayPrependArrayOnce
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( insArray ) is not an ArrayLike entity.
 * @throws { Error } An Error if ( onEqualize ) is not an Function.
 * @throws { Error } An Error if ( arguments.length ) is not equal two or three.
 * @memberof wTools
 */

function arrayPrependArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  arrayPrependedArrayOnce.apply( this, arguments );
  return dstArray;
}

//

/**
 * Method adds all unique elements from array( insArray ) to the beginning of an array( dstArray )
 * Additionaly takes callback( onEqualize ) that checks if element from( dstArray ) is equal to( ins ).
 * Returns updated array( dstArray ) if all elements from( insArray ) was added, otherwise throws error.
 * Even error was thrown, elements that was prepended to( dstArray ) stays in the destination array.
 *
 * @param { Array } dstArray - The destination array.
 * @param { ArrayLike } insArray - The source array.
 * @param { wTools~compareCallback } onEqualize - A callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns [ 0, 1, 2, 3, 4 ]
 * _.arrayPrependArrayOnceStrictly( [ 1, 2, 3, 4 ], [ 0, 1, 2, 3, 4 ] );
 *
 * @example
 * function onEqualize( a, b )
 * {
 *  return a.value === b.value;
 * };
 * _.arrayPrependArrayOnceStrictly( [ { value : 1 }, { value : 2 } ], { value : 1 }, onEqualize );
 * // returns [ { value : 1 }, { value : 2 } ]
 *
 * * @example
 * var dst = [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ];
 * _.arrayPrependArrayOnceStrictly( dst, [ 'Antony', 'Dmitry' ] );
 * // throws error, but dstArray was updated by one element from insArray
 *
 * @returns { Array } Returns updated array( dstArray ) or throws an error if not all elements from source
 * array( insArray ) was added.
 * @function arrayPrependArrayOnceStrictly
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( insArray ) is not an ArrayLike entity.
 * @throws { Error } An Error if ( onEqualize ) is not an Function.
 * @throws { Error } An Error if ( arguments.length ) is not equal two or three.
 * @memberof wTools
 */

function arrayPrependArrayOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  var result = arrayPrependedArrayOnce.apply( this, arguments );
  _.assert( result === insArray.length );
  return dstArray;
}

//

/**
 * Method adds all elements from array( insArray ) to the beginning of an array( dstArray ).
 * Returns count of added elements.
 *
 * @param { Array } dstArray - The destination array.
 * @param { ArrayLike } insArray - The source array.
 *
 * @example
 * var dst = [ 1, 2, 3, 4 ];
 * _.arrayPrependedArray( dst, [ 5, 6, 7 ] );
 * // returns 3
 * console.log( dst );
 * //returns [ 5, 6, 7, 1, 2, 3, 4 ]
 *
 * @returns { Array } Returns count of added elements.
 * @function arrayPrependedArray
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( insArray ) is not an ArrayLike entity.
 * @throws { Error } An Error if ( arguments.length ) is less or more than two.
 * @memberof wTools
 */

function arrayPrependedArray( dstArray, insArray )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.arrayIs( dstArray ),'arrayPrependedArray :','expects array' );
  _.assert( _.longIs( insArray ),'arrayPrependedArray :','expects longIs' );

  dstArray.unshift.apply( dstArray,insArray );
  return insArray.length;
}

//

/**
 * Method adds all unique elements from array( insArray ) to the beginning of an array( dstArray )
 * Additionaly takes callback( onEqualize ) that checks if element from( dstArray ) is equal to( ins ).
 * Returns count of added elements.
 *
 * @param { Array } dstArray - The destination array.
 * @param { ArrayLike } insArray - The source array.
 * @param { wTools~compareCallback } onEqualize - A callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns 3
 * _.arrayPrependedArrayOnce( [ 1, 2, 3 ], [ 4, 5, 6] );
 *
 * @example
 * // returns 1
 * _.arrayPrependedArrayOnce( [ 0, 2, 3, 4 ], [ 1, 1, 1 ] );
 *
 * @example
 * // returns 0
 * _.arrayPrependedArrayOnce( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], [ 'Dmitry' ] );
 *
 * @example
 * function onEqualize( a, b )
 * {
 *  return a.value === b.value;
 * };
 * _.arrayPrependedArrayOnce( [ { value : 1 }, { value : 2 } ], [ { value : 1 } ], onEqualize );
 * // returns 0
 *
 * @returns { Array } Returns count of added elements.
 * @function arrayPrependedArrayOnce
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if ( insArray ) is not an ArrayLike entity.
 * @throws { Error } An Error if ( onEqualize ) is not an Function.
 * @throws { Error } An Error if ( arguments.length ) is not equal two or three.
 * @memberof wTools
 */

function arrayPrependedArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  _.assert( _.arrayIs( dstArray ) );
  _.assert( _.longIs( insArray ) );
  _.assert( dstArray !== insArray );
  _.assert( 2 <= arguments.length && arguments.length <= 4 );

  var result = 0;

  for( var i = insArray.length - 1; i >= 0; i-- )
  {
    if( _.arrayLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 ) === -1 )
    {
      dstArray.unshift( insArray[ i ] );
      result += 1;
    }
  }

  return result;
}

//

/**
 * Method adds all elements from provided arrays to the beginning of an array( dstArray ) in same order
 * that they are in( arguments ).
 * If argument provided after( dstArray ) is not a ArrayLike entity it will be prepended to destination array as usual element.
 * If argument is an ArrayLike entity and contains inner arrays, routine looks for elements only on first two levels.
 * Example: _.arrayPrependArrays( [], [ [ 1 ], [ [ 2 ] ] ] ) -> [ 1, [ 2 ] ];
 * Throws an error if one of arguments is undefined. Even if error was thrown, elements that was prepended to( dstArray ) stays in the destination array.
 *
 * @param { Array } dstArray - The destination array.
 * @param{ longIs | * } arguments[...] - Source arguments.
 *
 * @example
 * // returns [ 5, 6, 7, 1, 2, 3, 4 ]
 * _.arrayPrependArrays( [ 1, 2, 3, 4 ], [ 5 ], [ 6 ], 7 );
 *
 * @example
 * var dst = [ 1, 2, 3, 4 ];
 * _.arrayPrependArrays( dst, [ 5 ], [ 6 ], undefined );
 * // throws error, but dst becomes equal [ 5, 6, 1, 2, 3, 4 ]
 *
 * @returns { Array } Returns updated array( dstArray ).
 * @function arrayPrependArrays
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if one of ( arguments ) is undefined.
 * @memberof wTools
 */

function arrayPrependArrays( dstArray, insArray )
{
  arrayPrependedArrays.apply( this, arguments );
  return dstArray;
}

//

/**
 * Method adds all unique elements from provided arrays to the beginning of an array( dstArray ) in same order
 * that they are in( arguments ).
 * If argument provided after( dstArray ) is not a ArrayLike entity it will be prepended to destination array as usual element.
 * If argument is an ArrayLike entity and contains inner arrays, routine looks for elements only on first two levels.
 * Example: _.arrayPrependArrays( [], [ [ 1 ], [ [ 2 ] ] ] ) -> [ 1, [ 2 ] ];
 * Throws an error if one of arguments is undefined. Even if error was thrown, elements that was prepended to( dstArray ) stays in the destination array.

 * @param { Array } dstArray - The destination array.
 * @param{ longIs | * } arguments[...] - Source arguments.
 *
 * @example
 * // returns [ 5, 6, 7, 1, 2, 3, 4 ]
 * _.arrayPrependArraysOnce( [ 1, 2, 3, 4 ], [ 5 ], 5, [ 6 ], 6, 7, [ 7 ] );
 *
 * @example
 * var dst = [ 1, 2, 3, 4 ];
 * _.arrayPrependArraysOnce( dst, [ 5 ], 5, [ 6 ], 6, undefined );
 * // throws error, but dst becomes equal [ 5, 6, 1, 2, 3, 4 ]
 *
 * @returns { Array } Returns updated array( dstArray ).
 * @function arrayPrependArraysOnce
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if one of ( arguments ) is undefined.
 * @memberof wTools
 */

function arrayPrependArraysOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  arrayPrependedArraysOnce.apply( this, arguments );
  return dstArray;
}

//

/**
 * Method adds all unique elements from provided arrays to the beginning of an array( dstArray ) in same order
 * that they are in( arguments ).
 * Throws an error if one of arguments is undefined.
 * If argument provided after( dstArray ) is not a ArrayLike entity it will be prepended to destination array as usual element.
 * If argument is an ArrayLike entity and contains inner arrays, routine looks for elements only on first two levels.
 * Example: _.arrayPrependArraysOnce( [], [ [ 1 ], [ [ 2 ] ] ] ) -> [ 1, [ 2 ] ];
 * After copying checks if all elements( from first two levels ) was copied, if true returns updated array( dstArray ), otherwise throws an error.
 * Even if error was thrown, elements that was prepended to( dstArray ) stays in the destination array.

 * @param { Array } dstArray - The destination array.
 * @param { longIs | * } arguments[...] - Source arguments.
 * @param { wTools~compareCallback } onEqualize - A callback function that can be provided through routine`s context. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns [ 5, 6, 7, 8, 1, 2, 3, 4 ]
 * _.arrayPrependArraysOnceStrictly( [ 1, 2, 3, 4 ], 5, [ 6, [ 7 ] ], 8 );
 *
 * @example
 * // throws error
 * _.arrayPrependArraysOnceStrictly( [ 1, 2, 3, 4 ], [ 5 ], 5, [ 6 ], 6, 7, [ 7 ] );
 *
 * @example
 * function onEqualize( a, b )
 * {
 *  return a === b;
 * };
 * var dst = [];
 * var arguments = [ dst, [ 1, [ 2 ], [ [ 3 ] ] ], 4 ];
 * _.arrayPrependArraysOnceStrictly.apply( { onEqualize : onEqualize }, arguments );
 * //returns [ 1, 2, [ 3 ], 4 ]
 *
 * @returns { Array } Returns updated array( dstArray ).
 * @function arrayPrependArraysOnceStrictly
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @throws { Error } An Error if one of ( arguments ) is undefined.
 * @throws { Error } An Error if count of added elements is not equal to count of elements from( arguments )( only first two levels inside of array are counted ).
 * @memberof wTools
 */

function arrayPrependArraysOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  var result = arrayPrependedArraysOnce.apply( this, arguments );
  var expected = 0;

  if( Config.debug )
  {

    for( var i = insArray.length - 1; i >= 0; i-- )
    {
      if( _.longIs( insArray[ i ] ) )
      expected += insArray[ i ].length;
      else
      expected += 1;
    }

    _.assert( result === expected, '{-dstArray-} should have none element from {-insArray-}' );

  }

  return dstArray;
}

//

/**
 * Method adds all elements from provided arrays to the beginning of an array( dstArray ) in same order
 * that they are in( arguments ).
 * If argument provided after( dstArray ) is not a ArrayLike entity it will be prepended to destination array as usual element.
 * If argument is an ArrayLike entity and contains inner arrays, routine looks for elements only on first two levels.
 * Example: _.arrayPrependArrays( [], [ [ 1 ], [ [ 2 ] ] ] ) -> [ 1, [ 2 ] ];
 * Throws an error if one of arguments is undefined. Even if error was thrown, elements that was prepended to( dstArray ) stays in the destination array.
 *
 * @param { Array } dstArray - The destination array.
 * @param{ longIs | * } arguments[...] - Source arguments.
 *
 * @example
 * // returns 3
 * _.arrayPrependedArrays( [ 1, 2, 3, 4 ], [ 5 ], [ 6 ], 7 );
 *
 * @example
 * var dst = [ 1, 2, 3, 4 ];
 * _.arrayPrependedArrays( dst, [ 5 ], [ 6 ], undefined );
 * // throws error, but dst becomes equal [ 5, 6, 1, 2, 3, 4 ]
 *
 * @returns { Array } Returns count of added elements.
 * @function arrayPrependedArrays
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @memberof wTools
 */

function arrayPrependedArrays( dstArray, insArray )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.arrayIs( dstArray ),'arrayPrependedArrays :','expects array' );
  _.assert( _.longIs( insArray ),'arrayPrependedArrays :','expects longIs entity' );

  var result = 0;

  for( var a = insArray.length - 1 ; a >= 0 ; a-- )
  {
    if( _.longIs( insArray[ a ] ) )
    {
      dstArray.unshift.apply( dstArray, insArray[ a ] );
      result += insArray[ a ].length;
    }
    else
    {
      dstArray.unshift( insArray[ a ] );
      result += 1;
    }
  }

  return result;
}

//

/**
 * Method adds all unique elements from provided arrays to the beginning of an array( dstArray ) in same order
 * that they are in( arguments ).
 * If argument provided after( dstArray ) is not a ArrayLike entity it will be prepended to destination array as usual element.
 * If argument is an ArrayLike entity and contains inner arrays, routine looks for elements only on first two levels.
 * Example: _.arrayPrependArrays( [], [ [ 1 ], [ [ 2 ] ] ] ) -> [ 1, [ 2 ] ];
 * Throws an error if one of arguments is undefined. Even if error was thrown, elements that was prepended to( dstArray ) stays in the destination array.
 *
 * @param { Array } dstArray - The destination array.
 * @param{ longIs | * } arguments[...] - Source arguments.
 *
 * @example
 * // returns 0
 * _.arrayPrependedArraysOnce( [ 1, 2, 3, 4, 5, 6, 7 ], [ 5 ], [ 6 ], 7 );
 *
 * @example
 * // returns 3
 * _.arrayPrependedArraysOnce( [ 1, 2, 3, 4 ], [ 5 ], 5, [ 6 ], 6, 7, [ 7 ] );
 *
 * @example
 * var dst = [ 1, 2, 3, 4 ];
 * _.arrayPrependedArraysOnce( dst, [ 5 ], [ 6 ], undefined );
 * // throws error, but dst becomes equal [ 5, 6, 1, 2, 3, 4 ]
 *
 * @returns { Array } Returns count of added elements.
 * @function arrayPrependedArraysOnce
 * @throws { Error } An Error if ( dstArray ) is not an Array.
 * @memberof wTools
 */

function arrayPrependedArraysOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ),'arrayPrependedArraysOnce :','expects array' );
  _.assert( _.longIs( insArray ),'arrayPrependedArraysOnce :','expects longIs entity' );

  var result = 0;

  function _prependOnce( element )
  {
    var index = _.arrayLeftIndex( dstArray, element, evaluator1, evaluator2 );
    if( index === -1 )
    {
      // dstArray.unshift( argument );
      dstArray.splice( result, 0, element );
      result += 1;
    }
  }

  // for( var ii = insArray.length - 1; ii >= 0; ii-- )
  for( var ii = 0 ; ii < insArray.length ; ii++ )
  {
    if( _.longIs( insArray[ ii ] ) )
    {
      var array = insArray[ ii ];
      // for( var a = array.length - 1; a >= 0; a-- )
      for( var a = 0 ; a < array.length ; a++ )
      _prependOnce( array[ a ] );
    }
    else
    {
      _prependOnce( insArray[ ii ] );
    }
  }

  return result;
}

// --
// array append
// --

function _arrayAppendUnrolling( dstArray, srcArray )
{
  _.assert( arguments.length === 2 );
  _.assert( _.arrayIs( dstArray ), 'expects array' );

  for( var a = 0, len = srcArray.length ; a < len; a++ )
  {
    if( _.unrollIs( srcArray[ a ] ) )
    {
      _arrayAppendUnrolling( dstArray, srcArray[ a ] );
    }
    else
    {
      dstArray.push( srcArray[ a ] );
    }
  }

  return dstArray;
}

//

function arrayAppendUnrolling( dstArray )
{
  _.assert( arguments.length >= 1 );
  _.assert( _.arrayIs( dstArray ) || dstArray === null, 'expects array' );

  dstArray = dstArray || [];

  _._arrayAppendUnrolling( dstArray, _.longSlice( arguments, 1 ) );

  return dstArray;
}

//

function arrayAppend_( dstArray )
{
  _.assert( arguments.length >= 1 );
  _.assert( _.arrayIs( dstArray ) || dstArray === null, 'expects array' );

  dstArray = dstArray || [];

  for( var a = 1, len = arguments.length ; a < len; a++ )
  {
    if( _.longIs( arguments[ a ] ) )
    {
      dstArray.push.apply( dstArray, arguments[ a ] );
    }
    else
    {
      dstArray.push( arguments[ a ] );
    }
  }

  return dstArray;
}

//

function arrayAppendElement( dstArray, ins )
{
  arrayAppendedElement.apply( this, arguments );
  return dstArray;
}

//

/**
 * The arrayAppendOnce() routine adds at the end of an array (dst) a value {-srcMap-},
 * if the array (dst) doesn't have the value {-srcMap-}.
 *
 * @param { Array } dst - The source array.
 * @param { * } src - The value to add.
 *
 * @example
 * // returns [ 1, 2, 3, 4, 5 ]
 * _.arrayAppendOnce( [ 1, 2, 3, 4 ], 5 );
 *
 * @example
 * // returns [ 1, 2, 3, 4, 5 ]
 * _.arrayAppendOnce( [ 1, 2, 3, 4, 5 ], 5 );
 *
 * @example
 * // returns [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ]
 * _.arrayAppendOnce( [ 'Petre', 'Mikle', 'Oleg' ], 'Dmitry' );
 *
 * @example
 * // returns [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ]
 * _.arrayAppendOnce( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], 'Dmitry' );
 *
 * @returns { Array } If an array (dst) doesn't have a value {-srcMap-} it returns the updated array (dst) with the new length,
 * otherwise, it returns the original array (dst).
 * @function arrayAppendOnce
 * @throws { Error } Will throw an Error if (dst) is not an Array.
 * @throws { Error } Will throw an Error if (arguments.length) is less or more than two.
 * @memberof wTools
 */

function arrayAppendOnce( dstArray, ins, evaluator1, evaluator2 )
{
  arrayAppendedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayAppendOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
{

  var result = arrayAppendedOnce.apply( this, arguments );
  _.assert( result >= 0,'array should have only unique elements, but has several', ins );
  return dstArray;
}

//

function arrayAppendedElement( dstArray, ins )
{
  _.assert( arguments.length === 2  );
  _.assert( _.arrayIs( dstArray ) );
  dstArray.push( ins );
  return dstArray.length - 1;
}

//

function arrayAppendedOnce( dstArray, ins, evaluator1, evaluator2 )
{
  var i = _.arrayLeftIndex.apply( _, arguments );

  if( i === -1 )
  {
    dstArray.push( ins );
    return dstArray.length - 1;
  }

  return -1;
}

//

/**
 * The arrayAppendArrayOnce() routine returns an array of elements from (dst)
 * and appending only unique following arguments to the end.
 *
 * It creates two variables the (result) - array and the (argument) - elements of array-like object (arguments[]),
 * iterate over array-like object (arguments[]) and assigns to the (argument) each element,
 * checks, if (argument) is equal to the 'undefined'.
 * If true, it throws an Error.
 * if (argument) is an array-like.
 * If true, it iterate over array (argument) and checks if (result) has the same values as the (argument).
 * If false, it adds elements of (argument) to the end of the (result) array.
 * Otherwise, it checks if (result) has not the same values as the (argument).
 * If true, it adds elements to the end of the (result) array.
 *
 * @param { Array } dst - Initial array.
 * @param {*} arguments[] - One or more argument(s).
 *
 * @example
 * // returns [ 1, 2, 'str', {}, 5 ]
 * var arr = _.arrayAppendArrayOnce( [ 1, 2 ], 'str', 2, {}, [ 'str', 5 ] );
 *
 * @returns { Array } - Returns an array (dst) with only unique following argument(s) that were added to the end of the (dst) array.
 * @function arrayAppendArrayOnce
 * @throws { Error } If the first argument is not array.
 * @throws { Error } If type of the argument is equal undefined.
 * @memberof wTools
 */

function arrayAppendArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  arrayAppendedArrayOnce.apply( this,arguments )
  return dstArray;
}

//

function arrayAppendArrayOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  var result = arrayAppendedArrayOnce.apply( this,arguments )
  _.assert( result === insArray.length );
  return dstArray;
}

//

function arrayAppendedArray( dstArray, insArray )
{
  _.assert( arguments.length === 2 )
  _.assert( _.arrayIs( dstArray ),'arrayPrependedArray :','expects array' );
  _.assert( _.longIs( insArray ),'arrayPrependedArray :','expects longIs' );

  dstArray.push.apply( dstArray,insArray );
  return insArray.length;
}

//

function arrayAppendedArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  _.assert( _.longIs( insArray ) );
  _.assert( dstArray !== insArray );
  _.assert( 2 <= arguments.length && arguments.length <= 4 );

  var result = 0;

  for( var i = 0 ; i < insArray.length ; i++ )
  {
    if( _.arrayLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 ) === -1 )
    {
      dstArray.push( insArray[ i ] );
      result += 1;
    }
  }

  return result;
}

//

/**
 * The arrayAppendArray() routine adds one or more elements to the end of the (dst) array
 * and returns the new length of the array.
 *
 * It creates two variables the (result) - array and the (argument) - elements of array-like object (arguments[]),
 * iterate over array-like object (arguments[]) and assigns to the (argument) each element,
 * checks, if (argument) is equal to the 'undefined'.
 * If true, it throws an Error.
 * If (argument) is an array-like.
 * If true, it merges the (argument) into the (result) array.
 * Otherwise, it adds element to the result.
 *
 * @param { Array } dst - Initial array.
 * @param {*} arguments[] - One or more argument(s) to add to the end of the (dst) array.
 *
 * @example
 * // returns [ 1, 2, 'str', false, { a : 1 }, 42, 3, 7, 13 ];
 * var arr = _.arrayAppendArray( [ 1, 2 ], 'str', false, { a : 1 }, 42, [ 3, 7, 13 ] );
 *
 * @returns { Array } - Returns an array (dst) with all of the following argument(s) that were added to the end of the (dst) array.
 * @function arrayAppendArray
 * @throws { Error } If the first argument is not an array.
 * @throws { Error } If type of the argument is equal undefined.
 * @memberof wTools
 */

function arrayAppendArray( dstArray, insArray )
{
  arrayAppendedArray.apply( this, arguments );
  return dstArray;
}

//

function arrayAppendArrays( dstArray )
{
  arrayAppendedArrays.apply( this, arguments );
  return dstArray;
}

//

function arrayAppendArraysOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  arrayAppendedArraysOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayAppendArraysOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  var result = arrayAppendedArraysOnce.apply( this, arguments );

  if( Config.debug )
  {

    var expected = 0;
    for( var i = insArray.length - 1; i >= 0; i-- )
    {
      if( _.longIs( insArray[ i ] ) )
      expected += insArray[ i ].length;
      else
      expected += 1;
    }

    _.assert( result === expected, '{-dstArray-} should have none element from {-insArray-}' );

  }

  return dstArray;
}

//

function arrayAppendedArrays( dstArray, insArray )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.arrayIs( dstArray ), 'expects array' );
  _.assert( _.longIs( insArray ), 'expects longIs entity' );

  var result = 0;

  for( var a = 0, len = insArray.length; a < len; a++ )
  {
    if( _.longIs( insArray[ a ] ) )
    {
      dstArray.push.apply( dstArray, insArray[ a ] );
      result += insArray[ a ].length;
    }
    else
    {
      dstArray.push( insArray[ a ] );
      result += 1;
    }
  }

  return result;
}

//

function arrayAppendedArraysOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ),'arrayAppendedArraysOnce :','expects array' );
  _.assert( _.longIs( insArray ),'arrayAppendedArraysOnce :','expects longIs entity' );

  var result = 0;

  function _appendOnce( argument )
  {
    var index = _.arrayLeftIndex( dstArray, argument, evaluator1, evaluator2 );
    if( index === -1 )
    {
      dstArray.push( argument );
      result += 1;
    }
  }

  for( var a = 0, len = insArray.length; a < len; a++ )
  {
    if( _.longIs( insArray[ a ] ) )
    {
      var array = insArray[ a ];
      for( var i = 0, alen = array.length; i < alen; i++ )
      _appendOnce( array[ i ] );
    }
    else
    {
      _appendOnce( insArray[ a ] );
    }
  }

  return result;
}

// --
// array remove
// --

function arrayRemove( dstArray, ins, evaluator1, evaluator2 )
{
  arrayRemoved.apply( this, arguments );
  return dstArray;
}

//

/**
 * The arrayRemoveOnce() routine removes the first matching element from (dstArray)
 * that corresponds to the condition in the callback function and returns a modified array.
 *
 * It takes two (dstArray, ins) or three (dstArray, ins, onEvaluate) arguments,
 * checks if arguments passed two, it calls the routine
 * [arrayRemovedOnce( dstArray, ins )]{@link wTools.arrayRemovedOnce}
 * Otherwise, if passed three arguments, it calls the routine
 * [arrayRemovedOnce( dstArray, ins, onEvaluate )]{@link wTools.arrayRemovedOnce}
 * @see  wTools.arrayRemovedOnce
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to remove.
 * @param { wTools~compareCallback } [ onEvaluate ] - The callback that compares (ins) with elements of the array.
 * By default, it checks the equality of two arguments.
 *
 * @example
 * // returns [ 1, 2, 3, 'str' ]
 * var arr = _.arrayRemoveOnce( [ 1, 'str', 2, 3, 'str' ], 'str' );
 *
 * @example
 * // returns [ 3, 7, 13, 33 ]
 * var arr = _.arrayRemoveOnce( [ 3, 7, 33, 13, 33 ], 13, function( el, ins ) {
 *   return el > ins;
 * });
 *
 * @returns { Array } - Returns the modified (dstArray) array with the new length.
 * @function arrayRemoveOnce
 * @throws { Error } If the first argument is not an array.
 * @throws { Error } If passed less than two or more than three arguments.
 * @throws { Error } If the third argument is not a function.
 * @memberof wTools
 */

function arrayRemoveOnce( dstArray, ins, evaluator1, evaluator2 )
{
  arrayRemovedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
{
  var result = arrayRemovedOnce.apply( this, arguments );
  _.assert( result >= 0, () => 'Array does not have element ' + _.toStrShort( ins ) );
  return dstArray;
}

//

function arrayRemoved( dstArray, ins, evaluator1, evaluator2 )
{
  var index = _.arrayLeftIndex.apply( _, arguments );

  /* qqq : this is not correct! */

  if( index !== -1 )
  {
    dstArray.splice( index,1 );
  }

  return index;
}

//

/**
 * The callback function to compare two values.
 *
 * @callback wTools~compareCallback
 * @param { * } el - The element of the array.
 * @param { * } ins - The value to compare.
 */

/**
 * The arrayRemovedOnce() routine returns the index of the first matching element from (dstArray)
 * that corresponds to the condition in the callback function and remove this element.
 *
 * It takes two (dstArray, ins) or three (dstArray, ins, onEvaluate) arguments,
 * checks if arguments passed two, it calls built in function(dstArray.indexOf(ins))
 * that looking for the value of the (ins) in the (dstArray).
 * If true, it removes the value (ins) from (dstArray) array by corresponding index.
 * Otherwise, if passed three arguments, it calls the routine
 * [arrayLeftIndex( dstArray, ins, onEvaluate )]{@link wTools.arrayLeftIndex}
 * If callback function(onEvaluate) returns true, it returns the index that will be removed from (dstArray).
 * @see {@link wTools.arrayLeftIndex} - See for more information.
 *
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to remove.
 * @param { wTools~compareCallback } [ onEvaluate ] - The callback that compares (ins) with elements of the array.
 * By default, it checks the equality of two arguments.
 *
 * @example
 * // returns 1
 * var arr = _.arrayRemovedOnce( [ 2, 4, 6 ], 4, function( el ) {
 *   return el;
 * });
 *
 * @example
 * // returns 0
 * var arr = _.arrayRemovedOnce( [ 2, 4, 6 ], 2 );
 *
 * @returns { Number } - Returns the index of the value (ins) that was removed from (dstArray).
 * @function arrayRemovedOnce
 * @throws { Error } If the first argument is not an array-like.
 * @throws { Error } If passed less than two or more than three arguments.
 * @throws { Error } If the third argument is not a function.
 * @memberof wTools
 */

function arrayRemovedOnce( dstArray, ins, evaluator1, evaluator2 )
{

  var index = _.arrayLeftIndex.apply( _, arguments );
  if( index >= 0 )
  dstArray.splice( index, 1 );

  return index;
}

//

function arrayRemovedOnceStrictly( dstArray, ins, evaluator1, evaluator2 )
{
  var result = arrayRemovedOnce.apply( this, arguments );
  _.assert( result >= 0, () => 'Array does not have element ' + _.toStrShort( ins ) );
  return dstArray;
}

//

function arrayRemovedOnceElement( dstArray, ins, evaluator1, evaluator2 )
{

  var result;
  var index = _.arrayLeftIndex.apply( _, arguments );
  if( index >= 0 )
  {
    result = dstArray[ index ];
    dstArray.splice( index, 1 );
  }

  return result;
}

//

function arrayRemovedOnceElementStrictly( dstArray, ins, evaluator1, evaluator2 )
{

  var result;
  var index = _.arrayLeftIndex.apply( _, arguments );
  if( index >= 0 )
  {
    result = dstArray[ index ];
    dstArray.splice( index, 1 );
  }
  else _.assert( 0, () => 'Array does not have element ' + _.toStrShort( ins ) );

  return result;
}
//

function arrayRemoveArray( dstArray, insArray )
{
  arrayRemovedArray.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  arrayRemovedArrayOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArrayOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  var result = arrayRemovedArrayOnce.apply( this, arguments );
  _.assert( result === insArray.length );
  return dstArray;
}

//

function arrayRemovedArray( dstArray, insArray )
{
  _.assert( arguments.length === 2 )
  _.assert( _.arrayIs( dstArray ) );
  _.assert( _.longIs( insArray ) );
  _.assert( dstArray !== insArray );

  var result = 0;
  var index = -1;

  for( var i = 0, len = insArray.length; i < len ; i++ )
  {
    index = dstArray.indexOf( insArray[ i ] );
    while( index !== -1 )
    {
      dstArray.splice( index,1 );
      result += 1;
      index = dstArray.indexOf( insArray[ i ], index );
    }
  }

  return result;
}

//

/**
 * The callback function to compare two values.
 *
 * @callback arrayRemovedArrayOnce~onEvaluate
 * @param { * } el - The element of the (dstArray[n]) array.
 * @param { * } ins - The value to compare (insArray[n]).
 */

/**
 * The arrayRemovedArrayOnce() determines whether a (dstArray) array has the same values as in a (insArray) array,
 * and returns amount of the deleted elements from the (dstArray).
 *
 * It takes two (dstArray, insArray) or three (dstArray, insArray, onEqualize) arguments, creates variable (var result = 0),
 * checks if (arguments[..]) passed two, it iterates over the (insArray) array and calls for each element built in function(dstArray.indexOf(insArray[i])).
 * that looking for the value of the (insArray[i]) array in the (dstArray) array.
 * If true, it removes the value (insArray[i]) from (dstArray) array by corresponding index,
 * and incrementing the variable (result++).
 * Otherwise, if passed three (arguments[...]), it iterates over the (insArray) and calls for each element the routine
 *
 * If callback function(onEqualize) returns true, it returns the index that will be removed from (dstArray),
 * and then incrementing the variable (result++).
 *
 * @see wTools.arrayLeftIndex
 *
 * @param { longIs } dstArray - The target array.
 * @param { longIs } insArray - The source array.
 * @param { function } onEqualize - The callback function. By default, it checks the equality of two arguments.
 *
 * @example
 * // returns 0
 * _.arrayRemovedArrayOnce( [  ], [  ] );
 *
 * @example
 * // returns 2
 * _.arrayRemovedArrayOnce( [ 1, 2, 3, 4, 5 ], [ 6, 2, 7, 5, 8 ] );
 *
 * @example
 * // returns 4
 * var got = _.arrayRemovedArrayOnce( [ 1, 2, 3, 4, 5 ], [ 6, 2, 7, 5, 8 ], function( a, b ) {
 *   return a < b;
 * } );
 *
 * @returns { number }  Returns amount of the deleted elements from the (dstArray).
 * @function arrayRemovedArrayOnce
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (insArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments.length < 2  || arguments.length > 3).
 * @memberof wTools
 */

function arrayRemovedArrayOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  _.assert( _.arrayIs( dstArray ) );
  _.assert( _.longIs( insArray ) );
  _.assert( dstArray !== insArray );
  _.assert( 2 <= arguments.length && arguments.length <= 4 );

  var result = 0;
  var index = -1;

  for( var i = 0, len = insArray.length; i < len ; i++ )
  {
    index = _.arrayLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 );

    if( index >= 0 )
    {
      dstArray.splice( index,1 );
      result += 1;
    }
  }

  return result;
}

//

function arrayRemoveArrays( dstArray, insArray )
{
  arrayRemovedArrays.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArraysOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  arrayRemovedArraysOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayRemoveArraysOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  var result = arrayRemovedArraysOnce.apply( this, arguments );

  var expected = 0;
  for( var i = insArray.length - 1; i >= 0; i-- )
  {
    if( _.longIs( insArray[ i ] ) )
    expected += insArray[ i ].length;
    else
    expected += 1;
  }

  _.assert( result === expected );

  return dstArray;
}

//

function arrayRemovedArrays( dstArray, insArray )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.arrayIs( dstArray ),'arrayRemovedArrays :','expects array' );
  _.assert( _.longIs( insArray ),'arrayRemovedArrays :','expects longIs entity' );

  var result = 0;

  function _remove( argument )
  {
    var index = dstArray.indexOf( argument );
    while( index !== -1 )
    {
      dstArray.splice( index,1 );
      result += 1;
      index = dstArray.indexOf( argument, index );
    }
  }

  for( var a = insArray.length - 1; a >= 0; a-- )
  {
    if( _.longIs( insArray[ a ] ) )
    {
      var array = insArray[ a ];
      for( var i = array.length - 1; i >= 0; i-- )
      _remove( array[ i ] );
    }
    else
    {
      _remove( insArray[ a ] );
    }
  }

  return result;
}

//

function arrayRemovedArraysOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ),'arrayRemovedArraysOnce :','expects array' );
  _.assert( _.longIs( insArray ),'arrayRemovedArraysOnce :','expects longIs entity' );

  var result = 0;

  function _removeOnce( argument )
  {
    var index = _.arrayLeftIndex( dstArray, argument, evaluator1, evaluator2 );
    if( index >= 0 )
    {
      dstArray.splice( index, 1 );
      result += 1;
    }
  }

  for( var a = insArray.length - 1; a >= 0; a-- )
  {
    if( _.longIs( insArray[ a ] ) )
    {
      var array = insArray[ a ];
      for( var i = array.length - 1; i >= 0; i-- )
      _removeOnce( array[ i ] );
    }
    else
    {
      _removeOnce( insArray[ a ] );
    }
  }

  return result;
}

//

/**
 * Callback for compare two value.
 *
 * @callback arrayRemoveAll~compareCallback
 * @param { * } el - Element of the array.
 * @param { * } ins - Value to compare.
 */

/**
 * The arrayRemoveAll() routine removes all (ins) values from (dstArray)
 * that corresponds to the condition in the callback function and returns the modified array.
 *
 * It takes two (dstArray, ins) or three (dstArray, ins, onEvaluate) arguments,
 * checks if arguments passed two, it calls the routine
 * [arrayRemoved( dstArray, ins )]{@link wTools.arrayRemoved}
 * Otherwise, if passed three arguments, it calls the routine
 * [arrayRemoved( dstArray, ins, onEvaluate )]{@link wTools.arrayRemoved}
 *
 * @see wTools.arrayRemoved
 *
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to remove.
 * @param { wTools~compareCallback } [ onEvaluate ] - The callback that compares (ins) with elements of the array.
 * By default, it checks the equality of two arguments.
 *
 * @example
 * // returns [ 2, 2, 3, 5 ]
 * var arr = _.arrayRemoveAll( [ 1, 2, 2, 3, 5 ], 2, function( el, ins ) {
 *   return el < ins;
 * });
 *
 * @example
 * // returns [ 1, 3, 5 ]
 * var arr = _.arrayRemoveAll( [ 1, 2, 2, 3, 5 ], 2 );
 *
 * @returns { Array } - Returns the modified (dstArray) array with the new length.
 * @function arrayRemoveAll
 * @throws { Error } If the first argument is not an array-like.
 * @throws { Error } If passed less than two or more than three arguments.
 * @throws { Error } If the third argument is not a function.
 * @memberof wTools
 */

function arrayRemoveAll( dstArray, ins, evaluator1, evaluator2 )
{
  arrayRemovedAll.apply( this, arguments );
  return dstArray;
}

//

function arrayRemovedAll( dstArray, ins, evaluator1, evaluator2  )
{
  var index = _.arrayLeftIndex.apply( _, arguments );
  var result = 0;

  while( index >= 0 )
  {
    dstArray.splice( index,1 );
    result += 1;
    index = _.arrayLeftIndex.apply( _, arguments );
  }

  return result;
}

// --
// array flatten
// --

/**
 * The arrayFlatten() routine returns an array that contains all the passed arguments.
 *
 * It creates two variables the (result) - array and the {-srcMap-} - elements of array-like object (arguments[]),
 * iterate over array-like object (arguments[]) and assigns to the {-srcMap-} each element,
 * checks if {-srcMap-} is not equal to the 'undefined'.
 * If true, it adds element to the result.
 * If {-srcMap-} is an Array and if element(s) of the {-srcMap-} is not equal to the 'undefined'.
 * If true, it adds to the (result) each element of the {-srcMap-} array.
 * Otherwise, if {-srcMap-} is an Array and if element(s) of the {-srcMap-} is equal to the 'undefined' it throws an Error.
 *
 * @param {...*} arguments - One or more argument(s).
 *
 * @example
 * // returns [ 'str', {}, 1, 2, 5, true ]
 * var arr = _.arrayFlatten( 'str', {}, [ 1, 2 ], 5, true );
 *
 * @returns { Array } - Returns an array of the passed argument(s).
 * @function arrayFlatten
 * @throws { Error } If (arguments[...]) is an Array and has an 'undefined' element.
 * @memberof wTools
 */

// function arrayFlatten()
// {
//   var result = _.arrayIs( this ) ? this : [];
//
//   for( var a = 0 ; a < arguments.length ; a++ )
//   {
//
//     var src = arguments[ a ];
//
//     if( !_.longIs( src ) )
//     {
//       if( src !== undefined ) result.push( src );
//       continue;
//     }
//
//     for( var s = 0 ; s < src.length ; s++ )
//     {
//       if( _.arrayIs( src[ s ] ) )
//       _.arrayFlatten.call( result,src[ s ] );
//       else if( src[ s ] !== undefined )
//       result.push( src[ s ] );
//       else if( src[ s ] === undefined )
//       throw _.err( 'array should have no undefined' );
//     }
//
//   }
//
//   return result;
// }
//
//

function arrayFlatten( dstArray, insArray )
{
  if( dstArray === null )
  dstArray = [];
  _.arrayFlattened.call( this, dstArray, insArray );
  return dstArray;
}

//

function arrayFlattenOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  arrayFlattenedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayFlattenOnceStrictly( dstArray, insArray, evaluator1, evaluator2 )
{
  var result = arrayFlattenedOnce.apply( this, arguments );

  function _count( arr )
  {
    var expected = 0;
    for( var i = arr.length - 1; i >= 0; i-- )
    {
      if( _.longIs( arr[ i ] ) )
      expected += _count( arr[ i ] );
      else
      expected += 1;
    }
    return expected;
  }

 _.assert( result === _count( insArray ) );

 return dstArray;
}

//

function arrayFlattened( dstArray, insArray )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectIs( this ) );
  _.assert( _.arrayIs( dstArray ) );
  _.assert( _.longIs( insArray ) );

  var result = 0;

  for( var i = 0, len = insArray.length; i < len; i++ )
  {
    if( _.longIs( insArray[ i ] ) )
    {
      var c = _.arrayFlattened( dstArray, insArray[ i ] );
      result += c;
    }
    else
    {
      _.assert( insArray[ i ] !== undefined, 'The array should have no undefined' );
      dstArray.push( insArray[ i ] );
      result += 1;
    }
  }

  return result;
}

//

function arrayFlattenedOnce( dstArray, insArray, evaluator1, evaluator2 )
{
  _.assert( 2 <= arguments.length && arguments.length <= 4 );
  _.assert( _.arrayIs( dstArray ) );
  _.assert( _.longIs( insArray ) );

  var result = 0;

  for( var i = 0, len = insArray.length; i < len; i++ )
  {
    _.assert( insArray[ i ] !== undefined );
    if( _.longIs( insArray[ i ] ) )
    {
      var c = _.arrayFlattenedOnce( dstArray, insArray[ i ], evaluator1, evaluator2 );
      result += c;
    }
    else
    {
      var index = _.arrayLeftIndex( dstArray, insArray[ i ], evaluator1, evaluator2 );
      if( index === -1 )
      {
        dstArray.push( insArray[ i ] );
        result += 1;
      }
    }
  }

  return result;
}

// --
// array replace
// --

/**
 * The arrayReplaceOnce() routine returns the index of the (dstArray) array which will be replaced by (sub),
 * if (dstArray) has the value (ins).
 *
 * It takes three arguments (dstArray, ins, sub), calls built in function(dstArray.indexOf(ins)),
 * that looking for value (ins) in the (dstArray).
 * If true, it replaces (ins) value of (dstArray) by (sub) and returns the index of the (ins).
 * Otherwise, it returns (-1) index.
 *
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to find.
 * @param { * } sub - The value to replace.
 *
 * @example
 * // returns -1
 * _.arrayReplaceOnce( [ 2, 4, 6, 8, 10 ], 12, 14 );
 *
 * @example
 * // returns 1
 * _.arrayReplaceOnce( [ 1, undefined, 3, 4, 5 ], undefined, 2 );
 *
 * @example
 * // returns 3
 * _.arrayReplaceOnce( [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ], 'Dmitry', 'Bob' );
 *
 * @example
 * // returns 4
 * _.arrayReplaceOnce( [ true, true, true, true, false ], false, true );
 *
 * @returns { number }  Returns the index of the (dstArray) array which will be replaced by (sub),
 * if (dstArray) has the value (ins).
 * @function arrayReplaceOnce
 * @throws { Error } Will throw an Error if (dstArray) is not an array.
 * @throws { Error } Will throw an Error if (arguments.length) is less than three.
 * @memberof wTools
 */

function arrayReplaceOnce( dstArray, ins, sub, evaluator1, evaluator2 )
{
  arrayReplacedOnce.apply( this, arguments );
  return dstArray;
}

//

function arrayReplaceOnceStrictly( dstArray, ins, sub, evaluator1, evaluator2 )
{
  var result = arrayReplacedOnce.apply( this, arguments );
  _.assert( result >= 0, () => 'Array does not have element ' + _.toStrShort( ins ) );
  return dstArray;
}

//

function arrayReplacedOnce( dstArray, ins, sub, evaluator1, evaluator2 )
{
  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  var index = -1;

  index = _.arrayLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  if( index >= 0 )
  dstArray.splice( index, 1, sub );

  return index;
}

//

function arrayReplaceArrayOnce( dstArray, ins, sub, evaluator1, evaluator2  )
{
  arrayReplacedArrayOnce.apply( this,arguments );
  return dstArray;
}

//

function arrayReplaceArrayOnceStrictly( dstArray, ins, sub, evaluator1, evaluator2  )
{
  var result = arrayReplacedArrayOnce.apply( this,arguments );
  _.assert( result === ins.length, '{-dstArray-} should have each element of {-insArray-}' );
  _.assert( ins.length === sub.length, '{-subArray-} should have the same length {-insArray-} has' );
  return dstArray;
}

//

function arrayReplacedArrayOnce( dstArray, ins, sub, evaluator1, evaluator2 )
{
  _.assert( _.longIs( ins ) );
  _.assert( _.longIs( sub ) );
  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  var index = -1;
  var result = 0;

  for( var i = 0, len = ins.length; i < len; i++ )
  {
    index = _.arrayLeftIndex( dstArray, ins[ i ], evaluator1, evaluator2 )
    if( index >= 0 )
    {
      var subValue = sub[ i ];
      if( subValue === undefined )
      dstArray.splice( index, 1 );
      else
      dstArray.splice( index, 1, subValue );
      result += 1;
    }
  }

  return result;
}

//

function arrayReplaceAll( dstArray, ins, sub, evaluator1, evaluator2 )
{
  arrayReplacedAll.apply( this, arguments );
  return dstArray;
}

//

function arrayReplacedAll( dstArray, ins, sub, evaluator1, evaluator2 )
{
  _.assert( 3 <= arguments.length && arguments.length <= 5 );

  var index = -1;
  var result = 0;

  index = _.arrayLeftIndex( dstArray, ins, evaluator1, evaluator2 );

  while( index !== -1 )
  {
    dstArray.splice( index,1,sub );
    result += 1;
    index = _.arrayLeftIndex( dstArray, ins, evaluator1, evaluator2 );
  }

  return result;
}

//

/**
 * The arrayUpdate() routine adds a value (sub) to an array (dstArray) or replaces a value (ins) of the array (dstArray) by (sub),
 * and returns the last added index or the last replaced index of the array (dstArray).
 *
 * It creates the variable (index) assigns and calls to it the function(arrayReplaceOnce( dstArray, ins, sub ).
 * [arrayReplaceOnce( dstArray, ins, sub )]{@link wTools.arrayReplaceOnce}.
 * Checks if (index) equal to the -1.
 * If true, it adds to an array (dstArray) a value (sub), and returns the last added index of the array (dstArray).
 * Otherwise, it returns the replaced (index).
 *
 * @see wTools.arrayReplaceOnce
 *
 * @param { Array } dstArray - The source array.
 * @param { * } ins - The value to change.
 * @param { * } sub - The value to add or replace.
 *
 * @example
 * // returns 3
 * var add = _.arrayUpdate( [ 'Petre', 'Mikle', 'Oleg' ], 'Dmitry', 'Dmitry' );
 * console.log( add ) = > [ 'Petre', 'Mikle', 'Oleg', 'Dmitry' ];
 *
 * @example
 * // returns 5
 * var add = _.arrayUpdate( [ 1, 2, 3, 4, 5 ], 6, 6 );
 * console.log( add ) => [ 1, 2, 3, 4, 5, 6 ];
 *
 * @example
 * // returns 4
 * var replace = _.arrayUpdate( [ true, true, true, true, false ], false, true );
 * console.log( replace ) => [ true, true true, true, true ];
 *
 * @returns { number } Returns the last added or the last replaced index.
 * @function arrayUpdate
 * @throws { Error } Will throw an Error if (dstArray) is not an array-like.
 * @throws { Error } Will throw an Error if (arguments.length) is less or more than three.
 * @memberof wTools
 */

function arrayUpdate( dstArray, ins, sub, evaluator1, evaluator2 )
{
  var index = arrayReplacedOnce.apply( this, arguments );

  if( index === -1 )
  {
    dstArray.push( sub );
    index = dstArray.length - 1;
  }

  return index;
}



// --
// array set
// --

/**
 * Returns new array that contains difference between two arrays: ( src1 ) and ( src2 ).
 * If some element is present in both arrays, this element and all copies of it are ignored.
 * @param { longIs } src1 - source array;
 * @param { longIs} src2 - array to compare with ( src1 ).
 *
 * @example
 * // returns [ 1, 2, 3, 4, 5, 6 ]
 * _.arraySetDiff( [ 1, 2, 3 ], [ 4, 5, 6 ] );
 *
 * @example
 * // returns [ 2, 4, 3, 5 ]
 * _.arraySetDiff( [ 1, 2, 4 ], [ 1, 3, 5 ] );
 *
 * @returns { Array } Array with unique elements from both arrays.
 * @function arraySetDiff
 * @throws { Error } If arguments count is not 2.
 * @throws { Error } If one or both argument(s) are not longIs entities.
 * @memberof wTools
 */

function arraySetDiff( src1, src2 )
{
  var result = [];

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( src1 ) );
  _.assert( _.longIs( src2 ) );

  for( var i = 0 ; i < src1.length ; i++ )
  {
    if( src2.indexOf( src1[ i ] ) === -1 )
    result.push( src1[ i ] );
  }

  for( var i = 0 ; i < src2.length ; i++ )
  {
    if( src1.indexOf( src2[ i ] ) === -1 )
    result.push( src2[ i ] );
  }

  return result;
}

//

/**
 * Returns new array that contains elements from ( src ) that are not present in ( but ).
 * All copies of ignored element are ignored too.
 * @param { longIs } src - source array;
 * @param { longIs} but - array of elements to ignore.
 *
 * @example
 * // returns []
 * _.arraySetBut( [ 1, 1, 1 ], [ 1 ] );
 *
 * @example
 * // returns [ 2, 2 ]
 * _.arraySetBut( [ 1, 1, 2, 2, 3, 3 ], [ 1, 3 ] );
 *
 * @returns { Array } Source array without elements from ( but ).
 * @function arraySetBut
 * @throws { Error } If arguments count is not 2.
 * @throws { Error } If one or both argument(s) are not longIs entities.
 * @memberof wTools
 */

function arraySetBut( dst )
{
  var args = _.longSlice( arguments );

  if( dst === null )
  if( args.length > 1 )
  {
    dst = _.longSlice( args[ 1 ] );
    args.splice( 1,1 );
  }
  else
  {
    return [];
  }

  args[ 0 ] = dst;

  _.assert( arguments.length >= 1, 'expects at least one argument' );
  for( var a = 0 ; a < args.length ; a++ )
  _.assert( _.longIs( args[ a ] ) );

  for( var i = dst.length-1 ; i >= 0 ; i-- )
  {
    for( var a = 1 ; a < args.length ; a++ )
    {
      var but = args[ a ];
      if( but.indexOf( dst[ i ] ) !== -1 )
      {
        dst.splice( i,1 );
        break;
      }
    }
  }

  return dst;
}

//

/**
 * Returns array that contains elements from ( src ) that exists at least in one of arrays provided after first argument.
 * If element exists and it has copies, all copies of that element will be included into result array.
 * @param { longIs } src - source array;
 * @param { ...longIs } - sequence of arrays to compare with ( src ).
 *
 * @example
 * // returns [ 1, 3 ]
 * _.arraySetIntersection( [ 1, 2, 3 ], [ 1 ], [ 3 ] );
 *
 * @example
 * // returns [ 1, 1, 2, 2, 3, 3 ]
 * _.arraySetIntersection( [ 1, 1, 2, 2, 3, 3 ], [ 1 ], [ 2 ], [ 3 ], [ 4 ] );
 *
 * @returns { Array } Array with elements that are a part of at least one of the provided arrays.
 * @function arraySetIntersection
 * @throws { Error } If one of arguments is not an longIs entity.
 * @memberof wTools
 */

function arraySetIntersection( dst )
{

  var first = 1;
  if( dst === null )
  if( arguments.length > 1 )
  {
    dst = _.longSlice( arguments[ 1 ] );
    first = 2;
  }
  else
  {
    return [];
  }

  _.assert( arguments.length >= 1, 'expects at least one argument' );
  _.assert( _.longIs( dst ) );
  for( var a = 1 ; a < arguments.length ; a++ )
  _.assert( _.longIs( arguments[ a ] ) );

  for( var i = dst.length-1 ; i >= 0 ; i-- )
  {

    for( var a = first ; a < arguments.length ; a++ )
    {
      var ins = arguments[ a ];
      if( ins.indexOf( dst[ i ] ) === -1 )
      {
        dst.splice( i,1 );
        break;
      }
    }

  }

  return dst;
}

//

function arraySetUnion( dst )
{
  var args = _.longSlice( arguments );

  if( dst === null )
  if( arguments.length > 1 )
  {
    dst = [];
    // dst = _.longSlice( args[ 1 ] );
    // args.splice( 1,1 );
  }
  else
  {
    return [];
  }

  _.assert( arguments.length >= 1, 'expects at least one argument' );
  _.assert( _.longIs( dst ) );
  for( var a = 1 ; a < args.length ; a++ )
  _.assert( _.longIs( args[ a ] ) );

  for( var a = 1 ; a < args.length ; a++ )
  {
    var ins = args[ a ];
    for( var i = 0 ; i < ins.length ; i++ )
    {
      if( dst.indexOf( ins[ i ] ) === -1 )
      dst.push( ins[ i ] )
    }
  }

  return dst;
}

//

/*
function arraySetContainAll( src )
{
  var result = [];

  _.assert( _.longIs( src ) );

  for( var a = 1 ; a < arguments.length ; a++ )
  {

    _.assert( _.longIs( arguments[ a ] ) );

    if( src.length > arguments[ a ].length )
    return false;

    for( var i = 0 ; i < src.length ; i++ )
    {

      throw _.err( 'Not tested' );
      if( arguments[ a ].indexOf( src[ i ] ) !== -1 )
      {
        throw _.err( 'Not tested' );
        return false;
      }

    }

  }

  return true;
}
*/
//
  /**
   * The arraySetContainAll() routine returns true, if at least one of the following arrays (arguments[...]),
   * contains all the same values as in the {-srcMap-} array.
   *
   * @param { longIs } src - The source array.
   * @param { ...longIs } arguments[...] - The target array.
   *
   * @example
   * // returns true
   * _.arraySetContainAll( [ 1, 'b', 'c', 4 ], [ 1, 2, 3, 4, 5, 'b', 'c' ] );
   *
   * @example
   * // returns false
   * _.arraySetContainAll( [ 'abc', 'def', true, 26 ], [ 1, 2, 3, 4 ], [ 26, 'abc', 'def', true ] );
   *
   * @returns { boolean } Returns true, if at least one of the following arrays (arguments[...]),
   * contains all the same values as in the {-srcMap-} array.
   * If length of the {-srcMap-} is more than the next argument, it returns false.
   * Otherwise, it returns false.
   * @function arraySetContainAll
   * @throws { Error } Will throw an Error if {-srcMap-} is not an array-like.
   * @throws { Error } Will throw an Error if (arguments[...]) is not an array-like.
   * @memberof wTools
   */

function arraySetContainAll( src )
{
  _.assert( _.longIs( src ) );
  for( var a = 1 ; a < arguments.length ; a++ )
  _.assert( _.longIs( arguments[ a ] ) );

  for( var a = 1 ; a < arguments.length ; a++ )
  {
    var ins = arguments[ a ];

    for( var i = 0 ; i < ins.length ; i++ )
    {
      if( src.indexOf( ins[ i ] ) === -1 )
      return false;
    }

  }

  return true;
}

//

/**
 * The arraySetContainAny() routine returns true, if at least one of the following arrays (arguments[...]),
 * contains the first matching value from {-srcMap-}.
 *
 * @param { longIs } src - The source array.
 * @param { ...longIs } arguments[...] - The target array.
 *
 * @example
 * // returns true
 * _.arraySetContainAny( [ 33, 4, 5, 'b', 'c' ], [ 1, 'b', 'c', 4 ], [ 33, 13, 3 ] );
 *
 * @example
 * // returns true
 * _.arraySetContainAny( [ 'abc', 'def', true, 26 ], [ 1, 2, 3, 4 ], [ 26, 'abc', 'def', true ] );
 *
 * @example
 * // returns false
 * _.arraySetContainAny( [ 1, 'b', 'c', 4 ], [ 3, 5, 'd', 'e' ], [ 'abc', 33, 7 ] );
 *
 * @returns { Boolean } Returns true, if at least one of the following arrays (arguments[...]),
 * contains the first matching value from {-srcMap-}.
 * Otherwise, it returns false.
 * @function arraySetContainAny
 * @throws { Error } Will throw an Error if {-srcMap-} is not an array-like.
 * @throws { Error } Will throw an Error if (arguments[...]) is not an array-like.
 * @memberof wTools
 */

function arraySetContainAny( src )
{
  _.assert( _.longIs( src ) );
  for( var a = 1 ; a < arguments.length ; a++ )
  _.assert( _.longIs( arguments[ a ] ) );

  if( src.length === 0 )
  return true;

  for( var a = 1 ; a < arguments.length ; a++ )
  {
    var ins = arguments[ a ];

    for( var i = 0 ; i < ins.length ; i++ )
    {
      if( src.indexOf( ins[ i ] ) !== -1 )
      break;
    }

    if( i === ins.length )
    return false;

  }

  return true;
}

//

function arraySetContainNone( src )
{
  _.assert( _.longIs( src ) );

  for( var a = 1 ; a < arguments.length ; a++ )
  {

    _.assert( _.longIs( arguments[ a ] ) );

    for( var i = 0 ; i < src.length ; i++ )
    {

      if( arguments[ a ].indexOf( src[ i ] ) !== -1 )
      {
        return false;
      }

    }

  }

  return true;
}

//

/**
 * Returns true if ( ins1 ) and ( ins2) arrays have same length and elements, elements order doesn't matter.
 * Inner arrays of arguments are not compared and result of such combination will be false.
 * @param { longIs } ins1 - source array;
 * @param { longIs} ins2 - array to compare with.
 *
 * @example
 * // returns false
 * _.arraySetIdentical( [ 1, 2, 3 ], [ 4, 5, 6 ] );
 *
 * @example
 * // returns true
 * _.arraySetIdentical( [ 1, 2, 4 ], [ 4, 2, 1 ] );
 *
 * @returns { Boolean } Result of comparison as boolean.
 * @function arraySetIdentical
 * @throws { Error } If one of arguments is not an ArrayLike entity.
 * @throws { Error } If arguments length is not 2.
 * @memberof wTools
 */

function arraySetIdentical( ins1,ins2 )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( ins1 ) );
  _.assert( _.longIs( ins2 ) );

  if( ins1.length !== ins2.length )
  return false;

  var result = _.arraySetDiff( ins1,ins2 );

  return result.length === 0;
}

// --
// range
// --

function rangeIs( range )
{
  _.assert( arguments.length === 1 );
  if( !_.numbersAre( range ) )
  return false;
  if( range.length !== 2 )
  return false;
  return true;
}

//

function rangeFrom( range )
{
  _.assert( arguments.length === 1 );
  if( _.numberIs( range ) )
  return [ range, Infinity ];
  _.assert( _.longIs( range ) );
  _.assert( range.length === 1 || range.length === 2 );
  _.assert( range[ 0 ] === undefined || _.numberIs( range[ 0 ] ) );
  _.assert( range[ 1 ] === undefined || _.numberIs( range[ 1 ] ) );
  if( range[ 0 ] === undefined )
  return [ 0, range[ 1 ] ];
  if( range[ 1 ] === undefined )
  return [ range[ 0 ], Infinity ];
  return range;
}

//

function rangeClamp( dstRange, clampRange )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.rangeIs( dstRange ) );
  _.assert( _.rangeIs( clampRange ) );

  if( dstRange[ 0 ] < clampRange[ 0 ] )
  dstRange[ 0 ] = clampRange[ 0 ];
  else if( dstRange[ 0 ] > clampRange[ 1 ] )
  dstRange[ 0 ] = clampRange[ 1 ];

  if( dstRange[ 1 ] < clampRange[ 0 ] )
  dstRange[ 1 ] = clampRange[ 0 ];
  else if( dstRange[ 1 ] > clampRange[ 1 ] )
  dstRange[ 1 ] = clampRange[ 1 ];

  return dstRange;
}

//

function rangeNumberElements( range, increment )
{

  _.assert( _.rangeIs( range ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( increment === undefined )
  increment = 1;

  return increment ? ( range[ 1 ]-range[ 0 ] ) / increment : 0;

}

//

function rangeFirstGet( range,options )
{

  var options = options || Object.create( null );
  if( options.increment === undefined )
  options.increment = 1;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( _.arrayIs( range ) )
  {
    return range[ 0 ];
  }
  else if( _.mapIs( range ) )
  {
    return range.first
  }
  _.assert( 0, 'unexpected type of range',_.strTypeOf( range ) );

}

//

function rangeLastGet( range,options )
{

  var options = options || Object.create( null );
  if( options.increment === undefined )
  options.increment = 1;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( _.arrayIs( range ) )
  {
    return range[ 1 ];
  }
  else if( _.mapIs( range ) )
  {
    return range.last
  }
  _.assert( 0, 'unexpected type of range',_.strTypeOf( range ) );

}

// --
// map checker
// --

/**
 * Function objectIs checks incoming param whether it is object.
 * Returns "true" if incoming param is object. Othervise "false" returned.
 *
 * @example
 * // returns true
 * var obj = {x : 100};
 * objectIs(obj);
 * @example
 * // returns false
 * objectIs( 10 );
 *
 * @param {*} src.
 * @return {Boolean}.
 * @function objectIs
 * @memberof wTools
 */

function objectIs( src )
{
  // if( !src )
  // return false;
  // if( _ObjectHasOwnProperty.call( src,'callee' ) )
  // return false;
  // if( src instanceof Array )
  // return true;
  // if( src instanceof Object )
  // return true;
  // var prototype = Object.getPrototypeOf( src );
  // return prototype === null;
  return _ObjectToString.call( src ) === '[object Object]';
}

//

function objectLike( src )
{

  if( _.objectIs( src ) )
  return true;
  if( _.primitiveIs( src ) )
  return false;
  if( _.longIs( src ) )
  return false;
  if( _.routineIsPure( src ) )
  return false;
  if( _.strIs( src ) )
  return false;

  for( var k in src )
  return true;

  return false;
}

//

function objectLikeOrRoutine( src )
{
  if( routineIs( src ) )
  return true;
  return objectLike( src );
}

//

/**
 * The mapIs() routine determines whether the passed value is an Object,
 * and not inherits through the prototype chain.
 *
 * If the {-srcMap-} is an Object, true is returned,
 * otherwise false is.
 *
 * @param { * } src - Entity to check.
 *
 * @example
 * // returns true
 * mapIs( { a : 7, b : 13 } );
 *
 * @example
 * // returns false
 * mapIs( 13 );
 *
 * @example
 * // returns false
 * mapIs( [ 3, 7, 13 ] );
 *
 * @returns { Boolean } Returns true if {-srcMap-} is an Object, and not inherits through the prototype chain.
 * @function mapIs
 * @memberof wTools
 */

function mapIs( src )
{

  if( !_.objectIs( src ) )
  return false;

  var proto = Object.getPrototypeOf( src );

  if( proto === null )
  return true;

  if( proto.constructor && proto.constructor.name !== 'Object' )
  return false;

  if( Object.getPrototypeOf( proto ) === null )
  return true;

  _.assert( proto === null || !!proto, 'unexpected' );

  return false;
}

//

function mapIsPure( src )
{
  if( !src )
  return;

  if( Object.getPrototypeOf( src ) === null )
  return true;

  return false;
}

//

function mapLike( src )
{

  if( mapIs( src ) )
  return true;

  // if( src.constructor === Object || src.constructor === null )
  // debugger;

  if( src.constructor === Object || src.constructor === null )
  return true;

  return false;
}

//

/**
 * The mapIdentical() returns true, if the second object (src2)
 * has the same values as the first object(src1).
 *
 * It takes two objects (scr1, src2), checks
 * if both object have the same length and [key, value] return true
 * otherwise it returns undefined.
 *
 * @param { objectLike } src1 - First object.
 * @param { objectLike } src2 - Target object.
 * Objects to compare values.
 *
 * @example
 * // returns true
 * mapIdentical( { a : 7, b : 13 }, { a : 7, b : 13 } );
 *
 * @example
 * returns false
 * _.mapIdentical( { a : 7, b : 13 }, { a : 33, b : 13 } );
 *
 * @example
 * returns false
 * _.mapIdentical( { a : 7, b : 13, c : 33 }, { a : 7, b : 13 } );
 *
 * @returns { boolean } Returns true, if the second object (src2)
 * has the same values as the first object(src1).
 * @function mapIdentical
 * @throws Will throw an error if ( arguments.length !== 2 ).
 * @memberof wTools
 */

function mapIdentical( src1,src2 )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectLike( src1 ) );
  _.assert( _.objectLike( src2 ) );

  if( Object.keys( src1 ).length !== Object.keys( src2 ).length )
  return false;

  for( var s in src1 )
  {
    if( src1[ s ] !== src2[ s ] )
    return false;
  }

  return true;
}

//

/**
 * The mapContain() returns true, if the first object {-srcMap-}
 * has the same values as the second object(ins).
 *
 * It takes two objects (scr, ins),
 * checks if the first object {-srcMap-} has the same [key, value] as
 * the second object (ins).
 * If true, it returns true,
 * otherwise it returns false.
 *
 * @param { objectLike } src - Target object.
 * @param { objectLike } ins - Second object.
 * Objects to compare values.
 *
 * @example
 * // returns true
 * mapContain( { a : 7, b : 13, c : 15 }, { a : 7, b : 13 } );
 *
 * @example
 * returns false
 * mapContain( { a : 7, b : 13 }, { a : 7, b : 13, c : 15 } );
 *
 * @returns { boolean } Returns true, if the first object {-srcMap-}
 * has the same values as the second object(ins).
 * @function mapContain
 * @throws Will throw an error if ( arguments.length !== 2 ).
 * @memberof wTools
 */

function mapContain( src,ins )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

/*
  if( Object.keys( src ).length < Object.keys( ins ).length )
  return false;
*/

  for( var s in ins )
  {

    if( ins[ s ] === undefined )
    continue;

    if( src[ s ] !== ins[ s ] )
    return false;

  }

  return true;
}

//
//
// function mapHas( object,name )
// {
//   var name = _.nameUnfielded( name ).coded;
//
//   var descriptor = Object.getOwnPropertyDescriptor( object,name );
//
//   if( !descriptor )
//   return false;
//
//   if( descriptor.set && descriptor.set.forbid )
//   return false;
//
//   return true;
// }

//

/**
 * Short-cut for _mapSatisfy() routine.
 * Checks if object( o.src ) has at least one key/value pair that is represented in( o.template ).
 * Also works with ( o.template ) as routine that check( o.src ) with own rules.
 * @param {wTools~mapSatisfyOptions} o - Default options {@link wTools~mapSatisfyOptions}.
 * @returns {boolean} Returns true if( o.src ) has same key/value pair(s) with( o.template )
 * or result if ( o.template ) routine call is true.
 *
 * @example
 * //returns true
 * _.mapSatisfy( {a : 1, b : 1, c : 1 }, { a : 1, b : 2 } );
 *
 * @example
 * //returns true
 * _.mapSatisfy( { template : {a : 1, b : 1, c : 1 }, src : { a : 1, b : 2 } } );
 *
 * @example
 * //returns false
 * function routine( src ){ return src.a === 12 }
 * _.mapSatisfy( { template : routine, src : { a : 1, b : 2 } } );
 *
 * @function mapSatisfy
 * @throws {exception} If( arguments.length ) is not equal to 1 or 2.
 * @throws {exception} If( o.template ) is not a Object.
 * @throws {exception} If( o.template ) is not a Routine.
 * @throws {exception} If( o.src ) is undefined.
 * @memberof wTools
*/

function mapSatisfy( o )
{

  if( arguments.length === 2 )
  o = { template : arguments[ 0 ], src : arguments[ 1 ] };

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( o.template ) || _.routineIs( o.template ) );
  _.assert( o.src !== undefined );

  _.routineOptions( mapSatisfy,o );

  return _mapSatisfy( o.template, o.src, o.src, o.levels );
}

mapSatisfy.defaults =
{
  template : null,
  src : null,
  levels : 1,
}

//

/**
 * Default options for _mapSatisfy() routine.
 * @typedef {object} wTools~mapSatisfyOptions
 * @property {object|function} [ template=null ] - Map to compare with( src ) or routine that checks each value of( src ).
 * @property {object} [ src=null ] - Source map.
 * @property {number} [ levels=256 ] - Number of levels in map structure.
 *
*/

/**
 * Checks if object( src ) has at least one key/value pair that is represented in( template ).
 * Returns true if( template ) has one or more indentical key/value pair with( src ).
 * If( template ) is provided as routine, routine uses it to check( src ).
 * @param {wTools~mapSatisfyOptions} args - Arguments list {@link wTools~mapSatisfyOptions}.
 * @returns {boolean} Returns true if( src ) has same key/value pair(s) with( template ).
 *
 * @example
 * //returns true
 * _._mapSatisfy( {a : 1, b : 1, c : 1 }, { a : 1, b : 2 } );
 *
 * @example
 * //returns false
 * _._mapSatisfy( {a : 1, b : 1, c : 1 }, { y : 1 , j : 1 } );
 *
 * @example
 * //returns true
 * function template( src ){ return src.y === 1 }
 * _._mapSatisfy( template, { y : 1 , j : 1 } );
 *
 * @function _mapSatisfy
 * @memberof wTools
*/

function _mapSatisfy( template, src, root, levels )
{

  if( template === src )
  return true;

  if( levels === 0 )
  {
    if( _.objectIs( template ) && _.objectIs( src ) && _.routineIs( template.identicalWith ) && src.identicalWith === template.identicalWith )
    return template.identicalWith( src );
    else
    return template === src;
  }
  else if( levels < 0 )
  {
    return false;
  }

  if( _.routineIs( template ) )
  return template( src );

  if( _.objectIs( template ) )
  {
    for( var t in template )
    {
      var satisfy = false;
      satisfy = _mapSatisfy( template[ t ], src[ t ], root, levels-1 );
      if( !satisfy )
      return false;
    }
    return true;
  }

  debugger;

  return false;
}

//

function mapHasKey( object,key )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.strIs( key ) )
  return ( key in object );
  else if( _.mapIs( key ) )
  return ( _.nameUnfielded( key ).coded in object );
  else if( _.symbolIs( key ) )
  return ( key in object );

  _.assert( 0,'mapHasKey :','unknown type of key :',_.strTypeOf( key ) );
}

//

/**
 * The mapOwnKey() returns true if (object) has own property.
 *
 * It takes (name) checks if (name) is a String,
 * if (object) has own property with the (name).
 * If true, it returns true.
 *
 * @param { Object } object - Object that will be check.
 * @param { name } name - Target property.
 *
 * @example
 * // returns true
 * _.mapOwnKey( { a : 7, b : 13 }, 'a' );
 *
 * @example
 * // returns false
 * _.mapOwnKey( { a : 7, b : 13 }, 'c' );
 *
 * @returns { boolean } Returns true if (object) has own property.
 * @function mapOwnKey
 * @throws { mapOwnKey } Will throw an error if the (name) is unknown.
 * @memberof wTools
 */

//

function mapOwnKey( object,key )
{

  // if( arguments.length === 1 )
  // {
  //   var result = _.mapExtendConditional( _.field.mapper.srcOwn,Object.create( null ),object );
  //   return result;
  // }

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.strIs( key ) )
  return _ObjectHasOwnProperty.call( object, key );
  else if( _.mapIs( key ) )
  return _ObjectHasOwnProperty.call( object, _.nameUnfielded( key ).coded );
  else if( _.symbolIs( key ) )
  return _ObjectHasOwnProperty.call( object, key );

  _.assert( 0,'mapOwnKey :','unknown type of key :',_.strTypeOf( key ) );
}

//

function mapHasVal( object,val )
{
  var vals = _.mapVals( object );
  return vals.indexOf( val ) !== -1;
}

//

function mapOwnVal( object,val )
{
  var vals = _.mapOwnVals( object );
  return vals.indexOf( val ) !== -1;
}

//

/**
 * The mapHasAll() returns true if object( src ) has all enumerable keys from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has property with same name.
 * Returns true if all keys from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { ObjectLike } src - Map that will be checked for keys from( screen ).
 * @param { ObjectLike } screen - Map that hold keys.
 *
 * @example
 * // returns true
 * _.mapHasAll( {}, {} );
 *
 * // returns false
 * _.mapHasAll( {}, { a : 1 } );
 *
 * @returns { boolean } Returns true if object( src ) has all enumerable keys from( screen ).
 * @function mapHasAll
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @memberof wTools
 */

function mapHasAll( src,screen )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectLike( src ) );
  _.assert( _.objectLike( screen ) );

  for( var k in screen )
  {
    if( !( k in src ) )
    return false;
  }

  return true;
}

//

/**
 * The mapHasAny() returns true if object( src ) has at least one enumerable key from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has at least one property with same name.
 * Returns true if any key from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { ObjectLike } src - Map that will be checked for keys from( screen ).
 * @param { ObjectLike } screen - Map that hold keys.
 *
 * @example
 * // returns false
 * _.mapHasAny( {}, {} );
 *
 * // returns true
 * _.mapHasAny( { a : 1, b : 2 }, { a : 1 } );
 *
 * // returns false
 * _.mapHasAny( { a : 1, b : 2 }, { c : 1 } );
 *
 * @returns { boolean } Returns true if object( src ) has at least one enumerable key from( screen ).
 * @function mapHasAny
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @memberof wTools
 */

function mapHasAny( src,screen )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectLike( src ) );
  _.assert( _.objectLike( screen ) );

  for( var k in screen )
  {
    if( k in src )
    debugger;
    if( k in src )
    return true;
  }

  debugger;
  return false;
}

//

/**
 * The mapHasAny() returns true if object( src ) has no one enumerable key from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has no one property with same name.
 * Returns true if all keys from( screen ) not exists on object( src ), otherwise returns false.
 *
 * @param { ObjectLike } src - Map that will be checked for keys from( screen ).
 * @param { ObjectLike } screen - Map that hold keys.
 *
 * @example
 * // returns true
 * _.mapHasNone( {}, {} );
 *
 * // returns false
 * _.mapHasNone( { a : 1, b : 2 }, { a : 1 } );
 *
 * // returns true
 * _.mapHasNone( { a : 1, b : 2 }, { c : 1 } );
 *
 * @returns { boolean } Returns true if object( src ) has at least one enumerable key from( screen ).
 * @function mapHasNone
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @memberof wTools
 */

function mapHasNone( src, screen )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectLike( src ) );
  _.assert( _.objectLike( screen ) );

  for( var k in screen )
  {
    if( k in src )
    return false;
  }

  return true;
}

//

/**
 * The mapOwnAll() returns true if object( src ) has all own keys from object( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has own property with that key name.
 * Returns true if all keys from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { Object } src - Map that will be checked for keys from( screen ).
 * @param { Object } screen - Map that hold keys.
 *
 * @example
 * // returns true
 * _.mapOwnAll( {}, {} );
 *
 * // returns true
 * _.mapOwnAll( { a : 1, b : 2 }, { a : 1 } );
 *
 * // returns false
 * _.mapOwnAll( { a : 1, b : 2 }, { c : 1 } );
 *
 * @returns { boolean } Returns true if object( src ) has own properties from( screen ).
 * @function mapOwnAll
 * @throws { Exception } Will throw an error if the ( src ) is not a ObjectLike entity.
 * @throws { Exception } Will throw an error if the ( screen ) is not a ObjectLike entity.
 * @memberof wTools
 */

function mapOwnAll( src,screen )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( src ) );
  _.assert( _.mapIs( screen ) );

  for( var k in screen )
  {
    if( !_ObjectHasOwnProperty.call( src,k ) )
    debugger;
    if( !_ObjectHasOwnProperty.call( src,k ) )
    return false;
  }

  debugger;
  return true;
}

//

/**
 * The mapOwnAny() returns true if map( src ) has at least one own property from map( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from map( screen ) and checks if source( src ) has at least one property with that key name.
 * Returns true if one of keys from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { Object } src - Map that will be checked for keys from( screen ).
 * @param { Object } screen - Map that hold keys.
 *
 * @example
 * // returns false
 * _.mapOwnAny( {}, {} );
 *
 * // returns true
 * _.mapOwnAny( { a : 1, b : 2 }, { a : 1 } );
 *
 * // returns false
 * _.mapOwnAny( { a : 1, b : 2 }, { c : 1 } );
 *
 * @returns { boolean } Returns true if object( src ) has own properties from( screen ).
 * @function mapOwnAny
 * @throws { Exception } Will throw an error if the ( src ) is not a map.
 * @throws { Exception } Will throw an error if the ( screen ) is not a map.
 * @memberof wTools
 */

function mapOwnAny( src,screen )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( src ) );
  _.assert( _.mapIs( screen ) );

  for( var k in screen )
  {
    if( _ObjectHasOwnProperty.call( src,k ) )
    debugger;
    if( _ObjectHasOwnProperty.call( src,k ) )
    return true;
  }

  debugger;
  return false;
}

//

/**
 * The mapOwnNone() returns true if map( src ) not owns properties from map( screen ).
 * Values of properties are not checked, only names.
 *
 * Uses for..in to get each key name from object( screen ) and checks if source( src ) has own property with that key name.
 * Returns true if no one key from( screen ) exists on object( src ), otherwise returns false.
 *
 * @param { Object } src - Map that will be checked for keys from( screen ).
 * @param { Object } screen - Map that hold keys.
 *
 * @example
 * // returns true
 * _.mapOwnNone( {}, {} );
 *
 * // returns false
 * _.mapOwnNone( { a : 1, b : 2 }, { a : 1 } );
 *
 * // returns true
 * _.mapOwnNone( { a : 1, b : 2 }, { c : 1 } );
 *
 * @returns { boolean } Returns true if map( src ) not owns properties from( screen ).
 * @function mapOwnNone
 * @throws { Exception } Will throw an error if the ( src ) is not a map.
 * @throws { Exception } Will throw an error if the ( screen ) is not a map.
 * @memberof wTools
 */

function mapOwnNone( src,screen )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( src ) );
  _.assert( _.mapIs( screen ) );

  for( var k in screen )
  {
    if( _ObjectHasOwnProperty.call( src,k ) )
    debugger;
    if( _ObjectHasOwnProperty.call( src,k ) )
    return false;
  }

  debugger;
  return true;
}

//

function mapHasExactly( srcMap, screenMaps )
{
  var result = true;

  _.assert( arguments.length === 2 );

  result = result && _.mapHasOnly( srcMap, screenMaps );
  result = result && _.mapHasAll( srcMap, screenMaps );

  return true;
}

//

function mapOwnExactly( srcMap, screenMaps )
{
  var result = true;

  _.assert( arguments.length === 2 );

  result = result && _.mapOwnOnly( srcMap, screenMaps );
  result = result && _.mapOwnAll( srcMap, screenMaps );

  return true;
}

//

function mapHasOnly( srcMap, screenMaps )
{

  _.assert( arguments.length === 2 );

  var l = arguments.length;
  var but = Object.keys( _.mapBut( srcMap, screenMaps ) );

  if( but.length > 0 )
  return false;

  return true;
}

//

function mapOwnOnly( srcMap, screenMaps )
{

  _.assert( arguments.length === 2 );

  var l = arguments.length;
  var but = Object.keys( _.mapOwnBut( srcMap, screenMaps ) );

  if( but.length > 0 )
  return false;

  return true;
}

// //
//
// function mapHasAll( srcMap, all )
// {
//
//   _.assert( arguments.length === 2 );
//
//   var but = Object.keys( _.mapBut( all,srcMap ) );
//
//   if( but.length > 0 )
//   return false;
//
//   return true;
// }
//
//
//
// function mapOwnAll( srcMap, all )
// {
//
//   _.assert( arguments.length === 2 );
//
//   var but = Object.keys( _.mapOwnBut( all,srcMap ) );
//
//   if( but.length > 0 )
//   return false;
//
//   return true;
// }
//
// //
//
// function mapHasNone( srcMap, screenMaps )
// {
//
//   _.assert( arguments.length === 2 );
//
//   var but = _.mapOnly( srcMap, screenMaps );
//   var keys = Object.keys( but );
//   if( keys.length )
//   return false;
//
//   return true;
// }
//
// //
//
// function mapOwnNone( srcMap, screenMaps )
// {
//
//   _.assert( arguments.length === 2 );
//
//   var but = Object.keys( _.mapOnlyOwn( srcMap, screenMaps ) );
//
//   if( but.length )
//   return false;
//
//   return true;
// }

//

function mapHasNoUndefine( srcMap )
{

  _.assert( arguments.length === 1 );

  var but = [];
  var l = arguments.length;

  for( var s in srcMap )
  if( srcMap[ s ] === undefined )
  return false;

  return true;
}

// --
// map move
// --

/**
 * The mapMake() routine is used to copy the values of all properties
 * from one or more source objects to the new object.
 *
 * @param { ...objectLike } arguments[] - The source object(s).
 *
 * @example
 * // returns { a : 7, b : 13, c : 3, d : 33, e : 77 }
 * _.mapMake( { a : 7, b : 13 }, { c : 3, d : 33 }, { e : 77 } );
 *
 * @returns { objectLike } It will return the new object filled by [ key, value ]
 * from one or more source objects.
 * @function mapMake
 * @memberof wTools
 */

function mapMake()
{
  if( arguments.length <= 1 )
  if( arguments[ 0 ] === undefined || arguments[ 0 ] === null )
  return Object.create( null );
  var args = _.longSlice( arguments );
  args.unshift( Object.create( null ) );
  _.assert( !_.primitiveIs( arguments[ 0 ] ) || arguments[ 0 ] === null );
  return _.mapExtend.apply( _,args );
}

//

function mapShallowClone( src )
{
  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( src ) );
  return _.mapExtend( null, src );
}

//

/**
 * @callback mapCloneAssigning~onField
 * @param { objectLike } dstContainer - destination object.
 * @param { objectLike } srcContainer - source object.
 * @param { string } key - key to coping from one object to another.
 * @param { function } onField - handler of fields.
 */

/**
 * The mapCloneAssigning() routine is used to clone the values of all
 * enumerable own properties from {-srcMap-} object to an (options.dst) object.
 *
 * It creates two variables:
 * var options = options || {}, result = options.dst || {}.
 * Iterate over {-srcMap-} object, checks if {-srcMap-} object has own properties.
 * If true, it calls the provided callback function( options.onField( result, srcMap, k ) ) for each key (k),
 * and copies each [ key, value ] of the {-srcMap-} to the (result),
 * and after cycle, returns clone with prototype of srcMap.
 *
 * @param { objectLike } srcMap - The source object.
 * @param { Object } o - The options.
 * @param { objectLike } [options.dst = Object.create( null )] - The target object.
 * @param { mapCloneAssigning~onField } [options.onField()] - The callback function to copy each [ key, value ]
 * of the {-srcMap-} to the (result).
 *
 * @example
 * // returns Example { sex : 'Male', name : 'Peter', age : 27 }
 * function Example() {
 *   this.name = 'Peter';
 *   this.age = 27;
 * }
 * mapCloneAssigning( new Example(), { dst : { sex : 'Male' } } );
 *
 * @returns { objectLike }  The (result) object gets returned.
 * @function mapCloneAssigning
 * @throws { Error } Will throw an Error if ( o ) is not an Object,
 * if ( arguments.length > 2 ), if (key) is not a String or
 * if {-srcMap-} has not own properties.
 * @memberof wTools
 */

function mapCloneAssigning( o )
{
  o.dstMap = o.dstMap || Object.create( null );

  _.assert( _.mapIs( o ) );
  _.assert( arguments.length === 1,'mapCloneAssigning :','expects {-srcMap-} as argument' );
  _.assert( objectLike( o.srcMap ),'mapCloneAssigning :','expects {-srcMap-} as argument' );
  _.routineOptions( mapCloneAssigning, o );

  if( !o.onField )
  o.onField = function onField( dstContainer,srcContainer,key )
  {
    _.assert( _.strIs( key ) );
    dstContainer[ key ] = srcContainer[ key ];
  }

  for( var k in o.srcMap )
  {
    if( _ObjectHasOwnProperty.call( o.srcMap,k ) )
    o.onField( o.dstMap,o.srcMap,k,o.onField );
  }

  Object.setPrototypeOf( o.dstMap, Object.getPrototypeOf( o.srcMap ) );

  return o.dstMap;
}

mapCloneAssigning.defaults =
{
  srcMap : null,
  dstMap : null,
  onField : null,
}

//

/**
 * The mapExtend() is used to copy the values of all properties
 * from one or more source objects to a target object.
 *
 * It takes first object (dstMap)
 * creates variable (result) and assign first object.
 * Checks if arguments equal two or more and if (result) is an object.
 * If true,
 * it extends (result) from the next objects.
 *
 * @param{ objectLike } dstMap - The target object.
 * @param{ ...objectLike } arguments[] - The source object(s).
 *
 * @example
 * // returns { a : 7, b : 13, c : 3, d : 33, e : 77 }
 * mapExtend( { a : 7, b : 13 }, { c : 3, d : 33 }, { e : 77 } );
 *
 * @returns { objectLike } It will return the target object.
 * @function mapExtend
 * @throws { Error } Will throw an error if ( arguments.length < 2 ),
 * if the (dstMap) is not an Object.
 * @memberof wTools
 */

function mapExtend( dstMap, srcMap )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  if( arguments.length === 2 && Object.getPrototypeOf( srcMap ) === null )
  return Object.assign( dstMap, srcMap );

  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  _.assert( !_.primitiveIs( dstMap ),'expects non primitive as the first argument' );

  for( var a = 1 ; a < arguments.length ; a++ )
  {
    var srcMap = arguments[ a ];

    _.assert( !_.primitiveIs( srcMap ),'expects non primitive' );

    if( Object.getPrototypeOf( srcMap ) === null )
    Object.assign( dstMap, srcMap );
    else
    for( var k in srcMap )
    {
      dstMap[ k ] = srcMap[ k ];
    }

  }

  return dstMap;
}

//

function mapsExtend( dstMap, srcMaps )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  if( srcMaps.length === 1 && Object.getPrototypeOf( srcMaps[ 0 ] ) === null )
  return Object.assign( dstMap,srcMaps[ 0 ] );

  if( !_.arrayLike( srcMaps ) )
  srcMaps = [ srcMaps ];

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.arrayLike( srcMaps ) );
  _.assert( !_.primitiveIs( dstMap ),'expects non primitive as the first argument' );

  for( var a = 0 ; a < srcMaps.length ; a++ )
  {
    var srcMap = srcMaps[ a ];

    _.assert( !_.primitiveIs( srcMap ),'expects non primitive' );

    if( Object.getPrototypeOf( srcMap ) === null )
    Object.assign( dstMap, srcMap );
    else for( var k in srcMap )
    {
      dstMap[ k ] = srcMap[ k ];
    }

  }

  return dstMap;
}

//

/**
 * The mapExtendConditional() creates a new [ key, value ]
 * from the next objects if callback function(filter) returns true.
 *
 * It calls a provided callback function(filter) once for each key in an (argument),
 * and adds to the {-srcMap-} all the [ key, value ] for which callback
 * function(filter) returns true.
 *
 * @param { function } filter - The callback function to test each [ key, value ]
 * of the (dstMap) object.
 * @param { objectLike } dstMap - The target object.
 * @param { ...objectLike } arguments[] - The next object.
 *
 * @example
 * // returns { a : 1, b : 2, c : 3 }
 * _.mapExtendConditional( _.field.mapper.dstNotHas, { a : 1, b : 2 }, { a : 1 , c : 3 } );
 *
 * @returns { objectLike } Returns the unique [ key, value ].
 * @function mapExtendConditional
 * @throws { Error } Will throw an Error if ( arguments.length < 3 ), (filter)
 * is not a Function, (result) and (argument) are not the objects.
 * @memberof wTools
 */

function mapExtendConditional( filter,dstMap )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( !!filter );
  _.assert( filter.functionFamily === 'field-mapper' );
  _.assert( arguments.length >= 3,'expects more arguments' );
  _.assert( _.routineIs( filter ),'expects filter' );
  _.assert( !_.primitiveIs( dstMap ),'expects non primitive as argument' );

  for( var a = 2 ; a < arguments.length ; a++ )
  {
    var srcMap = arguments[ a ];

    _.assert( !_.primitiveIs( srcMap ),'mapExtendConditional : expects object-like entity to extend, but got :',_.strTypeOf( srcMap ) );

    for( var k in srcMap )
    {

      filter.call( this, dstMap, srcMap, k );

    }

  }

  return dstMap;
}

//

function mapsExtendConditional( filter, dstMap, srcMaps )
{

  if( dstMap === null )
  dstMap = Object.create( null );

  _.assert( !!filter );
  _.assert( filter.functionFamily === 'field-mapper' );
  _.assert( arguments.length === 3,'expects exactly three arguments' );
  _.assert( _.routineIs( filter ),'expects filter' );
  _.assert( !_.primitiveIs( dstMap ),'expects non primitive as argument' );

  for( var a = 0 ; a < srcMaps.length ; a++ )
  {
    var srcMap = srcMaps[ a ];

    _.assert( !_.primitiveIs( srcMap ),'expects object-like entity to extend, but got :',_.strTypeOf( srcMap ) );

    for( var k in srcMap )
    {

      filter.call( this, dstMap, srcMap, k );

    }

  }

  return dstMap;
}

//

function mapExtendHiding( dstMap )
{
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.hiding );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapsExtendHiding( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return _.mapsExtendConditional( _.field.mapper.hiding, dstMap, srcMaps );
}

//

function mapExtendAppending( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return _.mapExtend( null, srcMap );
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.appending );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapsExtendAppending( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  if( dstMap === null )
  return _.mapExtend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.field.mapper.appending, dstMap, srcMaps );
}

//

function mapExtendByDefined( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return _.mapExtend( null, srcMap );
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.appending );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapsExtendByDefined( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return _.mapsExtendConditional( _.field.mapper.appending, dstMap, srcMaps );
}

//

/**
 * The mapSupplement() supplement destination map by source maps.
 * Pairs of destination map are not overwritten by pairs of source maps if any overlap.
 * Routine rewrite pairs of destination map which has key === undefined.
 *
 * @param { ...objectLike } arguments[] - The source object(s).
 *
 * @example
 * // returns { a : 1, b : 2, c : 3 }
 * var r = mapSupplement( { a : 1, b : 2 }, { a : 1, c : 3 } );
 *
 * @returns { objectLike } Returns an object with unique [ key, value ].
 * @function mapSupplement
 * @memberof wTools
 */

function mapSupplement( dstMap,srcMap )
{
  if( dstMap === null && arguments.length === 2 )
  return _.mapExtend( null, srcMap );
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotHas );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapSupplementByMaps( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  if( dstMap === null )
  return _.mapExtend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.field.mapper.dstNotHas, dstMap, srcMaps );
}

//

function mapSupplementNulls( dstMap )
{
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotHasOrHasNull );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapSupplementNils( dstMap )
{
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotHasOrHasNil );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapSupplementAssigning( dstMap )
{
  var args = _.longSlice( arguments );
  // args.unshift( _.field.mapper.dstNotOwnAssigning );
  args.unshift( _.field.mapper.dstNotHasAssigning );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapSupplementAppending( dstMap )
{
  if( dstMap === null && arguments.length === 2 )
  return _.mapExtend( null, srcMap );
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotHasAppending );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapsSupplementAppending( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return _.mapsExtendConditional( _.field.mapper.dstNotHasAppending, dstMap, srcMaps );
}

//

// function mapStretch( dstMap )
function mapSupplementOwn( dstMap, srcMap )
{
  if( dstMap === null && arguments.length === 2 )
  return _.mapExtend( dstMap,srcMap );
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotOwn );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapsSupplementOwn( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  if( dstMap === null )
  return _.mapExtend( null, srcMaps[ 0 ] );
  return _.mapsExtendConditional( _.field.mapper.dstNotOwn, dstMap, srcMaps );
}

//

function mapSupplementOwnAssigning( dstMap )
{
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotOwnAssigning );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapSupplementOwnFromDefinition( dstMap, srcMap )
{
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotOwnFromDefinition );
  return _.mapExtendConditional.apply( this, args );
}

//

function mapSupplementOwnFromDefinitionStrictlyPrimitives( dstMap, srcMap )
{
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotOwnFromDefinitionStrictlyPrimitive );
  return _.mapExtendConditional.apply( this, args );
}

//

/**
 * The mapComplement() complement ( dstMap ) by one or several ( srcMap ).
 *
 * @param { ...objectLike } arguments[] - The source object(s).
 *
 * @example
 * // returns { a : 1, b : 'ab', c : 3 };
 * _.mapComplement( { a : 1, b : 'ab' }, { a : 12 , c : 3 } );
 *
 * @returns { objectLike } Returns an object filled by all unique, clone [ key, value ].
 * @function mapComplement
 * @memberof wTools
 */

/* qqq : need to explain how undefined handled and write good documentation */

function mapComplement( dstMap,srcMap )
{
  _.assert( !!_.field.mapper );
  if( arguments.length === 2 )
  return _.mapExtendConditional( _.field.mapper.dstNotOwnOrUndefinedAssigning,dstMap,srcMap );
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotOwnOrUndefinedAssigning );
  return _.mapExtendConditional.apply( this, args );
}

//

function mapsComplement( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return _.mapsExtendConditional( _.field.mapper.dstNotOwnOrUndefinedAssigning, dstMap, srcMaps );
}

//

function mapComplementReplacingUndefines( dstMap,srcMap )
{
  _.assert( !!_.field.mapper );
  if( arguments.length === 2 )
  return _.mapExtendConditional( _.field.mapper.dstNotOwnOrUndefinedAssigning,dstMap,srcMap );
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotOwnOrUndefinedAssigning );
  return _.mapExtendConditional.apply( this, args );
}

//

function mapsComplementReplacingUndefines( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return _.mapsExtendConditional( _.field.mapper.dstNotOwnOrUndefinedAssigning, dstMap, srcMaps );
}

//

function mapComplementPreservingUndefines( dstMap )
{
  var args = _.longSlice( arguments );
  args.unshift( _.field.mapper.dstNotOwnAssigning );
  return _.mapExtendConditional.apply( this,args );
}

//

function mapsComplementPreservingUndefines( dstMap, srcMaps )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  return _.mapsExtendConditional( _.field.mapper.dstNotOwnAssigning, dstMap, srcMaps );
}

//

function mapDelete( dstMap, ins )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( dstMap ) );

  if( ins !== undefined )
  {
    _.assert( _.objectLike( ins ) );
    for( var i in ins )
    {
      delete dstMap[ i ];
    }
  }
  else
  {
    for( var i in dstMap )
    {
      delete dstMap[ i ];
    }
  }

  return dstMap;
}

// --
// map recursive
// --

function mapExtendRecursiveConditional( filters, dstMap, srcMap )
{
  _.assert( arguments.length >= 3, 'expects at least three arguments' );
  _.assert( this === Self );
  var srcMaps = _.longSlice( arguments,2 );
  return _.mapsExtendRecursiveConditional( filters, dstMap, srcMaps );
}

//

function _filterTrue(){ return true };
_filterTrue.functionFamily = 'field-filter';
function _filterFalse(){ return true };
_filterFalse.functionFamily = 'field-filter';

function mapsExtendRecursiveConditional( filters, dstMap, srcMaps )
{

  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( this === Self );

  if( _.routineIs( filters ) )
  filters = { onUpFilter : filters, onField : filters }

  if( filters.onUpFilter === undefined )
  filters.onUpFilter = filters.onField;
  else if( filters.onUpFilter === true )
  filters.onUpFilter = _filterTrue;
  else if( filters.onUpFilter === false )
  filters.onUpFilter = _filterFalse;

  if( filters.onField === true )
  filters.onField = _filterTrue;
  else if( filters.onField === false )
  filters.onField = _filterFalse;

  _.assert( _.routineIs( filters.onUpFilter ) );
  _.assert( _.routineIs( filters.onField ) );
  _.assert( filters.onUpFilter.functionFamily === 'field-filter' );
  _.assert( filters.onField.functionFamily === 'field-filter' || filters.onField.functionFamily === 'field-mapper' );

  for( var a = 0 ; a < srcMaps.length ; a++ )
  {
    var srcMap = srcMaps[ a ];
    _mapExtendRecursiveConditional( filters, dstMap, srcMap );
  }

  return dstMap;
}

//

function _mapExtendRecursiveConditional( filters, dstMap, srcMap )
{

  _.assert( _.mapIs( srcMap ) );

  for( var s in srcMap )
  {

    if( _.mapIs( srcMap[ s ] ) )
    {

      if( filters.onUpFilter( dstMap,srcMap,s ) === true )
      {
        if( !_.objectIs( dstMap[ s ] ) )
        dstMap[ s ] = Object.create( null );
        _mapExtendRecursiveConditional( filters,dstMap[ s ],srcMap[ s ] );
      }

    }
    else
    {

      if( filters.onField( dstMap,srcMap,s ) === true )
      dstMap[ s ] = srcMap[ s ];

    }

  }

}

//

function mapExtendRecursive( dstMap,srcMap )
{

  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  _.assert( this === Self );

  for( var a = 1 ; a < arguments.length ; a++ )
  {
    srcMap = arguments[ a ];
    _mapExtendRecursive( dstMap,srcMap );
  }

  return dstMap;
}

//

function mapsExtendRecursive( dstMap,srcMaps )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( this === Self );

  for( var a = 1 ; a < srcMaps.length ; a++ )
  {
    var srcMap = srcMaps[ a ];
    _mapExtendRecursive( dstMap,srcMap );
  }

  return dstMap;
}

//

function _mapExtendRecursive( dstMap,srcMap )
{

  _.assert( _.objectIs( srcMap ) );

  for( var s in srcMap )
  {

    if( _.objectIs( srcMap[ s ] ) )
    {

      if( !_.objectIs( dstMap[ s ] ) )
      dstMap[ s ] = Object.create( null );
      _mapExtendRecursive( dstMap[ s ],srcMap[ s ] );

    }
    else
    {

      dstMap[ s ] = srcMap[ s ];

    }

  }

}

//

function mapExtendAppendingRecursive( dstMap, srcMap )
{
  _.assert( this === Self );
  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  var filters = { onField : _.field.mapper.appending, onUpFilter : true };
  var args = _.longSlice( arguments );
  args.unshift( filters );
  return _.mapExtendRecursiveConditional.apply( _,args );
}

//

function mapsExtendAppendingRecursive( dstMap, srcMaps )
{
  _.assert( this === Self );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  var filters = { onField : _.field.mapper.appending, onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapExtendAppendingOnceRecursive( dstMap, srcMap )
{
  _.assert( this === Self );
  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  var filters = { onField : _.field.mapper.appendingOnce, onUpFilter : true };
  var args = _.longSlice( arguments );
  args.unshift( filters );
  return _.mapExtendRecursiveConditional.apply( _,args );
}

//

function mapsExtendAppendingOnceRecursive( dstMap, srcMaps )
{
  _.assert( this === Self );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  var filters = { onField : _.field.mapper.appendingOnce, onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapSupplementRecursive( dstMap, srcMap )
{
  _.assert( this === Self );
  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  var filters = { onField : _.field.mapper.dstNotHas, onUpFilter : true };
  var args = _.longSlice( arguments );
  args.unshift( filters );
  return _.mapExtendRecursiveConditional.apply( _,args );
}

//

function mapSupplementByMapsRecursive( dstMap, srcMaps )
{
  _.assert( this === Self );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  var filters = { onField : _.field.mapper.dstNotHas, onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapSupplementOwnRecursive( dstMap, srcMap )
{
  _.assert( this === Self );
  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  var filters = { onField : _.field.mapper.dstNotOwn, onUpFilter : true };
  var args = _.longSlice( arguments );
  args.unshift( filters );
  return _.mapExtendRecursiveConditional.apply( _,args );
}

//

function mapsSupplementOwnRecursive( dstMap, srcMaps )
{
  _.assert( this === Self );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  var filters = { onField : _.field.mapper.dstNotOwn, onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

//

function mapSupplementRemovingRecursive( dstMap, srcMap )
{
  _.assert( this === Self );
  _.assert( arguments.length >= 2, 'expects at least two arguments' );
  var filters = { onField : _.field.mapper.removing, onUpFilter : true };
  var args = _.longSlice( arguments );
  args.unshift( filters );
  return _.mapExtendRecursiveConditional.apply( _,args );
}

//

function mapSupplementByMapsRemovingRecursive( dstMap, srcMaps )
{
  _.assert( this === Self );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  var filters = { onField : _.field.mapper.removing, onUpFilter : true };
  return _.mapsExtendRecursiveConditional.call( _, filters, dstMap, srcMaps );
}

// --
// map manipulator
// --

function mapSetWithKeys( dstMap,srcArray,val )
{

  _.assert( _.objectIs( dstMap ) );
  _.assert( _.arrayIs( srcArray ) );
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  for( var s = 0 ; s < srcArray.length ; s++ )
  dstMap[ srcArray[ s ] ] = val;

}

// --
// map getter
// --

function mapInvert( src, dst )
{
  var o = this === Self ? Object.create( null ) : this;

  if( src )
  o.src = src;

  if( dst )
  o.dst = dst;

  _.routineOptions( mapInvert,o );

  o.dst = o.dst || Object.create( null );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( o.src ) );

  var del
  if( o.duplicate === 'delete' )
  del = Object.create( null );

  /* */

  for( var k in o.src )
  {
    var e = o.src[ k ];
    if( o.duplicate === 'delete' )
    if( o.dst[ e ] !== undefined )
    {
      del[ e ] = k;
      continue;
    }
    if( o.duplicate === 'array' || o.duplicate === 'array-with-value' )
    {
      if( o.dst[ e ] === undefined )
      o.dst[ e ] = o.duplicate === 'array-with-value' ? [ e ] : [];
      o.dst[ e ].push( k );
    }
    else
    {
      _.assert( o.dst[ e ] === undefined,'Cant invert the map, it has several keys with value',o.src[ k ] );
      o.dst[ e ] = k;
    }
  }

  /* */

  if( o.duplicate === 'delete' )
  _.mapDelete( o.dst,del );

  return o.dst;
}

mapInvert.defaults =
{
  src : null,
  dst : null,
  duplicate : 'error',
}

//

function mapInvertDroppingDuplicates( src,dst )
{
  var dst = dst || Object.create( null );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( src ) );

  var drop;

  for( var s in src )
  {
    if( dst[ src[ s ] ] !== undefined )
    {
      drop = drop || Object.create( null );
      drop[ src[ s ] ] = true;
    }
    dst[ src[ s ] ] = s;
  }

  if( drop )
  for( var d in drop )
  {
    delete dst[ d ];
  }

  return dst;
}

//

function mapsFlatten( o )
{

  if( _.arrayIs( o ) )
  o = { src : o }

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapsFlatten,o );
  _.assert( _.arrayIs( o.src ) )

  o.result = o.result || Object.create( null );

  function extend( r,s )
  {
    if( o.assertingUniqueness )
    _.assertMapHasNone( r,s );
    _.mapExtend( r,s );
  }

  for( var a = 0 ; a < o.src.length ; a++ )
  {

    var src = o.src[ a ];

    if( !_.longIs( src ) )
    {
      _.assert( _.objectLike( src ) );
      if( src !== undefined )
      extend( o.result, src );
      continue;
    }

    mapsFlatten
    ({
      src : src,
      result : o.result,
      assertingUniqueness : o.assertingUniqueness,
    });

    // for( var s = 0 ; s < src.length ; s++ )
    // {
    //   if( _.arrayIs( src[ s ] ) )
    //   mapsFlatten
    //   ({
    //     src : src[ s ],
    //     result : o.result,
    //     assertingUniqueness : o.assertingUniqueness,
    //   });
    //   else if( _.objectIs( src[ s ] ) )
    //   extend( o.result, src );
    //   else
    //   throw _.err( 'array should have only maps' );
    // }

  }

  return o.result;
}

mapsFlatten.defaults =
{
  src : null,
  result : null,
  assertingUniqueness : 1,
}

//

/**
 * The mapToArray() converts an object {-srcMap-} into array [ [ key, value ] ... ].
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if ( arguments.length === 1 ) and {-srcMap-} is an object.
 * If true, it returns a list of [ [ key, value ] ... ] pairs.
 * Otherwise it throws an Error.
 *
 * @param { objectLike } src - object to get a list of [ key, value ] pairs.
 *
 * @example
 * // returns [ [ 'a', 3 ], [ 'b', 13 ], [ 'c', 7 ] ]
 * _.mapToArray( { a : 3, b : 13, c : 7 } );
 *
 * @returns { array } Returns a list of [ [ key, value ] ... ] pairs.
 * @function mapToArray
 * @throws { Error } Will throw an Error if( arguments.length !== 1 ) or {-srcMap-} is not an object.
 * @memberof wTools
 */

function mapToArray( src )
{
  return _.mapPairs( src );
}

//

/**
 * The mapToStr() routine converts and returns the passed object {-srcMap-} to the string.
 *
 * It takes an object and two strings (keyValSep) and (tupleSep),
 * checks if (keyValSep and tupleSep) are strings.
 * If false, it assigns them defaults ( ' : ' ) to the (keyValSep) and
 * ( '; ' ) to the tupleSep.
 * Otherwise, it returns a string representing the passed object {-srcMap-}.
 *
 * @param { objectLike } src - The object to convert to the string.
 * @param { string } [ keyValSep = ' : ' ] keyValSep - colon.
 * @param { string } [ tupleSep = '; ' ] tupleSep - semicolon.
 *
 * @example
 * // returns 'a : 1; b : 2; c : 3; d : 4'
 * _.mapToStr( { a : 1, b : 2, c : 3, d : 4 }, ' : ', '; ' );
 *
 * @example
 * // returns '0 : 1; 1 : 2; 2 : 3';
 * _.mapToStr( [ 1, 2, 3 ], ' : ', '; ' );
 *
 * @example
 * // returns '0 : a; 1 : b; 2 : c';
 * _.mapToStr( 'abc', ' : ', '; ' );
 *
 * @returns { string } Returns a string (result) representing the passed object {-srcMap-}.
 * @function mapToStr
 * @memberof wTools
 */

function mapToStr( o )
{

  if( _.strIs( o ) )
  o = { src : o }

  _.routineOptions( mapToStr,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  var result = '';
  for( var s in o.src )
  {
    result += s + o.valKeyDelimeter + o.src[ s ] + o.entryDelimeter;
  }

  result = result.substr( 0,result.length-o.entryDelimeter.length );

  return result
}

mapToStr.defaults =
{
  src : null,
  valKeyDelimeter : ':',
  entryDelimeter : ';',
}

// --
// map selector
// --

function _mapEnumerableKeys( srcMap,own )
{
  var result = [];

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !_.primitiveIs( srcMap ) );

  if( own )
  {
    for( var k in srcMap )
    if( _ObjectHasOwnProperty.call( srcMap,k ) )
    result.push( k );
  }
  else
  {
    for( var k in srcMap )
    result.push( k );
  }

  return result;
}


//

function _mapKeys( o )
{
  var result = [];

  _.routineOptions( _mapKeys,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectLike( o ) );
  _.assert( !( o.srcMap instanceof Map ),'not implemented' );
  _.assert( o.selectFilter === null || _.routineIs( o.selectFilter ) );

  /* */

  function filter( srcMap,keys )
  {

    if( !o.selectFilter )
    {
      _.arrayAppendArrayOnce( result,keys );
    }
    else for( var k = 0 ; k < keys.length ; k++ )
    {
      var e = o.selectFilter( srcMap,keys[ k ] );
      if( e !== undefined )
      _.arrayAppendOnce( result,e );
    }
  }

  /* */

  if( o.enumerable )
  {

    filter( o.srcMap,_._mapEnumerableKeys( o.srcMap,o.own ) );

  }
  else
  {

    if( o.own  )
    {
      filter( o.srcMap,Object.getOwnPropertyNames( o.srcMap ) );
    }
    else
    {
      var proto = o.srcMap;
      result = [];
      do
      {
        filter( proto,Object.getOwnPropertyNames( proto ) );
        proto = Object.getPrototypeOf( proto );
      }
      while( proto );
    }

  }

  /* */

  return result;
}

_mapKeys.defaults =
{
  srcMap : null,
  own : 0,
  enumerable : 1,
  selectFilter : null,
}

//

/**
 * This routine returns an array of a given objects enumerable properties,
 * in the same order as that provided by a for...in loop.
 * Accept single object. Each element of result array is unique.
 * Unlike standard [Object.keys]{@https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/keys}
 * which accept object only mapKeys accept any object-like entity.
 *
 * @see {@link wTools.mapOwnKeys} - Similar routine taking into account own elements only.
 * @see {@link wTools.mapVals} - Similar routine returning values.
 *
 * @example
 * // returns [ "a", "b" ]
 * _.mapKeys({ a : 7, b : 13 });
 *
 * @example
 * // returns [ "a" ]
 * var o = { own : 1, enumerable : 0 };
 * _.mapKeys.call( o, { a : 1 } );
 *
 * @param { objectLike } srcMap - object of interest to extract keys.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.own = false ] - count only object`s own properties.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 * @return { array } Returns an array with unique string elements.
 * corresponding to the enumerable properties found directly upon object or empty array
 * if nothing found.
 * @function mapKeys
 * @throws { Exception } Throw an exception if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapKeys( srcMap )
{
  var result;
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapKeys, o );
  _.assert( !_.primitiveIs( srcMap ) );

  o.srcMap = srcMap;

  if( o.enumerable )
  result = _._mapEnumerableKeys( o.srcMap, o.own );
  else
  result = _._mapKeys( o );

  return result;
}

mapKeys.defaults =
{
  own : 0,
  enumerable : 1,
}

//

/**
 * The mapOwnKeys() returns an array of a given object`s own enumerable properties,
 * in the same order as that provided by a for...in loop. Each element of result array is unique.
 *
 * @param { objectLike } srcMap - The object whose properties keys are to be returned.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns [ "a", "b" ]
 * _.mapOwnKeys({ a : 7, b : 13 });
 *
 * * @example
 * // returns [ "a" ]
 * var o = { enumerable : 0 };
 * _.mapOwnKeys.call( o, { a : 1 } );
 *
 * @return { array } Returns an array whose elements are strings
 * corresponding to the own enumerable properties found directly upon object or empty
 * array if nothing found.
 * @function mapOwnKeys
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
*/

function mapOwnKeys( srcMap )
{
  var result;
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( o,mapOwnKeys.defaults );
  _.assert( !_.primitiveIs( srcMap ) );

  o.srcMap = srcMap;
  o.own = 1;

  if( o.enumerable )
  result = _._mapEnumerableKeys( o.srcMap,o.own );
  else
  result = _._mapKeys( o );

  if( !o.enumerable )
  debugger;

  return result;
}

mapOwnKeys.defaults =
{
  enumerable : 1,
}

//

/**
 * The mapAllKeys() returns all properties of provided object as array,
 * in the same order as that provided by a for...in loop. Each element of result array is unique.
 *
 * @param { objectLike } srcMap - The object whose properties keys are to be returned.
 *
 * @example
 * // returns [ "a", "b", "__defineGetter__", ... "isPrototypeOf" ]
 * var x = { a : 1 };
 * var y = { b : 2 };
 * Object.setPrototypeOf( x, y );
 * _.mapAllKeys( x );
 *
 * @return { array } Returns an array whose elements are strings
 * corresponding to the all properties found on the object.
 * @function mapAllKeys
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @memberof wTools
*/

function mapAllKeys( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( o,mapAllKeys.defaults );
  _.assert( !_.primitiveIs( srcMap ) );

  o.srcMap = srcMap;
  o.own = 0;
  o.enumerable = 0;

  var result = _._mapKeys( o );

  debugger;
  return result;
}

mapAllKeys.defaults =
{
}

//

function _mapVals( o )
{

  _.routineOptions( _mapVals,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.selectFilter === null || _.routineIs( o.selectFilter ) );
  _.assert( o.selectFilter === null );

  // var selectFilter = o.selectFilter;
  //
  // if( o.selectFilter )
  // debugger;
  //
  // if( !o.selectFilter )
  // o.selectFilter = function getVal( srcMap,k )
  // {
  //   return srcMap[ k ]
  // }

  var result = _._mapKeys( o );

  for( var k = 0 ; k < result.length ; k++ )
  {
    result[ k ] = o.srcMap[ result[ k ] ];
  }

  return result;
}

_mapVals.defaults =
{
  srcMap : null,
  own : 0,
  enumerable : 1,
  selectFilter : null,
}

//

/**
 * The mapVals() routine returns an array of a given object's
 * enumerable property values, in the same order as that provided by a for...in loop.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns an array of values,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - The object whose property values are to be returned.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.own = false ] - count only object`s own properties.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns [ "7", "13" ]
 * _.mapVals( { a : 7, b : 13 } );
 *
 * @example
 * var o = { own : 1 };
 * var a = { a : 7 };
 * var b = { b : 13 };
 * Object.setPrototypeOf( a, b );
 * _.mapVals.call( o, a )
 * // returns [ 7 ]
 *
 * @returns { array } Returns an array whose elements are strings.
 * corresponding to the enumerable property values found directly upon object.
 * @function mapVals
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapVals( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapVals, o );
  _.assert( !_.primitiveIs( srcMap ) );

  o.srcMap = srcMap;

  var result = _._mapVals( o );

  return result;
}

mapVals.defaults =
{
  own : 0,
  enumerable : 1,
}

//

/**
 * The mapOwnVals() routine returns an array of a given object's
 * own enumerable property values,
 * in the same order as that provided by a for...in loop.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns an array of values,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - The object whose property values are to be returned.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns [ "7", "13" ]
 * _.mapOwnVals( { a : 7, b : 13 } );
 *
 * @example
 * var o = { enumerable : 0 };
 * var a = { a : 7 };
 * Object.defineProperty( a, 'x', { enumerable : 0, value : 1 } )
 * _.mapOwnVals.call( o, a )
 * // returns [ 7, 1 ]
 *
 * @returns { array } Returns an array whose elements are strings.
 * corresponding to the enumerable property values found directly upon object.
 * @function mapOwnVals
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapOwnVals( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( o,mapVals.defaults );
  _.assert( !_.primitiveIs( srcMap ) );

  o.srcMap = srcMap;
  o.own = 1;

  var result = _._mapVals( o );

  debugger;
  return result;
}

mapOwnVals.defaults =
{
  enumerable : 1,
}

//

/**
 * The mapAllVals() returns values of all properties of provided object as array,
 * in the same order as that provided by a for...in loop.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns an array of values,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - The object whose property values are to be returned.
 *
 * @example
 * // returns [ "7", "13", function __defineGetter__(), ... function isPrototypeOf() ]
 * _.mapAllVals( { a : 7, b : 13 } );
 *
 * @returns { array } Returns an array whose elements are strings.
 * corresponding to the enumerable property values found directly upon object.
 * @function mapAllVals
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @memberof wTools
 */

function mapAllVals( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( o,mapAllVals.defaults );
  _.assert( !_.primitiveIs( srcMap ) );

  o.srcMap = srcMap;
  o.own = 0;
  o.enumerable = 0;

  var result = _._mapVals( o );

  debugger;
  return result;
}

mapAllVals.defaults =
{
}

//

function _mapPairs( o )
{

  _.routineOptions( _mapPairs,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.selectFilter === null || _.routineIs( o.selectFilter ) );
  _.assert( !_.primitiveIs( o.srcMap ) );

  var selectFilter = o.selectFilter;

  if( o.selectFilter )
  debugger;

  if( !o.selectFilter )
  o.selectFilter = function getVal( srcMap,k )
  {
    return [ k,srcMap[ k ] ];
  }

  var result = _._mapKeys( o );

  return result;
}

_mapPairs.defaults =
{
  srcMap : null,
  own : 0,
  enumerable : 1,
  selectFilter : null,
}

//

/**
 * The mapPairs() converts an object into a list of unique [ key, value ] pairs.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns a list of [ key, value ] pairs if they exist,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - Object to get a list of [ key, value ] pairs.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.own = false ] - count only object`s own properties.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns [ [ "a", 7 ], [ "b", 13 ] ]
 * _.mapPairs( { a : 7, b : 13 } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapPairs.call( { own : 1 }, a );
 * //returns [ [ "a", 1 ] ]
 *
 * @returns { array } A list of [ key, value ] pairs.
 * @function mapPairs
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapPairs( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( o,mapPairs.defaults );

  o.srcMap = srcMap;

  var result = _._mapPairs( o );

  return result;
}

mapPairs.defaults =
{
  own : 0,
  enumerable : 1,
}

//

/**
 * The mapOwnPairs() converts an object's own properties into a list of [ key, value ] pairs.
 *
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns a list of [ key, value ] pairs of object`s own properties if they exist,
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - Object to get a list of [ key, value ] pairs.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns [ [ "a", 7 ], [ "b", 13 ] ]
 * _.mapOwnPairs( { a : 7, b : 13 } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapOwnPairs( a );
 * //returns [ [ "a", 1 ] ]
 *
 * @example
 * var a = { a : 1 };
 * _.mapOwnPairs.call( { enumerable : 0 }, a );
 *
 * @returns { array } A list of [ key, value ] pairs.
 * @function mapOwnPairs
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapOwnPairs( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( o,mapPairs.defaults );

  o.srcMap = srcMap;
  o.own = 1;

  var result = _._mapPairs( o );

  debugger;
  return result;
}

mapOwnPairs.defaults =
{
  enumerable : 1,
}

//

/**
 * The mapAllPairs() converts all properties of the object {-srcMap-} into a list of unique [ key, value ] pairs.
 *
 * It takes an object {-srcMap-} creates an empty array,
 * checks if {-srcMap-} is an object.
 * If true, it returns a list of [ key, value ] pairs that repesents all properties of provided object{-srcMap-},
 * otherwise it returns an empty array.
 *
 * @param { objectLike } srcMap - Object to get a list of [ key, value ] pairs.
 *
 * @example
 * // returns [ [ "a", 7 ], [ "b", 13 ], ... [ "isPrototypeOf", function isPrototypeOf() ] ]
 * _.mapAllPairs( { a : 7, b : 13 } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapAllPairs( a );
 * //returns [ [ "a", 1 ],[ "b", 2 ], ... [ "isPrototypeOf", function isPrototypeOf() ]  ]
 *
 * @returns { array } A list of [ key, value ] pairs.
 * @function mapAllPairs
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @memberof wTools
 */

function mapAllPairs( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( o,mapAllPairs.defaults );

  o.srcMap = srcMap;
  o.own = 0;
  o.enumerable = 0;

  var result = _._mapPairs( o );

  debugger;
  return result;
}

mapAllPairs.defaults =
{
}

//

function _mapProperties( o )
{
  var result = Object.create( null );

  _.routineOptions( _mapProperties,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( !_.primitiveIs( o.srcMap ) );

  var keys = _._mapKeys( o );

  for( var k = 0 ; k < keys.length ; k++ )
  {
    result[ keys[ k ] ] = o.srcMap[ keys[ k ] ];
  }

  return result;
}

_mapProperties.defaults =
{
  srcMap : null,
  own : 0,
  enumerable : 1,
  selectFilter : null,
}

//

/**
 * The mapProperties() gets enumerable properties of the object{-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies unique enumerable properties of the provided object to the new map using
 * their original name/value and returns the result,
 * otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of enumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.own = false ] - count only object`s own properties.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns { a : 7, b : 13 }
 * _.mapProperties( { a : 7, b : 13 } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapProperties( a );
 * //returns { a : 1, b : 2 }
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapProperties.call( { own : 1 }, a )
 * //returns { a : 1 }
 *
 * @returns { object } A new map with unique enumerable properties from source{-srcMap-}.
 * @function mapProperties
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapProperties( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapProperties,o );

  o.srcMap = srcMap;

  var result = _._mapProperties( o );
  return result;
}

mapProperties.defaults =
{
  own : 0,
  enumerable : 1,
}

//

/**
 * The mapOwnProperties() gets the object's {-srcMap-} own enumerable properties and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object's own enumerable properties to the new map using
 * their original name/value and returns the result,
 * otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s own enumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns { a : 7, b : 13 }
 * _.mapOwnProperties( { a : 7, b : 13 } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapOwnProperties( a );
 * //returns { a : 1 }
 *
 * @example
 * var a = { a : 1 };
 * Object.defineProperty( a, 'b', { enumerable : 0, value : 2 } );
 * _.mapOwnProperties.call( { enumerable : 0 }, a )
 * //returns { a : 1, b : 2 }
 *
 * @returns { object } A new map with source {-srcMap-} own enumerable properties.
 * @function mapOwnProperties
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapOwnProperties( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapOwnProperties,o );

  o.srcMap = srcMap;
  o.own = 1;

  var result = _._mapProperties( o );
  return result;
}

mapOwnProperties.defaults =
{
  enumerable : 1,
}

//

/**
 * The mapAllProperties() gets all properties from provided object {-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies all unique object's properties to the new map using
 * their original name/value and returns the result,
 * otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of all object`s properties.
 *
 * @example
 * // returns { a : 7, b : 13, __defineGetter__ : function...}
 * _.mapAllProperties( { a : 7, b : 13 } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapAllProperties( a );
 * //returns { a : 1, b : 2, __defineGetter__ : function...}
 *
 * @returns { object } A new map with all unique properties from source {-srcMap-}.
 * @function mapAllProperties
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapAllProperties( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapAllProperties,o );

  o.srcMap = srcMap;
  o.own = 0;
  o.enumerable = 0;

  var result = _._mapProperties( o );
  return result;
}

mapAllProperties.defaults =
{
}

//

/**
 * The mapRoutines() gets enumerable properties that contains routines as value from the object {-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies unique enumerable properties that holds routines from source {-srcMap-} to the new map using
 * original name/value of the property and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s properties.
 * @param { objectLike } o - routine options, can be provided through routine`s context.
 * @param { boolean } [ o.own = false ] - count only object`s own properties.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns { f : function(){} }
 * _.mapRoutines( { a : 7, b : 13, f : function(){} } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapRoutines( a )
 * //returns { f : function(){} }
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapRoutines.call( { own : 1 }, a )
 * //returns {}
 *
 * @returns { object } A new map with unique enumerable routine properties from source {-srcMap-}.
 * @function mapRoutines
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */


function mapRoutines( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapRoutines,o );

  o.srcMap = srcMap;
  o.selectFilter = function selectRoutine( srcMap, k )
  {
    debugger;
    if( _.routineIs( srcMap[ k ] ) )
    return k;
    debugger;
  }

  debugger;
  var result = _._mapProperties( o );
  return result;
}

mapRoutines.defaults =
{
  own : 0,
  enumerable : 1,
}

//

/**
 * The mapOwnRoutines() gets object`s {-srcMap-} own enumerable properties that contains routines as value and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object`s {-srcMap-} own unique enumerable properties that holds routines to the new map using
 * original name/value of the property and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s properties.
 * @param { objectLike } o - routine options, can be provided through routine`s context.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns { f : function(){} }
 * _.mapOwnRoutines( { a : 7, b : 13, f : function(){} } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapOwnRoutines( a )
 * //returns {}
 *
 * @example
 * var a = { a : 1 };
 * Object.defineProperty( a, 'b', { enumerable : 0, value : function(){} } );
 * _.mapOwnRoutines.call( { enumerable : 0 }, a )
 * //returns { b : function(){} }
 *
 * @returns { object } A new map with unique object`s own enumerable routine properties from source {-srcMap-}.
 * @function mapOwnRoutines
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapOwnRoutines( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapOwnRoutines,o );

  o.srcMap = srcMap;
  o.own = 1;
  o.selectFilter = function selectRoutine( srcMap,k )
  {
    debugger;
    if( _.routineIs( srcMap[ k ] ) )
    return k;
    debugger;
  }

  debugger;
  var result = _._mapProperties( o );
  return result;
}

mapOwnRoutines.defaults =
{
  enumerable : 1,
}

//

/**
 * The mapAllRoutines() gets all properties of object {-srcMap-} that contains routines as value and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies all unique properties of source {-srcMap-} that holds routines to the new map using
 * original name/value of the property and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Source to get a map of object`s properties.
 *
 * @example
 * // returns { f : function, __defineGetter__ : function...}
 * _.mapAllRoutines( { a : 7, b : 13, f : function(){} } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, f : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapAllRoutines( a )
 * // returns { f : function, __defineGetter__ : function...}
 *
 *
 * @returns { object } A new map with all unique object`s {-srcMap-} properties that are routines.
 * @function mapAllRoutines
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapAllRoutines( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapAllRoutines,o );

  o.srcMap = srcMap;
  o.own = 0;
  o.enumerable = 0;
  o.selectFilter = function selectRoutine( srcMap,k )
  {
    debugger;
    if( _.routineIs( srcMap[ k ] ) )
    return k;
  }

  debugger;
  var result = _._mapProperties( o );
  return result;
}

mapAllRoutines.defaults =
{
}

//

/**
 * The mapFields() gets enumerable fields( all properties except routines ) of the object {-srcMap-} and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies unique enumerable properties of the provided object {-srcMap-} that are not routines to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of enumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.own = false ] - count only object`s own properties.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns { a : 7, b : 13 }
 * _.mapFields( { a : 7, b : 13, c : function(){} } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapFields( a );
 * //returns { a : 1, b : 2 }
 *
 * @example
 * var a = { a : 1, x : function(){} };
 * var b = { b : 2 };
 * Object.setPrototypeOf( a, b );
 * _.mapFields.call( { own : 1 }, a )
 * //returns { a : 1 }
 *
 * @returns { object } A new map with unique enumerable fields( all properties except routines ) from source {-srcMap-}.
 * @function mapFields
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapFields( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapFields,o );

  o.srcMap = srcMap;
  o.selectFilter = function selectRoutine( srcMap,k )
  {
    if( !_.routineIs( srcMap[ k ] ) )
    return k;
  }

  var result = _._mapProperties( o );
  return result;
}

mapFields.defaults =
{
  own : 0,
  enumerable : 1,
}

//

/**
 * The mapOwnFields() gets object`s {-srcMap-} own enumerable fields( all properties except routines ) and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object`s own enumerable properties that are not routines to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of enumerable properties.
 * @param { objectLike } o - routine options can be provided through routine`s context.
 * @param { boolean } [ o.enumerable = true ] - count only object`s enumerable properties.
 *
 * @example
 * // returns { a : 7, b : 13 }
 * _.mapOwnFields( { a : 7, b : 13, c : function(){} } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapOwnFields( a );
 * //returns { a : 1 }
 *
 * @example
 * var a = { a : 1, x : function(){} };
 * Object.defineProperty( a, 'b', { enumerable : 0, value : 2 } )
 * _.mapFields.call( { enumerable : 0 }, a )
 * //returns { a : 1, b : 2 }
 *
 * @returns { object } A new map with object`s {-srcMap-} own enumerable fields( all properties except routines ).
 * @function mapOwnFields
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapOwnFields( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapOwnFields,o );

  o.srcMap = srcMap;
  o.own = 1;
  o.selectFilter = function selectRoutine( srcMap,k )
  {
    if( !_.routineIs( srcMap[ k ] ) )
    return k;
  }

  var result = _._mapProperties( o );
  return result;
}

mapOwnFields.defaults =
{
  enumerable : 1,
}

//

/**
 * The mapAllFields() gets all object`s {-srcMap-} fields( properties except routines ) and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies all object`s properties that are not routines to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of all properties.
 *
 * @example
 * // returns { a : 7, b : 13, __proto__ : Object }
 * _.mapAllFields( { a : 7, b : 13, c : function(){} } );
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapAllFields( a );
 * //returns { a : 1, b : 2, __proto__ : Object }
 *
 * @example
 * var a = { a : 1, x : function(){} };
 * Object.defineProperty( a, 'b', { enumerable : 0, value : 2 } )
 * _.mapAllFields( a );
 * //returns { a : 1, b : 2, __proto__ : Object }
 *
 * @returns { object } A new map with all fields( properties except routines ) from source {-srcMap-}.
 * @function mapAllFields
 * @throws { Error } Will throw an Error if {-srcMap-} is not an objectLike entity.
 * @throws { Error } Will throw an Error if unknown option is provided.
 * @memberof wTools
 */

function mapAllFields( srcMap )
{
  var o = this === Self ? Object.create( null ) : this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( mapAllFields,o );

  o.srcMap = srcMap;
  o.own = 0;
  o.enumerable = 0;
  o.selectFilter = function selectRoutine( srcMap,k )
  {
    if( !_.routineIs( srcMap[ k ] ) )
    return k;
  }

  if( _.routineIs( srcMap ) )
  o.selectFilter = function selectRoutine( srcMap,k )
  {
    if( _.arrayHas( [ 'arguments', 'caller' ], k ) )
    return;
    if( !_.routineIs( srcMap[ k ] ) )
    return k;
  }

  var result = _._mapProperties( o );
  return result;
}

mapAllFields.defaults =
{
}

//

/**
 * The mapOnlyPrimitives() gets all object`s {-srcMap-} enumerable atomic fields( null,undef,number,string,symbol ) and returns them as new map.
 *
 * It takes an object {-srcMap-} creates an empty map,
 * checks if {-srcMap-} is an object.
 * If true, it copies object`s {-srcMap-} enumerable atomic properties to the new map using
 * their original name/value and returns the result, otherwise it returns empty map.
 *
 * @param { objectLike } srcMap - Object to get a map of atomic properties.
 *
 * @example
 * var a = {};
 * Object.defineProperty( a, 'x', { enumerable : 0, value : 3 } )
 * _.mapOnlyPrimitives( a );
 * // returns { }
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2, c : function(){} };
 * Object.setPrototypeOf( a, b );
 * _.mapOnlyPrimitives( a );
 * //returns { a : 1, b : 2 }
 *
 * @returns { object } A new map with all atomic fields from source {-srcMap-}.
 * @function mapOnlyPrimitives
 * @throws { Error } Will throw an Error if {-srcMap-} is not an Object.
 * @memberof wTools
 */

function mapOnlyPrimitives( srcMap )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( !_.primitiveIs( srcMap ) );

  var result = _.mapExtendConditional( _.field.mapper.primitive, Object.create( null ), srcMap );
  return result;
}

//

/**
 * The mapFirstPair() routine returns first pair [ key, value ] as array.
 *
 * @param { objectLike } srcMap - An object like entity of get first pair.
 *
 * @example
 * // returns [ 'a', 3 ]
 * _.mapFirstPair( { a : 3, b : 13 } );
 *
 * @example
 * // returns 'undefined'
 * _.mapFirstPair( {  } );
 *
 * @example
 * // returns [ '0', [ 'a', 7 ] ]
 * _.mapFirstPair( [ [ 'a', 7 ] ] );
 *
 * @returns { Array } Returns pair [ key, value ] as array if {-srcMap-} has fields, otherwise, undefined.
 * @function mapFirstPair
 * @throws { Error } Will throw an Error if (arguments.length) less than one, if {-srcMap-} is not an object-like.
 * @memberof wTools
 */

function mapFirstPair( srcMap )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectLike( srcMap ) );

  for( var s in srcMap )
  {
    return [ s,srcMap[ s ] ];
  }

  return [];
}

//

function mapValsSet( dstMap, val )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  for( var k in dstMap )
  {
    dstMap[ k ] = val;
  }

  return dstMap;
}

//

function mapSelect( srcMap, keys )
{
  var result = Object.create( null );

  _.assert( _.arrayLike( keys ) );
  _.assert( !_.primitiveIs( srcMap ) );

  for( var k = 0 ; k < keys.length ; k++ )
  {
    var key = keys[ k ];
    _.assert( _.strIs( key ) || _.numberIs( key ) );
    result[ key ] = srcMap[ key ];
  }

  return result;
}

//

/**
 * The mapValWithIndex() returns value of {-srcMap-} by corresponding (index).
 *
 * It takes {-srcMap-} and (index), creates a variable ( i = 0 ),
 * checks if ( index > 0 ), iterate over {-srcMap-} object-like and match
 * if ( i == index ).
 * If true, it returns value of {-srcMap-}.
 * Otherwise it increment ( i++ ) and iterate over {-srcMap-} until it doesn't match index.
 *
 * @param { objectLike } srcMap - An object-like.
 * @param { number } index - To find the position an element.
 *
 * @example
 * // returns 7
 * _.mapValWithIndex( [ 3, 13, 'c', 7 ], 3 );
 *
 * @returns { * } Returns value of {-srcMap-} by corresponding (index).
 * @function mapValWithIndex
 * @throws { Error } Will throw an Error if( arguments.length > 2 ) or {-srcMap-} is not an Object.
 * @memberof wTools
 */

function mapValWithIndex( srcMap,index )
{

 _.assert( arguments.length === 2, 'expects exactly two arguments' );
 _.assert( !_.primitiveIs( srcMap ) );

  if( index < 0 ) return;

  var i = 0;
  for( var s in srcMap )
  {
    if( i == index ) return srcMap[s];
    i++;
  }
}

//

/**
 * The mapKeyWithIndex() returns key of {-srcMap-} by corresponding (index).
 *
 * It takes {-srcMap-} and (index), creates a variable ( i = 0 ),
 * checks if ( index > 0 ), iterate over {-srcMap-} object-like and match
 * if ( i == index ).
 * If true, it returns value of {-srcMap-}.
 * Otherwise it increment ( i++ ) and iterate over {-srcMap-} until it doesn't match index.
 *
 * @param { objectLike } srcMap - An object-like.
 * @param { number } index - To find the position an element.
 *
 * @example
 * // returns '1'
 * _.mapKeyWithIndex( [ 'a', 'b', 'c', 'd' ], 1 );
 *
 * @returns { string } Returns key of {-srcMap-} by corresponding (index).
 * @function mapKeyWithIndex
 * @throws { Error } Will throw an Error if( arguments.length > 2 ) or {-srcMap-} is not an Object.
 * @memberof wTools
 */

function mapKeyWithIndex( srcMap, index )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !_.primitiveIs( srcMap ) );

  if( index < 0 )
  return;

  var i = 0;
  for( var s in srcMap )
  {
    if( i == index ) return s;
    i++;
  }

}

//

function mapKeyWithValue( srcMap, value )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !_.primitiveIs( srcMap ) );



}

//

function mapIndexWithKey( srcMap, key )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !_.primitiveIs( srcMap ) );

  for( var s in srcMap )
  {
    if( s === key )
    return s;
  }

  return;
}

//

function mapIndexWithValue( srcMap,value )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !_.primitiveIs( srcMap ) );

  for( var s in srcMap )
  {
    if( srcMap[ s ] === value )
    return s;
  }

  return;
}

// --
// map logic operator
// --

/**
 * The mapButConditional() routine returns a new object (result)
 * whose (values) are not equal to the arrays or objects.
 *
 * Takes any number of objects.
 * If the first object has same key any other object has
 * then this pair [ key, value ] will not be included into (result) object.
 * Otherwise,
 * it calls a provided callback function( _.field.mapper.primitive )
 * once for each key in the {-srcMap-}, and adds to the (result) object
 * all the [ key, value ],
 * if values are not equal to the array or object.
 *
 * @param { function } filter.primitive() - Callback function to test each [ key, value ] of the {-srcMap-} object.
 * @param { objectLike } srcMap - The target object.
 * @param { ...objectLike } arguments[] - The next objects.
 *
 * @example
 * // returns { a : 1, b : "b" }
 * mapButConditional( _.field.mapper.primitive, { a : 1, b : 'b', c : [ 1, 2, 3 ] } );
 *
 * @returns { object } Returns an object whose (values) are not equal to the arrays or objects.
 * @function mapButConditional
 * @throws { Error } Will throw an Error if {-srcMap-} is not an object.
 * @memberof wTools
 */

function mapButConditional( fieldFilter, srcMap, butMap )
{
  var result = Object.create( null );

  _.assert( arguments.length === 3, 'expects exactly three arguments' );
  _.assert( !_.primitiveIs( butMap ), 'expects map {-butMap-}' );
  _.assert( !_.primitiveIs( srcMap ) && !_.longIs( srcMap ), 'expects map {-srcMap-}' );
  _.assert( fieldFilter && fieldFilter.length === 3 && fieldFilter.functionFamily === 'field-filter', 'expects field-filter {-fieldFilter-}' );

  if( _.arrayLike( butMap ) )
  {

    for( var s in srcMap )
    {

      for( var m = 0 ; m < butMap.length ; m++ )
      {
        if( !fieldFilter( butMap[ m ], srcMap, s ) )
        break;
      }

      if( m === butMap.length )
      result[ s ] = srcMap[ s ];

    }

  }
  else
  {

    for( var s in srcMap )
    {

      if( fieldFilter( butMap, srcMap, s ) )
      {
        result[ s ] = srcMap[ s ];
      }

    }

  }

  return result;
}

//

/**
 * Returns new object with unique keys.
 *
 * Takes any number of objects.
 * Returns new object filled by unique keys
 * from the first {-srcMap-} original object.
 * Values for result object come from original object {-srcMap-}
 * not from second or other one.
 * If the first object has same key any other object has
 * then this pair( key/value ) will not be included into result object.
 * Otherwise pair( key/value ) from the first object goes into result object.
 *
 * @param{ objectLike } srcMap - original object.
 * @param{ ...objectLike } arguments[] - one or more objects.
 * Objects to return an object without repeating keys.
 *
 * @example
 * // returns { c : 3 }
 * mapBut( { a : 7, b : 13, c : 3 }, { a : 7, b : 13 } );
 *
 * @throws { Error }
 *  In debug mode it throws an error if any argument is not object like.
 * @returns { object } Returns new object made by unique keys.
 * @function mapBut
 * @memberof wTools
 */

function mapBut( srcMap, butMap )
{
  var result = Object.create( null );

  if( _.arrayLike( srcMap ) )
  srcMap = _.mapMake.apply( this, srcMap );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !_.primitiveIs( butMap ), 'expects map {-butMap-}' );
  _.assert( !_.primitiveIs( srcMap ) && !_.arrayLike( srcMap ), 'expects map {-srcMap-}' );

  if( _.arrayLike( butMap ) )
  {

    for( var s in srcMap )
    {
      for( var m = 0 ; m < butMap.length ; m++ )
      {
        if( ( s in butMap[ m ] ) )
        break;
      }

      if( m === butMap.length )
      result[ s ] = srcMap[ s ];

    }

  }
  else
  {

    for( var s in srcMap )
    {

      if( !( s in butMap ) )
      {
        result[ s ] = srcMap[ s ];
      }

    }

  }

  return result;
}

//

/**
 * Returns new object with unique keys.
 *
 * Takes any number of objects.
 * Returns new object filled by unique keys
 * from the first {-srcMap-} original object.
 * Values for result object come from original object {-srcMap-}
 * not from second or other one.
 * If the first object has same key any other object has
 * then this pair( key/value ) will not be included into result object.
 * Otherwise pair( key/value ) from the first object goes into result object.
 *
 * @param{ objectLike } srcMap - original object.
 * @param{ ...objectLike } arguments[] - one or more objects.
 * Objects to return an object without repeating keys.
 *
 * @example
 * // returns { c : 3 }
 * mapButIgnoringUndefines( { a : 7, b : 13, c : 3 }, { a : 7, b : 13 } );
 *
 * @throws { Error }
 *  In debug mode it throws an error if any argument is not object like.
 * @returns { object } Returns new object made by unique keys.
 * @function mapButIgnoringUndefines
 * @memberof wTools
 */

function mapButIgnoringUndefines( srcMap, butMap )
{
  var result = Object.create( null );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  return _.mapButConditional( _.field.filter.dstUndefinedSrcNotUndefined, srcMap, butMap );
  // return _.mapButConditional( _.field.filter.dstHasButUndefined, butMap, srcMap );
}

// function mapButIgnoringUndefines( srcMap, butMap )
// {
//   var result = Object.create( null );
//
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//   _.assert( !_.primitiveIs( butMap ), 'expects map {-butMap-}' );
//   _.assert( !_.primitiveIs( srcMap ) && !_.longIs( srcMap ), 'expects map {-srcMap-}' );
//
//   if( _.arrayLike( butMap ) )
//   {
//
//     for( var s in srcMap )
//     {
//
//       if( srcMap[ k ] === undefined )
//       continue;
//
//       for( var m = 0 ; m < butMap.length ; m++ )
//       {
//         if( butMap[ m ][ s ] === undefined )
//         break;
//       }
//
//       if( m === butMap.length )
//       result[ s ] = srcMap[ s ];
//
//     }
//
//   }
//   else
//   {
//
//     for( var s in srcMap )
//     {
//
//       if( srcMap[ k ] === undefined )
//       continue;
//
//       if( butMap[ s ] === undefined )
//       {
//         result[ s ] = srcMap[ s ];
//       }
//
//     }
//
//   }
//
//   return result;
// }
//
//
//
// function mapButIgnoringUndefines( srcMap )
// {
//   var result = Object.create( null );
//   var a,k;
//
//   _.assert( arguments.length >= 2 );
//   _.assert( !_.primitiveIs( srcMap ), 'expects object as argument' );
//
//   for( k in srcMap )
//   {
//
//     for( a = 1 ; a < arguments.length ; a++ )
//     {
//       var argument = arguments[ a ];
//
//       _.assert( !_.primitiveIs( argument ),'argument','#'+a,'is not object' );
//
//       if( k in argument )
//       if( argument[ k ] !== undefined )
//       break;
//
//     }
//     if( a === arguments.length )
//     {
//       result[ k ] = srcMap[ k ];
//     }
//   }
//
//   return result;
// }
//
// //
//
// function mapBut( srcMap )
// {
//   var result = Object.create( null );
//   var a,k;
//
//   _.assert( arguments.length >= 2 );
//   _.assert( !_.primitiveIs( srcMap ),'mapBut :','expects object as argument' );
//
//   for( k in srcMap )
//   {
//     for( a = 1 ; a < arguments.length ; a++ )
//     {
//       var argument = arguments[ a ];
//
//       _.assert( !_.primitiveIs( argument ),'argument','#'+a,'is not object' );
//
//       if( k in argument )
//       break;
//
//     }
//     if( a === arguments.length )
//     {
//       result[ k ] = srcMap[ k ];
//     }
//   }
//
//   return result;
// }
//
//

/**
 * The mapOwnBut() returns new object with unique own keys.
 *
 * Takes any number of objects.
 * Returns new object filled by unique own keys
 * from the first {-srcMap-} original object.
 * Values for (result) object come from original object {-srcMap-}
 * not from second or other one.
 * If {-srcMap-} does not have own properties it skips rest of code and checks another properties.
 * If the first object has same key any other object has
 * then this pair( key/value ) will not be included into result object.
 * Otherwise pair( key/value ) from the first object goes into result object.
 *
 * @param { objectLike } srcMap - The original object.
 * @param { ...objectLike } arguments[] - One or more objects.
 *
 * @example
 * // returns { a : 7 }
 * mapBut( { a : 7, 'toString' : 5 }, { b : 33, c : 77 } );
 *
 * @returns { object } Returns new (result) object with unique own keys.
 * @function mapOwnBut
 * @throws { Error } Will throw an Error if {-srcMap-} is not an object.
 * @memberof wTools
 */

function mapOwnBut( srcMap, butMap )
{
  var result = Object.create( null );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  return _.mapButConditional( _.field.filter.dstNotHasSrcOwn, srcMap, butMap );
}

//

/**
 * @namespace
 * @property { objectLike } screenMaps.screenMap - The first object.
 * @property { ...objectLike } srcMap.arguments[1,...] -
 * The pseudo array (arguments[]) from the first [1] index to the end.
 * @property { object } dstMap - The empty object.
 */

/**
 * The mapOnly() returns an object filled by unique [ key, value ]
 * from others objects.
 *
 * It takes number of objects, creates a new object by three properties
 * and calls the _mapOnly( {} ) with created object.
 *
 * @see  {@link wTools._mapOnly} - See for more information.
 *
 * @param { objectLike } screenMap - The first object.
 * @param { ...objectLike } arguments[] - One or more objects.
 *
 * @example
 * // returns { a : "abc", c : 33, d : "name" };
 * _.mapOnly( { a : 13, b : 77, c : 3, d : 'name' }, { d : 'name', c : 33, a : 'abc' } );
 *
 * @returns { Object } Returns the object filled by unique [ key, value ]
 * from others objects.
 * @function mapOnly
 * @throws { Error } Will throw an Error if (arguments.length < 2) or (arguments.length !== 2).
 * @memberof wTools
 */

function mapOnly( srcMaps, screenMaps )
{

  if( arguments.length === 1 )
  return _.mapsExtend( null, srcMaps );

  _.assert( arguments.length === 1 || arguments.length === 2, 'expects single or two arguments' );

  return _mapOnly
  ({
    srcMaps : srcMaps,
    screenMaps : screenMaps,
    dstMap : Object.create( null ),
  });

}

//

function mapOnlyOwn( srcMaps, screenMaps )
{

  if( arguments.length === 1 )
  return _.mapsExtendConditional( _.field.mapper.srcOwn, null, srcMaps );

  _.assert( arguments.length === 1 || arguments.length === 2, 'expects single or two arguments' );

  return _mapOnly
  ({
    filter : _.field.mapper.srcOwn,
    srcMaps : srcMaps,
    screenMaps : screenMaps,
    dstMap : Object.create( null ),
  });

}

//

function mapOnlyComplementing( srcMaps, screenMaps )
{

  _.assert( arguments.length === 1 || arguments.length === 2, 'expects single or two arguments' );

  return _mapOnly
  ({
    filter : _.field.mapper.dstNotOwnOrUndefinedAssigning,
    srcMaps : srcMaps,
    screenMaps : screenMaps,
    dstMap : Object.create( null ),
  });

}

//

/**
 * @callback  options.filter
 * @param { objectLike } dstMap - An empty object.
 * @param { objectLike } srcMaps - The target object.
 * @param { string } - The key of the (screenMap).
 */

/**
 * The _mapOnly() returns an object filled by unique [ key, value]
 * from others objects.
 *
 * The _mapOnly() checks whether there are the keys of
 * the (screenMap) in the list of (srcMaps).
 * If true, it calls a provided callback function(filter)
 * and adds to the (dstMap) all the [ key, value ]
 * for which callback function returns true.
 *
 * @param { function } [options.filter = filter.bypass()] options.filter - The callback function.
 * @param { objectLike } options.srcMaps - The target object.
 * @param { objectLike } options.screenMaps - The source object.
 * @param { Object } [options.dstMap = Object.create( null )] options.dstMap - The empty object.
 *
 * @example
 * // returns { a : 33, c : 33, name : "Mikle" };
 * var options = Object.create( null );
 * options.dstMap = Object.create( null );
 * options.screenMaps = { 'a' : 13, 'b' : 77, 'c' : 3, 'name' : 'Mikle' };
 * options.srcMaps = { 'a' : 33, 'd' : 'name', 'name' : 'Mikle', 'c' : 33 };
 * _mapOnly( options );
 *
 * @example
 * // returns { a : "abc", c : 33, d : "name" };
 * var options = Object.create( null );
 * options.dstMap = Object.create( null );
 * options.screenMaps = { a : 13, b : 77, c : 3, d : 'name' };
 * options.srcMaps = { d : 'name', c : 33, a : 'abc' };
 * _mapOnly( options );
 *
 * @returns { Object } Returns an object filled by unique [ key, value ]
 * from others objects.
 * @function _mapOnly
 * @throws { Error } Will throw an Error if (options.dstMap or screenMap) are not objects,
 * or if (srcMaps) is not an array
 * @memberof wTools
 */

function _mapOnly( o )
{

  var dstMap = o.dstMap || Object.create( null );
  var screenMap = o.screenMaps;
  var srcMaps = o.srcMaps;

  if( _.arrayIs( screenMap ) )
  screenMap = _.mapMake.apply( this,screenMap );

  if( !_.arrayIs( srcMaps ) )
  srcMaps = [ srcMaps ];

  if( !o.filter )
  o.filter = _.field.mapper.bypass;

  if( Config.debug )
  {

    _.assert( o.filter.functionFamily === 'field-mapper' );
    _.assert( arguments.length === 1, 'expects single argument' );
    _.assert( _.objectLike( dstMap ), 'expects object-like {-dstMap-}' );
    _.assert( !_.primitiveIs( screenMap ), 'expects not primitive {-screenMap-}' );
    _.assert( _.arrayIs( srcMaps ), 'expects array {-srcMaps-}' );
    _.assertMapHasOnly( o,_mapOnly.defaults );

    for( var s = srcMaps.length-1 ; s >= 0 ; s-- )
    _.assert( !_.primitiveIs( srcMaps[ s ] ), 'expects {-srcMaps-}' );

  }

  for( var k in screenMap )
  {

    if( screenMap[ k ] === undefined )
    continue;

    for( var s = srcMaps.length-1 ; s >= 0 ; s-- )
    if( k in srcMaps[ s ] )
    if( srcMaps[ s ][ k ] !== undefined )
    break;

    if( s === -1 )
    continue;

    o.filter.call( this, dstMap, srcMaps[ s ], k );

  }

  return dstMap;
}

_mapOnly.defaults =
{
  dstMap : null,
  srcMaps : null,
  screenMaps : null,
  filter : null,
}

// --
// map sure
// --

function sureMapHasExactly( srcMap, screenMaps, msg )
{
  var result = true;

  result = result && _.sureMapHasOnly( srcMap, screenMaps );
  result = result && _.sureMapHasAll( srcMap, screenMaps );

  return true;
}

//

function sureMapOwnExactly( srcMap, screenMaps, msg )
{
  var result = true;

  result = result && _.sureMapOwnOnly( srcMap, screenMaps );
  result = result && _.sureMapOwnAll( srcMap, screenMaps );

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument.
 *
 * @param {Object} srcMap - source map.
 * @param {...Object} target - object(s) to compare with.
 * @param {String} [ msgs ] - error message as last argument.
 *
 * @example
 * var a = { a : 1, c : 3 };
 * var b = { a : 2, b : 3 };
 * wTools.sureMapHasOnly( a, b );
 *
 * // caught <anonymous>:3:8
 * // Object should have no fields : c
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:3
 *
 * @example
 * var x = { d : 1 };
 * var a = Object.create( x );
 * var b = { a : 1 };
 * wTools.sureMapHasOnly( a, b, 'message' )
 *
 * // caught <anonymous>:4:8
 * // message Object should have no fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:4
 *
 * @function sureMapHasOnly
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @memberof wTools
 *
 */

/* qqq : msg also could be a routine */

function sureMapHasOnly( srcMap, screenMaps, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( arguments.length === 2 || _.strIs( arguments[ 2 ] ) || _.arrayIs( arguments[ 2 ] ) );

  var l = arguments.length;
  var but = Object.keys( _.mapBut( srcMap, screenMaps ) );

  if( but.length > 0 )
  {
    if( _.strJoin && !msg )
    console.error( 'Consider extending object by :\n' + _.strJoin( '  ', but, ' : null,' ).join( '\n' ) );
    debugger;
    throw _err
    ({
      args : [ ( msg ? _.strConcat( msg ) : 'Object should have no fields :' ), _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks only own properties of the objects.
 * Works only in debug mode. Uses StackTrace level 2.@see wTools.err
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument.
 *
 * @param {Object} srcMap - source map.
 * @param {...Object} target - object(s) to compare with.
 * @param {String} [ msgs ] - error message as last argument.
 *
 * @example
 * var x = { d : 1 };
 * var a = Object.create( x );
 * a.a = 5;
 * var b = { a : 2 };
 * wTools.sureMapOwnOnly( a, b ); //no exception
 *
 * @example
 * var a = { d : 1 };
 * var b = { a : 2 };
 * wTools.sureMapOwnOnly( a, b );
 *
 * // caught <anonymous>:3:10
 * // Object should have no own fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:3
 *
 * @example
 * var a = { x : 0, y : 2 };
 * var b = { c : 0, d : 3};
 * var c = { a : 1 };
 * wTools.sureMapOwnOnly( a, b, 'error msg' );
 *
 * // caught <anonymous>:4:8
 * // error msg Object should have no own fields : x,y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:4
 *
 * @function sureMapOwnOnly
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @memberof wTools
 *
 */

function sureMapOwnOnly( srcMap, screenMaps, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( arguments.length === 2 || _.strIs( arguments[ 2 ] ) || _.arrayIs( arguments[ 2 ] ) );

  var l = arguments.length;
  var but = Object.keys( _.mapOwnBut( srcMap, screenMaps ) );

  if( but.length > 0 )
  {
    if( _.strJoin && !msg )
    console.error( 'Consider extending object by :\n' + _.strJoin( '  ',but,' : null,' ).join( '\n' ) );
    debugger;
    throw _err
    ({
      args : [ ( msg ? _.strConcat( msg ) : 'Object should own no fields :' ), _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2.@see wTools.err
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument( msg ).
 *
 * @param {Object} srcMap - source map.
 * @param {Object} all - object to compare with.
 * @param {String} [ msgs ] - error message.
 *
 * @example
 * var x = { a : 1 };
 * var a = Object.create( x );
 * var b = { a : 2 };
 * wTools.sureMapHasAll( a, b );// no exception
 *
 * @example
 * var a = { d : 1 };
 * var b = { a : 2 };
 * wTools.sureMapHasAll( a, b );
 *
 * // caught <anonymous>:3:10
 * // Object should have fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @example
 * var a = { x : 0, y : 2 };
 * var b = { x : 0, d : 3};
 * wTools.sureMapHasAll( a, b, 'error msg' );
 *
 * // caught <anonymous>:4:9
 * // error msg Object should have fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @function sureMapHasAll
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @memberof wTools
 *
 */

function sureMapHasAll( srcMap, all, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( arguments.length === 2 || _.strIs( msg ) );

  // var l = arguments.length;
  var but = Object.keys( _.mapBut( all,srcMap ) );

  if( but.length > 0 )
  {
    debugger;
    throw _err
    ({
      args : [ ( msg ? _.strConcat( msg ) : 'Object should have fields :' ), _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks only own properties of the objects.
 * Works only in Config.debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument( msg ).
 *
 * @param {Object} srcMap - source map.
 * @param {Object} all - object to compare with.
 * @param {String} [ msgs ] - error message.
 *
 * @example
 * var a = { a : 1 };
 * var b = { a : 2 };
 * wTools.sureMapOwnAll( a, b );// no exception
 *
 * @example
 * var a = { a : 1 };
 * var b = { a : 2, b : 2 }
 * wTools.sureMapOwnAll( a, b );
 *
 * // caught <anonymous>:3:8
 * // Object should have own fields : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @example
 * var a = { x : 0 };
 * var b = { x : 1, y : 0};
 * wTools.sureMapHasAll( a, b, 'error msg' );
 *
 * // caught <anonymous>:4:9
 * // error msg Object should have fields : y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapOwnAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @function sureMapOwnAll
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @memberof wTools
 *
 */

function sureMapOwnAll( srcMap, all, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( arguments.length === 2 || _.strIs( msg ) );

  // var l = arguments.length;
  var but = Object.keys( _.mapOwnBut( all,srcMap ) );

  if( but.length > 0 )
  {
    debugger;
    throw _err
    ({
      args : [ ( msg ? _.strConcat( msg ) : 'Object should own fields :' ), _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} has no properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine found some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument( msg ).
 *
 * @param {Object} srcMap - source map.
 * @param {...Object} target - object(s) to compare with.
 * @param {String} [ msg ] - error message as last argument.
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * wTools.sureMapHasNone( a, b );// no exception
 *
 * @example
 * var x = { a : 1 };
 * var a = Object.create( x );
 * var b = { a : 2, b : 2 }
 * wTools.sureMapHasNone( a, b );
 *
 * // caught <anonymous>:4:8
 * // Object should have no fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasAll (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:4
 *
 * @example
 * var a = { x : 0, y : 1 };
 * var b = { x : 1, y : 0 };
 * wTools.sureMapHasNone( a, b, 'error msg' );
 *
 * // caught <anonymous>:3:9
 * // error msg Object should have no fields : x,y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasNone (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:3
 *
 * @function sureMapHasNone
 * @throws {Exception} If map {-srcMap-} contains some properties from other map(s).
 * @memberof wTools
 *
 */

function sureMapHasNone( srcMap, screenMaps, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( arguments.length === 2 || _.strIs( arguments[ 2 ] ) || _.arrayIs( arguments[ 2 ] ) );

  var but = _.mapOnly( srcMap, screenMaps );
  var keys = Object.keys( but );
  if( keys.length )
  {
    debugger;
    throw _err
    ({
      args : [ ( msg ? _.strConcat( msg ) : 'Object should have no fields :' ), _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    return false;
  }

  return true;
}

//

function sureMapOwnNone( srcMap, screenMaps, msg )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );
  _.assert( arguments.length === 2 || _.strIs( msg ) );

  // var l = arguments.length;
  var but = Object.keys( _.mapOnlyOwn( srcMap, screenMaps ) );

  if( but.length )
  {
    debugger;
    throw _err
    ({
      args : [ ( msg ? _.strConcat( msg ) : 'Object should own no fields :' ), _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    return false;
  }

  return true;
}

//

/**
 * Checks if map passed by argument {-srcMap-} not contains undefined properties. Works only in debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine found undefined property it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after first argument.
 *
 * @param {Object} srcMap - source map.
 * @param {String} [ msgs ] - error message for generated exception.
 *
 * @example
 * var map = { a : '1', b : undefined };
 * wTools.sureMapHasNoUndefine( map );
 *
 * // caught <anonymous>:2:8
 * // Object  should have no undefines, but has : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @example
 * var map = { a : undefined, b : '1' };
 * wTools.sureMapHasNoUndefine( map, '"map"');
 *
 * // caught <anonymous>:2:8
 * // Object "map" should have no undefines, but has : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at sureMapHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @function sureMapHasNoUndefine
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If map {-srcMap-} contains undefined property.
 * @memberof wTools
 *
 */

function sureMapHasNoUndefine( srcMap, msg )
{

  _.assert( arguments.length === 1 || arguments.length === 2 )

  var but = [];
  var l = arguments.length;

  for( var s in srcMap )
  if( srcMap[ s ] === undefined )
  but.push( s );

  if( but.length )
  {
    debugger;
    throw _err
    ({
      args : [ 'Object ' + ( msg ? _.strConcat( msg ) : 'should have no undefines, but has' ) + ' : ' + _.strQuote( but ).join( ', ' ) ],
      level : 2,
    });
    return false;
  }

  return true;
}

// --
// map assert
// --

function assertMapHasFields( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapHasExactly.apply( this, arguments );
}

//

function assertMapOwnFields( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapOwnExactly.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument.
 *
 * @param {Object} srcMap - source map.
 * @param {...Object} target - object(s) to compare with.
 * @param {String} [ msgs ] - error message as last argument.
 *
 * @example
 * var a = { a : 1, c : 3 };
 * var b = { a : 2, b : 3 };
 * wTools.assertMapHasOnly( a, b );
 *
 * // caught <anonymous>:3:8
 * // Object should have no fields : c
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:3
 *
 * @example
 * var x = { d : 1 };
 * var a = Object.create( x );
 * var b = { a : 1 };
 * wTools.assertMapHasOnly( a, b, 'message' )
 *
 * // caught <anonymous>:4:8
 * // message Object should have no fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasOnly (file:///.../wTools/staging/Base.s:4188)
 * // at <anonymous>:4
 *
 * @function assertMapHasOnly
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @memberof wTools
 *
 */

function assertMapHasOnly( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapHasOnly.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has only properties represented in object(s) passed after first argument. Checks only own properties of the objects.
 * Works only in debug mode. Uses StackTrace level 2.@see wTools.err
 * If routine found some unique properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument.
 *
 * @param {Object} srcMap - source map.
 * @param {...Object} target - object(s) to compare with.
 * @param {String} [ msgs ] - error message as last argument.
 *
 * @example
 * var x = { d : 1 };
 * var a = Object.create( x );
 * a.a = 5;
 * var b = { a : 2 };
 * wTools.assertMapOwnOnly( a, b ); //no exception
 *
 * @example
 * var a = { d : 1 };
 * var b = { a : 2 };
 * wTools.assertMapOwnOnly( a, b );
 *
 * // caught <anonymous>:3:10
 * // Object should have no own fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:3
 *
 * @example
 * var a = { x : 0, y : 2 };
 * var b = { c : 0, d : 3};
 * var c = { a : 1 };
 * wTools.assertMapOwnOnly( a, b, 'error msg' );
 *
 * // caught <anonymous>:4:8
 * // error msg Object should have no own fields : x,y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapOwnOnly (file:///.../wTools/staging/Base.s:4215)
 * // at <anonymous>:4
 *
 * @function assertMapOwnOnly
 * @throws {Exception} If map {-srcMap-} contains unique property.
 * @memberof wTools
 *
 */

function assertMapOwnOnly( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapOwnOnly.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has no properties represented in object(s) passed after first argument. Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine found some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument( msg ).
 *
 * @param {Object} srcMap - source map.
 * @param {...Object} target - object(s) to compare with.
 * @param {String} [ msg ] - error message as last argument.
 *
 * @example
 * var a = { a : 1 };
 * var b = { b : 2 };
 * wTools.assertMapHasNone( a, b );// no exception
 *
 * @example
 * var x = { a : 1 };
 * var a = Object.create( x );
 * var b = { a : 2, b : 2 }
 * wTools.assertMapHasNone( a, b );
 *
 * // caught <anonymous>:4:8
 * // Object should have no fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasAll (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:4
 *
 * @example
 * var a = { x : 0, y : 1 };
 * var b = { x : 1, y : 0 };
 * wTools.assertMapHasNone( a, b, 'error msg' );
 *
 * // caught <anonymous>:3:9
 * // error msg Object should have no fields : x,y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasNone (file:///.../wTools/staging/Base.s:4518)
 * // at <anonymous>:3
 *
 * @function assertMapHasNone
 * @throws {Exception} If map {-srcMap-} contains some properties from other map(s).
 * @memberof wTools
 *
 */

function assertMapHasNone( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapHasNone.apply( this, arguments );
}

//

function assertMapOwnNone( srcMap, screenMaps, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapOwnNone.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks all enumerable properties.
 * Works only in debug mode. Uses StackTrace level 2.@see wTools.err
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument( msg ).
 *
 * @param {Object} srcMap - source map.
 * @param {Object} all - object to compare with.
 * @param {String} [ msgs ] - error message.
 *
 * @example
 * var x = { a : 1 };
 * var a = Object.create( x );
 * var b = { a : 2 };
 * wTools.assertMapHasAll( a, b );// no exception
 *
 * @example
 * var a = { d : 1 };
 * var b = { a : 2 };
 * wTools.assertMapHasAll( a, b );
 *
 * // caught <anonymous>:3:10
 * // Object should have fields : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @example
 * var a = { x : 0, y : 2 };
 * var b = { x : 0, d : 3};
 * wTools.assertMapHasAll( a, b, 'error msg' );
 *
 * // caught <anonymous>:4:9
 * // error msg Object should have fields : d
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasAll (file:///.../wTools/staging/Base.s:4242)
 * // at <anonymous>:3
 *
 * @function assertMapHasAll
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @memberof wTools
 *
 */

function assertMapHasAll( srcMap, all, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapHasAll.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} has all properties represented in object passed by argument( all ). Checks only own properties of the objects.
 * Works only in Config.debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine did not find some properties in source it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed as last argument( msg ).
 *
 * @param {Object} srcMap - source map.
 * @param {Object} all - object to compare with.
 * @param {String} [ msgs ] - error message.
 *
 * @example
 * var a = { a : 1 };
 * var b = { a : 2 };
 * wTools.assertMapOwnAll( a, b );// no exception
 *
 * @example
 * var a = { a : 1 };
 * var b = { a : 2, b : 2 }
 * wTools.assertMapOwnAll( a, b );
 *
 * // caught <anonymous>:3:8
 * // Object should have own fields : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @example
 * var a = { x : 0 };
 * var b = { x : 1, y : 0};
 * wTools.assertMapHasAll( a, b, 'error msg' );
 *
 * // caught <anonymous>:4:9
 * // error msg Object should have fields : y
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapOwnAll (file:///.../wTools/staging/Base.s:4269)
 * // at <anonymous>:3
 *
 * @function assertMapOwnAll
 * @throws {Exception} If map {-srcMap-} not contains some properties from argument( all ).
 * @memberof wTools
 *
 */

function assertMapOwnAll( srcMap, all, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapOwnAll.apply( this, arguments );
}

//

/**
 * Checks if map passed by argument {-srcMap-} not contains undefined properties. Works only in debug mode. Uses StackTrace level 2. @see wTools.err
 * If routine found undefined property it generates and throws exception, otherwise returns without exception.
 * Also generates error using message passed after first argument.
 *
 * @param {Object} srcMap - source map.
 * @param {String} [ msgs ] - error message for generated exception.
 *
 * @example
 * var map = { a : '1', b : undefined };
 * wTools.assertMapHasNoUndefine( map );
 *
 * // caught <anonymous>:2:8
 * // Object  should have no undefines, but has : b
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @example
 * var map = { a : undefined, b : '1' };
 * wTools.assertMapHasNoUndefine( map, '"map"');
 *
 * // caught <anonymous>:2:8
 * // Object "map" should have no undefines, but has : a
 * //
 * // at _err (file:///.../wTools/staging/Base.s:3707)
 * // at assertMapHasNoUndefine (file:///.../wTools/staging/Base.s:4087)
 * // at <anonymous>:2
 *
 * @function assertMapHasNoUndefine
 * @throws {Exception} If no arguments provided.
 * @throws {Exception} If map {-srcMap-} contains undefined property.
 * @memberof wTools
 *
 */

function assertMapHasNoUndefine( srcMap, msg )
{
  if( Config.debug === false )
  return true;
  return _.sureMapHasNoUndefine.apply( this, arguments );
}

// --
// var
// --

/**
 * Throwen to indicate that operation was aborted by user or other subject.
 *
 * @error ErrorAbort
 * @memberof wTools
 */

function ErrorAbort()
{
  this.message = arguments.length ? _.arrayFrom( arguments ) : 'Aborted';
}

ErrorAbort.prototype = Object.create( Error.prototype );

var error =
{
  ErrorAbort : ErrorAbort,
}

// if( !_global.WTOOLS_PRIVATE )
Error.stackTraceLimit = Infinity;

/**
 * Some Event
 *
 * @event wTools#init
 * @property {string} kind - kind of event( 'init' ).
 * @memberof wTools
 */

// --
// meta
// --

_.Later = function Later()
{
  var d = Object.create( null );
  d.args = arguments;
  _.Later._lates.push( d );
  return d;
}

//

_.Later.replace = function replace( container )
{
  if( arguments.length !== 1 || !container )
  throw Error( 'Expects single argument {-container-}' );
  if( !_.Later._lates.length )
  throw Error( 'No late was done' );

  // debugger;
  var descriptors = _.Later._associatedMap.get( container ) || [];
  _.Later._associatedMap.set( container, descriptors );
  _.Later._lates.forEach( ( d ) =>
  {
    d.container = container;
    // _.Later._associatedLates.push( d );
    descriptors.push( d );
  });
  _.Later._lates = [];
  // debugger;

}

//

_.Later.for = function for_( container )
{
  if( arguments.length !== 1 || !container )
  throw Error( 'Expects single argument {-container-}' );

  var descriptors = _.Later._associatedMap.get( container );
  _.Later._associatedMap.delete( container );

  if( !descriptors )
  throw Error( 'No laters for {-container-} was made' );

  // debugger;

  for( var k in container )
  {
    var d = container[ k ];
    var i = descriptors.indexOf( d );
    if( i !== -1 )
    {
      descriptors.splice( i,1 );
      _.Later._for( k,d );
    }
  }

  // debugger;

  if( descriptors.length )
  throw Error( 'Some laters was not found in the {-container-}' );

}

//

_.Later._for = function _for( key, descriptor )
{

  if( descriptor.args.length === 3 )
  if( !_.arrayIs( descriptor.args[ 2 ] ) )
  descriptor.args[ 2 ] = [ descriptor.args[ 2 ] ];

  // debugger;
  descriptor.container[ key ] = routineCall.apply( _, descriptor.args );
  // debugger;

}

//

_.Later._lates = [];
_.Later._associatedMap = new Map();

// --
// fields
// --

var unrollSymbol = Symbol.for( 'unroll' );

var Fields =
{

  ArrayType : Array,
  error : error,

  accuracy : 1e-7,
  accuracySqrt : 1e-4,
  accuracySqr : 1e-14,

  regexpIdentationRegexp : /(\s*\n(\s*))/g,

}

// --
// routines
// --

var Routines =
{

  // multiplier

  dup : dup,
  multiple : multiple,
  multipleAll : multipleAll,

  // entity iterator

  eachSample : eachSample,
  eachInRange : eachInRange,
  eachInManyRanges : eachInManyRanges,
  eachInMultiRange : eachInMultiRange, /* experimental */

  entityEach : entityEach,
  entityEachName : entityEachName,
  entityEachOwn : entityEachOwn,

  entityAll : entityAll,
  entityAny : entityAny,
  entityNone : entityNone,

  entityMap : entityMap,
  entityFilter : entityFilter,
  _entityFilterDeep : _entityFilterDeep,
  entityFilterDeep : entityFilterDeep,

  each : entityEach,
  eachName : entityEachName,
  eachOwn : entityEachOwn,

  all : entityAll,
  any : entityAny,
  none : entityNone,

  map : entityMap,
  filter : entityFilter,

  // entity modifier

  enityExtend : enityExtend,
  enityExtendAppending : enityExtendAppending,

  entityMake : entityMake,
  entityMakeTivial : entityMakeTivial,

  entityAssign : entityAssign, /* dubious */
  entityAssignFieldFromContainer : entityAssignFieldFromContainer, /* dubious */
  entityAssignField : entityAssignField, /* dubious */

  entityCoerceTo : entityCoerceTo,

  entityFreeze : entityFreeze,

  // entity chacker

  entityHasNan : entityHasNan,
  entityHasUndef : entityHasUndef,

  // entity selector

  entityLength : entityLength,
  entitySize : entitySize, /* dubious */

  entityValueWithIndex : entityValueWithIndex, /* dubious */
  entityKeyWithValue : entityKeyWithValue, /* dubious */

  _selectorMake : _selectorMake,

  entityVals : entityVals,

  _entityMost : _entityMost,
  entityMin : entityMin,
  entityMax : entityMax,

  entityShallowClone : entityShallowClone,

  // error

  errIs : errIs,
  errIsRefined : errIsRefined,
  errIsAttended : errIsAttended,
  errIsAttentionRequested : errIsAttentionRequested,
  errAttentionRequest : errAttentionRequest,

  _err : _err,
  err : err,
  errBriefly : errBriefly,
  errAttend : errAttend,
  errRestack : errRestack,
  errLog : errLog,
  errLogOnce : errLogOnce,

  // sure

  sure : sure,
  sureWithoutDebugger : sureWithoutDebugger,

  // assert

  assert : assert,
  assertWithoutBreakpoint : assertWithoutBreakpoint,
  assertNotTested : assertNotTested,
  assertWarn : assertWarn,

  // type test

  /* !!! requires good tests */

  nothingIs : nothingIs,
  definedIs : definedIs,
  primitiveIs : primitiveIs,
  containerIs : containerIs,
  containerLike : containerLike,

  symbolIs : symbolIs,
  bigIntIs : bigIntIs,

  vectorIs : vectorIs,
  constructorIsVector : constructorIsVector,
  spaceIs : spaceIs,
  constructorIsSpace : constructorIsSpace,

  consequenceIs : consequenceIs,
  consequenceLike : consequenceLike,
  promiseIs : promiseIs,

  typeOf : typeOf,
  prototypeHas : prototypeHas,
  prototypeIs : prototypeIs,
  prototypeIsStandard : prototypeIsStandard,
  constructorIs : constructorIs,
  constructorIsStandard : constructorIsStandard,
  instanceIs : instanceIs,
  instanceIsStandard : instanceIsStandard,
  instanceLike : instanceLike,

  workerIs : workerIs,
  streamIs : streamIs,
  consoleIs : consoleIs,
  printerLike : printerLike,
  printerIs : printerIs,
  loggerIs : loggerIs,
  processIs : processIs,
  processIsDebugged : processIsDebugged,
  definitionIs : definitionIs,

  // routine

  routineIs : routineIs,
  routinesAre : routinesAre,
  routineIsPure : routineIsPure,
  routineHasName : routineHasName,

  _routineJoin : _routineJoin,
  routineJoin : routineJoin,
  routineSeal : routineSeal,

  routineDelayed : routineDelayed,

  routineCall : routineCall,
  routineTolerantCall : routineTolerantCall,

  routinesJoin : routinesJoin,
  _routinesCall : _routinesCall,
  routinesCall : routinesCall,
  routinesCallEvery : routinesCallEvery,
  methodsCall : methodsCall,

  routinesChain : routinesChain,
  routinesCompose : routinesCompose,
  routinesComposeReturningLast : routinesComposeReturningLast,
  routinesComposeReturningBeforeLast : routinesComposeReturningBeforeLast,
  routinesComposeEvery : routinesComposeEvery,
  routinesComposeEveryReturningLast : routinesComposeEveryReturningLast,

  routineOptions : routineOptions,
  assertRoutineOptions : assertRoutineOptions,
  routineOptionsPreservingUndefines : routineOptionsPreservingUndefines,
  assertRoutineOptionsPreservingUndefines : assertRoutineOptionsPreservingUndefines,
  routineOptionsFromThis : routineOptionsFromThis,

  routineExtend : routineExtend,
  routineForPreAndBody : routineForPreAndBody,

  routineVectorize_functor : routineVectorize_functor,

  _equalizerFromMapper : _equalizerFromMapper,
  _comparatorFromEvaluator : _comparatorFromEvaluator,

  bind : null,

  // bool

  boolIs : boolIs,
  boolLike : boolLike,
  boolFrom : boolFrom,

  // number

  numberIs : numberIs,
  numberIsNotNan : numberIsNotNan,
  numberIsFinite : numberIsFinite,
  numberIsInfinite : numberIsInfinite,
  numberIsInt : numberIsInt,

  numbersAre : numbersAre,
  numbersAreIdentical : numbersAreIdentical,
  numbersAreEquivalent : numbersAreEquivalent,
  numbersAreFinite : numbersAreFinite,
  numbersArePositive : numbersArePositive,
  numbersAreInt : numbersAreInt,

  numberInRange : numberInRange,
  numbersTotal : numbersTotal,

  numberFrom : numberFrom,
  numbersFrom : numbersFrom,

  numbersSlice : numbersSlice,

  numberRandomInRange : numberRandomInRange,
  numberRandomInt : numberRandomInt,
  numberRandomIntBut : numberRandomIntBut, /* dubious */

  numbersMake : numbersMake,
  numbersFromNumber : numbersFromNumber,
  numbersFromInt : numbersFromInt,

  numbersMake_functor : numbersMake_functor,
  numbersFrom_functor : numbersFrom_functor,

  numberClamp : numberClamp,
  numberMix : numberMix,

  // str

  strIs : strIs,
  strsAre : strsAre,
  strIsNotEmpty : strIsNotEmpty,
  strsAreNotEmpty : strsAreNotEmpty,

  strTypeOf : strTypeOf,
  strPrimitiveTypeOf : strPrimitiveTypeOf,

  str : str,
  toStr : str,
  toStrShort : str,
  strFrom : str,

  _strFirst : _strFirst,
  strFirst : strFirst,
  _strLast : _strLast,
  strLast : strLast,

  _strIsolateInsideOrNone : _strIsolateInsideOrNone,
  strIsolateInsideOrNone : strIsolateInsideOrNone,
  _strIsolateInsideOrAll : _strIsolateInsideOrAll,
  strIsolateInsideOrAll : strIsolateInsideOrAll,

  _strBeginOf : _strBeginOf,
  _strEndOf : _strEndOf,

  strBegins : strBegins,
  strEnds : strEnds,

  strBeginOf : strBeginOf,
  strEndOf : strEndOf,

  strInsideOf : strInsideOf,
  strOutsideOf : strOutsideOf,

  // regexp

  regexpIs : regexpIs,
  regexpObjectIs : regexpObjectIs,
  regexpLike : regexpLike,
  regexpsLike : regexpsLike,
  regexpsAreIdentical : regexpsAreIdentical,

  /* !!! move out */

  /* qqq : add test coverage -> */

  _regexpTest : _regexpTest,
  regexpTest : regexpTest,

  regexpTestAll : regexpTestAll,
  regexpTestAny : regexpTestAny,
  regexpTestNone : regexpTestNone,

  regexpsTestAll : regexpsTestAll,
  regexpsTestAny : regexpsTestAny,
  regexpsTestNone : regexpsTestNone,

  /* <- qqq : add test coverage */

  regexpEscape : regexpEscape,
  regexpsEscape : _.Later( _, routineVectorize_functor, regexpEscape ),

  // regexpMakeObject : regexpMakeObject,
  regexpMakeArray : regexpArrayMake,
  regexpFrom : regexpFrom,

  regexpMaybeFrom : regexpMaybeFrom,
  regexpsMaybeFrom : _.Later( _, routineVectorize_functor, { routine : regexpMaybeFrom, select : 'srcStr' } ),

  regexpsSources : regexpsSources,
  regexpsJoin : regexpsJoin,
  regexpsJoinEscaping : regexpsJoinEscaping,
  regexpsAtLeastFirst : regexpsAtLeastFirst,
  regexpsAtLeastFirstOnly : regexpsAtLeastFirstOnly,

  regexpsNone : regexpsNone,
  regexpsAny : regexpsAny,
  regexpsAll : regexpsAll,

  regexpArrayMake : regexpArrayMake,
  regexpArrayIndex : regexpArrayIndex,
  regexpArrayAny : regexpArrayAny,
  regexpArrayAll : regexpArrayAll,
  regexpArrayNone : regexpArrayNone,

  // time

  dateIs : dateIs,
  datesAreIdentical : datesAreIdentical,

  timeReady : timeReady,
  timeReadyJoin : timeReadyJoin,
  timeOnce : timeOnce,
  timeOut : timeOut,
  timeSoon : timeSoon,
  timeOutError : timeOutError,

  timePeriodic : timePeriodic, /* dubious */

  _timeNow_functor : _timeNow_functor,
  timeNow : _.Later( _, _timeNow_functor ),

  timeFewer_functor : timeFewer_functor,

  timeFrom : timeFrom,
  timeSpent : timeSpent,
  timeSpentFormat : timeSpentFormat,
  dateToStr : dateToStr,

  // buffer

  bufferRawIs : bufferRawIs,
  bufferTypedIs : bufferTypedIs,
  bufferViewIs : bufferViewIs,
  bufferNodeIs : bufferNodeIs,
  bufferAnyIs : bufferAnyIs,
  bufferBytesIs : bufferBytesIs,
  bytesIs : bufferBytesIs,
  constructorIsBuffer : constructorIsBuffer,

  buffersTypedAreEquivalent : buffersTypedAreEquivalent,
  buffersTypedAreIdentical : buffersTypedAreIdentical,
  buffersRawAreIdentical : buffersRawAreIdentical,
  buffersViewAreIdentical : buffersViewAreIdentical,
  buffersNodeAreIdentical : buffersNodeAreIdentical,
  buffersAreEquivalent : buffersAreEquivalent,
  buffersAreIdentical : buffersAreIdentical,

  bufferMakeSimilar : bufferMakeSimilar,
  bufferButRange : bufferButRange,
  bufferRelen : bufferRelen,
  bufferResize : bufferResize,
  bufferBytesGet : bufferBytesGet,
  bufferRetype : bufferRetype,

  bufferJoin : bufferJoin,

  bufferMove : bufferMove,
  bufferToStr : bufferToStr,
  bufferToDom : bufferToDom,

  bufferLeft : bufferLeft,
  bufferSplit : bufferSplit,
  bufferCutOffLeft : bufferCutOffLeft,

  bufferFromArrayOfArray : bufferFromArrayOfArray,
  bufferFrom : bufferFrom,
  bufferRawFromTyped : bufferRawFromTyped,
  bufferRawFrom : bufferRawFrom,
  bufferBytesFrom : bufferBytesFrom,
  bufferBytesFromNode : bufferBytesFromNode,
  bufferNodeFrom : bufferNodeFrom,

  buffersSerialize : buffersSerialize, /* deprecated */
  buffersDeserialize : buffersDeserialize, /* deprecated */

  // long

  longMakeSimilar : longMakeSimilar,
  longMakeSimilarZeroed : longMakeSimilarZeroed,

  longSlice : longSlice,
  longButRange : longButRange,

  // arguments array

  argumentsArrayIs : argumentsArrayIs,
  _argumentsArrayMake : _argumentsArrayMake,
  args : _argumentsArrayMake,
  argumentsArrayOfLength : argumentsArrayOfLength,
  argumentsArrayFrom : argumentsArrayFrom,

  // unroll

  unrollFrom : unrollFrom,
  unrollPrepend : unrollPrepend,
  unrollAppend : unrollAppend,

  // array checker

  arrayIs : arrayIs,
  arrayLikeResizable : arrayLikeResizable,
  arrayLike : arrayLike,
  longIs : longIs,
  unrollIs : unrollIs,

  constructorLikeArray : constructorLikeArray,
  hasLength : hasLength,
  arrayHasArray : arrayHasArray,

  arrayCompare : arrayCompare,
  arrayIdentical : arrayIdentical,

  arrayHas : arrayHas, /* dubious */
  arrayHasAny : arrayHasAny, /* dubious */
  arrayHasAll : arrayHasAll, /* dubious */
  arrayHasNone : arrayHasNone, /* dubious */

  arrayAll : arrayAll,
  arrayAny : arrayAny,
  arrayNone : arrayNone,

  // array maker

  arrayMakeRandom : arrayMakeRandom,
  arrayFromNumber : arrayFromNumber,
  arrayFrom : arrayFrom,
  arrayAs : arrayAs,

  _longClone : _longClone,
  longShallowClone : longShallowClone,

  arrayFromRange : arrayFromRange,
  arrayFromProgressionArithmetic : arrayFromProgressionArithmetic,
  arrayFromRangeWithStep : arrayFromRangeWithStep,
  arrayFromRangeWithNumberOfSteps : arrayFromRangeWithNumberOfSteps,

  // array converter

  arrayToMap : arrayToMap, /* dubious */
  arrayToStr : arrayToStr, /* dubious */

  // array transformer

  arraySub : arraySub,
  arrayButRange : arrayButRange,

  arraySlice : arraySlice,
  arrayGrow : arrayGrow,
  arrayResize : arrayResize,
  arrayMultislice : arrayMultislice,
  arrayDuplicate : arrayDuplicate,

  arrayMask : arrayMask, /* dubious */
  arrayUnmask : arrayUnmask, /* dubious */

  arrayInvestigateUniqueMap : arrayInvestigateUniqueMap,  /* dubious */
  arrayUnique : arrayUnique,  /* dubious */
  arraySelect : arraySelect,

  // array mutator

  arraySet : arraySet,
  arraySwap : arraySwap,

  arrayCutin : arrayCutin,
  arrayPut : arrayPut,
  arrayFillTimes : arrayFillTimes,
  arrayFillWhole : arrayFillWhole,

  arraySupplement : arraySupplement, /* experimental */
  arrayExtendScreening : arrayExtendScreening, /* experimental */

  arrayShuffle : arrayShuffle,
  arraySort : arraySort,

  // array sequential search

  arrayLeftIndex : arrayLeftIndex,
  arrayRightIndex : arrayRightIndex,

  arrayLeft : arrayLeft,
  arrayRight : arrayRight,

  arrayLeftDefined : arrayLeftDefined,
  arrayRightDefined : arrayRightDefined,

  arrayCount : arrayCount,
  arrayCountUnique : arrayCountUnique,

  // array etc

  arrayIndicesOfGreatest : arrayIndicesOfGreatest, /* dubious */
  arraySum : arraySum, /* dubious */

  // array prepend

  _arrayPrependUnrolling : _arrayPrependUnrolling,
  arrayPrependUnrolling : arrayPrependUnrolling,
  arrayPrepend_ : arrayPrepend_,

  arrayPrependElement : arrayPrependElement,
  arrayPrependOnce : arrayPrependOnce,
  arrayPrependOnceStrictly : arrayPrependOnceStrictly,
  arrayPrependedElement : arrayPrependedElement,
  arrayPrependedOnce : arrayPrependedOnce,

  arrayPrependArray : arrayPrependArray,
  arrayPrependArrayOnce : arrayPrependArrayOnce,
  arrayPrependArrayOnceStrictly : arrayPrependArrayOnceStrictly,
  arrayPrependedArray : arrayPrependedArray,
  arrayPrependedArrayOnce : arrayPrependedArrayOnce,

  arrayPrependArrays : arrayPrependArrays,
  arrayPrependArraysOnce : arrayPrependArraysOnce,
  arrayPrependArraysOnceStrictly : arrayPrependArraysOnceStrictly,
  arrayPrependedArrays : arrayPrependedArrays,
  arrayPrependedArraysOnce : arrayPrependedArraysOnce,

  // array append

  _arrayAppendUnrolling : _arrayAppendUnrolling,
  arrayAppendUnrolling : arrayAppendUnrolling,
  arrayAppend_ : arrayAppend_,

  arrayAppendElement : arrayAppendElement,
  arrayAppendOnce : arrayAppendOnce,
  arrayAppendOnceStrictly : arrayAppendOnceStrictly,
  arrayAppendedElement : arrayAppendedElement,
  arrayAppendedOnce : arrayAppendedOnce,

  arrayAppendArray : arrayAppendArray,
  arrayAppendArrayOnce : arrayAppendArrayOnce,
  arrayAppendArrayOnceStrictly : arrayAppendArrayOnceStrictly,
  arrayAppendedArray : arrayAppendedArray,
  arrayAppendedArrayOnce : arrayAppendedArrayOnce,

  arrayAppendArrays : arrayAppendArrays,
  arrayAppendArraysOnce : arrayAppendArraysOnce,
  arrayAppendArraysOnceStrictly : arrayAppendArraysOnceStrictly,
  arrayAppendedArrays : arrayAppendedArrays,
  arrayAppendedArraysOnce : arrayAppendedArraysOnce,

  // array remove

  arrayRemove : arrayRemove,
  arrayRemoveOnce : arrayRemoveOnce,
  arrayRemoveOnceStrictly : arrayRemoveOnceStrictly,
  arrayRemoved : arrayRemoved,
  arrayRemovedOnce : arrayRemovedOnce,
  arrayRemovedOnceStrictly : arrayRemovedOnceStrictly, /* qqq : test required */
  arrayRemovedOnceElement : arrayRemovedOnceElement, /* qqq : test required */
  arrayRemovedOnceElementStrictly : arrayRemovedOnceElementStrictly, /* qqq : test required */

  arrayRemoveArray : arrayRemoveArray,
  arrayRemoveArrayOnce : arrayRemoveArrayOnce,
  arrayRemoveArrayOnceStrictly : arrayRemoveArrayOnceStrictly,
  arrayRemovedArray : arrayRemovedArray,
  arrayRemovedArrayOnce : arrayRemovedArrayOnce,

  arrayRemoveArrays : arrayRemoveArrays,
  arrayRemoveArraysOnce : arrayRemoveArraysOnce,
  arrayRemoveArraysOnceStrictly : arrayRemoveArraysOnceStrictly,
  arrayRemovedArrays : arrayRemovedArrays,
  arrayRemovedArraysOnce : arrayRemovedArraysOnce,

  arrayRemoveAll : arrayRemoveAll,
  arrayRemovedAll : arrayRemovedAll,

  // array flatten

  arrayFlatten : arrayFlatten,
  arrayFlattenOnce : arrayFlattenOnce,
  arrayFlattenOnceStrictly : arrayFlattenOnceStrictly,
  arrayFlattened : arrayFlattened,
  arrayFlattenedOnce : arrayFlattenedOnce,

  // array replace

  arrayReplaceOnce : arrayReplaceOnce,
  arrayReplaceOnceStrictly : arrayReplaceOnceStrictly,
  arrayReplacedOnce : arrayReplacedOnce,

  // arrayReplacedOnceStrictly : arrayReplacedOnceStrictly, /* qqq : implement */
  // arrayReplacedOnceElement : arrayReplacedOnceElement, /* qqq : implement */
  // arrayReplacedOnceElementStrictly : arrayReplacedOnceElementStrictly, /* qqq : implement */

  arrayReplaceArrayOnce : arrayReplaceArrayOnce,
  arrayReplaceArrayOnceStrictly : arrayReplaceArrayOnceStrictly,
  arrayReplacedArrayOnce : arrayReplacedArrayOnce,

  arrayReplaceAll : arrayReplaceAll,
  arrayReplacedAll : arrayReplacedAll,

  arrayUpdate : arrayUpdate,

  // array set

  arraySetDiff : arraySetDiff,

  arraySetBut : arraySetBut,
  arraySetIntersection : arraySetIntersection,
  arraySetUnion : arraySetUnion,

  arraySetContainAll : arraySetContainAll,
  arraySetContainAny : arraySetContainAny,
  arraySetContainNone : arraySetContainNone,
  arraySetIdentical : arraySetIdentical,

  // range

  rangeIs : rangeIs,
  rangeFrom : rangeFrom,
  rangeClamp : rangeClamp,
  rangeNumberElements : rangeNumberElements,
  rangeFirstGet : rangeFirstGet,
  rangeLastGet : rangeLastGet,

  // map checker

  objectIs : objectIs,
  objectLike : objectLike,
  objectLikeOrRoutine : objectLikeOrRoutine,
  mapIs : mapIs,
  mapIsPure : mapIsPure,
  mapLike : mapLike,

  mapIdentical : mapIdentical,
  mapContain : mapContain,

  mapSatisfy : mapSatisfy,
  _mapSatisfy : _mapSatisfy,

  mapHas : mapHasKey,
  mapHasKey : mapHasKey,
  mapOwnKey : mapOwnKey,
  mapHasVal : mapHasVal,
  mapOwnVal : mapOwnVal,

  mapHasAll : mapHasAll,
  mapHasAny : mapHasAny,
  mapHasNone : mapHasNone,

  mapOwnAll : mapOwnAll,
  mapOwnAny : mapOwnAny,
  mapOwnNone : mapOwnNone,

  mapHasExactly : mapHasExactly,
  mapOwnExactly : mapOwnExactly,

  mapHasOnly : mapHasOnly,
  mapOwnOnly : mapOwnOnly,

  // mapHasAll : mapHasAll,
  // mapOwnAll : mapOwnAll,
  // mapHasNone : mapHasNone,
  // mapOwnNone : mapOwnNone,

  mapHasNoUndefine : mapHasNoUndefine,

  // map extend

  mapMake : mapMake,
  mapShallowClone : mapShallowClone,
  mapCloneAssigning : mapCloneAssigning, /* dubious */

  mapExtend : mapExtend,
  mapsExtend : mapsExtend,
  mapExtendConditional : mapExtendConditional,
  mapsExtendConditional : mapsExtendConditional,

  mapExtendHiding : mapExtendHiding,
  mapsExtendHiding : mapsExtendHiding,
  mapExtendAppending : mapExtendAppending,
  mapsExtendAppending : mapsExtendAppending,
  mapExtendByDefined : mapExtendByDefined,
  mapsExtendByDefined : mapsExtendByDefined,

  mapSupplement : mapSupplement,
  mapSupplementNulls : mapSupplementNulls,
  mapSupplementNils : mapSupplementNils,
  mapSupplementAssigning : mapSupplementAssigning,
  mapSupplementAppending : mapSupplementAppending,
  mapsSupplementAppending : mapsSupplementAppending,

  mapSupplementOwn : mapSupplementOwn,
  mapsSupplementOwn : mapsSupplementOwn,
  mapSupplementOwnAssigning : mapSupplementOwnAssigning,
  mapSupplementOwnFromDefinition : mapSupplementOwnFromDefinition,
  mapSupplementOwnFromDefinitionStrictlyPrimitives : mapSupplementOwnFromDefinitionStrictlyPrimitives,

  mapComplement : mapComplement,
  mapsComplement : mapsComplement,
  mapComplementReplacingUndefines : mapComplementReplacingUndefines,
  mapsComplementReplacingUndefines : mapsComplementReplacingUndefines,
  mapComplementPreservingUndefines : mapComplementPreservingUndefines,
  mapsComplementPreservingUndefines : mapsComplementPreservingUndefines,

  // map extend recursive

  mapExtendRecursiveConditional : mapExtendRecursiveConditional,
  mapsExtendRecursiveConditional : mapsExtendRecursiveConditional,
  _mapExtendRecursiveConditional : _mapExtendRecursiveConditional,

  mapExtendRecursive : mapExtendRecursive,
  mapsExtendRecursive : mapsExtendRecursive,
  _mapExtendRecursive : _mapExtendRecursive,

  mapExtendAppendingRecursive : mapExtendAppendingRecursive,
  mapsExtendAppendingRecursive : mapsExtendAppendingRecursive,
  mapExtendAppendingOnceRecursive : mapExtendAppendingOnceRecursive,
  mapsExtendAppendingOnceRecursive : mapsExtendAppendingOnceRecursive,

  mapSupplementRecursive : mapSupplementRecursive,
  mapSupplementByMapsRecursive : mapSupplementByMapsRecursive,
  mapSupplementOwnRecursive : mapSupplementOwnRecursive,
  mapsSupplementOwnRecursive : mapsSupplementOwnRecursive,
  mapSupplementRemovingRecursive : mapSupplementRemovingRecursive,
  mapSupplementByMapsRemovingRecursive : mapSupplementByMapsRemovingRecursive,

  // map manipulator

  mapSetWithKeys : mapSetWithKeys,
  mapDelete : mapDelete,

  // map transformer

  mapInvert : mapInvert,
  mapInvertDroppingDuplicates : mapInvertDroppingDuplicates,
  mapsFlatten : mapsFlatten,

  mapToArray : mapToArray, /* qqq : test rquired */
  mapToStr : mapToStr, /* experimental */

  // map selector

  _mapEnumerableKeys : _mapEnumerableKeys,

  _mapKeys : _mapKeys,
  mapKeys : mapKeys,
  mapOwnKeys : mapOwnKeys,
  mapAllKeys : mapAllKeys,

  _mapVals : _mapVals,
  mapVals : mapVals,
  mapOwnVals : mapOwnVals,
  mapAllVals : mapAllVals,

  _mapPairs : _mapPairs,
  mapPairs : mapPairs,
  mapOwnPairs : mapOwnPairs,
  mapAllPairs : mapAllPairs,

  _mapProperties : _mapProperties,

  properties : mapProperties,
  mapProperties : mapProperties,
  mapOwnProperties : mapOwnProperties,
  mapAllProperties : mapAllProperties,

  routines : mapRoutines,
  mapRoutines : mapRoutines,
  mapOwnRoutines : mapOwnRoutines,
  mapAllRoutines : mapAllRoutines,

  fields : mapFields,
  mapFields : mapFields,
  mapOwnFields : mapOwnFields,
  mapAllFields : mapAllFields,

  mapOnlyPrimitives : mapOnlyPrimitives,
  mapFirstPair : mapFirstPair,
  mapValsSet : mapValsSet,
  mapSelect : mapSelect,

  mapValWithIndex : mapValWithIndex,
  mapKeyWithIndex : mapKeyWithIndex,
  mapKeyWithValue : mapKeyWithValue,
  mapIndexWithKey : mapIndexWithKey,
  mapIndexWithValue : mapIndexWithValue,

  // map logic operator

  mapButConditional : mapButConditional,
  mapBut : mapBut,
  mapButIgnoringUndefines : mapButIgnoringUndefines,
  mapOwnBut : mapOwnBut,

  mapOnly : mapOnly,
  mapOnlyOwn : mapOnlyOwn,
  mapOnlyComplementing : mapOnlyComplementing,
  _mapOnly : _mapOnly,

  // map surer

  sureMapHasExactly : sureMapHasExactly,
  sureMapOwnExactly : sureMapOwnExactly,

  sureMapHasOnly : sureMapHasOnly,
  sureMapOwnOnly : sureMapOwnOnly,

  sureMapHasAll : sureMapHasAll,
  sureMapOwnAll : sureMapOwnAll,

  sureMapHasNone : sureMapHasNone,
  sureMapOwnNone : sureMapOwnNone,

  sureMapHasNoUndefine : sureMapHasNoUndefine,

  // map assert

  assertMapHasFields : assertMapHasFields,
  assertMapOwnFields : assertMapOwnFields,

  assertMapHasOnly : assertMapHasOnly,
  assertMapOwnOnly : assertMapOwnOnly,

  assertMapHasNone : assertMapHasNone,
  assertMapOwnNone : assertMapOwnNone,

  assertMapHasAll : assertMapHasAll,
  assertMapOwnAll : assertMapOwnAll,

  assertMapHasNoUndefine : assertMapHasNoUndefine,

}

//

Object.assign( Self, Routines );
Object.assign( Self, Fields );

_.assert( !Self.Array );
_.assert( !Self.array );
_.assert( !Self.withArray );

_.assert( _.objectIs( _.regexpsEscape ) );
_.Later.replace( Self );
_.assert( _.objectIs( _.regexpsEscape ) );

// --
// export
// --

_global[ 'wTools' ] = Self;
_global.wTools = Self;
_global.wBase = Self;

if( typeof module !== 'undefined' )
if( _global.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
