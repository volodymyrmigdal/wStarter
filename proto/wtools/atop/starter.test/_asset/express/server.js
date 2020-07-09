var express = require('express');
var app = express();
var port = 4444;

app.get( '/', ( req, res) => 
{
  res.send( 'Hello world' );
})

app.listen( port );

console.log( `Go to http://localhost:${port}` );