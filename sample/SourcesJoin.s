
if( typeof module !== 'undefined' )
{
  require( 'wstarter' );
}

let _ = _global_.wTools;

var starter = new _.starter.System();

starter.form();

var o =
{
  interpreter: 'njs',
  outPath : _.path.join( __dirname, 'out/SingleFileTools.ss' ),
  entryPath : _.path.resolve( 'node_modules/wTools/proto/wtools/Tools.s' ),
  withServer: 0
}

o.inPath =
{
  filePath : _.path.resolve( 'node_modules/wTools/**.(s|ss)' )
}

starter.sourcesJoinFiles( o );

//

var o =
{
  interpreter: 'browser',
  outPath : _.path.join( __dirname, 'out/SingleFileTools.s' ),
  entryPath : _.path.resolve( 'node_modules/wTools/proto/wtools/Tools.s' ),
  withServer: 0
}

o.inPath =
{
  filePath : _.path.resolve( 'node_modules/wTools/**.(s|ss)' )
}

starter.sourcesJoinFiles( o );