( function _Mid_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( './Base.s' );

  require( '../l1/Namespace.s' );

  require( '../l3/Maker.s' );

  if( Config.interpreter === 'njs' )
  require( '../l5/Servlet.ss' );

  require( '../l7/Main.s' );

  // require( './legacy/StarterMaker.s' );

  module.exports = _;
}

})();
