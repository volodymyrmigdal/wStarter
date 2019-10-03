console.log( 'app2/File2.js:begin main:' + !module.parent );
require( './File1.js' );
console.log( 'app2/File2.js:end main:' + !module.parent );
