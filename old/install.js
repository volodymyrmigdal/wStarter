if( typeof module !== 'undefined' )
{
  require( 'wFiles' );
}

let _ = _global_.wTools;

let srcPath = _.path.join( __dirname, 'node_modules' );
let dstPath = _.path.join( __dirname, 'proto/tmp/wtools' );

let includeList =
[
  '**/abase/l?/**',
  '**/abase/layer?/**',
  '**/amid/amapping/**',
  '**/amid/amixin/**',
  '**/amid/bclass/**',
  '**/amid/files/**',
]

let srcFilter =
{
  maskAll :
  [
    _.path.globsToRegexp( includeList ),
    { excludeAny : 'wstarter' }
  ],
  maskTransientAll : _.files.regexpMakeSafe()
}

let reflectMap = Object.create( null );
reflectMap[ srcPath ] = dstPath;

_.fileProvider.filesReflect
({
  reflectMap : reflectMap,
  resolvingSrcSoftLink : 0,
  includingDirectories : 1,
  includingTerminals : 1,
  onDstName : onDstName,
  srcFilter : srcFilter
})

/**/

function onDstName( relative, dstRecordContext, op, o, srcRecord )
{
  if( srcRecord.isActual )
  {
    let path = _.strIsolateBeginOrNone( srcRecord.absolute, 'wtools/' )[ 2 ];
    return _.path.dot( path );
  }
  return relative;
}