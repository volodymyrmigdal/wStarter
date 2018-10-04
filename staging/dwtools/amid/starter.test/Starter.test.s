( function _Starter_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    var toolsPath = '../../../dwtools/Base.s';
    var toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );

  require( '../Starter/StarterMaker.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
//
// --

function trivial( test )
{
  var srcPath = _.path.resolve( __dirname, '../../..' );
  var tempPath = _.path.dirTempOpen();

  try
  {

    var starterMaker = new _.StarterMaker
    ({
      appName : 'Test',
      inPath : '/',
      outPath : '/',
      initScriptPath : '{{inPath}}/Init.s',
      offline : 1,
      verbosity : 5,
      logger : new _.Logger({ output : logger }),
    });

    starterMaker.fileProviderForm();
    starterMaker.fromHardDriveRead({ srcPath : _.uri.join( 'file:///', srcPath ) });

    starterMaker.form();

    starterMaker.starterMake();
    starterMaker.filesMapMake();
    starterMaker.toHardDriveWrite({ dstPath : _.uri.join( 'file:///', tempPath ) });

  }
  catch( err )
  {
    test.exceptionReport({ err : err });
  }

  debugger;
  _.path.dirTempClose( tempPath );

  test.identical( 1,1 );
}

trivial.timeOut = 60000;

// --
//
// --

var Self =
{

  name : 'Tools/mid/Starter',
  silencing : 1,
  enabled : 1,

  tests :
  {
    trivial : trivial,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
