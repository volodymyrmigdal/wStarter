let global = typeof window !== 'undefined' ? window : self;

if( global.tools )
throw "Already included"

function routine()
{
  console.log( "Global:", global.constructor.name );
}

var Routines =
{
  routine
}

global.tools = Object.create( null );

Object.assign( global.tools, Routines );
