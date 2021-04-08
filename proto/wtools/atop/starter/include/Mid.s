( function _Mid_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( './Base.s' );

  require( '../l1/Namespace.s' );

  require( '../l3/Maker.s' );

  require( '../l5/Center.s' );
  require( '../l5/Maker2.s' );
  require( '../l5/Servlet.s' );
  require( '../l5/Session.s' );

  require( '../l7/System.s' );

  require( '../l7_session/BrowserCdp.s' );
  require( '../l7_session/Njs.s' );

  // require( './legacy/StarterMaker.s' );

  module.exports = _;
}

})();
