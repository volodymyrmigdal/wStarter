
const _ = require( '../../../node_modules/Tools' );

_.include( 'wProcess' );
_.include( 'wFiles' );

let o =
{
  execPath : _.path.join( __dirname, 'Experiment.js' ),
  // mode : 'shell',
}
// _.process._exitHandlerRepair();
let shell = _.process.startNjsPassingThrough( o );
