( function _Mid_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( './Base.s' );

  require( '../l1/Namespace.s' );

  require( '../l3/Maker.s' );

  if( Config.interpreter === 'njs' )
  {
    require( '../l5/Center.s' );
    require( '../l5/Servlet.s' );
    require( '../l5/Session.s' );
  }

  require( '../l7/System.s' );

  // require( './legacy/StarterMaker.s' );

  module.exports = _;
}

})();
