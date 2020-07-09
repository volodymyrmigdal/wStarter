console.log( 'app1/File2.js:begin main:' + !module.parent );
require( './File1.js' );
console.log( 'app1/File2.js:end main:' + !module.parent );
