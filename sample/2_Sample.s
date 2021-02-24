
if( typeof module !== 'undefined' )
require('./out/SingleFileTools.ss' );

let _ = wTools;
_.include( 'wFiles' );

console.log( _.strSplit( 'a b c' ) );

/* log : ["a", "", "b", "", "c"] */

_.fileProvider.filesDelete( _.path.join( __dirname, 'out' ) );
