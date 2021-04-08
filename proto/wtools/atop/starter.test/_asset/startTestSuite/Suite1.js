( function _Suite1_js_()
{

'use strict';

const _ = require( '../../../../../node_modules/Tools' );
const _global = _global_;

_.include( 'wTesting' );

// --
// context
// --

function routine1( test )
{
  test.identical( 1, 1 );
  test.identical( 1, 0 );
}

// --
// declare
// --

const Self =
{

  name : 'Tools.Starter.Suite1',
  silencing : 1,

  tests :
  {

    routine1,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
