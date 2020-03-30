( function _StarterMaker_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  var _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wPuppet' );

  require( '../starter/Include.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;

  context.suiteTempPath = _.path.pathDirTempOpen( _.path.join( __dirname, '../..'  ), 'Starter' );
  context.assetsOriginalSuitePath = _.path.join( __dirname, '_asset' );
  context.willbeExecPath = _.module.resolve( 'willbe' );
  context.execJsPath = _.module.resolve( 'wStarter' );

}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, '/Starter' ) )
  _.path.pathDirTempClose( context.suiteTempPath );
}

//

function assetFor( test, name )
{
  let context = this;
  let a = test.assetFor( name );

  a.find = _.fileProvider.filesFinder
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

  a.will = _.process.starter
  ({
    execPath : context.willbeExecPath,
    currentPath : a.routinePath,
    outputCollecting : 1,
    outputGraying : 1,
    ready : a.ready,
    mode : 'fork',
  })

  return a;
}

// --
// tests
// --

function shellSourcesJoin( test )
{
  let context = this;
  let a = context.assetFor( test, 'several' );
  let outputPath = _.path.join( a.routinePath, 'Index.js' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    execPath : 'node',
    currentPath : a.routinePath,
    mode : 'spawn',
    outputCollecting : 1,
    ready : ready,
  });

  a.reflect();

  shell( `${execPath} .sources.join ${a.routinePath}/** entryPath:File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoin\/Index\.js/ ), 1 )

    var files = a.find( a.routinePath );
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
  let context = this;
  let a = context.assetFor( test, 'dep' );
  let outputPath = _.path.join( a.routinePath, 'out/app0.js' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.starter.System().form();

  let shell = _.process.starter
  ({
    execPath : 'node',
    currentPath : a.routinePath,
    mode : 'spawn',
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 0,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join app0/** entryPath:app0/File2.js outPath:out/app0.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinWithEntry\/out\/app0\.js/ ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0.js' ] );

    let read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'base path : .';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join app0/** entryPath:app0/File2.js outPath:out/app0.js basePath:.` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinWithEntry\/out\/app0\.js/ ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0.js' ] );

    let read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'base path : app0';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join ** entryPath:File2.js outPath:../out/app0.js basePath:app0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinWithEntry\/out\/app0\.js/ ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0.js' ] );

    let read = _.fileProvider.fileRead( outputPath );
    test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'bad entry';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join app0/** entryPath:File2.js outPath:out/app0.js` )
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of source files should have all entry files' ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js' ] );

    return op;
  })

  /* */

  ready.then( () =>
  {
    test.case = 'bad entry, base path defined';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `${execPath} .sources.join ** entryPath:app0/File2.js outPath:../out/app0.js basePath:app0` )
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'List of source files should have all entry files' ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js' ] );

    return op;
  })

  /* */

  return ready;
}

//

function shellSourcesJoinDep( test )
{
  let context = this;
  let a = context.assetFor( test, 'dep' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
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

  let start = _.process.starter
  ({
    currentPath : a.routinePath,
    mode : 'spawn',
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  let shell = _.process.starter
  ({
    mode : 'shell',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `npm i` )
  start( `node ${execPath} .sources.join app2/** outPath:out/app2` )
  start( `node ${execPath} .sources.join app0/** outPath:out/app0 entryPath:app0/File2.js externalBeforePath:out/app2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinDep\/out\/app0/ ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/app0', './out/app2' ] );

    return op;
  })

  start( `node out/app0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  start( `node app0/File2.js` )
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
  let context = this;
  let a = context.assetFor( test, 'dep' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
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

  let start = _.process.starter
  ({
    mode : 'spawn',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  let shell = _.process.starter
  ({
    mode : 'shell',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `npm i` )
  start( `node ${execPath} .sources.join app0/** outPath:out/dir/app0` )
  start( `node ${execPath} .sources.join app2/** outPath:out/dir/app2` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinRequireInternal\/out\/dir\/app2/ ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app2', './app2/File1.js', './app2/File2.js', './ext', './ext/RequireApp2File2.js', './out', './out/dir', './out/dir/app0', './out/dir/app2' ] );

    return op;
  })

  start( `node ext/RequireApp2File2.js` )
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
  let context = this;
  let a = context.assetFor( test, 'complex' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
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

  let start = _.process.starter
  ({
    mode : 'spawn',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  let shell = _.process.starter
  ({
    mode : 'shell',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect()
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `npm i` )
  start( `node ${execPath} .sources.join app2/** outPath:out/app2` )
  start( `node ${execPath} .sources.join app1/** outPath:out/app1` )
  start( `node ${execPath} .sources.join app0/** outPath:out/app0 entryPath:app0/File2.js externalBeforePath:[out/app1, out/app2]` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinComplex\/out\/app0/ ), 1 );

    var files = a.find( a.routinePath );
    test.identical( files, [ '.', './app0', './app0/File1.js', './app0/File2.js', './app1', './app1/File1.js', './app1/File2.js', './app2', './app2/File1.js', './app2/File2.js', './out', './out/app0', './out/app1', './out/app2' ] );

    return op;
  })

  start( `node out/app0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.equivalent( op.output, output );
    return op;
  })

  start( `node app0/File2.js` )
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
  let context = this;
  let a = context.assetFor( test, 'tree' );
  let outPath = _.path.join( a.routinePath, 'out' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    mode : 'spawn',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'app1, entry:File1';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/dir1/File1.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinTree\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = a.find( outPath );
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
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/dir1/dir2/File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinTree\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = a.find( outPath );
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
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1` )
  shell( `node ${execPath} .sources.join in/app2/** outPath:out/app2 entryPath:in/app2/File2.js externalBeforePath:out/app1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinTree\/out\/app2/ ), 1 );

    var expected = [ '.', './app1', './app2' ];
    var files = a.find( outPath );
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
  let context = this;
  let a = context.assetFor( test, 'cycle' );
  let outPath = _.path.join( a.routinePath, 'out' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.starter.System().form();

  let shell = _.process.starter
  ({
    mode : 'spawn',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
    throwingExitCode : 1,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'app1, entry:File1';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/File1.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinCycle\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = a.find( outPath );
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
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/File2.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ sourcesJoin to .*shellSourcesJoinCycle\/out\/app1/ ), 1 );

    var expected = [ '.', './app1' ];
    var files = a.find( outPath );
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
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    _.fileProvider.filesDelete( a.routinePath + '/out' );
    return null;
  })

  shell( `node ${execPath} .sources.join in/app1/** outPath:out/app1 entryPath:in/app1/File2.js externalBeforePath:out/app2` )
  shell( `node ${execPath} .sources.join in/app2/** outPath:out/app2 entryPath:in/app2/File2.js externalBeforePath:out/app1` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );

    var expected = [ '.', './app1', './app2' ];
    var files = a.find( outPath );
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

function shellHtmlFor( test )
{
  let context = this;
  let a = context.assetFor( test, 'several' );
  let outputPath = _.path.join( a.routinePath, 'Index.html' );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );
  let starter = new _.starter.System().form();

  let shell = _.process.starter
  ({
    mode : 'spawn',
    execPath : 'node',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready : ready,
  });

  /* */

  ready.then( () =>
  {
    test.case = 'default';
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    return null;
  })

  shell( `${execPath} .html.for ${a.routinePath}/**` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = a.find( a.routinePath );
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
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    return null;
  })

  shell( `${execPath} .html.for ${a.routinePath}/** title:"Html for test"` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = a.find( a.routinePath );
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
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    return null;
  })

  shell( `${execPath} .html.for ${a.routinePath}/** title:"Html for test" starterIncluding:0` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = a.find( a.routinePath );
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
    _.fileProvider.filesDelete( a.routinePath );
    a.reflect();
    return null;
  })

  shell( `${execPath} .html.for []` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /\+ html saved to .*shellHtmlFor\/Index\.html/ ), 1 )

    var files = a.find( a.routinePath );
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

async function logging( test )
{
  let context = this;
  let a = context.assetFor( test, 'asyncError' );

  a.reflect();

  a.js( `.start F1.js` )
  .then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'xxx' ), 1 )
    return op;
  })

  return a.ready;
}

//

function version( test )
{
  let context = this;
  let routinePath = _.path.join( context.suiteTempPath, test.name );
  let execPath = _.path.nativize( _.path.join( __dirname, '../starter/Exec' ) );
  let ready = new _.Consequence().take( null );

  let shell = _.process.starter
  ({
    execPath : 'node ' + execPath,
    currentPath : routinePath,
    outputCollecting : 1,
    throwingExitCode : 0,
    mode : 'spawn',
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

  name : 'Tools.Starter.Ext',
  silencing : 1,
  enabled : 1,
  routineTimeOut : 60000,
  onSuiteBegin,
  onSuiteEnd,

  context :
  {

    assetFor,

    suiteTempPath : null,
    assetsOriginalSuitePath : null,
    execJsPath : null,

    willbeExecPath : null,
    find : null,

  },

  tests :
  {

    // sourcesJoin

    shellSourcesJoin,
    shellSourcesJoinWithEntry,
    shellSourcesJoinDep,
    shellSourcesJoinRequireInternal,
    shellSourcesJoinComplex,
    shellSourcesJoinTree,
    shellSourcesJoinCycle,

    // html for

    shellHtmlFor,

    // etc

    logging,
    version,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
