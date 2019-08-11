
let _ = require( '../../Tools.s' );

_.include( 'wExternalFundamentals' );
_.include( 'wFiles' );

let o =
{
  execPath : _.path.join( __dirname, 'Experiment.js' ),
  // mode : 'shell',
}
// _.appExitHandlerRepair();
let shell = _.shellNodePassingThrough( o );
