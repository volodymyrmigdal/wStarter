console.log( 'Index.js:begin' );

debugger;
var dir = require( './dir/**' );

console.log( `` );
console.log( `dir.length : ${dir.length}` );
console.log( `dir[ 0 ] : ${dir[ 0 ]}` );
console.log( `dir[ 1 ] : ${dir[ 1 ]}` );
debugger;

console.log( `` );
console.log( `Index.js` );
if( typeof _filePath_ !== 'undefined' )
console.log( `_filePath_ : ${_filePath_}` );
if( typeof _dirPath_ !== 'undefined' )
console.log( `_dirPath_ : ${_dirPath_}` );
console.log( `__filename : ${__filename}` );
console.log( `__dirname : ${__dirname}` );
console.log( `module : ${typeof module}` );
console.log( `module.parent : ${typeof module.parent}` );
console.log( `exports : ${typeof exports}` );
console.log( `require : ${typeof require}` );
if( typeof include !== 'undefined' )
console.log( `include : ${typeof include}` );
if( typeof _starter_ !== 'undefined' )
console.log( `_starter_.interpreter : ${_starter_.interpreter}` );
console.log( `` );

console.log( 'Index.js:end' );
