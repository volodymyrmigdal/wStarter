
if( typeof module !== 'undefined' )
{
  require( 'wstarter' );
}

var _ = _global_.wTools;

var srcPath = _.path.resolve( __dirname, '..' );
var outPath = _.path.join( __dirname, 'out' );

var starterMaker = new _.StarterMaker
({
   appName : 'Sample',
   inPath : '/',
   outPath : '/',
   toolsPath : '/staging/tmp/wtools',
   initScriptPath : '/sample/index.js',
   offline : 1,
   verbosity : 5,
   logger : new _.Logger({ output : logger }),
});

starterMaker.fileProviderForm();
starterMaker.fromHardDriveRead({ srcPath : _.uri.join( 'file:///', srcPath ) });

starterMaker.form();

starterMaker.starterMake();
starterMaker.filesMapMake();
starterMaker.toHardDriveWrite({ dstPath : _.uri.join( 'file:///', outPath ) });
