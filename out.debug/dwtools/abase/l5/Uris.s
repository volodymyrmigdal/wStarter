( function _Uris_s_() {

'use strict';

/**
 * @file Uris.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  require( '../l4/Uri.s' );

}

//

let _ = _global_.wTools;
let Parent = _.uri;
let Self = _.uri.s = _.uri.s || Object.create( Parent );

// --
//
// --

function _keyEndsUriFilter( e,k,c )
{
  _.assert( 0, 'not tested' );

  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Uri' ) )
    return true;
    else
    return false
  }
  return this.is( e );
}

//

function _isUriFilter( e )
{
  return this.is( e[ 0 ] )
}

//

function vectorize( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( routine ) );
  select = select || 1;
  return _.routineVectorize_functor
  ({
    routine : [ 'single', routine ],
    vectorizingArray : 1,
    vectorizingMap : 0,
    vectorizingKeys : 1,
    select : select,
  });
}

//

function vectorizeOnly( routine )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( routine ) );
  return _.routineVectorize_functor
  ({
    routine : [ 'single', routine ],
    fieldFilter : _keyEndsUriFilter,
    vectorizingArray : 1,
    vectorizingMap : 1,
  });
}

// --
// fields
// --

let Fields =
{
  uri : Parent,
}

// --
// routines
// --

let Routines =
{

  _keyEndsUriFilter : _keyEndsUriFilter,
  _isUriFilter : _isUriFilter,

  // uri

  parse : vectorize( 'parse' ),
  parseAtomic : vectorize( 'parseAtomic' ),
  parseConsecutive : vectorize( 'parseConsecutive' ),

  onlyParse : vectorizeOnly( 'parse' ),
  onlyParseAtomic : vectorizeOnly( 'parseAtomic' ),
  onlyParseConsecutive : vectorizeOnly( 'parseConsecutive' ),

  str : vectorize( 'str' ),
  full : vectorize( 'full' ),

  normalizeTolerant : vectorize( 'normalizeTolerant' ),

  onlyTormalizeTolerant : vectorizeOnly( 'normalizeTolerant' ),

  rebase : vectorize( 'rebase', 3 ),

  documentGet : vectorize( 'documentGet', 2 ),
  server : vectorize( 'server' ),
  query : vectorize( 'query' ),
  dequery : vectorize( 'dequery' )

}

_.mapSupplementOwn( Self, Fields );
_.mapSupplementOwn( Self, Routines );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
