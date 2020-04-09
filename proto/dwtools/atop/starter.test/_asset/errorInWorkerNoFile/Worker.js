console.log( 'Worker:begin' );

try
{
  require( './W1.js' );
}
catch( err )
{
  console.log( 'err:begin' );
  console.error( err );
  console.log( 'err:end' );
}

console.log( 'Worker:end' );
