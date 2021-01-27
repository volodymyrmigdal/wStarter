
console.log( 'F1:begin' );

setTimeout( () =>
{
  Promise.reject( 'Promise Error!' );
}, 1000 );

setTimeout( () =>
{
  throw 'Some Error!'
}, 1000 );

console.log( 'F1:end' );
