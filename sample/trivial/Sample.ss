
require( 'wstarter' );

let _ = wTools;

/* */

let programPath = _.module.resolve( 'wStarter' );

_.process.start
({
  execPath : `node ${ programPath } .version`,
  currentPath : __dirname,
  mode : 'shell',
  outputCollecting : 1,
});
