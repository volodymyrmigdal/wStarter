( function _IncludeMid_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './IncludeBase.s' );

  require( './MainBase.s' );

  require( './legacy/StarterMaker.s' );

  if( Config.platform === 'nodejs' )
  require( './light/Servlet.ss' );

}

})();
