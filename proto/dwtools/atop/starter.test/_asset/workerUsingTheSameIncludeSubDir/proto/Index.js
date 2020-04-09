
debugger;
let scriptPath = require.resolve( './Script.js' );
console.log( `Index.js : scriptPath : ${scriptPath}` );
debugger;
include( './Script.js' );
debugger;

window.tools.routine();

var worker = new Worker( './Worker.js' );
