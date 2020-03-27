( function _worker_js_( ) {

  include( '/dwtools/abase/Layer2.s' );

  var _ = _global_.wTools;

  var got1 = _.include( '/module.js' );
  var got2 = _.include( '/module.js' );

  console.log( 'Module was exported:', self.testModule !== undefined && got1 === self.testModule );
  console.log( 'Both includes have same export:', got1 === got2 );

})();
