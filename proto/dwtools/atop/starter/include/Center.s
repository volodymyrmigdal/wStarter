( function _Center_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( './Base.s' );

  require( '../l1/Namespace.s' );

  if( Config.interpreter === 'njs' )
  {
    require( '../l5/Center.s' );
  }

  module.exports = _;
}

})();
