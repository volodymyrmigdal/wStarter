( function _Top_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  require( './Mid.s' );

  const _ = _global_.wTools;

  _.include( 'wCommandsAggregator' );
  // _.include( 'wCommandsConfig' );
  // _.include( 'wStateStorage' );
  // _.include( 'wStateSession' );

  require( '../l8/Cui.s' );

  module.exports = _;
}

})();
