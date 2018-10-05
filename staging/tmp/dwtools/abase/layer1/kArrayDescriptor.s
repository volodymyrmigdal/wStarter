(function _kArrayDescriptor_s_() {

'use strict';

var _global = _global_;
var _ = _global.wTools;
var Self = _global.wTools;

_.assert( !_.Array );
_.assert( !_.array );
_.assert( !_.withArray );

//

function _arrayNameSpaceApplyTo( dst,def )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !_.mapOwnKey( dst,'withArray' ) );
  _.assert( !_.mapOwnKey( dst,'array' ) );
  _.assert( !!ArrayNameSpaces[ def ] );

  dst.withArray = Object.create( null );

  for( var d in ArrayNameSpaces )
  {
    dst.withArray[ d ] = Object.create( dst );
    _.mapExtend( dst.withArray[ d ], ArrayNameSpaces[ d ] );
  }

  dst.array = dst.withArray[ def ];
  dst.ArrayNameSpaces = ArrayNameSpaces;

}

// --
// delcare
// --

function _declare( nameSpace )
{

var ArrayType = nameSpace.ArrayType;
var ArrayName = nameSpace.ArrayName;

nameSpace = _.mapExtend( null,nameSpace );

//

function makeSimilar( src,length )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  var result = _.longMakeSimilar( src,length );

  return result;
}

//

function makeArrayOfLength( length )
{

  if( length === undefined )
  length = 0;

  _.assert( length === undefined || length >= 0 );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  var result = new this.array.ArrayType( length );

  return result;
}

//

function makeArrayOfLengthZeroed( length )
{
  if( length === undefined )
  length = 0;

  _.assert( length === undefined || length >= 0 );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  var result = new this.array.ArrayType( length );

  if( this.array.ArrayType === Array )
  for( var i = 0 ; i < length ; i++ )
  result[ i ] = 0;

  return result;
}

//

function arrayFromCoercing( src )
{
  _.assert( _.longIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( src.constructor === this.array.ArrayType )
  return src;

  var result;

  if( this.array.ArrayType === Array )
  result = new( _.routineJoin( this.array.ArrayType, this.array.ArrayType, src ) );
  else
  result = new this.array.ArrayType( src );

  return result;
}

// --
//
// --

var Extend =
{

  makeSimilar : makeSimilar,
  makeArrayOfLength : makeArrayOfLength,
  makeArrayOfLengthZeroed : makeArrayOfLengthZeroed,

  arrayFrom : arrayFromCoercing,
  arrayFromCoercing : arrayFromCoercing,

  array : nameSpace,

}

_.mapExtend( nameSpace,Extend );
_.assert( !ArrayNameSpaces[ ArrayName ] );

ArrayNameSpaces[ ArrayName ] = nameSpace;

return nameSpace;

}

// --
//
// --

var _ArrayNameSpaces =
[
  { ArrayType : Float32Array, ArrayName : 'Float32' },
  { ArrayType : Uint32Array, ArrayName : 'Wrd32' },
  { ArrayType : Int32Array, ArrayName : 'Int32' },
  { ArrayType : Array, ArrayName : 'Array' },
]

// if( _.Array )
// debugger;
// if( _.Array )
// return;

_.assert( !_.Array );
_.assert( !_.array );
_.assert( !_.withArray );

var ArrayNameSpaces = Object.create( null );

_._arrayNameSpaceApplyTo = _arrayNameSpaceApplyTo;

for( var d = 0 ; d < _ArrayNameSpaces.length ; d++ )
_declare( _ArrayNameSpaces[ d ] );

_arrayNameSpaceApplyTo( _,'Array' );

_.assert( !_.Array );

_.assert( _.mapOwnKey( _,'withArray' ) );
_.assert( _.mapOwnKey( _,'array' ) );
_.assert( _.mapOwnKey( _.array,'array' ) );
_.assert( !_.mapOwnKey( _.array,'withArray' ) );
_.assert( !!_.array.withArray );

_.assert( _.objectIs( _.withArray ) );
_.assert( _.objectIs( _.array ) );
_.assert( _.routineIs( _.array.makeArrayOfLength ) );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
