
debugger;
let scriptPath = require.resolve( './Script.js' );
debugger;
console.log( `Worker.js : scriptPath : ${scriptPath}` );

include( './Script.js' )
tools.routine();
