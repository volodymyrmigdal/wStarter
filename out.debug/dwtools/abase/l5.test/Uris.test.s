( function _Uris_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );
  require( '../l4/Uri.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
//
// --

function refine( test )
{
  test.case = 'refine the uris';

  var srcs =
  [
    '/some/staging/index.html',
    '/some/staging/index.html/',
    '//some/staging/index.html',
    '//some/staging/index.html/',
    '///some/staging/index.html',
    '///some/staging/index.html/',
    'file:///some/staging/index.html',
    'file:///some/staging/index.html/',
    'http://some.come/staging/index.html',
    'http://some.come/staging/index.html/',
    'svn+https://user@subversion.com/svn/trunk',
    'svn+https://user@subversion.com/svn/trunk/',
    'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
    '://www.site.com:13/path//name//?query=here&and=here#anchor',
    ':///www.site.com:13/path//name/?query=here&and=here#anchor',
  ]

  var expected =
  [
    '/some/staging/index.html',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk',
    'svn+https://user@subversion.com/svn/trunk',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
    '://www.site.com:13/path//name//?query=here&and=here#anchor',
    ':///www.site.com:13/path//name?query=here&and=here#anchor'
  ]

  var got = _.uri.s.refine( srcs );
  test.identical( got, expected );
}


// --
// declare
// --

var Self =
{

  name : 'Tools/base/l4/Uri/S',
  silencing : 1,

  tests :
  {
    refine : refine,
  },

}

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self );

})();
