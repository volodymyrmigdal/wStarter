
( function _index_js_( ) {

  'use strict';

  if( typeof include !== 'undefined' ) 
  { 
    var _ = include( '/dwtools/abase/Layer2.s' );
    _.include( 'wPathBasic' );
  }
  
  var path = _.path.join( '/a', 'b' );
  console.log( path );
  
})();
