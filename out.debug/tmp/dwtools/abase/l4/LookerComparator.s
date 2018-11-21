( function _LookerComparator_s_() {

'use strict';

/**
  @module Tools/base/Comparator - Collection of routines to compare two complex structures. The module can answer questions: are two structures equivalent? are them identical? what is the difference between each other? Use the module avoid manually work and cherry picking.
*/

/**
 * @file LookerComparator.s.
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

_.include( 'wLooker' );
_.include( 'wSelector' );

_.assert( !!_realGlobal_ );
_.assert( !!_.look );
_.assert( !!_.select );

// --
// entity investigator
// --

function __entityEqualUp( e, k, it )
{

  _.assert( arguments.length === 3, 'Expects exactly three argument' );

  /* if containing mode then src2 could even don't have such entry */

  if( it.context.containing )
  {
    if( it.down && !( it.key in it.down.src2 ) )
    return clearEnd( false );
  }

  /* */

  if( Object.is( it.src, it.src2 ) )
  {
    return clearEnd( true );
  }

  /* fast comparison if possible */

  if( it.context.strictTyping )
  {
    if( _ObjectToString.call( it.src ) !== _ObjectToString.call( it.src2 ) )
    return clearEnd( false );
  }
  else
  {
    if( _.primitiveIs( it.src ) || _.primitiveIs( it.src2 ) )
    if( _ObjectToString.call( it.src ) !== _ObjectToString.call( it.src2 ) ) {
      if( it.context.strictNumbering )
      return clearEnd( false );
      return clearEnd( it.src == it.src2 );
    }
  }

  /* */

  if( _.numberIs( it.src ) )
  {
    return clearEnd( it.context.onNumbersAreEqual( it.src, it.src2 ) );
  }
  else if( _.regexpIs( it.src ) )
  {
    return clearEnd( _.regexpsAreIdentical( it.src, it.src2 ) );
  }
  else if( _.dateIs( it.src ) )
  {
    return clearEnd( _.datesAreIdentical( it.src, it.src2 ) );
  }
  else if( _.bufferAnyIs( it.src ) )
  {
    if( !it.context.strictTyping )
    debugger;
    if( it.context.strictTyping )
    return clearEnd( _.buffersAreIdentical( it.src, it.src2 ) );
    else
    return clearEnd( _.buffersAreEquivalent( it.src, it.src2, it.context.accuracy ) );
  }
  else if( _.longIs( it.src ) )
  {

    it._ = 'longIs';

    if( !it.src2 )
    return clearEnd( false );
    if( it.src.constructor !== it.src2.constructor )
    return clearEnd( false );

    if( !it.context.containing )
    {
      if( it.src.length !== it.src2.length )
      return clearEnd( false );
    }
    else
    {
      if( it.src.length > it.src2.length )
      return clearEnd( false );
    }

  }
  else if( _.objectLike( it.src ) )
  {

    it._ = 'objectLike';

    if( _.routineIs( it.src._equalAre ) )
    {
      // _.assert( it.src._equalAre.length === 1 ); // does not applicable to VectorImage
      if( !it.src._equalAre( it ) )
      return clearEnd( false );
    }
    else if( _.routineIs( it.src.equalWith ) )
    {
      _.assert( it.src.equalWith.length <= 2 );
      if( !it.src.equalWith( it.src2, it ) )
      return clearEnd( false );
    }
    else if( _.routineIs( it.src2.equalWith ) )
    {
      _.assert( it.src2.equalWith.length <= 2 );
      if( !it.src2.equalWith( it.src, it ) )
      return clearEnd( false );
    }
    else
    {
      if( !it.context.containing )
      if( _.entityLength( it.src ) !== _.entityLength( it.src2 ) )
      return clearEnd( false );
    }

  }
  else
  {
    if( it.context.strictTyping )
    {
      if( it.src !== it.src2 )
      return clearEnd( false );
    }
    else
    {
      if( it.src != it.src2 )
      return clearEnd( false );
    }
  }

  __entityEqualCycle( e, k, it );

  return end();

  /* */

  function clearEnd( result )
  {

    it.result = it.result && result;
    it.looking = false;

    _.assert( arguments.length === 1 );

    return end();
  }

  /* */

  function end()
  {

    if( !it.result )
    {
      it.iterator.looking = false;
      it.looking = false;
    }

    _.assert( arguments.length === 0 );

    return it.looking ? it.looking : _.dont;
  }

}

//

function __entityEqualDown( e, k, it )
{

  _.assert( it.ascending === false );

  // __entityEqualCycle( e, k, it );

  /* if element is not equal then descend it down */
  if( !it.result )
  if( it.down )
  {
    it.down.result = it.result;
  }

  if( it.result === false )
  return _.dont;

  return it.result;
}

//

function __entityEqualCycle( e, k, it )
{

  if( !it.visitedManyTimes )
  return;
  if( !it.result )
  return;

  debugger;

  /* if cycled and strict cycling */
  if( it.context.strictCycling )
  {
    /* if opposite branch was cycled earlier */
    if( it.down.src2 !== undefined )
    {
      let i = it.visited2.indexOf( it.down.src2 );
      if( 0 <= i && i <= it.visited2.length-2 )
      it.result = false;
    }
    /* or not yet cycled */
    if( it.result )
    it.result = it.visited2[ it.visited.indexOf( it.src ) ] === it.src2;
    /* then not equal otherwise equal */
  }
  else
  {
    if( it.levelLimit && it.level < it.levelLimit )
    {
      let o2 = _.mapExtend( null, it.context );
      o2.src1 = it.src2;
      o2.src2 = it.src;
      o2.levelLimit = 1;
      debugger;
      it.result = _._entityEqual.body( o2 );
    }
  }

}

//

function _entityEqual_pre( routine, args )
{

  _.assert( args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let o = args[ 2 ] || Object.create( null );

  if( o.looker && _.prototypeOf( o.looker, o ) )
  {
    _.assert( o.src === args[ 0 ] );
    _.assert( o.src2 === args[ 1 ] );
    return o;
  }

  o = _.routineOptionsPreservingUndefines( routine, args[ 2 ] || Object.create( null ) );

  let accuracy = o.accuracy;

  o.src1 = args[ 0 ];
  o.src2 = args[ 1 ];

  if( o.onNumbersAreEqual === null )
  if( o.strictNumbering && o.strictTyping )
  o.onNumbersAreEqual = numbersAreIdentical;
  else if( o.strictNumbering && !o.strictTyping )
  o.onNumbersAreEqual = numbersAreIdenticalNotStrictly;
  else
  o.onNumbersAreEqual = numbersAreEquivalent;

  return _.look.pre( _.look, [ optionsFor( o ) ] );

  /* */

  function numbersAreIdentical( a,b )
  {
    return Object.is( a,b );
  }

  function numbersAreIdenticalNotStrictly( a,b )
  {
    /* take into account -0 === +0 case */
    return Object.is( a,b ) || a === b;
  }

  function numbersAreEquivalent( a,b )
  {
    if( Object.is( a,b ) )
    return true;
    return Math.abs( a-b ) <= accuracy;
  }

  /* */

  function optionsFor( o )
  {

    _.assert( arguments.length === 1 );

    let o2 = Object.create( null );
    o2.src = o.src2;
    o2.src2 = o.src1;
    o2.levelLimit = o.levelLimit;
    o2.context = o;
    o2.onUp = _.routinesComposeReturningLast([ __entityEqualUp, o.onUp ]);
    o2.onDown = _.routinesComposeReturningLast([ __entityEqualDown, o.onDown ]);

    return o2;
  }

}

//

function _entityEqual_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  it.context.iteration = _.look.body( it );

  _.assert( it.iterator !== it );
  _.assert( it.result === _.dont || _.boolIs( it.result ) );

  return it.result === _.dont ? false : it.result;
}

_entityEqual_body.defaults =
{
  src1 : null,
  src2 : null,
  containing : 0,
  strictTyping : 1,
  strictNumbering : 1,
  strictCycling : 1,
  accuracy : 1e-7,
  levelLimit : 0,
  onNumbersAreEqual : null,
  onUp : null,
  onDown : null,
}

//

/**
 * Deep comparsion of two entities. Uses recursive comparsion for objects,arrays and array-like objects.
 * Returns false if finds difference in two entities, else returns true. By default routine uses it own
 * ( onNumbersAreEqual ) routine to compare numbers.
 *
 * @param {*} src1 - Entity for comparison.
 * @param {*} src2 - Entity for comparison.
 * @param {wTools~entityEqualOptions} o - comparsion options {@link wTools~entityEqualOptions}.
 * @returns {boolean} result - Returns true for same entities.
 *
 * @example
 * //returns false
 * _._entityEqual( '1', 1 );
 *
 * @example
 * //returns true
 * _._entityEqual( '1', 1, { strictTyping : 0 } );
 *
 * @example
 * //returns true
 * _._entityEqual( { a : { b : 1 }, b : 1 } , { a : { b : 1 } }, { containing : 1 } );
 *
 * @example
 * //returns ".a.b"
 * let o = { containing : 1 };
 * _._entityEqual( { a : { b : 1 }, b : 1 } , { a : { b : 1 } }, o );
 * console.log( o.lastPath );
 *
 * @function _entityEqual
 * @throws {exception} If( arguments.length ) is not equal 2 or 3.
 * @throws {exception} If( o ) is not a Object.
 * @throws {exception} If( o ) is extended by unknown property.
 * @memberof wTools
 */

let _entityEqual = _.routineFromPreAndBody( _entityEqual_pre, _entityEqual_body );

//

/**
 * Deep strict comparsion of two entities. Uses recursive comparsion for objects,arrays and array-like objects.
 * Returns true if entities are identical.
 *
 * @param {*} src1 - Entity for comparison.
 * @param {*} src2 - Entity for comparison.
 * @param {wTools~entityEqualOptions} options - Comparsion options {@link wTools~entityEqualOptions}.
 * @param {boolean} [ options.strictTyping = true ] - Method uses strict equality mode( '===' ).
 * @returns {boolean} result - Returns true for identical entities.
 *
 * @example
 * //returns true
 * let src1 = { a : 1, b : { a : 1, b : 2 } };
 * let src2 = { a : 1, b : { a : 1, b : 2 } };
 * _.entityIdentical( src1, src2 ) ;
 *
 * @example
 * //returns false
 * let src1 = { a : '1', b : { a : 1, b : '2' } };
 * let src2 = { a : 1, b : { a : 1, b : 2 } };
 * _.entityIdentical( src1, src2 ) ;
 *
 * @function entityIdentical
 * @throws {exception} If( arguments.length ) is not equal 2 or 3.
 * @throws {exception} If( options ) is extended by unknown property.
 * @memberof wTools
*/

let entityIdentical = _.routineFromPreAndBody( _entityEqual_pre, _entityEqual_body );

var defaults = entityIdentical.defaults;

defaults.strictTyping = 1;
defaults.strictNumbering = 1;
defaults.strictCycling = 1;

//

/**
 * Deep soft comparsion of two entities. Uses recursive comparsion for objects,arrays and array-like objects.
 * By default uses own( onNumbersAreEqual ) routine to compare numbers using( options.accuracy ). Returns true if two numbers are NaN, strict equal or
 * ( a - b ) <= ( options.accuracy ). For example: '_.entityEquivalent( 1, 1.5, { accuracy : .5 } )' returns true.
 *
 * @param {*} src1 - Entity for comparison.
 * @param {*} src2 - Entity for comparison.
 * @param {wTools~entityEqualOptions} options - Comparsion options {@link wTools~entityEqualOptions}.
 * @param {boolean} [ options.strict = false ] - Method uses( '==' ) equality mode .
 * @param {number} [ options.accuracy = 1e-7 ] - Maximal distance between two numbers.
 * Example: If( options.accuracy ) is '1e-7' then 0.99999 and 1.0 are equivalent.
 * @returns {boolean} Returns true if entities are equivalent.
 *
 * @example
 * //returns true
 * _.entityEquivalent( 2, 2.1, { accuracy : .2 } );
 *
 * @example
 * //returns true
 * _.entityEquivalent( [ 1, 2, 3 ], [ 1.9, 2.9, 3.9 ], { accuracy : 0.9 } );
 *
 * @function entityEquivalent
 * @throws {exception} If( arguments.length ) is not equal 2 or 3.
 * @throws {exception} If( options ) is extended by unknown property.
 * @memberof wTools
*/

let entityEquivalent = _.routineFromPreAndBody( _entityEqual_pre, _entityEqual_body );

var defaults = entityEquivalent.defaults;

defaults.strictTyping = 0;
defaults.strictNumbering = 0;
defaults.strictCycling = 0;

//

/**
 * Deep contain comparsion of two entities. Uses recursive comparsion for objects,arrays and array-like objects.
 * Returns true if entity( src1 ) contains keys/values from entity( src2 ) or they are indentical.
 *
 * @param {*} src1 - Entity for comparison.
 * @param {*} src2 - Entity for comparison.
 * @param {wTools~entityEqualOptions} opts - Comparsion options {@link wTools~entityEqualOptions}.
 * @param {boolean} [ opts.strict = true ] - Method uses strict( '===' ) equality mode .
 * @param {boolean} [ opts.containing = true ] - Check if( src1 ) contains  keys/indexes and same appropriates values from( src2 ).
 * @returns {boolean} Returns boolean result of comparison.
 *
 * @example
 * //returns true
 * _.entityContains( [ 1, 2, 3 ], [ 1 ] );
 *
 * @example
 * //returns false
 * _.entityContains( [ 1, 2, 3 ], [ 1, 4 ] );
 *
 * @example
 * //returns true
 * _.entityContains( { a : 1, b : 2 }, { a : 1 , b : 2 }  );
 *
 * @function entityContains
 * @throws {exception} If( arguments.length ) is not equal 2 or 3.
 * @throws {exception} If( opts ) is extended by unknown property.
 * @memberof wTools
*/

function entityContains( src1, src2, opts )
{
  let it = _entityEqual.pre.call( this, entityContains, arguments );
  let result = _entityEqual.body.call( this, it );
  return result;
}

_.routineExtend( entityContains, _entityEqual );

var defaults = entityContains.defaults;

defaults.containing = 1;
defaults.strictTyping = 0;
defaults.strictNumbering = 1;
defaults.strictCycling = 1;

//

 /**
  * Deep comparsion of two entities. Uses recursive comparsion for objects,arrays and array-like objects.
  * Returns string refering to first found difference or false if entities are sames.
  *
  * @param {*} src1 - Entity for comparison.
  * @param {*} src2 - Entity for comparison.
  * @param {wTools~entityEqualOptions} o - Comparsion options {@link wTools~entityEqualOptions}.
  * @returns {boolean} result - Returns false for same entities or difference as a string.
  *
  * @example
  * //returns
  * //"at :
  * //src1 :
  * //1
  * //src2 :
  * //1 "
  * _.entityDiff( '1', 1 );
  *
  * @example
  * //returns
  * //"at : .2
  * //src1 :
  * //3
  * //src2 :
  * //4
  * //difference :
  * //*"
  * _.entityDiff( [ 1, 2, 3 ], [ 1, 2, 4 ] );
  *
  * @function entityDiff
  * @throws {exception} If( arguments.length ) is not equal 2 or 3.
  * @throws {exception} If( o ) is not a Object.
  * @throws {exception} If( o ) is extended by unknown property.
  * @memberof wTools
  */

function entityDiff( src1, src2, opts )
{

  opts = opts || Object.create( null );
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );
  let equal = _._entityEqual( src1, src2, opts );

  if( equal )
  return false;

  let result = _.entityDiffExplanation
  ({
    srcs : [ src1, src2 ],
    path : opts.iteration.lastPath,
  });

  return result;
}

//

function entityDiffExplanation( o )
{
  let result = '';

  o = _.routineOptions( entityDiffExplanation, arguments );
  _.assert( _.arrayIs( o.srcs ) );
  _.assert( o.srcs.length === 2 );

  if( o.path )
  {

    let dir = _.strIsolateEndOrNone( o.path, '/' )[ 0 ];
    if( !dir )
    dir = '/';

    _.assert( arguments.length === 1 );

    o.srcs[ 0 ] = _.select( o.srcs[ 0 ], dir );
    o.srcs[ 1 ] = _.select( o.srcs[ 1 ], dir );

    if( o.path !== '/' )
    result += 'at ' + o.path + '\n';

  }

  if( _.mapIs( o.srcs[ 0 ] ) && _.mapIs( o.srcs[ 1 ] ) )
  {
    let common = _.filter( _.mapFields( o.srcs[ 0 ] ), ( e, k ) => _.entityIdentical( e, o.srcs[ 1 ][ k ] ) ? e : undefined );
    o.srcs[ 0 ] = _.mapBut( o.srcs[ 0 ], common );
    o.srcs[ 1 ] = _.mapBut( o.srcs[ 1 ], common );
  }

  o.srcs[ 0 ] = _.toStr( o.srcs[ 0 ], { levels : 2 } );
  o.srcs[ 1 ] = _.toStr( o.srcs[ 1 ], { levels : 2 } );

  o.srcs[ 0 ] = _.strIndentation( o.srcs[ 0 ], '  ' );
  o.srcs[ 1 ] = _.strIndentation( o.srcs[ 1 ], '  ' );

  result += _.str( o.name1 + ' :\n' + o.srcs[ 0 ] + '\n' + o.name2 + ' :\n' + o.srcs[ 1 ] );

  /* */

  let strDiff = _.strDifference( o.srcs[ 0 ], o.srcs[ 1 ] );
  if( strDiff !== false )
  {
    result += ( '\n' + o.differenceName + ' :\n' + strDiff );
  }

  /* */

  if( o.accuracy !== null )
  result += '\n' + o.accuracyName + ' ' + o.accuracy + '\n';

  return result;
}

var defaults = entityDiffExplanation.defaults = Object.create( null );

defaults.name1 = '- src1';
defaults.name2 = '- src2';
defaults.differenceName = '- difference';
defaults.accuracyName = 'with accuracy';
defaults.srcs = null;
defaults.path = null;
defaults.accuracy = null;

// --
// declare
// --

let Proto =
{

  // entity investigator

  __entityEqualUp : __entityEqualUp,
  __entityEqualDown : __entityEqualDown,
  __entityEqualCycle : __entityEqualCycle,

  _entityEqual : _entityEqual,

  entityIdentical : entityIdentical,
  entityEquivalent : entityEquivalent,
  entityContains : entityContains,
  entityDiff : entityDiff,
  entityDiffExplanation : entityDiffExplanation,

}

_.mapSupplement( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
