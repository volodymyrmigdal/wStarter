
/*
starter .start proto/experiment/F1.js
cls && starter .start builder/include/experiment/F1.js
*/

debugger;
console.log( 'F1:before' );
let got = require( './F2.js' );
console.log( `F1:${typeof got}`,  );
console.log( 'F1:after' );
module.exports = 'F1';

// setTimeout( () => process.exit(), 3000 );
