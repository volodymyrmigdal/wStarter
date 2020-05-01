( function _module_js_( ) {

  if( self.testModule )
  throw 'Module is included second time';

  self.testModule = Object.create( null );

  Object.assign( self.testModule, { exported : 1 } )

  module.exports = self.testModule;

})();
