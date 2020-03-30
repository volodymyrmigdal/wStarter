
/*
starter .start proto/experiment/F1.js
cls && local-starter .start builder/include/experiment/F1.js
*/

console.log( 'F1:before' );
require( './F2.js' );
console.log( 'F1:after' );

setTimeout( () => process.exit(), 3000 );
