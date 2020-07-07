
if( typeof module !== 'undefined' )
{
  require( '../proto/dwtools/amid/starter/StarterServer.ss' );
  var Express = require( 'express' );
}

var _ = _global_.wTools;

var srcPath = _.path.resolve( __dirname, '..' );
var outPath = _.path.join( __dirname, 'out' );

var starterMaker = new _.StarterMaker
({
   appName : 'Sample',
   inPath : '/',
   outPath : '/',
   toolsPath : '/staging/tmp/dwtools',
   initScriptPath : '/sample/index.js',
   offline : 0,
   verbosity : 5,
   logger : new _.Logger({ output : logger }),
});

starterMaker.fileProviderForm();
starterMaker.fromHardDriveRead({ srcPath : _.uri.join( 'file:///', srcPath ) });

starterMaker.form();

starterMaker.starterMake();
starterMaker.filesMapMake();
starterMaker.toHardDriveWrite({ dstPath : _.uri.join( 'file:///', outPath ) });

//

let express = Express();

var staticRequestHandler = _.starter.staticRequestHandler_functor
({
  basePath : _.path.resolve( __dirname, '..' ),
  filterPath : '/',
})

var staticPaths = [ __dirname, _.path.join( __dirname, 'out' ) ];

staticPaths.forEach( ( path ) => express.use( Express.static( _.path.nativize( path ) ) ) )

express.use( staticRequestHandler );

express.listen( 3000, () =>
{
  console.log( 'Goto: http://127.0.0.1:3000/index.html',  )
});
