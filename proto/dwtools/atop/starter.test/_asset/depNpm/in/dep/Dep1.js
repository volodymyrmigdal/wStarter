console.log( 'Dep1.js:begin' );

let _ = require( 'wTools' );
_.include( 'wBlueprint' );

console.log( `` );
console.log( `Dep1.js` );
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
if( typeof wTools !== 'undefined' )
console.log( `wTools.blueprint.is : ${typeof wTools.blueprint.is}` );
console.log( `` );

console.log( 'Dep1.js:end' );
