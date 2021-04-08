( function _worker_js_( ) {

  // include( '/wtools/abase/Layer2.s' );
  include( 'Tools' );

  const _ = _global_.wTools;

  var got1 = _.include( '/Module.js' );
  var got2 = _.include( '/Module.js' );

  console.log( 'Module was exported:', self.testModule !== undefined && got1 === self.testModule );
  console.log( 'Both includes have same export:', got1 === got2 );

})();
