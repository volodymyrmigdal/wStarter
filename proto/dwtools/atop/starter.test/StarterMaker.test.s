( function _StarterMaker_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  var Pupeteer = require( 'puppeteer' );
  var _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../starter/Include.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let self = this;

  self.suiteTempPath = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'Starter' );
  self.assetsOriginalSuitePath = _.path.join( __dirname, '_asset' );

  self.find = _.fileProvider.filesFinder
  ({
    withTerminals : 1,
    withDirs : 1,
    withTransient : 1,
    allowingMissed : 1,
    maskPreset : 0,
    outputFormat : 'relative',
    filter :
    {
      filePath : { 'node_modules' : 0, 'package.json' : 0, 'package-lock.json' : 0 },
      recursive : 2,
    }
  });

}

//

function onSuiteEnd()
{
  let self = this;
  _.assert( _.strHas( self.suiteTempPath, '/Starter' ) )
  _.path.pathDirTempClose( self.suiteTempPath );
  // _.assert( _.strHas( self.suiteTempPath, '/dwtools/tmp.tmp' ) || _.strHas( self.suiteTempPath, '/Temp/' ) )
  // _.fileProvider.filesDelete( self.suiteTempPath );
}

//

function assetFor( test, name )
{
  let self = this;
  let a = Object.create( null );

  a.test = test;
  a.name = name;
  a.originalAssetPath = _.path.join( self.assetsOriginalSuitePath, name );
  a.routinePath = _.path.join( self.suiteTempPath, test.name );
  a.fileProvider = _.fileProvider;
  a.path = _.fileProvider.path;
  a.ready = _.Consequence().take( null );

  a.reflect = function reflect()
  {
    _.fileProvider.filesDelete( a.routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath } });
  }

  // a.shell = _.process.starter
  // ({
  //   currentPath : a.routinePath,
  //   outputCollecting : 1,
  //   outputGraying : 1,
  //   ready : a.ready,
  //   mode : 'shell',
  // })

  _.assert( a.fileProvider.isDir( a.originalAssetPath ) );

  // debugger;
  // try
  // {
  //   a.willbeExecPath = _.path.normalize( require.resolve( 'willbe' ) );
  // }
  // catch( err )
  // {
  //   debugger;
  //   a.willbeExecPath = _.path.join( __dirname, '../willbe/xxx' );
  // }

  a.willbeExecPath = _.module.resolve( 'willbe' );

  a.willbe = _.process.starter
  ({
    execPath : 'node ' + a.willbeExecPath,
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    ready : a.ready,
    mode : 'spawn',
  })

  return a;

}

// --
// tests
// --

function sourcesJoin( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'several' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let outputPath = _.path.join( routinePath, 'Index.js' );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();

  let shell = _.process.starter
  ({
    execPath : 'node',
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
  });

  _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })

  starter.sourcesJoin
  ({
    inPath : '**',
    entryPath : 'File2.js',
    basePath : routinePath,
  })

  var files = self.find( routinePath );
  test.identical( files, [ '.', './File1.js', './File2.js', './Index.js' ] );

  let read = _.fileProvider.fileRead( outputPath );
  test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

  debugger

  shell( _.path.nativize( outputPath ) )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var output =
    `
    File1.js:0
    File1.js:1
    File1.js:2
    File2.js:0
    File2.js:1
    File2.js:2
    File1.js:timeout
    File2.js:timeout
    `;
    test.equivalent( op.output, output );
    return op;
  });

  return ready;
}

//

function shellSourcesJoin( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'several' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let outputPath = _.path.join( routinePath, 'Index.js' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();

  let shell = _.process.starter
  ({
    execPath : 'node',
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
  });

  _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })

  shell( `${execPath} .sources.join ${routinePath}/** entryPath:File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoin\/Index\.js/ ), 1 )

    var files = self.find( routinePath );
    test.identical( files, [ '.', './File1.js', './File2.js', './Index.js' ] );

    let read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

    return op;
  })

  shell( _.path.nativize( outputPath ) )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    debugger;
    var output =
    `
    File1.js:0
    File1.js:1
    File1.js:2
    File2.js:0
    File2.js:1
    File2.js:2
    File1.js:timeout
    File2.js:timeout
    `;
    test.equivalent( op.output, output );
    return op;
  });

  return ready;
}

//

function shellSourcesJoinWithEntry( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'dep' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let outputPath = _.path.join( routinePath, 'out/app0.js' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();

  let shell = _.process.starter
  ({
    execPath : 'node',
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 0,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join app0/** entryPath:app0/File2.js outPath:out/app0.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinWithEntry\/out\/app0\.js/ ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0.js' ] );

    let read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'base path : .';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join app0/** entryPath:app0/File2.js outPath:out/app0.js basePath:.` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinWithEntry\/out\/app0\.js/ ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0.js' ] );

    let read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'base path : app0';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join ** entryPath:File2.js outPath:../out/app0.js basePath:app0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinWithEntry\/out\/app0\.js/ ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0.js' ] );

    let read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'bad entry';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join app0/** entryPath:File2.js outPath:out/app0.js` )
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of source files should have all entry files' ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js' ] );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'bad entry, base path defined';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } });
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join ** entryPath:app0/File2.js outPath:../out/app0.js basePath:app0` )
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of source files should have all entry files' ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js' ] );

    return op;
  })

  /* */

  return ready;
}

//

function shellSourcesJoinDep( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'dep' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();
  var output =
`
app0/File2.js:begin main:true
app2/File2.js:begin main:false
app0/File1.js:begin main:false
numberIs:true
app0/File1.js:end
app2/File2.js:end
app0/File2.js:end
app0/File1.js:timeout numberIs:true
app0/File1.js:timeout numberIs:true
app0/File1.js:timeout numberIs:true
`

  let shell = _.process.starter
  ({
    // execPath : 'node',
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `npm i` )
  shell( `node ${execPath} .sources.join app2/** outPath:out/app2` )
  shell( `node ${execPath} .sources.join app0/** outPath:out/app0 entryPath:app0/File2.js externalBeforePath:out/app2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinDep\/out\/app0/ ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0', './out/app2' ] );

    return op;
  })

  shell( `node out/app0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node app0/File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  return ready;
}

//

function shellSourcesJoinRequireInternal( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'dep' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();
  var output =
`
app2/File2.js:begin main:false
app0/File1.js:begin main:false
numberIs:true
app0/File1.js:end
app2/File2.js:end
app0/File1.js:timeout numberIs:true
app0/File1.js:timeout numberIs:true
`

  let shell = _.process.starter
  ({
    // execPath : 'node',
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `npm i` )
  shell( `node ${execPath} .sources.join app0/** outPath:out/dir/app0` )
  shell( `node ${execPath} .sources.join app2/** outPath:out/dir/app2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinRequireInternal\/out\/dir\/app2/ ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/dir', './out/dir/app0', './out/dir/app2' ] );

    return op;
  })

  shell( `node ext/RequireApp2File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  return ready;
}

//

function shellSourcesJoinComplex( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'complex' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();
  var output =
`
app0/File2.js:begin
app2/File2.js:begin
app0/File1.js:begin
numberIs true
app0/File1.js:end
app1/File2.js:begin
app1/File1.js:begin
app1/File1.js:end
app1/File2.js:end
app2/File2.js:end
app0/File2.js:end
app0/File1.js:timeout true
app1/File1.js:timeout
app1/File2.js:timeout
app1/File2.js:timeout
app0/File1.js:timeout true
app0/File1.js:timeout true
`

  let shell = _.process.starter
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `npm i` )
  shell( `node ${execPath} .sources.join app2/** outPath:out/app2` )
  shell( `node ${execPath} .sources.join app1/** outPath:out/app1` )
  shell( `node ${execPath} .sources.join app0/** outPath:out/app0 entryPath:app0/File2.js externalBeforePath:[out/app1, out/app2]` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinComplex\/out\/app0/ ), 1 );

    var files = self.find( routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app1', './app1/File1.js', './app1/File2.js', './app2', './app2/File1.js', './app2/File2.js', './out', './out/app0', './out/app1', './out/app2' ] );

    return op;
  })

  shell( `node out/app0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node app0/File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );

    return op;
  })

  /* */

  return ready;
}

//

function shellSourcesJoinTree( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'tree' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let outPath = _.path.join( routinePath, 'out' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();

  let shell = _.process.starter
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'app1, entry:File1';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/dir1/File1.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinTree\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = self.find( outPath );
    test.identical( files, expected );

    return op;
  })

  shell( `node in/app1/dir1/File1.js` )
  .then( ( op ) =>
  {
    var output =
`
app1/File1.js:begin main:true
External1.js main:false
app1/File1.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node out/app1` )
  .then( ( op ) =>
  {
    var output =
`
app1/File1.js:begin main:true
External1.js main:false
app1/File1.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'app1, entry:File2';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/dir1/dir2/File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinTree\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = self.find( outPath );
    test.identical( files, expected );

    return op;
  })

  shell( `node in/app1/dir1/dir2/File2.js` )
  .then( ( op ) =>
  {
    var output =
`
app1/File2.js:begin main:true
External2.js main:false
app1/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node out/app1` )
  .then( ( op ) =>
  {
    var output =
`
app1/File2.js:begin main:true
External2.js main:false
app1/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'app2';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1` )
  shell( `node ${execPath} .sources.join in/app2/** outPath:out/app2 entryPath:in/app2/File2.js externalBeforePath:out/app1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinTree\/out\/app2/ ), 1 );

    var expected = [ '.', './app1', './app2' ];
    var files = self.find( outPath );
    test.identical( files, expected );

    return op;
  })

  shell( `node in/app2/File2.js` )
  .then( ( op ) =>
  {
    var output =
`
app0/File2.js:begin main:true
app2/File1.js:begin main:false
app1/File2.js:begin main:false
External2.js main:false
app1/File2.js:end main:false
app2/File1.js:end main:false
app0/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node out/app2` )
  .then( ( op ) =>
  {
    var output =
`
app0/File2.js:begin main:true
app2/File1.js:begin main:false
app1/File2.js:begin main:false
External2.js main:false
app1/File2.js:end main:false
app2/File1.js:end main:false
app0/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  return ready;
} /* end of shellSourcesJoinTree */

//

function shellSourcesJoinCycle( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'cycle' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let outPath = _.path.join( routinePath, 'out' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();

  let shell = _.process.starter
  ({
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'app1, entry:File1';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/File1.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinCycle\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = self.find( outPath );
    test.identical( files, expected );

    return op;
  })

  shell( `node in/app1/File1.js` )
  .then( ( op ) =>
  {
    var output =
`
app1/File1.js:begin main:true
app1/File2.js:begin main:false
app1/File2.js:end main:false
app1/File1.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node out/app1` )
  .then( ( op ) =>
  {
    var output =
`
app1/File1.js:begin main:true
app1/File2.js:begin main:false
app1/File2.js:end main:false
app1/File1.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'app1, entry:File2';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinCycle\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = self.find( outPath );
    test.identical( files, expected );

    return op;
  })

  shell( `node in/app1/File2.js` )
  .then( ( op ) =>
  {
    var output =
`
app1/File2.js:begin main:true
app1/File1.js:begin main:false
app1/File1.js:end main:false
app1/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node out/app1` )
  .then( ( op ) =>
  {
    var output =
`
app1/File2.js:begin main:true
app1/File1.js:begin main:false
app1/File1.js:end main:false
app1/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'cycled-external';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    _.fileProvider.filesDelete( routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/File2.js externalBeforePath:out/app2` )
  shell( `node ${execPath} .sources.join in/app2/** outPath:out/app2 entryPath:in/app2/File2.js externalBeforePath:out/app1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var expected = [ '.', './app1', './app2' ];
    var files = self.find( outPath );
    test.identical( files, expected );

    return op;
  })

  shell( `node out/app1` )
  .then( ( op ) =>
  {
    var output =
`
app2/File2.js:begin main:true
app2/File1.js:begin main:false
app2/File1.js:end main:false
app2/File2.js:end main:true
app1/File2.js:begin main:true
app1/File1.js:begin main:false
app1/File1.js:end main:false
app1/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  shell( `node out/app2` )
  .then( ( op ) =>
  {
    var output =
`
app1/File2.js:begin main:true
app1/File1.js:begin main:false
app1/File1.js:end main:false
app1/File2.js:end main:true
app2/File2.js:begin main:true
app2/File1.js:begin main:false
app2/File1.js:end main:false
app2/File2.js:end main:true
`
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  /* */

  return ready;
} /* end of shellSourcesJoinCycle */

//

function htmlFor( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'several' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let outputPath = _.path.join( routinePath, 'Index.html' );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();

  /* */

  test.case = 'default';

  _.fileProvider.filesDelete( routinePath );
  _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })

  starter.htmlFor
  ({
    inPath : '**',
    basePath : routinePath,
    title : 'Html for test',
  })

  var files = self.find( routinePath );
  test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

  var read = _.fileProvider.fileRead( outputPath );
  test.identical( _.strCount( read, '<html' ), 1 );
  test.identical( _.strCount( read, 'src="/.starter"' ), 1 );
  test.identical( _.strCount( read, 'src="./File1.js"' ), 1 );
  test.identical( _.strCount( read, 'src="./File2.js"' ), 1 );
  test.identical( _.strCount( read, '<title>Html for test</title>' ), 1 );
  test.identical( _.strCount( read, '<script src' ), 3 );

  /* */

  test.case = 'without starter';

  _.fileProvider.filesDelete( routinePath );
  _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })

  starter.htmlFor
  ({
    inPath : '**',
    basePath : routinePath,
    title : 'Html for test',
    starterIncluding : 0,
  })

  var files = self.find( routinePath );
  test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

  var read = _.fileProvider.fileRead( outputPath );
  test.identical( _.strCount( read, '<html' ), 1 );
  test.identical( _.strCount( read, 'src="/.starter"' ), 0 );
  test.identical( _.strCount( read, 'src="./File1.js"' ), 1 );
  test.identical( _.strCount( read, 'src="./File2.js"' ), 1 );
  test.identical( _.strCount( read, '<title>Html for test</title>' ), 1 );
  test.identical( _.strCount( read, '<script src' ), 2 );

  /* */

  return ready;
}

//

function shellHtmlFor( test )
{
  let self = this;
  let originalAssetPath = _.path.join( self.assetsOriginalSuitePath, 'several' );
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let outputPath = _.path.join( routinePath, 'Index.html' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.Starter().form();

  let shell = _.process.starter
  ({
    execPath : 'node',
    currentPath : routinePath,
    outputCollecting : 1,
    ready : ready,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    return null;
  })

  shell( `${execPath} .html.for ${routinePath}/**` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = self.find( routinePath );
    test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

    var read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, '<html' ), 1 );
    test.identical( _.strCount( read, 'src="/.starter"' ), 1 );
    test.identical( _.strCount( read, 'src="./File1.js"' ), 1 );
    test.identical( _.strCount( read, 'src="./File2.js"' ), 1 );
    test.identical( _.strCount( read, '<title>' ), 1 );
    test.identical( _.strCount( read, '<script src' ), 3 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'with title';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    return null;
  })

  shell( `${execPath} .html.for ${routinePath}/** title:"Html for test"` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = self.find( routinePath );
    test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

    var read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, '<html' ), 1 );
    test.identical( _.strCount( read, 'src="/.starter"' ), 1 );
    test.identical( _.strCount( read, 'src="./File1.js"' ), 1 );
    test.identical( _.strCount( read, 'src="./File2.js"' ), 1 );
    test.identical( _.strCount( read, '<title>Html for test</title>' ), 1 );
    test.identical( _.strCount( read, '<title>' ), 1 );
    test.identical( _.strCount( read, '<script src' ), 3 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'without starter';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    return null;
  })

  shell( `${execPath} .html.for ${routinePath}/** title:"Html for test" starterIncluding:0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = self.find( routinePath );
    test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

    var read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, '<html' ), 1 );
    test.identical( _.strCount( read, 'src="/.starter"' ), 0 );
    test.identical( _.strCount( read, 'src="./File1.js"' ), 1 );
    test.identical( _.strCount( read, 'src="./File2.js"' ), 1 );
    test.identical( _.strCount( read, '<title>Html for test</title>' ), 1 );
    test.identical( _.strCount( read, '<script src' ), 2 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'empty';
    _.fileProvider.filesDelete( routinePath );
    _.fileProvider.filesReflect({ reflectMap : { [ originalAssetPath ] : routinePath } })
    return null;
  })

  shell( `${execPath} .html.for []` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = self.find( routinePath );
    test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

    var read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, '<html' ), 1 );
    test.identical( _.strCount( read, 'src="/.starter"' ), 1 );
    test.identical( _.strCount( read, './src="File1.js"' ), 0 );
    test.identical( _.strCount( read, './src="File2.js"' ), 0 );
    test.identical( _.strCount( read, '<script src' ), 1 );

    return op;
  })

  /* */

  return ready;
}

//

async function includeCss( test )
{
  let self = this;
  let a = self.assetFor( test, 'includeCss', true );
  let starter = new _.Starter({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  var page,browser;

  a.reflect();
  starter.start
  ({
    basePath : a.routinePath,
    entryPath : 'index.js',
    open : 0
  })

  try
  {
    browser = await Pupeteer.launch({ headless : true });
    page = await browser.newPage();

    await page.goto( 'http://127.0.0.1:5000/index.js/?entry:1', { waitUntil : 'load' } );

    var got = await page.$$eval( 'script', ( scripts ) => scripts.map( ( s ) => s.src ) );
    test.identical( got, [ 'http://127.0.0.1:5000/.starter', 'http://127.0.0.1:5000/index.js' ] )

    var got = await page.evaluate( () =>
    {
      var style = window.getComputedStyle( document.querySelector( 'body') );
      return style.getPropertyValue( 'background' )
    });
    test.is( _.strHas( got, 'rgb(192, 192, 192)' ) );

    await browser.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await browser.close();
  }

  let ready = new _.Consequence();
  starter.servlet.server.close( () => ready.take( null ) );

  await ready;
}

//

async function workerWithInclude( test )
{
  let self = this;
  let a = self.assetFor( test, 'worker', true );
  let starter = new _.Starter({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let browser,page;

  a.reflect();
  starter.start
  ({
    basePath : a.routinePath,
    entryPath : 'index.js',
    open : 0,
  })

  try
  {
    browser = await Pupeteer.launch({ headless : true });
    page = await browser.newPage();
    let output = '';

    page.on( 'console', msg => output += msg.text() + '\n' );
    await page.goto( 'http://127.0.0.1:5000/index.js/?entry:1', { waitUntil : 'load' } );

    await _.time.out( 1500 );

    test.is( _.strHas( output, 'Global: Window' ) )
    test.is( _.strHas( output, 'Global: DedicatedWorkerGlobalScope' ) )

    await browser.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await browser.close();
  }

  let ready = new _.Consequence();
  starter.servlet.server.close( () => ready.take( null ) );

  await ready;
}

//

async function includeExcludingManual( test )
{
  let self = this;
  let a = self.assetFor( test, 'exclude', true );
  let starter = new _.Starter({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let browser, page;

  a.reflect();
  starter.start
  ({
    basePath : a.routinePath,
    entryPath : 'index.js',
    open : 0,
  })

  try
  {
    browser = await Pupeteer.launch({ headless : true });
    page = await browser.newPage();

    await page.goto( 'http://127.0.0.1:5000/index.js/?entry:1', { waitUntil : 'load' } );

    var scripts = await page.$$eval( 'script', ( scripts ) => scripts.map( ( s ) => s.innerHTML || s.src ) )
    test.identical( scripts.length, 3 );
    test.identical( scripts[ 0 ], 'http://127.0.0.1:5000/.starter' );
    test.identical( scripts[ 1 ], 'http://127.0.0.1:5000/index.js' );
    test.is( _.strHas( scripts[ 2 ], './src/File.js' ) );

    await browser.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await browser.close();
  }

  let ready = new _.Consequence();
  starter.servlet.server.close( () => ready.take( null ) );

  await ready;
}

//

async function includeModule( test )
{
  let self = this;
  let a = self.assetFor( test, 'includeModule', true );
  let starter = new _.Starter({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let browser,page;

  a.reflect();

  await a.willbe({ args : '.build' })

  starter.start
  ({
    basePath : _.path.join( a.routinePath, 'out/debug' ),
    entryPath : 'index.js',
    open : 0,
  })

  try
  {
    browser = await Pupeteer.launch({ headless : true });
    page = await browser.newPage();

    await page.goto( 'http://127.0.0.1:5000/index.js/?entry:1', { waitUntil : 'load' } );

    var result = await page.evaluate( () =>
    {
      var _ = _global_.wTools;
      _.include( 'wPathBasic' );
      return _.path.join( '/a', 'b' );
    })
    test.identical( result, '/a/b' )

    await browser.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await browser.close();
  }

  let ready = new _.Consequence();
  starter.servlet.server.close( () => ready.take( null ) );

  await ready;
}

//

function version( test )
{
  let self = this;
  let routinePath = _.path.join( self.suiteTempPath, test.name );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    mode : 'shell',
    ready : ready,
  })

  _.fileProvider.dirMake( routinePath );

  /* */

  shell({ execPath : '.version' })
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.is( _.strHas( op.output, /Current version:.*\..*\..*/ ) );
    test.is( _.strHas( op.output, /Available version:.*\..*\..*/ ) );
    return op;
  })

  return ready;
}

// --
// declare
// --

var Self =
{

  name : 'Tools.StarterMaker',
  silencing : 1,
  enabled : 1,
  routineTimeOut : 60000,
  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null,
    assetsOriginalSuitePath : null,
    find : null,
    assetFor
  },

  tests :
  {

    sourcesJoin,
    shellSourcesJoin,
    shellSourcesJoinWithEntry,
    shellSourcesJoinDep,
    shellSourcesJoinRequireInternal,
    shellSourcesJoinComplex,
    shellSourcesJoinTree,
    shellSourcesJoinCycle,

    htmlFor,
    shellHtmlFor,

    includeCss,
    workerWithInclude,
    includeExcludingManual,

    includeModule,

    version,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
