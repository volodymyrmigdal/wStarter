( function _Looker_s_() {

'use strict';

/**
  @module Tools/base/Looker - Collection of light-weight routines to traverse complex data structure. The module takes care of cycles in a data structure( recursions ) and can be used for comparison or operation on several similar data structures. Please see wComparator which based on the module for comparison.
*/

/**
 * @file Looker.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

}

let _global = _global_;
let Self = _global_.wTools;
let _ = _global_.wTools;

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

_.assert( !!_realGlobal_ );

// --
// looker
// --

function lookerIterator( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.objectIs( this.Iterator ) );

  /* */

  let iterator = Object.create( o.looker );
  Object.assign( iterator, this.Iterator );
  Object.assign( iterator, o );

  delete iterator.it;

  _.assert( iterator.it === undefined );

  iterator.iterator = iterator;

  if( iterator.trackingVisits )
  {
    iterator.visited = [];
    iterator.visited2 = [];
  }

  if( iterator.path === null )
  iterator.path = iterator.upToken;

  iterator.lastPath = iterator.path;

  Object.preventExtensions( iterator );

  _.assert( iterator.level !== undefined );
  _.assert( iterator.path !== undefined );
  _.assert( _.strIs( iterator.lastPath ) );

  return iterator;
}

// --
// iterator
// --

function iteratorIterationAct()
{
  let it = this;

  _.assert( arguments.length === 0 );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.iterator ) );
  _.assert( _.objectIs( it.looker ) );

  _.assert( _.numberIs( it.level ) && it.level >= 0 );
  _.assert( _.numberIs( it.logicalLevel ) && it.logicalLevel >= 0 );

  let newIt = Object.create( it.iterator );
  Object.assign( newIt, it.looker.Iteration );
  Object.preventExtensions( newIt );

  // debugger;
  _.mapExtend( newIt, _.mapOnly( it, it.looker.IterationPreserve ) );
  // _.mapExtendConditional( _.field.mapper.primitive, _.mapOnly( it, it.looker.IterationPreserve ) );
  // debugger;

  // newIt.level = it.level;
  // newIt.path = it.path;
  // newIt.src = it.src;
  // newIt.src2 = it.src2;

  if( it.iterator !== it )
  newIt.down = it;

  return newIt;
}

//

function iteratorIteration()
{
  let it = this;
  let newIt = it.iterationAct();

  newIt.logicalLevel = it.logicalLevel + 1;

  _.assert( arguments.length === 0 );

  return newIt;
}

//

function iteratorReiteration()
{
  let it = this;
  let newIt = it.iterationAct();

  newIt.logicalLevel = it.logicalLevel;

  _.assert( arguments.length === 0 );

  return newIt;
}

//

function iteratorSelect( k )
{
  let it = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.down ) );

  it.level = it.level+1;
  it.path = it.path !== it.upToken ? it.path + it.upToken + k : it.path + k;
  it.iterator.lastPath = it.path;
  it.iterator.lastSelect = it;
  it.key = k;
  it.index = it.down.hasChildren;

  if( it.src )
  it.src = it.src[ k ];
  else
  it.src = undefined;

  // it.onSelect( k );
  // it.select2( k );

  return it;
}

//

function iteratorSelect2( k )
{
  let it = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.level >= 0 );
  _.assert( _.objectIs( it.down ) );

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( it.src2 )
  it.src2 = it.src2[ it.key ];
  else
  it.src2 = undefined;

  return it;
  // return it.onSelect2( k );
}

//

function iteratorLook()
{
  let it = this;

  _.assert( it.level >= 0 );
  _.assert( arguments.length === 0 );

  let startLooking = it.canStartLooking();
  if( !startLooking )
  return it;

  if( it.down )
  it.down.hasChildren += 1;

  it.visiting = it.visitingRoot || it.root !== it.src;

  it.lookUp();

  let keepLooking = it.canKeepLooking();
  if( keepLooking === false )
  return it.lookDown();

  it.onIterate( function( eit )
  {
    eit.look();
  });

  if( !it.iterable )
  it.onTerminal();

  return it.lookDown();
}

//

function iteratorLookUp()
{
  let it = this;

  it.ascending = true;

  if( it.iterator.trackingVisits )
  {
    if( it.visited.indexOf( it.src ) !== -1 )
    it.visitedManyTimes = true;
  }

  if( it.visiting )
  {
    _.assert( _.routineIs( it.onUp ) );
    let r = it.onUp.call( it, it.src, it.key, it );
    if( r === _.dontUp )
    {
      it.iterator.looking = false;
      it.looking = false;
    }
    if( it.looking === true && r !== undefined )
    it.looking = r;
    if( it.looking === _.dont )
    it.looking = false;
    _.assert( _.boolIs( it.looking ), () => 'Expects it.onUp returns boolean, but got ' + _.strTypeOf( it.looking ) );
  }

  it.visitBeginMaybe()

}

//

function iteratorLookDown()
{
  let it = this;

  it.ascending = false;

  if( it.visiting )
  {
    if( it.onDown )
    it.result = it.onDown.call( it, it.src, it.key, it );
  }

  it.visitEndMaybe();

  return it;
}

//

function iteratorVisitBegin()
{
  let it = this;

  if( it.iterator.trackingVisits )
  {
    it.visited.push( it.src );
    it.visited2.push( it.src2 );
  }

}

//

function iteratorVisitBeginMaybe()
{
  let it = this;

  if( it.iterator.trackingVisits && it.trackingVisits )
  it.visitBegin();

}

//

function iteratorVisitEnd()
{
  let it = this;

  if( it.iterator.trackingVisits )
  {
    _.assert( Object.is( it.visited[ it.visited.length-1 ], it.src ), () => 'Top-most visit does not match ' + it.path );
    it.visited.pop();
    _.assert( Object.is( it.visited2[ it.visited2.length-1 ], it.src2 ), 'Top-most visit does not match ' + it.path );
    it.visited2.pop();
  }

}

//

function iteratorVisitEndMaybe()
{
  let it = this;

  if( it.iterator.trackingVisits && it.trackingVisits )
  it.visitEnd();

  it.trackingVisits = 0;

}

//

function iteratorCanStartLooking()
{
  let it = this;
  let startLooking = true;

  if( !it.recursive && it.down )
  startLooking = false;

  return startLooking;
}

//

function iteratorCanKeepLooking()
{
  let it = this;
  let keepLooking = true;

  if( it.levelLimit !== 0 )
  if( !( it.level < it.levelLimit ) )
  keepLooking = false;

  _.assert( _.boolIs( it.looking ) );
  _.assert( _.boolIs( it.iterator.looking ) );

  if( keepLooking === false )
  {}
  else if( it.looking === false )
  keepLooking = false;
  else if( it.iterator.looking === false )
  keepLooking = false;
  else if( it.visitedManyTimes )
  keepLooking = false;
  else if( it.ascending === false )
  keepLooking = false;

  return keepLooking;
}

// --
// iteration
// --

// function iterationIteration()
// {
//   let it = this;
//
//   _.assert( arguments.length === 0 );
//
//   let newIt = it.iterator.iteration.call( it )
//
//   newIt.down = it;
//
//   return newIt;
// }

// --
// handler
// --

function onUp( e,k,it )
{
  return it.looking;
}

//

function onDown( e,k,it )
{
  return it.result;
}

//

function onTerminal()
{
  let it = this;
  return it;
}

//

function onIterate( onIteration )
{
  let it = this;

  if( _.arrayIs( it.src ) || _.argumentsArrayIs( it.src ) )
  {
    it.iterable = 'array-like';
  }
  else if( _.objectLike( it.src ) )
  {
    it.iterable = 'object-like';
  }
  else
  {
    it.iterable = false;
  }

  _.assert( arguments.length === 1 );
  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( _.routineIs( onIteration ) );
  _.assert( onIteration.length === 0 || onIteration.length === 1 );

  if( it.iterable === 'array-like' )
  {

    for( let k = 0 ; k < it.src.length ; k++ )
    {

      let eit = it.iteration().select( k ).select2( k );

      onIteration.call( it, eit );

      if( !it.looking || it.looking === _.dont )
      break;

      if( !it.iterator.looking || it.iterator.looking === _.dont )
      break;

    }

  }
  else if( it.iterable === 'object-like' )
  {

    for( let k in it.src )
    {

      if( it.own )
      if( !_ObjectHasOwnProperty.call( it.src, k ) )
      continue;

      let eit = it.iteration().select( k ).select2( k );

      onIteration.call( it, eit );

      if( !it.looking || it.looking === _.dont )
      break;

      if( !it.iterator.looking || it.iterator.looking === _.dont )
      break;

    }

  }

}

// //
//
// function onSelect( k )
// {
//   let it = this;
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   it.level = it.level+1;
//   it.path = it.path !== it.upToken ? it.path + it.upToken + k : it.path + k;
//   it.iterator.lastPath = it.path;
//   it.iterator.lastSelect = it;
//   it.key = k;
//   it.index = it.down.hasChildren;
//
//   if( it.src )
//   it.src = it.src[ k ];
//   else
//   it.src = undefined;
//
// }
//
// //
//
// function onSelect2( k )
// {
//   let it = this;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   if( it.src2 )
//   it.src2 = it.src2[ it.key ];
//   else
//   it.src2 = undefined;
//
//   return it;
// }

// --
// relations
// --

let Defaults = Object.create( null );

Defaults.onUp = onUp;
Defaults.onDown = onDown;
Defaults.onTerminal = onTerminal;
Defaults.onIterate = onIterate;
// Defaults.onSelect = onSelect;
// Defaults.onSelect2 = onSelect2;

Defaults.own = 0;
Defaults.recursive = 1;
Defaults.visitingRoot = 1;

Defaults.trackingVisits = 1;
Defaults.levelLimit = 0;

Defaults.upToken = '/';
Defaults.path = null;
Defaults.level = 0;
Defaults.logicalLevel = 0;

Defaults.src = null;
Defaults.root = null;

Defaults.src2 = null;
Defaults.root2 = null;

Defaults.context = null;
Defaults.looker = null;
Defaults.it = null;
Defaults._inherited = null;

//

let Looker = Defaults.looker = Object.create( null );
Looker.looker = Looker;
Looker.iterator = lookerIterator;
// Looker.Iterator = Iterator;
// Looker.Iteration = Iteration;
Looker.Defaults = Defaults;

//

// let Iterator = _global.wTools.Iterator = _global.wTools.Iterator || Object.create( null );
let Iterator = Looker.Iterator = Object.create( null );

Iterator.iterator = null;
Iterator.iterationAct = iteratorIterationAct;
Iterator.iteration = iteratorIteration;
Iterator.reiteration = iteratorReiteration;
Iterator.select = iteratorSelect;
Iterator.select2 = iteratorSelect2;
Iterator.look = iteratorLook;
Iterator.lookUp = iteratorLookUp;
Iterator.lookDown = iteratorLookDown;
Iterator.visitBegin = iteratorVisitBegin;
Iterator.visitBeginMaybe = iteratorVisitBeginMaybe;
Iterator.visitEnd = iteratorVisitEnd;
Iterator.visitEndMaybe = iteratorVisitEndMaybe;
Iterator.canStartLooking = iteratorCanStartLooking;
Iterator.canKeepLooking = iteratorCanKeepLooking;

Iterator.path = null;
Iterator.lastPath = null;
Iterator.lastSelect = null;
Iterator.looking = true;
Iterator.key = null;
Iterator.error = null;

Iterator.visited = null;
Iterator.visited2 = null;

Object.freeze( Iterator );

//

let Iteration = Looker.Iteration = Object.create( null );

// Iteration.iteration = iterationIteration;
Iteration.hasChildren = 0;
Iteration.level = 0,
Iteration.logicalLevel = 0;
Iteration.path = '/';
Iteration.key = null;
Iteration.index = null;
Iteration.src = null;
Iteration.src2 = null;
Iteration.result = true;
Iteration.looking = true;
Iteration.ascending = true;
Iteration.visitedManyTimes = false;
Iteration._ = null;
Iteration._inherited = null;
Iteration.down = null;
Iteration.visiting = false;
Iteration.iterable = null;
Iteration.trackingVisits = 1;

Object.freeze( Iteration );

//

let IterationPreserve = Looker.IterationPreserve = Object.create( null );

IterationPreserve.level = null;
IterationPreserve.path = null;
IterationPreserve.src = null;
IterationPreserve.src2 = null;
IterationPreserve._inherited =  null;

Object.freeze( IterationPreserve );

//

function ErrorLooking()
{

  if( !( this instanceof ErrorLooking ) )
  {
    let err1 = new ErrorLooking();
    let err2 = _.err.apply( _, _.arrayAppendArray( [ err1, '\n' ], arguments ) );

    _.assert( err2 instanceof Error );
    _.assert( err2 instanceof ErrorLooking );
    _.assert( !!err2.stack );

    return err2;
  }

  _.assert( arguments.length === 0 );
  return this;
}

ErrorLooking.prototype = Object.create( Error.prototype );
ErrorLooking.prototype.constructor = ErrorLooking;

// --
// expose
// --

function _look_pre( routine, args )
{
  let o;

  if( args.length === 1 )
  {
    if( _.numberIs( args[ 0 ] ) )
    o = { accuracy : args[ 0 ] }
    else
    o = args[ 0 ];
  }
  else if( args.length === 2 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ] };
  }
  else if( args.length === 3 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ], onDown : args[ 2 ] };
  }
  else _.assert( 0,'look expects single options map, 2 or 3 arguments' );

  if( o.looker && _.prototypeOf( o.looker, o ) )
  {
    return o;
  }

  o.looker = o.looker || routine.defaults.looker;

  _.mapComplementPreservingUndefines( o, routine.defaults );
  _.routineOptionsPreservingUndefines( routine, o, o.looker.Defaults );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.onUp === null || o.onUp.length === 0 || o.onUp.length === 3, 'onUp should Expects exactly three arguments' );
  _.assert( o.onDown === null || o.onDown.length === 0 || o.onDown.length === 3, 'onUp should Expects exactly three arguments' );

  if( o.it === null || o.it === undefined )
  {
    let iterator = o.looker.iterator( o );
    let iteration = iterator.iteration();
    return iteration;
  }
  else
  {
    return o.it;
  }

}

//

function _look_body( it )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.looker ) );
  _.assert( _.prototypeOf( it.looker, it ) );

  return it.look();
}

_look_body.defaults = Object.create( Defaults );

//

let look = _.routineFromPreAndBody( _look_pre, _look_body );

var defaults = look.defaults;

defaults.own = 0;
defaults.recursive = 1;

//

let lookOwn = _.routineFromPreAndBody( _look_pre, _look_body );

var defaults = lookOwn.defaults;

defaults.own = 1;
defaults.recursive = 1;

//

function iteratorIs( it )
{
  if( !it )
  return false;
  if( !it.looker )
  return false;
  if( it.iterator !== it )
  return false;
  return true;
}

//

function iterationIs( it )
{
  if( !it )
  return false;
  if( !it.looker )
  return false;
  if( !it.iterator )
  return false;
  if( it.iterator === it )
  return false;
  return true;
}

// --
// declare
// --

let Supplement =
{

  Looker : Looker,
  ErrorLooking : ErrorLooking,

  look : look,
  lookOwn : lookOwn,

  iteratorIs : iteratorIs,
  iterationIs : iterationIs,

}

_.mapSupplement( Self, Supplement );

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
