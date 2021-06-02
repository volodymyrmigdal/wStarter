
let global = typeof window !== 'undefined' ? window : self;

if( global.tools )
throw "Already included"

function routine()
{
  console.log( `Script.js : Global : ${global.constructor.name}` );
}

var Extension =
{
  routine
}

global.tools = Object.create( null );

Object.assign( global.tools, Extension );
