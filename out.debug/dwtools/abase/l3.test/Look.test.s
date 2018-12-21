( function _Looker_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  require( '../l3/Looker.s' );

  _.include( 'wTesting' );
  _.include( 'wStringer' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

function look( test )
{

  var structure1 =
  {
    a : 1,
    b : 's',
    c : [ 1,3 ],
    d : [ 1,{ date : new Date() } ],
    e : function(){},
    f : new ArrayBuffer( 13 ),
    g : new Float32Array([ 1,2,3 ]),
  }

  var expectedUpPaths = [ '/', '/a', '/b', '/c', '/c/0', '/c/1', '/d', '/d/0', '/d/1', '/d/1/date', '/e', '/f', '/g' ];
  var expectedDownPaths = [ '/a', '/b', '/c/0', '/c/1', '/c', '/d/0', '/d/1/date', '/d/1', '/d', '/e', '/f', '/g', '/' ];
  var expectedUpIndinces = [ null, 0, 1, 2, 0, 1, 3, 0, 1, 0, 4, 5, 6 ];
  var expectedDownIndices = [ 0, 1, 0, 1, 2, 0, 0, 1, 3, 4, 5, 6, null ];

  var gotUpPaths = [];
  var gotDownPaths = [];
  var gotUpIndinces = [];
  var gotDownIndices = [];

  function handleUp1( e, k, it )
  {
    debugger;
    gotUpPaths.push( it.path );
    gotUpIndinces.push( it.index );
  }

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
    gotDownIndices.push( it.index );
  }

  debugger;
  _.look( structure1, handleUp1, handleDown1 );
  debugger;

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );
  test.case = 'indices on up';
  test.identical( gotUpIndinces, expectedUpIndinces );
  test.case = 'indices on down';
  test.identical( gotDownIndices, expectedDownIndices );

}

// --
// declare
// --

var Self =
{

  name : 'Tools/base/l2/Look',
  silencing : 1,
  enabled : 1,

  context :
  {
  },

  tests :
  {

    look : look,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
