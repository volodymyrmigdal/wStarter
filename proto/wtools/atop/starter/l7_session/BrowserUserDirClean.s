( function _BrowserUserDirClean_s_()
{
const _ = require( 'wTools' );
_.include( 'wFiles' )

/* */

let tempDirPath = process.argv[ 2 ];
let starterPid = _.numberFrom( process.argv[ 3 ] );
let waitForParent = _.boolFrom( process.argv[ 4 ] );

let tries = 0;
let maxAttempts = 3;
let timeOutBeforeNextAttempt = 5000;

let ready = _.Consequence().take( null );

if( waitForParent )
ready.then( () => waitForStarter( 1000 ) )

ready.then( () => deleteTemp().finally( check ) );

/* */

function waitForStarter( period )
{
  let ready = _.Consequence();
  let timer = _.time.periodic( period, () =>
  {
    if( _.process.isAlive( starterPid ) )
    return true;
    ready.take( true );
  })
  return ready;
}

async function check( err, deleted )
{

  if( deleted )
  return true;

  if( err )
  _.errAttend( err );

  tries++;
  if( tries < maxAttempts )
  {
    await _.time.out( timeOutBeforeNextAttempt );
    return deleteTemp().finally( check );
  }

  throw err;
}

/* */

function deleteTemp()
{
  return _.fileProvider.filesDelete
  ({
    filePath : tempDirPath,
    sync : 0
  })
}

})();
