( function _Uri_test_s_( ) {

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

function isRelative( test )
{

  test.case = 'relative with protocol'; /* */

  var path = 'ext://.';
  var expected = true;
  var got = _.uri.isRelative( path );
  test.identical( got, expected );

  test.case = 'relative with protocol and folder'; /* */

  var path = 'ext://something';
  var expected = true;
  var got = _.uri.isRelative( path );
  test.identical( got, expected );

  test.case = 'relative with protocol and 2 folders'; /* */

  var path = 'ext://something/longer';
  var expected = true;
  debugger;
  var got = _.uri.isRelative( path );
  debugger;
  test.identical( got, expected );

  test.case = 'absolute with protocol'; /* */

  var path = 'ext:///';
  var expected = false;
  var got = _.uri.isRelative( path );
  test.identical( got, expected );

}

//

function isRoot( test )
{

  test.case = 'local';

  var path = '/src/a1';
  var got = _.uri.isRoot( path );
  test.identical( got, false );

  var path = '.';
  var got = _.uri.isRoot( path );
  test.identical( got, false );

  var path = '';
  var got = _.uri.isRoot( path );
  test.identical( got, false );

  var path = '/';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  var path = '/.';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  var path = '/./.';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  var path = '/x/..';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  test.case = 'global';

  var path = 'extract+src:///src/a1';
  var got = _.uri.isRoot( path );
  test.identical( got, false );

  var path = 'extract+src:///';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///.';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///./.';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src:///x/..';
  var got = _.uri.isRoot( path );
  test.identical( got, true );

  var path = 'extract+src://';
  var got = _.uri.isRoot( path );
  test.identical( got, false );

  var path = 'extract+src://.';
  var got = _.uri.isRoot( path );
  test.identical( got, false );

}

//

function normalize( test )
{

  test.case = 'dot at end'; /* */

  var path = 'ext:///.';
  var expected = 'ext:///';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/.';
  var expected = 'file:///C/proto';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/'
  var expected ='://some/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = '://some/staging/index.html.'
  var expected ='://some/staging/index.html.'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html'
  var expected =':///some/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html/.'
  var expected =':///some/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html/./'
  var expected =':///some/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = ':///some/staging/./index.html/./'
  var expected =':///some/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = ':///some/staging/.//index.html/./'
  var expected =':///some/staging//index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html///.'
  var expected =':///some/staging/index.html///'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'file:///some/staging/index.html/..'
  var expected ='file:///some/staging'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'file:///some/staging/index.html/..///'
  var expected ='file:///some/staging///'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'file:///some\\staging\\index.html\\..\\'
  var expected ='file:///some/staging'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'http:///./some.come/staging/index.html/.'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'http:///./some.come/staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'http:///./some.come/./staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'svn+https://../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'svn+https://..//..//user@subversion.com/svn/trunk'
  var expected ='svn+https://..//user@subversion.com/svn/trunk'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'svn+https://..//../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'complex+protocol://www.site.com:13/path/name/.?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'complex+protocol://www.site.com:13/path/name/./../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path?query=here&and=here#anchor'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'complex+protocol://www.site.com:13/path/name/.//../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org/index/ranking'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org/index/ranking//'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org//index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://www.heritage.org//index/ranking//'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/../index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking//'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking//'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.'
  var expected ='https://web.archive.org/web/*\/http://index/ranking'
  var got = _.uri.normalize( path );
  test.identical( got,expected )

}

//

function normalizeLocalPaths( test )
{
  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar//baz/asdf';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar//baz/asdf';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '//foo/bar//baz/asdf//';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar//baz/asdf//';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp//foo';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp//';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp//';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '//';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '///';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  debugger
  var path = './/.//foo/bar/';
  var expected = './//foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '///foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '..//foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/..//foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = '.';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." and "." combined'; /* */

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.uri.normalize( path );
  test.identical( got, expected );

}

//

function normalizeTolerant( test )
{
  var got;

  test.case = 'dot at end'; /* */

  var path = 'ext:///.';
  var expected = 'ext:///';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'file:///C/proto/.';
  var expected = 'file:///C/proto/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '://some/staging/index.html/'
  var expected ='://some/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = '://some/staging/index.html/.'
  var expected ='://some/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = '://some/staging/index.html.'
  var expected ='://some/staging/index.html.'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html'
  var expected =':///some/staging/index.html'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html/.'
  var expected =':///some/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = ':///some/staging/./index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = ':///some/staging/.//index.html/./'
  var expected =':///some/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = ':///some/staging/index.html///.'
  var expected =':///some/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'file:///some/staging/index.html/..'
  var expected ='file:///some/staging/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'file:///some/staging/index.html/..///'
  var expected ='file:///some/staging/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'file:///some\\staging\\index.html\\..\\'
  var expected ='file:///some/staging/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'http:///./some.come/staging/index.html/.'
  var expected ='http:///some.come/staging/index.html/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'http:///./some.come/staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'http:///./some.come/./staging/index.html'
  var expected ='http:///some.come/staging/index.html'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'svn+https://../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'svn+https://..//..//user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'svn+https://..//../user@subversion.com/svn/trunk'
  var expected ='svn+https://../user@subversion.com/svn/trunk'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'complex+protocol://www.site.com:13/path/name/.?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'complex+protocol://www.site.com:13/path/name/./../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/?query=here&and=here#anchor'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'complex+protocol://www.site.com:13/path/name/.//../?query=here&and=here#anchor'
  var expected ='complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking/.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org//index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/www.heritage.org/index/ranking/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/../index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking//.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

  var path = 'https://web.archive.org/web/*\/http://www.heritage.org/.././index/ranking/./.'
  var expected ='https://web.archive.org/web/*\/http:/index/ranking/'
  var got = _.uri.normalizeTolerant( path );
  test.identical( got,expected )

}

//

function normalizeLocalPathsTolerant( test )
{
  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar/baz/asdf/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp/foo/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x./';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '../foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/../foo/bar/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = '/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." and "." combined'; /* */

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b/';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '../';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '../';
  var got = _.uri.normalizeTolerant( path );
  test.identical( got, expected );
}

//

function refine( test )
{
  test.case = 'refine the uri';

  var cases =
  [
    { src : '', expected : '.' },

    { src : 'a/', expected : 'a' },
    { src : 'a//', expected : 'a//' },
    { src : 'a\\', expected : 'a' },
    { src : 'a\\\\', expected : 'a//' },

    { src : 'a', expected : 'a' },
    { src : 'a/b', expected : 'a/b' },
    { src : 'a\\b', expected : 'a/b' },
    { src : '\\a\\b\\c', expected : '/a/b/c' },
    { src : '\\\\a\\\\b\\\\c', expected : '//a//b//c' },
    { src : '\\', expected : '/' },
    { src : '\\\\', expected : '//' },
    { src : '\\\\\\', expected : '///' },
    { src : '/', expected : '/' },
    { src : '//', expected : '//' },
    { src : '///', expected : '///' },

    {
      src : '/some/staging/index.html',
      expected : '/some/staging/index.html'
    },
    {
      src : '/some/staging/index.html/',
      expected : '/some/staging/index.html'
    },
    {
      src : '//some/staging/index.html',
      expected : '//some/staging/index.html'
    },
    {
      src : '//some/staging/index.html/',
      expected : '//some/staging/index.html'
    },
    {
      src : '///some/staging/index.html',
      expected : '///some/staging/index.html'
    },
    {
      src : '///some/staging/index.html/',
      expected : '///some/staging/index.html'
    },
    {
      src : 'file:///some/staging/index.html',
      expected : 'file:///some/staging/index.html'
    },
    {
      src : 'file:///some/staging/index.html/',
      expected : 'file:///some/staging/index.html'
    },
    {
      src : 'http://some.come/staging/index.html',
      expected : 'http://some.come/staging/index.html'
    },
    {
      src : 'http://some.come/staging/index.html/',
      expected : 'http://some.come/staging/index.html'
    },
    {
      src : 'svn+https://user@subversion.com/svn/trunk',
      expected : 'svn+https://user@subversion.com/svn/trunk'
    },
    {
      src : 'svn+https://user@subversion.com/svn/trunk/',
      expected : 'svn+https://user@subversion.com/svn/trunk'
    },
    {
      src : 'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor',
      expected : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
    },
    {
      src : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
      expected : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
    },
    {
      src : 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
      expected : 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking'
    },
    {
      src : 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
      expected : 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking'
    },
    {
      src : '://www.site.com:13/path//name//?query=here&and=here#anchor',
      expected : '://www.site.com:13/path//name//?query=here&and=here#anchor'
    },
    {
      src : ':///www.site.com:13/path//name/?query=here&and=here#anchor',
      expected : ':///www.site.com:13/path//name?query=here&and=here#anchor'
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    test.shouldThrowError( () => _.uri.refine( c.src ) );
    else
    test.identical( _.uri.refine( c.src ), c.expected );
  }

}

//

function urisRefine( test )
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

//

function parse( test )
{

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';

  /* */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';

  var expected =
  {
    localPath : '127.0.0.1:61726/../path',
    longPath : '127.0.0.1:61726/../path',
    protocols : [],
    full : '127.0.0.1:61726/../path'
  }
  var got = _.uri.parse( uri );
  test.identical( got, expected );

  var expected =
  {
    localPath : '127.0.0.1:61726/../path'
  }

  var got = _.uri.parseAtomic( uri );
  test.identical( got, expected );

  var expected =
  {
    longPath : '127.0.0.1:61726/../path'
  }

  var got = _.uri.parseConsecutive( uri );
  test.identical( got, expected );

  /* */

  test.case = 'full uri with all components';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    protocols : [ 'http' ],
    hostWithPort : 'www.site.com:13',
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var got = _.uri.parse( uri1 );
  test.identical( got, expected );

  test.case = 'full uri with all components, primitiveOnly'; /* */

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    // longPath : 'www.site.com:13/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.uri.parseAtomic( uri1 );
  test.identical( got, expected );

  test.case = 'reparse with non primitives';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    longPath : 'www.site.com:13/path/name',
    protocols : [ 'http' ],
    hostWithPort : 'www.site.com:13',
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var parsed = got;
  var got = _.uri.parse( parsed );
  test.identical( got, expected );

  test.case = 'reparse with primitives';

  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    // longPath : 'www.site.com:13/path/name',
  }

  var got = _.uri.parseAtomic( uri1 );
  test.identical( got, expected );

  test.case = 'uri with zero length protocol'; /* */

  var uri = '://some.domain.com/something/to/add';

  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    localPath : '/something/to/add',
    longPath : 'some.domain.com/something/to/add',
    protocols : [],
    hostWithPort : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/something/to/add',
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  test.case = 'uri with zero length hostWithPort'; /* */

  var uri = 'file:///something/to/add';

  var expected =
  {
    protocol : 'file',
    host : '',
    localPath : '/something/to/add',
    longPath : '/something/to/add',
    protocols : [ 'file' ],
    hostWithPort : '',
    origin : 'file://',
    full : 'file:///something/to/add',
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  test.case = 'uri with double protocol'; /* */

  var uri = 'svn+https://user@subversion.com/svn/trunk';

  var expected =
  {
    protocol : 'svn+https',
    host : 'user@subversion.com',
    localPath : '/svn/trunk',
    longPath : 'user@subversion.com/svn/trunk',
    protocols : [ 'svn','https' ],
    hostWithPort : 'user@subversion.com',
    origin : 'svn+https://user@subversion.com',
    full : 'svn+https://user@subversion.com/svn/trunk',
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  test.case = 'simple path'; /* */

  var uri = '/some/file';

  var expected =
  {
    localPath : '/some/file',
    longPath : '/some/file',
    protocols : [],
    full : '/some/file',
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  test.case = 'without ":"'; /* */

  var uri = '//some.domain.com/was';
  var expected =
  {
    localPath : '//some.domain.com/was',
    longPath : '//some.domain.com/was',
    protocols : [],
    full : '//some.domain.com/was'
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  test.case = 'with ":"'; /* */

  var uri = '://some.domain.com/was';
  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    localPath : '/was',
    longPath : 'some.domain.com/was',
    protocols : [ '' ],
    hostWithPort : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/was'
  }

  test.case = 'with ":" and protocol'; /* */

  var uri = 'protocol://some.domain.com/was';
  var expected =
  {
    protocol : 'protocol',
    host : 'some.domain.com',
    localPath : '/was',
    longPath : 'some.domain.com/was',
    protocols : [ 'protocol' ],
    hostWithPort : 'some.domain.com',
    origin : 'protocol://some.domain.com',
    full : 'protocol://some.domain.com/was'
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  test.case = 'simple path'; /* */

  var uri = '//';
  var expected =
  {
    localPath : '//',
    longPath : '//',
    protocols : [],
    full : '//'
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  var uri = '///';
  var expected =
  {
    localPath : '///',
    longPath : '///',
    protocols : [],
    full : '///'
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  var uri = '///a/b/c';
  var expected =
  {
    localPath : '///a/b/c',
    longPath : '///a/b/c',
    protocols : [],
    full : '///a/b/c'
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected )

  test.case = 'complex';
  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'complex+protocol',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path/name',
    protocols : [ 'complex', 'protocol' ],
    hostWithPort : 'www.site.com:13',
    origin : 'complex+protocol://www.site.com:13',
    full : uri,
  }

  var got = _.uri.parse( uri );
  test.identical( got, expected );

  test.case = 'complex, parseAtomic + str';
  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uri.parseAtomic( uri );
  var expected =
  {
    protocol : 'complex+protocol',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );
  var newUrl = _.uri.str( got );
  test.identical( newUrl, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    protocol : '',
    host : 'www.site.com',
    port : '13',
    localPath : '/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path//name//',
    protocols : [],
    hostWithPort : 'www.site.com:13',
    origin : '://www.site.com:13',
    full : uri,
  }
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uri.parseAtomic( uri );
  var expected =
  {
    protocol : '',
    host : 'www.site.com',
    port : '13',
    localPath : '/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor'
  }
  test.identical( got, expected );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uri.parseConsecutive( uri );
  var expected =
  {
    protocol : '',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : 'www.site.com:13/path//name//',
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    protocol : '',
    host : '',
    localPath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
    protocols : [],
    hostWithPort : '',
    origin : '://',
    full : uri,
    longPath : '/www.site.com:13/path//name//',
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uri.parseAtomic( uri );
  var expected =
  {
    protocol : '',
    host : '',
    localPath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.uri.parseConsecutive( uri );
  var expected =
  {
    protocol : '',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : '/www.site.com:13/path//name//'
  }
  test.identical( got, expected );

  /* */

  var expected =
  {
    localPath : '///some.com:99/staging/index.html',
    query : 'query=here&and=here',
    hash : 'anchor',
    longPath : '///some.com:99/staging/index.html',
    protocols : [],
    full : '///some.com:99/staging/index.html?query=here&and=here#anchor',
  }
  var got = _.uri.parse( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
  test.identical( got, expected );

  var expected =
  {
    localPath : '///some.com:99/staging/index.html',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uri.parseAtomic( '///some.com:99/staging/index.html?query=here&and=here#anchor' );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _.uri.parse();
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    _.uri.parse( 'http://www.site.com:13/path/name?query=here&and=here#anchor','' );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function()
  {
    _.uri.parse( 34 );
  });

}

//

function parseGlob( test )
{
  test.open( 'local path' );

  var src = '!a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/a/!a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/a/!a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/a/^a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/a/+a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/a/!';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/a/^';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/a/+';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '?';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '*';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '**';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '?c.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '*.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '**/a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir?c/a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/*.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/**.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/**/a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/dir?c/a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/dir/*.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/dir/**.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/dir/**/a.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '[a-c]';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '{a,c}';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '(a|b)';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '(ab)';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '@(ab)';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '!(ab)';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '?(ab)';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '*(ab)';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '+(ab)';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/[a-c].js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/{a,c}.js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/(a|b).js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/(ab).js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/@(ab).js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/!(ab).js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/?(ab).js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/*(ab).js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = 'dir/+(ab).js';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  var src = '/index/**';
  var got = _.uri.parse( src );
  var expected = { localPath : src };
  test.contains( got, expected );

  test.close( 'local path' );

  //

  test.open( 'complex uri' );

  var src = '/!a.js?';
  var uri = 'complex+protocol://www.site.com:13/!a.js??query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/a/!a.js';
  var uri = 'complex+protocol://www.site.com:13/a/!a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/a/^a.js';
  var uri = 'complex+protocol://www.site.com:13/a/^a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/a/+a.js';
  var uri = 'complex+protocol://www.site.com:13/a/+a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/a/!';
  var uri = 'complex+protocol://www.site.com:13/a/!?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/a/^';
  var uri = 'complex+protocol://www.site.com:13/a/^?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/a/+';
  var uri = 'complex+protocol://www.site.com:13/a/+?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/?';
  var uri = 'complex+protocol://www.site.com:13/??query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/*';
  var uri = 'complex+protocol://www.site.com:13/*?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/**';
  var uri = 'complex+protocol://www.site.com:13/**?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/?c.js';
  var uri = 'complex+protocol://www.site.com:13/?c.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/*.js';
  var uri = 'complex+protocol://www.site.com:13/*.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/**/a.js';
  var uri = 'complex+protocol://www.site.com:13/**/a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir?c/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir?c/a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/*.js';
  var uri = 'complex+protocol://www.site.com:13/dir/*.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/**.js';
  var uri = 'complex+protocol://www.site.com:13/dir/**.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/**/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir/**/a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir?c/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir?c/a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/*.js';
  var uri = 'complex+protocol://www.site.com:13/dir/*.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/**/a.js';
  var uri = 'complex+protocol://www.site.com:13/dir/**/a.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/[a-c]';
  var uri = 'complex+protocol://www.site.com:13/[a-c]?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/{a-c}';
  var uri = 'complex+protocol://www.site.com:13/{a-c}?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/(a|b)';
  var uri = 'complex+protocol://www.site.com:13/(a|b)?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/@(ab)';
  var uri = 'complex+protocol://www.site.com:13/@(ab)?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/!(ab)';
  var uri = 'complex+protocol://www.site.com:13/!(ab)?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/?(ab)';
  var uri = 'complex+protocol://www.site.com:13/?(ab)?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/*(ab)';
  var uri = 'complex+protocol://www.site.com:13/*(ab)?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/+(ab)';
  var uri = 'complex+protocol://www.site.com:13/+(ab)?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/[a-c].js';
  var uri = 'complex+protocol://www.site.com:13/dir/[a-c].js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/{a,c}.js';
  var uri = 'complex+protocol://www.site.com:13/dir/{a,c}.js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/(a|b).js';
  var uri = 'complex+protocol://www.site.com:13/dir/(a|b).js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/(ab).js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/@(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/@(ab).js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/?(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/?(ab).js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/*(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/*(ab).js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/dir/+(ab).js';
  var uri = 'complex+protocol://www.site.com:13/dir/+(ab).js?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  var src = '/index/**';
  var uri = 'complex+protocol://www.site.com:13/index/**?query=here&and=here#anchor';
  var got = _.uri.parse( uri );
  var expected =
  {
    localPath : src,
    query : 'query=here&and=here',
    hash : 'anchor'
  };
  test.contains( got, expected );

  test.close( 'complex uri' );

  // '?';
  // '*';
  // '**';
  // '?c.js';
  // '*.js';
  // '**/a.js';
  // 'dir?c/a.js';
  // 'dir/*.js';
  // 'dir/**.js';
  // 'dir/**/a.js';
  // '/dir?c/a.js';
  // '/dir/*.js';
  // '/dir/**.js';
  // '/dir/**/a.js';
  // '[a-c]';
  // '{a,c}';
  // '(a|b)';
  // '(ab)';
  // '@(ab)';
  // '!(ab)';
  // '?(ab)';
  // '*(ab)';
  // '+(ab)';
  // 'dir/[a-c].js';
  // 'dir/{a,c}.js';
  // 'dir/(a|b).js';
  // 'dir/(ab).js';
  // 'dir/@(ab).js';
  // 'dir/!(ab).js';
  // 'dir/?(ab).js';
  // 'dir/*(ab).js';
  // 'dir/+(ab).js';
  // '/index/**';
}

//

function str( test )
{

  var uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var components0 =
  {
    full : uri
  }

  var components2 =
  {
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    origin: 'http://www.site.com:13'
  }

  var components3 =
  {
    protocol : 'http',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    hostWithPort : 'www.site.com:13'
  }

  /* */

  test.case = 'string from string';
  var expected = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uri.str( 'http://www.site.com:13/path/name?query=here&and=here#anchor' );
  test.identical( got, expected );

  /* */

  test.case = 'make uri from components uri';
  var expected1 = uri;
  var got = _.uri.str( components0 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri from atomic components';
  var components =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  var got = _.uri.str( components );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri from composites components: origin';
  var got = _.uri.str( components2 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri from composites components: hostWithPort';
  var got = _.uri.str( components3 );
  test.identical( got, expected1 );

  /* */

  test.case = 'make uri from composites components: hostWithPort';
  var expected = '//some.domain.com/was';
  var components =
  {
    host : 'some.domain.com',
    localPath : '/was',
  }
  var got = _.uri.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'no host, but protocol'

  var components =
  {
    localPath : '/some2',
    protocol : 'src',
  }
  var expected = 'src:///some2';
  var got = _.uri.str( components );
  test.identical( got, expected );

  var components =
  {
    localPath : 'some2',
    protocol : 'src',
  }
  var expected = 'src://some2';
  var got = _.uri.str( components );
  test.identical( got, expected );

  /* */

  test.case = 'hash and protocol null, but protocols presents'

  var components =
  {
    protocol : null,
    hash : null,
    longPath : '/github.com/user/repo.git',
    protocols : [ 'git' ]
  }
  var expected = 'git:///github.com/user/repo.git';
  var got = _.uri.str( components );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.uri.str() );
  test.shouldThrowErrorSync( () => _.uri.str( 'a', 'b' ) );
  test.shouldThrowErrorSync( () => _.uri.str({ x : 'x' }) );

}

//

function parseAndStr( test )
{

  test.open( 'all' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uri.parse( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  /* - */

  test.close( 'all' );
  test.open( 'atomic' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'git:///github.com/user/repo.git';
  var parsed = _.uri.parseAtomic( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  /* - */

  test.close( 'atomic' );
  test.open( 'consecutive' );

  /* - */

  test.case = 'no protocol';

  var uri = '127.0.0.1:61726/../path';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  test.case = 'other';

  var uri = '/some/staging/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//some/staging/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some/staging/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some/staging/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come/staging/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/index.html';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'protocol://';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//:99';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '://:99';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//?q=1#x';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '//a/b/c';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = '///a/b/c';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  var uri = 'git:///github.com/user/repo.git';
  var parsed = _.uri.parseConsecutive( uri );
  var got = _.uri.str( parsed );
  test.identical( got, uri );

  /* - */

  test.close( 'consecutive' );

}

//
//
// function from( test )
// {
//   var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
//   var options1 =
//   {
//     full : string,
//   }
//   var expected1 = string;
//
//   test.case = 'call with options.uri';
//   var got = _.uri.from( options1 );
//   test.contains( got, expected1 );
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed arguments';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uri.from();
//   });
//
// }

//

function documentGet( test )
{

  var uri1 = 'https://www.site.com:13/path/name?query=here&and=here#anchor',
    uri2 = 'www.site.com:13/path/name?query=here&and=here#anchor',
    uri3 = 'http://www.site.com:13/path/name',
    options1 = { withoutServer: 1 },
    options2 = { withoutProtocol: 1 },
    expected1 = 'https://www.site.com:13/path/name',
    expected2 = 'http://www.site.com:13/path/name',
    expected3 = 'www.site.com:13/path/name',
    expected4 = '/path/name';

  test.case = 'full components uri';
  var got = _.uri.documentGet( uri1 );
  test.contains( got, expected1 );

  test.case = 'uri without protocol';
  var got = _.uri.documentGet( uri2 );
  test.contains( got, expected2 );

  test.case = 'uri without query, options withoutProtocol = 1';
  var got = _.uri.documentGet( uri3, options2 );
  test.contains( got, expected3 );

  test.case = 'get path only';
  var got = _.uri.documentGet( uri1, options1 );
  test.contains( got, expected4 );

}

//

function server( test )
{
  var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected = 'http://www.site.com:13/';

  test.case = 'get server part of uri';
  var got = _.uri.server( string );
  test.contains( got, expected );

}

//

function query( test )
{
  var string = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
    expected = 'query=here&and=here#anchor';

  test.case = 'get query part of uri';
  var got = _.uri.query( string );
  test.contains( got, expected );

}

//

function dequery( test )
{
  var query1 = 'key=value',
    query2 = 'key1=value1&key2=value2&key3=value3',
    query3 = 'k1=&k2=v2%20v3&k3=v4_v4',
    expected1 = { key: 'value' },
    expected2 =
    {
      key1 : 'value1',
      key2 : 'value2',
      key3 : 'value3'
    },
    expected3 =
    {
      k1: '',
      k2: 'v2 v3',
      k3: 'v4_v4'
    };

  test.case = 'parse simpliest query';
  var got = _.uri.dequery( query1 );
  test.contains( got, expected1 );

  test.case = 'parse query with several key/value pair';
  var got = _.uri.dequery( query2 );
  test.contains( got, expected2 );

  test.case = 'parse query with several key/value pair and decoding';
  var got = _.uri.dequery( query3 );
  test.contains( got, expected3 );

}

//
//
// function _uriJoin_body( test )
// {
//
//   var paths1 = [ 'http://www.site.com:13/', 'bar', 'foo', ];
//   var paths2 = [ 'c:\\', 'foo\\', 'bar\\' ];
//   var paths3 = [ '/bar/', '/', 'foo/' ];
//   var paths4 = [ '/bar/', '/baz', 'foo/' ];
//
//   var expected1 = 'http://www.site.com:13/bar/foo';
//   var expected2 = '/c/foo/bar';
//   var expected3 = '/foo';
//   var expected4 = '/bar/baz/foo';
//
//   test.case = 'join URI';
//   var got = _.uri._uriJoin_body
//   ({
//     paths : paths1,
//     reroot : 0,
//     isUri : 1,
//     allowingNull : 1,
//   });
//   test.identical( got, expected1 );
//
//   test.case = 'join windows os paths';
//   var got = _.uri._uriJoin_body
//   ({
//     paths : paths2,
//     reroot : 0,
//     isUri : 0,
//     allowingNull : 1,
//   });
//   test.identical( got, expected2 );
//
//   test.case = 'join unix os paths';
//   var got = _.uri._uriJoin_body
//   ({
//     paths : paths3,
//     reroot : 0,
//     isUri : 0,
//     allowingNull : 1,
//   });
//   test.identical( got, expected3 );
//
//   test.case = 'join unix os paths with reroot';
//   var got = _.uri._uriJoin_body
//   ({
//     paths : paths4,
//     reroot : 1,
//     isUri : 0,
//     allowingNull : 1,
//   });
//   test.identical( got, expected4 );
//
//   test.case = 'join reroot with /';
//   var got = _.uri._uriJoin_body
//   ({
//     paths : [ '/','/a/b' ],
//     reroot : 1,
//     isUri : 0,
//     allowingNull : 1,
//   });
//   test.identical( got, '/a/b' );
//
//   if( !Config.debug )
//   return;
//
//   test.case = 'missed arguments';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uri._uriJoin_body();
//   });
//
//   test.case = 'path element is not string';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uri._uriJoin_body( _.mapSupplement( { paths : [ 34 , 'foo/' ] },options3 ) );
//   });
//
//   test.case = 'missed options';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uri._uriJoin_body( paths1 );
//   });
//
//   test.case = 'options has unexpected parameters';
//   test.shouldThrowErrorSync( function()
//   {
//     debugger;
//     _.uri._uriJoin_body({ paths : paths1, wrongParameter : 1 });
//     debugger;
//   });
//
//   test.case = 'options does not has paths';
//   test.shouldThrowErrorSync( function()
//   {
//     _.uri._uriJoin_body({ wrongParameter : 1 });
//   });
//
// }

//

function join( test )
{

  test.case = 'join with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';

  var got = _.uri.join( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'join different protocols';

  var got = _.uri.join( 'file://www.site.com:13','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'file:///d','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'join same protocols';

  var got = _.uri.join( 'http://www.site.com:13','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http:///www.site.com:13','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http://server1','a','http://server2','b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http:///server1','a','http://server2','b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http://server1','a','http:///server2','b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'join protocol with protocol-less';

  var got = _.uri.join( 'http://www.site.com:13','a',':///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http:///www.site.com:13','a','://dir','b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http:///www.site.com:13','a',':///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http://www.site.com:13','a','://dir','b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http://dir:13','a','://dir','b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uri.join( 'http://www.site.com:13','a','://:14','b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uri.join( 'a','://dir1/x','b','http://dir2/y','c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uri.join( 'a',':///dir1/x','b','http://dir2/y','c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uri.join( 'a','://dir1/x','b','http:///dir2/y','c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uri.join( 'a',':///dir1/x','b','http:///dir2/y','c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server join absolute path 1';
  var got = _.uri.join( 'http://www.site.com:13','/x','/y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uri.join( 'http://www.site.com:13/','x','/y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path 2';
  var got = _.uri.join( 'http://www.site.com:13/','x','y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server join absolute path';
  var got = _.uri.join( 'http://www.site.com:13/','x','/y','z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server join relative path';
  var got = _.uri.join( 'http://www.site.com:13/','x','y','z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uri.join( 'http://www.site.com:13/ab','/y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uri.join( 'http://www.site.com:13/ab','/y','z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path join absolute path 2';
  var got = _.uri.join( 'http://www.site.com:13/ab','y','z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative to uri with no localPath';
  var got = _.uri.join( 'https://some.domain.com/','something/to/add' );
  test.identical( got, 'https://some.domain.com/something/to/add' );

  test.case = 'add relative to uri with localPath';
  var got = _.uri.join( 'https://some.domain.com/was','something/to/add' );
  test.identical( got, 'https://some.domain.com/was/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( 'https://some.domain.com/was','/something/to/add' );
  test.identical( got, 'https:///something/to/add' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '//some.domain.com/was','/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '://some.domain.com/was','/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '//some.domain.com/was', 'x', '/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '://some.domain.com/was', 'x', '/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '//some.domain.com/was', '/something/to/add', 'x' );
  test.identical( got, '/something/to/add/x' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '://some.domain.com/was', '/something/to/add', 'x' );
  test.identical( got, ':///something/to/add/x' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '//some.domain.com/was', '/something/to/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '://some.domain.com/was', '/something/to/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '/some/staging/index.html','/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '/some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '/some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, '/something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '/some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '///some/staging/index.html','/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( ':///some/staging/index.html','/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '///some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( ':///some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '///some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, '/something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( ':///some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, ':///something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( '///some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( ':///some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( 'svn+https://user@subversion.com/svn/trunk','/something/to/add' );
  test.identical( got, 'svn+https:///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/to/add' );
  test.identical( got, 'svn+https:///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/to/add', 'y' );
  test.identical( got, 'svn+https:///something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( 'svn+https://user@subversion.com/svn/trunk','/something/to/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( uri,'/something/to/add' );
  test.identical( got, 'complex+protocol:///something/to/add?query=here&and=here#anchor' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( uri, 'x', '/something/to/add' );
  test.identical( got, 'complex+protocol:///something/to/add?query=here&and=here#anchor' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( uri, 'x', '/something/to/add', 'y' );
  test.identical( got, 'complex+protocol:///something/to/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( uri,'/something/to/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uri.join( '/something/to/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/to/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uri2 = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uri.join( uri1, uri2, '/x//y//z'  );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.join( uri, 'x'  );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.join( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.join( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uri.join( uri, 'x/'  );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.join( uri, 'x'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.join( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.join( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.join( uri, 'x/'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.join( 'file:///some/file','/something/to/add' );
  test.identical( got, 'file:///something/to/add' );

  /* */

  test.case = 'add uris';

  var got = _.uri.join( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uri.join( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );
  // test.identical( got, 'd://e/f' );

  var got = _.uri.join( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.case = 'other special cases';

  /* qqq */

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc','.' ];
  var expected = '/aa/bb//cc';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [  '/','a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/d/..e';
  var got = _.uri.join.apply( _.uri, paths );
  test.identical( got, expected );

}

//

function joinRaw( test )
{

  test.case = 'joinRaw with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  test.case = 'replace protocol';

  var got = _.uri.joinRaw( 'src:///in', 'fmap://' );
  var expected = 'fmap:///in';
  test.identical( got, expected );

  test.case = 'joinRaw different protocols';

  var got = _.uri.joinRaw( 'file://www.site.com:13','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'file:///d','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  test.case = 'joinRaw same protocols';

  var got = _.uri.joinRaw( 'http://www.site.com:13','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http:///www.site.com:13','a','http:///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http://server1','a','http://server2','b' );
  var expected = 'http://server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http:///server1','a','http://server2','b' );
  var expected = 'http:///server1/a/server2/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http://server1','a','http:///server2','b' );
  var expected = 'http:///server2/b';
  test.identical( got, expected );

  test.case = 'joinRaw protocol with protocol-less';

  var got = _.uri.joinRaw( 'http://www.site.com:13','a',':///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http:///www.site.com:13','a','://dir','b' );
  var expected = 'http:///www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http:///www.site.com:13','a',':///dir','b' );
  var expected = 'http:///dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http://www.site.com:13','a','://dir','b' );
  var expected = 'http://www.site.com:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http://dir:13','a','://dir','b' );
  var expected = 'http://dir:13/a/dir/b';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'http://www.site.com:13','a','://:14','b' );
  var expected = 'http://www.site.com:13/a/:14/b';
  test.identical( got, expected );

  /**/

  var got = _.uri.joinRaw( 'a','://dir1/x','b','http://dir2/y','c' );
  var expected = 'http://a/dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'a',':///dir1/x','b','http://dir2/y','c' );
  var expected = 'http:///dir1/x/b/dir2/y/c';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'a','://dir1/x','b','http:///dir2/y','c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  var got = _.uri.joinRaw( 'a',':///dir1/x','b','http:///dir2/y','c' );
  var expected = 'http:///dir2/y/c';
  test.identical( got, expected );

  /* */

  test.case = 'server joinRaw absolute path 1';
  var got = _.uri.joinRaw( 'http://www.site.com:13','/x','/y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uri.joinRaw( 'http://www.site.com:13/','x','/y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path 2';
  var got = _.uri.joinRaw( 'http://www.site.com:13/','x','y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server joinRaw absolute path';
  var got = _.uri.joinRaw( 'http://www.site.com:13/','x','/y','z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server joinRaw relative path';
  var got = _.uri.joinRaw( 'http://www.site.com:13/','x','y','z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uri.joinRaw( 'http://www.site.com:13/ab','/y','/z' );
  test.identical( got, 'http:///z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uri.joinRaw( 'http://www.site.com:13/ab','/y','z' );
  test.identical( got, 'http:///y/z' );

  test.case = 'server with path joinRaw absolute path 2';
  var got = _.uri.joinRaw( 'http://www.site.com:13/ab','y','z' );
  test.identical( got, 'http://www.site.com:13/ab/y/z' );

  test.case = 'add relative to uri with no localPath';
  var got = _.uri.joinRaw( 'https://some.domain.com/','something/to/add' );
  test.identical( got, 'https://some.domain.com/something/to/add' );

  test.case = 'add relative to uri with localPath';
  var got = _.uri.joinRaw( 'https://some.domain.com/was','something/to/add' );
  test.identical( got, 'https://some.domain.com/was/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( 'https://some.domain.com/was','/something/to/add' );
  test.identical( got, 'https:///something/to/add' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '//some.domain.com/was','/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '://some.domain.com/was','/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '//some.domain.com/was', 'x', '/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '://some.domain.com/was', 'x', '/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '//some.domain.com/was', '/something/to/add', 'x' );
  test.identical( got, '/something/to/add/x' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '://some.domain.com/was', '/something/to/add', 'x' );
  test.identical( got, ':///something/to/add/x' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '//some.domain.com/was', '/something/to/add', '/x' );
  test.identical( got, '/x' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '://some.domain.com/was', '/something/to/add', '/x' );
  test.identical( got, ':///x' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '/some/staging/index.html','/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '/some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '/some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, '/something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '/some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, '/y' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '///some/staging/index.html','/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( ':///some/staging/index.html','/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '///some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( ':///some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, ':///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '///some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, '/something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( ':///some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, ':///something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( '///some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, '/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( ':///some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, ':///y' );

  /* */

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( 'svn+https://user@subversion.com/svn/trunk','/something/to/add' );
  test.identical( got, 'svn+https:///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/to/add' );
  test.identical( got, 'svn+https:///something/to/add' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/to/add', 'y' );
  test.identical( got, 'svn+https:///something/to/add/y' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( 'svn+https://user@subversion.com/svn/trunk','/something/to/add', '/y' );
  test.identical( got, 'svn+https:///y' );

  /* */

  var uri = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.uri.parse( uri );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( uri,'/something/to/add' );
  test.identical( got, 'complex+protocol:///something/to/add?query=here&and=here#anchor' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( uri, 'x', '/something/to/add' );
  test.identical( got, 'complex+protocol:///something/to/add?query=here&and=here#anchor' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( uri, 'x', '/something/to/add', 'y' );
  test.identical( got, 'complex+protocol:///something/to/add/y?query=here&and=here#anchor' );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( uri,'/something/to/add', '/y' );
  test.identical( got, 'complex+protocol:///y?query=here&and=here#anchor' );

  test.case = 'prased uri at the end';
  var got = _.uri.joinRaw( '/something/to/add', 'y', uri );
  test.identical( got, 'complex+protocol:///something/to/add/y/www.site.com:13/path/name?query=here&and=here#anchor' );

  /* */

  test.case = 'several queries and hashes'
  var uri1 = '://user:pass@sub.host.com:8080/p/a/t/h?query1=string1#hash1';
  var uri2 = '://user:pass@sub.host.com:8080/p/a/t/h?query2=string2#hash2';
  var got = _.uri.joinRaw( uri1, uri2, '/x//y//z'  );
  var expected = ':///x//y//z?query1=string1&query2=string2#hash2';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.joinRaw( uri, 'x'  );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.joinRaw( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.joinRaw( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash';
  test.identical( got, expected );

  var uri = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.uri.joinRaw( uri, 'x/'  );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.joinRaw( uri, 'x'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.joinRaw( uri, 'x', '/y'  );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.joinRaw( uri, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var uri = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.uri.joinRaw( uri, 'x/'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.case = 'add absolute to uri with localPath';
  var got = _.uri.joinRaw( 'file:///some/file','/something/to/add' );
  test.identical( got, 'file:///something/to/add' );

  /* */

  test.case = 'add uris';

  var got = _.uri.joinRaw( '//a', '//b', 'c' );
  test.identical( got, '//b/c' )

  var got = _.uri.joinRaw( 'b://c', 'd://e', 'f' );
  test.identical( got, 'd://c/e/f' );
  // test.identical( got, 'd://e/f' );

  var got = _.uri.joinRaw( 'a://b', 'c://d/e', '//f/g' );
  test.identical( got, 'c:////f/g' )

  /* - */

  test.case = 'not global, windows path';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  test.case = 'not global';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  test.case = 'other special cases';

  /* qqq */

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc','.' ];
  var expected = '/aa/bb//cc/.';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

  var paths = [  '/','a', '//b', '././c', '../d', '..e' ];
  var expected = '//b/././c/../d/..e';
  var got = _.uri.joinRaw.apply( _.uri, paths );
  test.identical( got, expected );

}

//

function common( test )
{

  var got = _.uri.common( '://a1/b2', '://some/staging/index.html' );
  test.identical( got, '://.' );

  var got = _.uri.common( '://some/staging/index.html', '://a1/b2' );
  test.identical( got, '://.' );

  var got = _.uri.common( '://some/staging/index.html', '://some/staging/' );
  test.identical( got, '://some/staging' );

  var got = _.uri.common( '://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uri.common( 'file:///some/staging/index.html', ':///some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uri.common( 'file://some/staging/index.html', '://some/stagi' );
  test.identical( got, '://some/' );

  var got = _.uri.common( 'file:///some/staging/index.html', '/some/stagi' );
  test.identical( got, ':///some/' );

  var got = _.uri.common( 'file:///some/staging/index.html', 'file:///some/staging' );
  test.identical( got, 'file:///some/staging' );

  var got = _.uri.common( 'http://some', 'some/staging' );
  test.identical( got, '://some' );

  var got = _.uri.common( 'some/staging', 'http://some' );
  test.identical( got, '://some' );

  var got = _.uri.common( 'http://some.come/staging/index.html', 'some/staging' );
  test.identical( got, '://.' );

  var got = _.uri.common( 'http:///some.come/staging/index.html', '/some/staging' );
  test.identical( got, ':///' );

  var got = _.uri.common( 'http://some.come/staging/index.html', 'file://some/staging' );
  test.identical( got, '' );

  var got = _.uri.common( 'http:///some.come/staging/index.html', 'file:///some/staging' );
  test.identical( got, '' );

  var got = _.uri.common( 'http:///some.come/staging/index.html', 'http:///some/staging/file.html' );
  test.identical( got, 'http:///' );

  var got = _.uri.common( 'http://some.come/staging/index.html', 'http://some.come/some/staging/file.html' );
  test.identical( got, 'http://some.come/' );

  // qqq !!! : implement
  // var got = _.uri.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path' );
  // test.identical( got, 'complex+protocol://www.site.com:13/path' );
  //
  // var got = _.uri.common( 'complex+protocol://www.site.com:13/path', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  // test.identical( got, 'complex+protocol://www.site.com:13/path' );
  //
  // var got = _.uri.common( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', 'complex+protocol://www.site.com:13/path?query=here' );
  // test.identical( got, 'complex+protocol://www.site.com:13/path' );
  //
  // var got = _.uri.common( 'complex+protocol://www.site.com:13/path?query=here', 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' );
  // test.identical( got, 'complex+protocol://www.site.com:13/path' );
  //
  // var got = _.uri.common( 'https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash', 'https://user:pass@sub.host.com:8080/p/a' );
  // test.identical( got, 'https://user:pass@sub.host.com:8080/p/a' );

  var got = _.uri.common( '://some/staging/a/b/c', '://some/staging/a/b/c/index.html', '://some/staging/a/x' );
  test.identical( got, '://some/staging/a/' );

  var got = _.uri.common( 'http:///', 'http:///' );
  test.identical( got, 'http:///' );

  var got = _.uri.common( '/some/staging/a/b/c' );
  test.identical( got, '/some/staging/a/b/c' );
/*
  var got = _.uri.common( 'http://some.come/staging/index.html', 'file:///some/staging' );
  var got = _.uri.common( 'http://some.come/staging/index.html', 'http:///some/staging/file.html' );

*/

  /* */

  if( !Config.debug )
  return

  test.shouldThrowError( () => _.uri.common( 'http://some.come/staging/index.html', 'file:///some/staging' ) );
  test.shouldThrowError( () => _.uri.common( 'http://some.come/staging/index.html', 'http:///some/staging/file.html' ) );
  test.shouldThrowError( () => _.uri.common([]) );
  test.shouldThrowError( () => _.uri.common() );
  test.shouldThrowError( () => _.uri.common( [ 'http:///' ], [ 'http:///' ] ) );
  test.shouldThrowError( () => _.uri.common( [ 'http:///' ], 'http:///' ) );

}

//

function commonLocalPaths( test )
{
  test.case = 'absolute-absolute'

  var got = _.uri.common( '/a1/b2', '/a1/b' );
  test.identical( got, '/a1/' );

  var got = _.uri.common( '/a1/b2', '/a1/b1' );
  test.identical( got, '/a1/' );

  var got = _.uri.common( '/a1/x/../b1', '/a1/b1' );
  test.identical( got, '/a1/b1' );

  var got = _.uri.common( '/a1/b1/c1', '/a1/b1/c' );
  test.identical( got, '/a1/b1/' );

  var got = _.uri.common( '/a1/../../b1/c1', '/a1/b1/c1' );
  test.identical( got, '/' );

  var got = _.uri.common( '/abcd', '/ab' );
  test.identical( got, '/' );

  var got = _.uri.common( '/.a./.b./.c.', '/.a./.b./.c' );
  test.identical( got, '/.a./.b./' );

  var got = _.uri.common( '//a//b//c', '/a/b' );
  test.identical( got, '/' );

  var got = _.uri.common( '/a//b', '/a//b' );
  test.identical( got, '/a//b' );

  var got = _.uri.common( '/a//', '/a//' );
  test.identical( got, '/a//' );

  var got = _.uri.common( '/./a/./b/./c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.uri.common( '/A/b/c', '/a/b/c' );
  test.identical( got, '/' );

  var got = _.uri.common( '/', '/x' );
  test.identical( got, '/' );

  var got = _.uri.common( '/a', '/x'  );
  test.identical( got, '/' );

  // test.case = 'absolute-relative'
  //
  // var got = _.uri.common( '/', '..' );
  // test.identical( got, '/' );
  //
  // var got = _.uri.common( '/', '.' );
  // test.identical( got, '/' );
  //
  // var got = _.uri.common( '/', 'x' );
  // test.identical( got, '/' );
  //
  // var got = _.uri.common( '/', '../..' );
  // test.identical( got, '/' );

  test.case = 'relative-relative'

  var got = _.uri.common( 'a1/b2', 'a1/b' );
  test.identical( got, 'a1/' );

  var got = _.uri.common( 'a1/b2', 'a1/b1' );
  test.identical( got, 'a1/' );

  var got = _.uri.common( 'a1/x/../b1', 'a1/b1' );
  test.identical( got, 'a1/b1' );

  var got = _.uri.common( './a1/x/../b1', 'a1/b1' );
  test.identical( got,'a1/b1' );

  var got = _.uri.common( './a1/x/../b1', './a1/b1' );
  test.identical( got, 'a1/b1');

  var got = _.uri.common( './a1/x/../b1', '../a1/b1' );
  test.identical( got, '..');

  var got = _.uri.common( '.', '..' );
  test.identical( got, '..' );

  var got = _.uri.common( './b/c', './x' );
  test.identical( got, '.' );

  var got = _.uri.common( './././a', './a/b' );
  test.identical( got, 'a' );

  var got = _.uri.common( './a/./b', './a/b' );
  test.identical( got, 'a/b' );

  var got = _.uri.common( './a/./b', './a/c/../b' );
  test.identical( got, 'a/b' );

  var got = _.uri.common( '../b/c', './x' );
  test.identical( got, '..' );

  var got = _.uri.common( '../../b/c', '../b' );
  test.identical( got, '../..' );

  var got = _.uri.common( '../../b/c', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.uri.common( '../../b/c/../../x', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.uri.common( './../../b/c/../../x', './../../../x' );
  test.identical( got, '../../..' );

  var got = _.uri.common( '../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.uri.common( './../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.uri.common( '../../..', '../../..' );
  test.identical( got, '../../..' );

  var got = _.uri.common( '../b', '../b' );
  test.identical( got, '../b' );

  var got = _.uri.common( '../b', './../b' );
  test.identical( got, '../b' );

  test.case = 'several absolute paths'

  var got = _.uri.common( '/a/b/c', '/a/b/c', '/a/b/c' );
  test.identical( got, '/a/b/c' );

  var got = _.uri.common( '/a/b/c', '/a/b/c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.uri.common( '/a/b/c', '/a/b/c', '/a/b1' );
  test.identical( got, '/a/' );

  var got = _.uri.common( '/a/b/c', '/a/b/c', '/a' );
  test.identical( got, '/a' );

  var got = _.uri.common( '/a/b/c', '/a/b/c', '/x' );
  test.identical( got, '/' );

  var got = _.uri.common( '/a/b/c', '/a/b/c', '/' );
  test.identical( got, '/' );

  test.case = 'several relative paths';

  var got = _.uri.common( 'a/b/c', 'a/b/c', 'a/b/c' );
  test.identical( got, 'a/b/c' );

  var got = _.uri.common( 'a/b/c', 'a/b/c', 'a/b' );
  test.identical( got, 'a/b' );

  var got = _.uri.common( 'a/b/c', 'a/b/c', 'a/b1' );
  test.identical( got, 'a/' );

  var got = _.uri.common( 'a/b/c', 'a/b/c', '.' );
  test.identical( got, '.' );

  var got = _.uri.common( 'a/b/c', 'a/b/c', 'x' );
  test.identical( got, '.' );

  var got = _.uri.common( 'a/b/c', 'a/b/c', './' );
  test.identical( got, '.' );

  var got = _.uri.common( '../a/b/c', 'a/../b/c', 'a/b/../c' );
  test.identical( got, '..' );

  var got = _.uri.common( './a/b/c', '../../a/b/c', '../../../a/b' );
  test.identical( got, '../../..' );

  var got = _.uri.common( '.', './', '..' );
  test.identical( got, '..' );

  var got = _.uri.common( '.', './../..', '..' );
  test.identical( got, '../..' );

  /* */

  if( !Config.debug )
  return

  test.shouldThrowError( () => _.uri.common( '/a', '..' ) );
  test.shouldThrowError( () => _.uri.common( '/a', '.' ) );
  test.shouldThrowError( () => _.uri.common( '/a', 'x' ) );
  test.shouldThrowError( () => _.uri.common( '/a', '../..' ) );

  test.shouldThrowError( () => _.uri.common( '/a/b/c', '/a/b/c', './' ) );
  test.shouldThrowError( () => _.uri.common( '/a/b/c', '/a/b/c', '.' ) );
  test.shouldThrowError( () => _.uri.common( 'x', '/a/b/c', '/a' ) );
  test.shouldThrowError( () => _.uri.common( '/a/b/c', '..', '/a' ) );
  test.shouldThrowError( () => _.uri.common( '../..', '../../b/c', '/a' ) );

}

//

function resolve( test )
{

  var originalPath = _.path.current();
  var current = originalPath;

  if( _.fileProvider )
  {
    _.path.current( '/' );
    current = _.strPrependOnce( _.uri.current(), '/' );
  }

  try
  {

    test.open( 'with protocol' );

    var got = _.uri.resolve( 'http://www.site.com:13','a' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/a' ) );

    var got = _.uri.resolve( 'http://www.site.com:13/','a' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/a' ) );

    var got = _.uri.resolve( 'http://www.site.com:13/','a','b' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','a', '/b' );
    test.identical( got, _.uri.join( current, 'http:///b' ) );

    var got = _.uri.resolve( 'http://www.site.com:13/','a','b','.' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','a', '/b', 'c' );
    test.identical( got, _.uri.join( current, 'http:///b/c' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','/a/', '/b/', 'c/', '.' );
    test.identical( got, _.uri.join( current, 'http:///b/c' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','a', '.', 'b' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uri.resolve( 'http://www.site.com:13/','a', '.', 'b' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/a/b' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','a', '..', 'b' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/b' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','a', '..', '..', 'b' );
    test.identical( got, _.uri.join( current, 'http://b' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','.a.', 'b', '.c.' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13/.a./b/.c.' ) );

    var got = _.uri.resolve( 'http://www.site.com:13','a/../' );
    test.identical( got, _.uri.join( current, 'http://www.site.com:13' ) );

    test.close( 'with protocol' );

    /* - */

    test.open( 'with null protocol' );

    var got = _.uri.resolve( '://www.site.com:13','a' );
    test.identical( got, _.uri.join( current, '://www.site.com:13/a' ) );

    var got = _.uri.resolve( '://www.site.com:13','a', '/b' );
    test.identical( got, _.uri.join( current, ':///b' ) );

    var got = _.uri.resolve( '://www.site.com:13','a', '/b', 'c' );
    test.identical( got, _.uri.join( current, ':///b/c' ) );

    var got = _.uri.resolve( '://www.site.com:13','/a/', '/b/', 'c/', '.' );
    test.identical( got, _.uri.join( current, ':///b/c' ) );

    var got = _.uri.resolve( '://www.site.com:13','a', '.', 'b' );
    test.identical( got, _.uri.join( current, '://www.site.com:13/a/b' ) );

    var got = _.uri.resolve( '://www.site.com:13','a', '..', 'b' );
    test.identical( got, _.uri.join( current, '://www.site.com:13/b' ) );

    var got = _.uri.resolve( '://www.site.com:13','a', '..', '..', 'b' );
    test.identical( got, _.uri.join( current, '://b' ) );

    var got = _.uri.resolve( '://www.site.com:13','.a.', 'b','.c.' );
    test.identical( got, _.uri.join( current, '://www.site.com:13/.a./b/.c.' ) );

    var got = _.uri.resolve( '://www.site.com:13','a/../' );
    test.identical( got, _.uri.join( current, '://www.site.com:13' ) );

    test.close( 'with null protocol' );

    /* */

    var got = _.uri.resolve( ':///www.site.com:13','a' );
    test.identical( got, ':///www.site.com:13/a' );

    var got = _.uri.resolve( ':///www.site.com:13/','a' );
    test.identical( got, ':///www.site.com:13/a' );

    var got = _.uri.resolve( ':///www.site.com:13','a', '/b' );
    test.identical( got, ':///b' );

    var got = _.uri.resolve( ':///www.site.com:13','a', '/b', 'c' );
    test.identical( got, ':///b/c' );

    var got = _.uri.resolve( ':///www.site.com:13','/a/', '/b/', 'c/', '.' );
    test.identical( got, ':///b/c' );

    var got = _.uri.resolve( ':///www.site.com:13','a', '.', 'b' );
    test.identical( got, ':///www.site.com:13/a/b' );

    var got = _.uri.resolve( ':///www.site.com:13/','a', '.', 'b' );
    test.identical( got, ':///www.site.com:13/a/b' );

    var got = _.uri.resolve( ':///www.site.com:13','a', '..', 'b' );
    test.identical( got, ':///www.site.com:13/b' );

    var got = _.uri.resolve( ':///www.site.com:13','a', '..', '..', 'b' );
    test.identical( got, ':///b' );

    var got = _.uri.resolve( ':///www.site.com:13','.a.', 'b','.c.' );
    test.identical( got, ':///www.site.com:13/.a./b/.c.' );

    var got = _.uri.resolve( ':///www.site.com:13/','.a.', 'b','.c.' );
    test.identical( got, ':///www.site.com:13/.a./b/.c.' );

    var got = _.uri.resolve( ':///www.site.com:13','a/../' );
    test.identical( got, ':///www.site.com:13' );

    var got = _.uri.resolve( ':///www.site.com:13/','a/../' );
    test.identical( got, ':///www.site.com:13' );

    /* */

    var got = _.uri.resolve( '/some/staging/index.html','a' );
    test.identical( got, '/some/staging/index.html/a' );

    var got = _.uri.resolve( '/some/staging/index.html','.' );
    test.identical( got, '/some/staging/index.html' );

    var got = _.uri.resolve( '/some/staging/index.html/','a' );
    test.identical( got, '/some/staging/index.html/a' );

    var got = _.uri.resolve( '/some/staging/index.html','a', '/b' );
    test.identical( got, '/b' );

    var got = _.uri.resolve( '/some/staging/index.html','a', '/b', 'c' );
    test.identical( got, '/b/c' );

    var got = _.uri.resolve( '/some/staging/index.html','/a/', '/b/', 'c/', '.' );
    test.identical( got, '/b/c' );

    var got = _.uri.resolve( '/some/staging/index.html','a', '.', 'b' );
    test.identical( got, '/some/staging/index.html/a/b' );

    var got = _.uri.resolve( '/some/staging/index.html/','a', '.', 'b' );
    test.identical( got, '/some/staging/index.html/a/b' );

    var got = _.uri.resolve( '/some/staging/index.html','a', '..', 'b' );
    test.identical( got, '/some/staging/index.html/b' );

    var got = _.uri.resolve( '/some/staging/index.html','a', '..', '..', 'b' );
    test.identical( got, '/some/staging/b' );

    var got = _.uri.resolve( '/some/staging/index.html','.a.', 'b','.c.' );
    test.identical( got, '/some/staging/index.html/.a./b/.c.' );

    var got = _.uri.resolve( '/some/staging/index.html/','.a.', 'b','.c.' );
    test.identical( got, '/some/staging/index.html/.a./b/.c.' );

    var got = _.uri.resolve( '/some/staging/index.html','a/../' );
    test.identical( got, '/some/staging/index.html' );

    var got = _.uri.resolve( '/some/staging/index.html/','a/../' );
    test.identical( got, '/some/staging/index.html' );

    var got = _.uri.resolve( '//some/staging/index.html', '.', 'a' );
    test.identical( got, '//some/staging/index.html/a' )

    var got = _.uri.resolve( '///some/staging/index.html', 'a', '.', 'b', '..' );
    test.identical( got, '///some/staging/index.html/a' )

    var got = _.uri.resolve( 'file:///some/staging/index.html', '../..' );
    test.identical( got, 'file:///some' )

    var got = _.uri.resolve( 'svn+https://user@subversion.com/svn/trunk', '../a', 'b', '../c' );
    test.identical( got, _.uri.join( current, 'svn+https://user@subversion.com/svn/a/c' ) );

    var got = _.uri.resolve( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', '../../path/name' );
    test.identical( got, _.uri.join( current, 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' ) );

    var got = _.uri.resolve( 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking', '../../../a.com' );
    test.identical( got, _.uri.join( current, 'https://web.archive.org/web/*\/http://a.com' ) );

    var got = _.uri.resolve( '127.0.0.1:61726', '../path'  );
    test.identical( got, _.uri.join( _.uri.current(),'path' ) )

    var got = _.uri.resolve( 'http://127.0.0.1:61726', '../path'  );
    test.identical( got, _.uri.join( current, 'http://path' ) );

    /* */

    test.case = 'works like resolve';

    var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
    var expected = '/c/foo/bar';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [ '/bar/', '/baz', 'foo/', '.' ];
    var expected = '/baz/foo';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  'aa','.','cc' ];
    var expected = _.uri.join( _.uri.current(),'aa/cc' );
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  'aa','cc','.' ];
    var expected = _.uri.join( _.uri.current(),'aa/cc' )
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '.','aa','cc' ];
    var expected = _.uri.join( _.uri.current(),'aa/cc' )
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '.','aa','cc','..' ];
    var expected = _.uri.join( _.uri.current(),'aa' )
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '.','aa','cc','..','..' ];
    var expected = _.uri.current();
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  'aa','cc','..','..','..' ];
    var expected = _.uri.resolve( _.uri.current(),'..' );
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '.x.','aa','bb','.x.' ];
    var expected = _.uri.join( _.uri.current(),'.x./aa/bb/.x.' );
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '..x..','aa','bb','..x..' ];
    var expected = _.uri.join( _.uri.current(),'..x../aa/bb/..x..' );
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '/abc','./../a/b' ];
    var expected = '/a/b';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '/abc','a/.././a/b' ];
    var expected = '/abc/a/b';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '/abc','.././a/b' ];
    var expected = '/a/b';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '/abc','./.././a/b' ];
    var expected = '/a/b';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '/abc','./../.' ];
    var expected = '/';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '/abc','./../../.' ];
    var expected = '/..';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  '/abc','./../.' ];
    var expected = '/';
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    var paths = [  null ];
    // var expected = _.uri.current();
    var expected = null;
    var got = _.uri.resolve.apply( _.uri, paths );
    test.identical( got, expected );

    /* - */

    if( _.fileProvider )
    _.uri.current( originalPath );

  }
  catch( err )
  {

    if( _.fileProvider )
    _.uri.current( originalPath );
    throw err;
  }

}

//

function rebase( test )
{

  test.case = 'replacing by empty protocol';

  var expected = ':///some2/file'; /* not src:///some2/file */
  var got = _.uri.rebase( 'src:///some/file', '/some', ':///some2' );
  test.identical( got, expected );

  test.case = 'removing protocol';

  var expected = '/some2/file';
  var got = _.uri.rebase( 'src:///some/file', 'src:///some', '/some2' );
  test.identical( got, expected );

  var expected = '/some2/file';
  var got = _.uri.rebase( 'src:///some/file', 'dst:///some', '/some2' );
  test.identical( got, expected );

}

//

function name( test )
{
  var paths =
  [
    /* */ '',
    'some.txt',
    '/foo/bar/baz.asdf',
    '/foo/bar/.baz',
    '/foo.coffee.md',
    '/foo/bar/baz',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk/index.html',
    'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor',
    '://www.site.com:13/path/name.html?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.html?query=here&and=here#anchor',
  ]

  var expectedExt =
  [
    /* */ '',
    'some.txt',
    'baz.asdf',
    '.baz',
    'foo.coffee.md',
    'baz',
    'index.html',
    'index.html',
    'index.html',
    'index.html',
    'index.html',
    'index.html',
    'name.html',
    'name.html',
    'name.html',
  ]

  var expectedNoExt =
  [
    /* */ '',
    'some',
    'baz',
    '',
    'foo.coffee',
    'baz',
    'index',
    'index',
    'index',
    'index',
    'index',
    'index',
    'name',
    'name',
    'name',
  ]

  /* */

  test.case = 'uri to file';
  var uri = 'http://www.site.com:13/path/name.txt'
  var got = _.uri.name( uri );
  var expected = 'name';
  test.identical( got, expected );

  test.case = 'uri with params';
  var uri1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.uri.name( uri );
  var expected = 'name';
  test.identical( got, expected );

  test.case = 'uri without protocol';
  var uri1 = '://www.site.com:13/path/name.js';
  var got = _.uri.name( uri );
  var expected = 'name';
  test.identical( got, expected );

  /* - */

  test.case = 'name works like name'
  paths.forEach( ( path, i ) =>
  {
    var got = _.uri.name( path );
    var exp = expectedNoExt[ i ];
    test.identical( got, exp );

    var o = { path : path, withExtension : 1 };
    var got = _.uri.name( o );
    var exp = expectedExt[ i ];
    test.identical( got, exp );
  })

  /* - */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uri.name( false );
  });
}

//

//

function ext( test )
{
  var paths =
  [
    /* */ '',
    'some.txt',
    '/foo/bar/baz.asdf',
    '/foo/bar/.baz',
    '/foo.coffee.md',
    '/foo/bar/baz',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk/index.html',
    'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor',
    '://www.site.com:13/path/name.html?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.html?query=here&and=here#anchor',
  ]

  var expected =
  [
    /* */ '',
    'txt',
    'asdf',
    '',
    'md',
    '',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
  ]

  test.case = 'ext test'
  paths.forEach( ( path, i ) =>
  {
    test.logger.log( path )
    var got = _.uri.ext( path );
    var exp = expected[ i ];
    test.identical( got, exp );
  })

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uri.ext( false );
  });
}

//

function changeExt( test )
{
  var paths =
  [
    { path : 'some.txt', ext : 'abc' },
    { path : '/foo/bar/baz.asdf', ext : 'abc' },
    { path : '/foo/bar/.baz', ext : 'abc' },
    { path : '/foo.coffee.md', ext : 'abc' },
    { path : '/foo/bar/baz', ext : 'abc' },
    { path : '/some/staging/index.html', ext : 'abc' },
    { path : '//some/staging/index.html', ext : 'abc' },
    { path : '///some/staging/index.html', ext : 'abc' },
    { path : 'file:///some/staging/index.html', ext : 'abc' },
    { path : 'http://some.come/staging/index.html', ext : 'abc' },
    { path : 'svn+https://user@subversion.com/svn/trunk/index.html', ext : 'abc' },
    { path : 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor', ext : 'abc' },
    { path : '://www.site.com:13/path/name.html?query=here&and=here#anchor', ext : 'abc' },
    { path : ':///www.site.com:13/path/name.html?query=here&and=here#anchor', ext : 'abc' },
  ]

  var expected =
  [
    'some.abc',
    '/foo/bar/baz.abc',
    '/foo/bar/.baz.abc',
    '/foo.coffee.abc',
    '/foo/bar/baz.abc',
    '/some/staging/index.abc',
    '//some/staging/index.abc',
    '///some/staging/index.abc',
    'file:///some/staging/index.abc',
    'http://some.come/staging/index.abc',
    'svn+https://user@subversion.com/svn/trunk/index.abc',
    'complex+protocol://www.site.com:13/path/name.abc?query=here&and=here#anchor',
    '://www.site.com:13/path/name.abc?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.abc?query=here&and=here#anchor',
  ]

  test.case = 'changeExt test'
  paths.forEach( ( c, i ) =>
  {
    test.logger.log( c.path, c.ext )
    var got = _.uri.changeExt( c.path, c.ext );
    var exp = expected[ i ];
    test.identical( got, exp );
  })

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uri.changeExt( false );
  });
}

//

function dir( test )
{
  var paths =
  [
    'some.txt',
    '/foo/bar/baz.asdf',
    '/foo/bar/.baz',
    '/foo.coffee.md',
    '/foo/bar/baz',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk/index.html',
    'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor',
    '://www.site.com:13/path/name.html?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.html?query=here&and=here#anchor',
  ]

  var expected =
  [
    '.',
    '/foo/bar',
    '/foo/bar',
    '/',
    '/foo/bar',
    '/some/staging',
    '//some/staging',
    '///some/staging',
    'file:///some/staging',
    'http://some.come/staging',
    'svn+https://user@subversion.com/svn/trunk',
    'complex+protocol://www.site.com:13/path?query=here&and=here#anchor',
    '://www.site.com:13/path?query=here&and=here#anchor',
    ':///www.site.com:13/path?query=here&and=here#anchor',
  ]

  test.case = 'dir test'
  paths.forEach( ( path, i ) =>
  {
    test.logger.log( path )
    var got = _.uri.dir( path );
    var exp = expected[ i ];
    test.identical( got, exp );
  })

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.uri.dir( false );
  });
}

//

/*

a//b
a///b
127.0.0.1:61726

://some/staging/index.html
:///some/staging/index.html
/some/staging/index.html
file:///some/staging/index.html
http://some.come/staging/index.html
svn+https://user@subversion.com/svn/trunk
complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor
https://web.archive.org/web/*\/http://www.heritage.org/index/ranking
https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash
*/

// --
// declare
// --

var Self =
{

  name : 'Tools/base/l4/UriFundamentals',
  silencing : 1,

  tests :
  {

    isRelative,
    isRoot,

    normalize : normalize,
    normalizeLocalPaths : normalizeLocalPaths,
    normalizeTolerant : normalizeTolerant,
    normalizeLocalPathsTolerant : normalizeLocalPathsTolerant,

    refine : refine,
    urisRefine : urisRefine,
    parse : parse,
    parseGlob : parseGlob,
    str : str,
    parseAndStr : parseAndStr,
    // from : from,
    documentGet : documentGet,
    server : server,
    query : query,
    dequery : dequery,
    resolve : resolve,

    // _uriJoin_body : _uriJoin_body,
    join,
    joinRaw,

    commonLocalPaths : commonLocalPaths,
    common : common,

    rebase : rebase,

    name : name,
    ext : ext,
    changeExt : changeExt,
    dir : dir

  },

}

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self );

})();
