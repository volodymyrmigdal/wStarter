( function _Launcher_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( './Base.s' );

  require( '../l1/Namespace.s' );

  if( Config.interpreter === 'njs' )
  {
    require( '../l5/Center.s' );
  }

  require( '../l8/Launcher.s' );

  module.exports = _;
}

})();
