( function _BrowserUserDirClean_s_()
{
  let _ = require( 'wTools' );
  _.include( 'wFiles' )

  let tempDirPath = process.argv[ 2 ];
  
  let tries = 0;
  let maxAttempts = 3;
  let timeOutBeforeNextAttempt = 5000;
  
  return deleteTemp().finally( check )
  
  /* */
  
  async function check( err, deleted )
  {
    debugger
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
  