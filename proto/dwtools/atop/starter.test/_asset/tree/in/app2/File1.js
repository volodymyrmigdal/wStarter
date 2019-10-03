console.log( 'app2/File1.js:begin main:' + !module.parent );
require( '../app1/dir1/dir2/File2.js' );
console.log( 'app2/File1.js:end main:' + !module.parent );
