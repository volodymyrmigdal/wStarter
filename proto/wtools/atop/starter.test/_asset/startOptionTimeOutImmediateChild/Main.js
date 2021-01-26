
console.log( 'Main.js:begin' );

require( './F1.js' );
require( './F2.js' );
require( './F3.js' );

setTimeout( () => { console.log( 'Main.js:end' ) }, 30000 );
