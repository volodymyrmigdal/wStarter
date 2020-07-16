( function _worker_js_( ) {

  include( '/wtools/abase/Layer2.s' );

  let _ = _global_.wTools;

  try
  {
    _.include( '/Module.js' );
    throw _.err( 'Module was included' );
  }
  catch( err )
  {
    console.log( '-' );
    // debugger;
    logger.error( String( err ) );
    // debugger;
    // _.errLogOnce( err );
  }

})();
