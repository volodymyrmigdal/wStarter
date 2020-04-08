
debugger;
console.log( 'F2:before' );
let got = require( './F1.js' );
console.log( `F2:${typeof got}`,  );
console.log( 'F2:after' );
module.exports = 'F1';
