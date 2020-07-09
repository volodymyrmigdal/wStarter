
let _ = require( '../../../wtools/Tools.s' );

_.include( 'wProcess' );
_.include( 'wFiles' );

let o =
{
  execPath : _.path.join( __dirname, 'Experiment.js' ),
  // mode : 'shell',
}
// _.process._exitHandlerRepair();
let shell = _.process.startNodePassingThrough( o );
