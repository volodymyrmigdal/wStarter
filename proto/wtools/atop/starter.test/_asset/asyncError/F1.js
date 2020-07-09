
console.log( 'F1:begin' );

setTimeout( () =>
{
  throw 'Some Error!'
}, 1000 );

console.log( 'F1:end' );
