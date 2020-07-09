console.log( 'app1/File1.js:begin main:' + !module.parent );
require( '../../../External1.js' );
console.log( 'app1/File1.js:end main:' + !module.parent );
