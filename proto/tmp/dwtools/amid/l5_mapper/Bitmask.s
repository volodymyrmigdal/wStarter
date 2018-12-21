( function _Bitmask_s_( ) {

'use strict';

/**
  @module Tools/mid/Bitmask - A small class to convert a map of Booleans to Integer and vice versa with help of defined schema. The constructor of Bitmask expects names which created instance use for conversion. Use the module to solve the bitmask conversion problem robustly.
*/

/**
 * @file mapping/Bitmask.s.
 */

// dependencies

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wCopyable' );

}

// constructor

var _ = _global_.wTools;
var Parent = null;
var Self = function wBitmask( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Bitmask';

// --
// inter
// --

function init( o )
{
  var self = this; /* changes context to current object */

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.instanceInit( self );/* extends object by fields from relations */

  Object.preventExtensions( self );/* disables object extending */

  if( o ) /* copy fields from options object */
  self.copy( o );

  _.assert( _.arrayIs( self.defaultFieldsArray ), 'Bitmask','needs defaultFieldsArray' ); /* checks if defaultFieldsArray is provided by( o ) */

}

//

/**
 * Converts boolean map( map ) into  32-bit number bitmask.
 * Each true/false key value in map corresponds to 1/0 bit value in number.
 * Before convertion function supplements source( map ) by unique fields from( defaultFieldsMap ).
 *
 * @param { object } map - source map.
 * @return { number } Returns boolean map values represented as number.
 *
 * @example
 * var defaultFieldsArray =
 * [
 *   { hidden : false },
 *   { system : true }
 * ];
 *
 * var bitmask = wBitmask
 * ({
 *   defaultFieldsArray : defaultFieldsArray
 * });
 * var word = bitmask.mapToWord( { hidden : true } );
 * console.log( word ); // returns 3( 0011 in Dec )
 *
 * @method mapToWord
 * @throws {exception} If no argument provided.
 * @throws {exception} If( map ) is not a Object.
 * @throws {exception} If( map ) is extended by unknown property.
 * @memberof wTools
 */

function mapToWord( map )
{
  var self = this;
  var result = 0;
  var names = self.names;
  var defaultFieldsMap = self.defaultFieldsMap;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( map ) );
  _.mapSupplement( map,defaultFieldsMap )
  _.assertMapHasOnly( map,defaultFieldsMap );

  for( var f = 0 ; f < names.length ; f++ )
  {
    var name = names[ f ];
    result |= map[ name ] ? 1 << f : 0;
  }

  return result;
}

//

/**
 * Applies 32-bit number bitmask( word ) on boolean map( defaultFieldsMap ).
 * Each bit value in number corresponds to true/false key value in map.
 *
 * @param { number } word - source bitmask.
 * @return { object } Returns new boolean map with values from( word ).
 *
 * @example
 * var defaultFieldsArray =
 * [
 *   { hidden : false },
 *   { system : true }
 * ];
 *
 * var bitmask = wBitmask
 * ({
 *   defaultFieldsArray : defaultFieldsArray
 * });
 * var map = bitmask.wordToMap( parseInt( '0011', 2 ) );
 * console.log( map ); // returns { hidden: true, system: true }
 *
 * @method wordToMap
 * @throws {exception} If no argument provided.
 * @throws {exception} If( word ) is not a Number.
 * @memberof wTools
 */

function wordToMap( word )
{
  var self = this;
  var result = {};
  var names = self.names;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( word ) );

  for( var f = 0 ; f < names.length ; f++ )
  {
    var name = names[ f ];
    result[ name ] = word & ( 1 << f ) ? true : false;
  }

  return result;
}

//

/**
 * Converts map( defaultFieldsMap ) to string representation using
 * options( o ).
 *
 * @param { object } o - options {@link wTools~toStrOptions}.
 * @return { string } Returns string that represents map's data.
 *
 * @example
 * var defaultFieldsArray =
 * [
 *   { hidden : false },
 *   { system : true }
 * ];
 *
 * var bitmask = wBitmask
 * ({
 *   defaultFieldsArray : defaultFieldsArray
 * });
 * var str = bitmask.toStr( { multiline : true } );
 * console.log( str );
 * // returns
 * // {
 * //   hidden: true,
 * //   system: true
 * // }
 *
 * @method toStr
 * @memberof wTools
 */

function toStr( o )
{
  var self = this;
  var result = '';
  var o = o || {};

  var result = _.toStr( self.defaultFieldsMap, o );
  return result;
}

//

/**
 * Setter for ( defaultFieldsArray ) field.
 * @param { array } src - source array.
 *
 * @example
 * var defaultFieldsArray =
 * [
 *   { hidden : false },
 *   { system : true }
 * ];
 * var bitmask = wBitmask
 * ({
 *   defaultFieldsArray : defaultFieldsArray
 * });
 * console.log( bitmask.defaultFieldsArray );
 * // returns [ { hidden: false }, { system: true } ]
 *
 * @private
 * @method _defaultFieldsArraySet
 * @throws {exception} If( src ) is not a Array or null.
 * @throws {exception} If( src.length ) is bigger then 32.
 * @memberof wTools
 */

function _defaultFieldsArraySet( src )
{
  var self = this;

  _.assert( _.arrayIs( src ) || src === null );

  var names = [];
  var defaultFieldsMap = {};

  if( src )
  {

    // debugger;
    // src = _.cloneJust( src );

    if( src.length > 32 )
    throw _.err( 'Bitmask cant store more then 32 fields' );

    for( var s = 0 ; s < src.length ; s++ )
    {
      var field = src[ s ];
      var keys = Object.keys( field );
      _.assert( _.objectIs( field ) );
      _.assert( keys.length === 1 );
      names.push( keys[ 0 ] );
      defaultFieldsMap[ keys[ 0 ] ] = field[ keys[ 0 ] ];
    }

  }

  self[ Symbol.for( 'defaultFieldsArray' ) ] = Object.freeze( src );
  self[ Symbol.for( 'names' ) ] = Object.freeze( names );
  self[ Symbol.for( 'defaultFieldsMap' ) ] = Object.freeze( defaultFieldsMap );

}

// --
// relations
// --

var Composes =
{
}

var Aggregates =
{
  defaultFieldsArray : null,
}

var Associates =
{
}

var Restricts =
{
}

// --
// declare
// --

var Proto =
{

  init : init,

  mapToWord : mapToWord,
  wordToMap : wordToMap,

  toStr : toStr,

  _defaultFieldsArraySet : _defaultFieldsArraySet,


  // relations


  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

};

// define

/*Makes prototype for constructor Self. Extends prototype with fields from Proto
and repairs relations : Composes, Aggregates, Associates, Restricts.*/

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

/*Mixins wCopyable into prototype Self*/

_.Copyable.mixin( Self );

// accessor

/*Defines set/get functions for provided object fields names*/

_.accessor.declare( Self.prototype,
{

  defaultFieldsArray : 'defaultFieldsArray',

});

// readonly

/*Makes fields readonly by defining only getter function*/

_.accessor.readOnly( Self.prototype,
{

  names : 'names',
  defaultFieldsMap : 'defaultFieldsMap',

});

//

/*Defines class on wTools and global namespaces*/

_[ Self.shortName ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
