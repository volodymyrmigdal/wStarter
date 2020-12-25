( function _Int_test_s_()
{

'use strict';

let Jsdom;

if( typeof module !== 'undefined' )
{

  Jsdom = require( 'jsdom' );
  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wPuppet' );

  require( '../starter/entry/Include.s' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;

  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Starter' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
  context.willbeExecPath = _.module.resolve( 'willbe' );
  context.appJsPath = _.module.resolve( 'wStarter' );
}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, '/Starter' ) )
  _.path.tempClose( context.suiteTempPath );
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

  let oprogram = a.program;
  program_body.defaults = a.program.defaults;
  a.program = _.routineUnite( a.program.head, program_body );
  return a;

  /* */

  function program_body( o )
  {
    let locals =
    {
      toolsPath : _.module.resolve( 'wTools' ),
    };
    o.locals = o.locals || locals;
    _.mapSupplement( o.locals, locals );
    let programPath = a.path.nativize( oprogram.body.call( a, o ) ); /* zzz : modify a.program()? */
    return programPath;
  }
}

// --
// tests
// --

function sourcesJoinFiles( test )
{
  let context = this;
  let a = context.assetFor( test, 'several' );
  let outputPath = _.path.join( a.routinePath, 'Index.js' );
  let ready = new _.Consequence().take( null );
  let starter = new _.starter.System().form();

  a.reflect();

  let js = _.process.starter
  ({
    execPath : 'node',
    currentPath : a.routinePath,
    outputCollecting : 1,
    ready,
  });

  starter.sourcesJoinFiles
  ({
    inPath : '**',
    entryPath : 'File2.js',
    basePath : a.routinePath,
  })

  var files = a.find( a.routinePath );
  test.identical( files, [ '.', './File1.js', './File2.js', './Index.js' ] );

  let read = _.fileProvider.fileRead( outputPath );
  test.identical( _.strCount( read, 'setTimeout( f, 1000 );' ), 2 );

  js( _.path.nativize( outputPath ) )
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

function htmlForFilesBasic( test )
{
  let context = this;
  let a = context.assetFor( test, 'several' );
  let outputPath = _.path.join( a.routinePath, 'Index.html' );
  let ready = new _.Consequence().take( null );
  let starter = new _.starter.System().form();

  /* */

  test.case = 'default';

  a.reflect();

  starter.htmlForFiles
  ({
    inPath : '**',
    basePath : a.routinePath,
  })

  var files = a.find( a.routinePath );
  test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

  var read = a.fileProvider.fileRead( outputPath );
  var dom = new Jsdom.JSDOM( read );
  var document = dom.window.document;

  test.description = 'scripts';
  var exp = [ '/.starter', './File1.js', './File2.js' ];
  var got = _.select( document.querySelectorAll( 'script' ), '*/src' );
  test.identical( got, exp );

  test.description = 'title';
  var exp = [ 'File1.js' ];
  var got = _.select( document.querySelectorAll( 'title' ), '*/text' );
  test.identical( got, exp );

  var got = document.querySelectorAll( 'html' );
  test.identical( got.length, 1 );

  /* */

  return ready;
}

//

function htmlForFilesOptionTitle( test )
{
  let context = this;
  let a = context.assetFor( test, 'several' );
  let outputPath = _.path.join( a.routinePath, 'Index.html' );
  let ready = new _.Consequence().take( null );
  let starter = new _.starter.System().form();

  /* */

  test.case = 'default';

  a.reflect();

  starter.htmlForFiles
  ({
    inPath : '**',
    basePath : a.routinePath,
  })

  var read = a.fileProvider.fileRead( outputPath );
  var dom = new Jsdom.JSDOM( read );
  var document = dom.window.document;

  test.description = 'title';
  var exp = [ 'File1.js' ];
  var got = _.select( document.querySelectorAll( 'title' ), '*/text' );
  test.identical( got, exp );

  /* */

  test.case = 'explicit';

  a.reflect();

  starter.htmlForFiles
  ({
    inPath : '**',
    basePath : a.routinePath,
    title : 'Explicit Title',
  })

  var read = a.fileProvider.fileRead( outputPath );
  var dom = new Jsdom.JSDOM( read );
  var document = dom.window.document;

  test.description = 'title';
  var exp = [ 'Explicit Title' ];
  var got = _.select( document.querySelectorAll( 'title' ), '*/text' );
  test.identical( got, exp );

  /* */

  return ready;
}

//

function htmlForFilesOptionWithStarter( test )
{
  let context = this;
  let a = context.assetFor( test, 'several' );
  let outputPath = _.path.join( a.routinePath, 'Index.html' );
  let ready = new _.Consequence().take( null );
  let starter = new _.starter.System().form();

  /* */

  test.case = 'without starter';

  a.reflect();

  starter.htmlForFiles
  ({
    inPath : '**',
    basePath : a.routinePath,
    title : 'Html for test',
    withStarter : 0,
  })

  var files = a.find( a.routinePath );
  test.identical( files, [ '.', './File1.js', './File2.js', './Index.html' ] );

  var read = a.fileProvider.fileRead( outputPath );
  var dom = new Jsdom.JSDOM( read );
  var document = dom.window.document;

  test.description = 'scripts';
  var exp = [ './File1.js', './File2.js' ];
  var got = _.select( document.querySelectorAll( 'script' ), '*/src' );
  test.identical( got, exp );

  /* */

  return ready;
}

//

async function includeCss( test )
{
  let context = this;
  let a = context.assetFor( test, 'includeCss' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  var page, window;

  a.reflect();

  let session = await starter.start
  ({
    basePath : a.routinePath,
    entryPath : 'Index.js',
    curating : 0
  })

  var parsed = _.uri.parse( session.entryWithQueryUri );

  try
  {
    window = await _.puppet.windowOpen({ headless : true });
    page = await window.pageOpen();

    await page.goto( session.entryWithQueryUri );

    var got = await page.selectEval( 'script', ( scripts ) => scripts.map( ( s ) => s.src ) );
    test.identical( got, [ `${parsed.origin}/.starter`, `${parsed.origin}/Index.js` ] );

    var got = await page.eval( () =>
    {
      var style = window.getComputedStyle( document.querySelector( 'body') );
      return style.getPropertyValue( 'background' )
    });
    test.true( _.strHas( got, 'rgb(192, 192, 192)' ) );

    await window.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await window.close();
  }

  return starter.close();
}

//

async function includeExcludingManual( test )
{
  let context = this;
  let a = context.assetFor( test, 'exclude' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let window, page;

  a.reflect();

  let session = await starter.start
  ({
    basePath : a.routinePath,
    entryPath : 'Index.js',
    curating : 0,
  })

  var parsed = _.uri.parse( session.entryWithQueryUri );

  try
  {
    window = await _.puppet.windowOpen({ headless : true });
    page = await window.pageOpen();

    await page.goto( session.entryWithQueryUri );

    var scripts = await page.selectEval( 'script', ( scripts ) => scripts.map( ( s ) => s.innerHTML || s.src ) )
    test.identical( scripts.length, 3 );
    test.identical( scripts[ 0 ], `${parsed.origin}/.starter` );
    test.identical( scripts[ 1 ], `${parsed.origin}/Index.js` );
    test.true( _.strHas( scripts[ 2 ], './src/File.js' ) );

    await window.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await window.close();
  }

  return starter.close();
}

//

async function includeModule( test )
{
  let context = this;
  let a = context.assetFor( test, 'includeModule' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let window, page;

  a.reflect();

  await a.will({ args : '.build' })

  let session = await starter.start
  ({
    basePath : _.path.join( a.routinePath, 'build' ),
    entryPath : 'Index.js',
    curating : 0,
  })

  var parsed = _.uri.parse( session.entryWithQueryUri );

  try
  {
    window = await _.puppet.windowOpen({ headless : true });
    page = await window.pageOpen();

    await page.goto( session.entryWithQueryUri );

    var result = await page.eval( () =>
    {
      let _ = _global_.wTools;
      _.include( 'wPathBasic' );
      return _.path.join( '/a', 'b' );
    })
    test.identical( result, '/a/b' )

    await window.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await window.close();
  }

  return starter.close();
}

includeModule.timeOut = 300000;

// --
// worker
// --

async function workerWithInclude( test )
{
  let context = this;
  let a = context.assetFor( test, 'workerUsingTheSameInclude' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let window, page;

  a.reflect();

  // debugger;
  // var files = a.fileProvider.dirRead( a.routinePath );
  // logger.log( `files : ${files}` );

  let session = await starter.start
  ({
    basePath : a.routinePath,
    entryPath : 'Index.js',
    curating : 0,
  })

  var parsed = _.uri.parse( session.entryWithQueryUri );

  try
  {
    window = await _.puppet.windowOpen({ headless : true });
    page = await window.pageOpen();
    let output = '';

    page.on( 'console', ( msg ) => output += msg.text() + '\n' );

    await page.goto( session.entryWithQueryUri );
    await _.time.out( context.deltaTime2 );

    test.true( _.strHas( output, 'Global : Window' ) )
    test.true( _.strHas( output, 'Global : DedicatedWorkerGlobalScope' ) )

    await window.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await window.close();
  }

  return starter.close();
}

workerWithInclude.timeOut = 300000;

//

async function includeModuleInWorker( test )
{
  let context = this;
  let a = context.assetFor( test, 'includeModuleInWorker' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let window, page;

  test.description = 'include module two times, second time module cache should be used'

  a.reflect();

  await a.will({ args : '.build' })

  let session = await starter.start
  ({
    basePath : _.path.join( a.routinePath, 'build' ),
    entryPath : 'Index.js',
    curating : 0,
  })

  var parsed = _.uri.parse( session.entryWithQueryUri );

  try
  {
    window = await _.puppet.windowOpen({ headless : true });
    page = await window.pageOpen();
    let output = '';

    page.on( 'console', ( msg ) => output += msg.text() + '\n' );

    await page.goto( session.entryWithQueryUri );

    await _.time.out( context.deltaTime2 );

    console.log( output )

    test.case = 'module was exported and returned object is same as global namespace created in module'
    test.true( _.strHas( output, `Module was exported: true` ) );
    test.case = 'two includes return same object'
    test.true( _.strHas( output, `Both includes have same export: true` ) );

    await window.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await window.close();
  }

  return starter.close();
}

includeModuleInWorker.timeOut = 300000;

//

async function includeModuleInWorkerThrowing( test )
{
  let context = this;
  let a = context.assetFor( test, 'includeModuleInWorkerThrowing' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let window, page;

  test.description = 'module throws an error during include process, error should be catched in try/catch block'

  a.reflect();

  await a.will({ args : '.build' })

  let session = await starter.start
  ({
    basePath : _.path.join( a.routinePath, 'build' ), /* xxx : replace */
    entryPath : 'Index.js',
    curating : 0,
  })

  var parsed = _.uri.parse( session.entryWithQueryUri );

  try
  {
    window = await _.puppet.windowOpen({ headless : true });
    page = await window.pageOpen();
    let output = '';

    page.on( 'console', ( msg ) => output += msg.text() + '\n' );

    await page.goto( session.entryWithQueryUri );

    await _.time.out( context.deltaTime2 );

    // console.log( '!' + output + '!' );

    test.true( !_.strHas( output, `Module was included` ) );
    test.true( _.strHas( output, `Module error` ) );
    test.true( _.strHas( output, `Error including source file /Module.js` ) );

    await window.close();
  }
  catch( err )
  {
    test.exceptionReport({ err });
    await window.close();
  }

  return starter.close();
}

includeModuleInWorkerThrowing.timeOut = 300000;

// --
// curated run
// --

async function curatedRunWindowOpenCloseAutomatic( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let session;

  try
  {

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );

    // await _.time.out( context.deltaTime3 ); /* xxx : remove later and find fix working for linux */
    // debugger;

    session = await starter.start
    ({
      entryPath : a.originalAbs( './F1.js' ),
      headless : 1,
      cleanupAfterStarterDeath : 0
    })

    test.identical( session.curratedRunState, 'launching' );

    await _.time.out( context.deltaTime2 ); /* xxx : remove later and find fix working for linux */

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, true );
    debugger;

    await _.time.out( context.deltaTime2 );

    test.identical( session.curratedRunState, 'launched' );

    await session.unform();

    test.identical( session.curratedRunState, 'terminated' );
    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );
    test.identical( session.curratedRunState, 'terminated' );

  }
  catch( err )
  {
    if( session )
    await session.unform();
  }

}

curatedRunWindowOpenCloseAutomatic.timeOut = 300000;

//

async function curatedRunWindowOpenCloseWindowManually( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let session;

  try
  {

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );

    session = await starter.start
    ({
      entryPath : a.originalAbs( './F1.js' ),
      headless : 1,
      cleanupAfterStarterDeath : 0
    })

    test.identical( session.curratedRunState, 'launching' );

    await _.time.out( context.deltaTime2 );

    test.identical( session.curratedRunState, 'launched' );

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, true );

    await session._curratedRunWindowClose();

    await _.time.out( context.deltaTime3 );

    test.identical( session.curratedRunState, 'terminated' );
    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );
    test.identical( session.curratedRunState, 'terminated' );

  }
  catch( err )
  {
    if( session )
    await session.unform();
  }

}

curatedRunWindowOpenCloseWindowManually.timeOut = 300000;

//

async function curatedRunWindowOpenClosePageManually( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let session;

  try
  {

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );

    session = await starter.start
    ({
      entryPath : a.originalAbs( './F1.js' ),
      headless : 1,
      cleanupAfterStarterDeath : 0
    })

    test.identical( session.curratedRunState, 'launching' );

    await _.time.out( context.deltaTime2 ); /* xxx : remove later and find fix working for linux */

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, true );

    await _.time.out( context.deltaTime2 );

    test.identical( session.curratedRunState, 'launched' );

    await session._curratedRunPageEmptyOpen();
    await session._curratedRunPageClose();

    await _.time.out( context.deltaTime3 );

    test.identical( session.curratedRunState, 'terminated' );
    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );
    test.identical( session.curratedRunState, 'terminated' );

  }
  catch( err )
  {
    if( session )
    await session.unform();
  }

}

curatedRunWindowOpenClosePageManually.timeOut = 300000;

//

async function curatedRunEventsCloseAutomatic( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );
  let system = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let encountered = Object.create( null );
  let session;

  try
  {

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );

    let opts =
    {
      system,
      entryPath : a.originalAbs( './F1.js' ),
      headless : 1,
      cleanupAfterStarterDeath : 0
    }
    session = new _.starter.session.BrowserCdp( opts );

    session.on( [ 'curatedRunLaunchBegin', 'curatedRunLaunchEnd', 'curatedRunTerminateEnd' ], ( e ) =>
    {
      encountered[ e.kind ] = encountered[ e.kind ] || 0;
      encountered[ e.kind ] += 1;
    });

    test.identical( session.curratedRunState, null );

    await session.form();

    test.identical( session.curratedRunState, 'launching' );
    await session.eventWaitFor( 'curatedRunLaunchEnd' );
    test.identical( session.curratedRunState, 'launched' );

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, true );
    test.identical( session.curratedRunState, 'launched' );

    await session.unform();

    test.identical( session.curratedRunState, 'terminated' );
    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );
    test.identical( session.curratedRunState, 'terminated' );

    var exp =
    {
      curatedRunLaunchBegin : 1,
      curatedRunLaunchEnd : 1,
      curatedRunTerminateEnd : 1,
    }
    test.identical( encountered, exp );

  }
  catch( err )
  {
    if( session )
    await session.unform();
  }

}

curatedRunEventsCloseAutomatic.timeOut = 300000;

//

async function curatedRunEventsCloseWindowManually( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );
  let system = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let encountered = Object.create( null );
  let session;

  try
  {

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );

    let opts =
    {
      system,
      entryPath : a.originalAbs( './F1.js' ),
      headless : 1,
      cleanupAfterStarterDeath : 0
    }
    session = new _.starter.session.BrowserCdp( opts );

    session.on( [ 'curatedRunLaunchBegin', 'curatedRunLaunchEnd', 'curatedRunTerminateEnd' ], ( e ) =>
    {
      encountered[ e.kind ] = encountered[ e.kind ] || 0;
      encountered[ e.kind ] += 1;
    });

    test.identical( session.curratedRunState, null );

    await session.form();

    test.identical( session.curratedRunState, 'launching' );
    await session.eventWaitFor( 'curatedRunLaunchEnd' );
    test.identical( session.curratedRunState, 'launched' );

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, true );
    test.identical( session.curratedRunState, 'launched' );

    await session._curratedRunWindowClose();

    await session.eventWaitFor( 'curatedRunTerminateEnd' );

    test.identical( session.curratedRunState, 'terminated' );
    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );
    test.identical( session.curratedRunState, 'terminated' );

    var exp =
    {
      curatedRunLaunchBegin : 1,
      curatedRunLaunchEnd : 1,
      curatedRunTerminateEnd : 1,
    }
    test.identical( encountered, exp );

    await session.eventWaitFor( 'unformed' );

  }
  catch( err )
  {
    if( session )
    await session.unform();
  }

}

curatedRunEventsCloseWindowManually.timeOut = 300000;

//

async function curatedRunEventsClosePageManually( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );
  let system = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let encountered = Object.create( null );
  let session;

  try
  {

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );

    let opts =
    {
      system,
      entryPath : a.originalAbs( './F1.js' ),
      headless : 1,
      cleanupAfterStarterDeath : 0
    }
    session = new _.starter.session.BrowserCdp( opts );

    session.on( [ 'curatedRunLaunchBegin', 'curatedRunLaunchEnd', 'curatedRunTerminateEnd' ], ( e ) =>
    {
      encountered[ e.kind ] = encountered[ e.kind ] || 0;
      encountered[ e.kind ] += 1;
    });

    test.identical( session.curratedRunState, null );

    await session.form();

    test.identical( session.curratedRunState, 'launching' );
    await session.eventWaitFor( 'curatedRunLaunchEnd' );
    test.identical( session.curratedRunState, 'launched' );

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, true );
    test.identical( session.curratedRunState, 'launched' );

    await session._curratedRunPageEmptyOpen();
    await session._curratedRunPageClose();

    /* event curatedRunTerminateEnd can come before return of _curratedRunPageClose! */
    await session.eventWaitFor( 'curatedRunTerminateEnd' );

    test.identical( session.curratedRunState, 'terminated' );
    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );
    test.identical( session.curratedRunState, 'terminated' );

    var exp =
    {
      curatedRunLaunchBegin : 1,
      curatedRunLaunchEnd : 1,
      curatedRunTerminateEnd : 1,
    }
    test.identical( encountered, exp );

    await session.eventWaitFor( 'unformed' );

  }
  catch( err )
  {
    if( session )
    await session.unform();
  }

}

curatedRunEventsClosePageManually.timeOut = 300000;

//

async function curatedRunRandomPort( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );
  let starter = new _.starter.System({ verbosity : test.suite.verbosity >= 7 ? 3 : 0 }).form();
  let session;

  try
  {

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened();
    test.identical( !!cdp, false );

    // await _.time.out( context.deltaTime3 ); /* xxx : remove later and find fix working for linux */
    // debugger;

    session = await starter.start
    ({
      entryPath : a.originalAbs( './F1.js' ),
      headless : 1,
      cleanupAfterStarterDeath : 0,
      sessionPort : 0,
      serverPath : 'http://127.0.0.1:0'
    })

    test.identical( session.curratedRunState, 'launching' );

    await _.time.out( context.deltaTime2 ); /* xxx : remove later and find fix working for linux */

    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened( session );
    test.identical( !!cdp, true );

    await _.time.out( context.deltaTime2 );

    test.identical( session.curratedRunState, 'launched' );

    test.notIdentical( session.sessionPort, 0 );
    let servletPathParsed = _.servlet.serverPathParse({ full : session.servlet.serverPath });
    test.notIdentical( servletPathParsed.port, 0 );
    test.identical( session.servlet.httpServer.address().port, servletPathParsed.port );

    await session.unform();

    test.identical( session.curratedRunState, 'terminated' );
    var cdp = await _.starter.session.BrowserCdp._CurratedRunWindowIsOpened( session );
    test.identical( !!cdp, false );
    test.identical( session.curratedRunState, 'terminated' );

  }
  catch( err )
  {
    if( session )
    await session.unform();
  }

}

curatedRunRandomPort.timeOut = 300000;

//

function browserUserTempDirCleanup( test )
{
  let context = this;
  let a = context.assetFor( test, 'minute' );

  a.reflect();

  let locals =
  {
    toolsPath : _.module.resolve( 'wTools' ),
    starterPath : a.path.nativize( a.path.join( __dirname, '../starter/entry/Include.s' ) ),
    context : { deltaTime3 : context.deltaTime3 },
    opts :
    {
      entryPath : a.abs( './F1.js' ),
      basePath : a.abs( '.'),
      headless : 1
    }
  }

  let execPath = a.program({ routine : program, locals });

  let op = { execPath };
  let ready = _.Consequence();
  let ready2 = _.Consequence();
  let tempDirPath, secondaryProcessPid;

  a.fork( op );

  op.pnd.on( 'message', ( data ) =>
  {
    if( data.field === 'tempDirPath' )
    ready.take( data.val )
    if( data.field === 'secondaryProcessPid' )
    ready2.take( data.val )
  });

  ready.then( ( got ) =>
  {
    tempDirPath = got;
    test.true( a.fileProvider.fileExists( tempDirPath ) );
    return null;
  })

  ready2.then( ( got ) =>
  {
    secondaryProcessPid = got;
    test.true( _.process.isAlive( secondaryProcessPid ) );
    return null;
  })

  op.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return _.time.out( context.deltaTime2 * 2 ) /* 6000 */
    .then( () =>
    {
      test.true( !a.fileProvider.fileExists( tempDirPath ) );
      test.true( !_.process.isAlive( secondaryProcessPid ) );
      return null;
    })
  })

  return _.Consequence.And( op.ready, ready, ready2 );

  /* */

  function program()
  {
    let _ = require( toolsPath );
    _.include( 'wStarter')

    let starter = new _.starter.System({ verbosity : 7 }).form();
    let session;

    main();

    async function main()
    {
      try
      {
        session = await starter.start( opts );
        process.send({ field : 'tempDirPath', val : session._tempDir });
        await _.time.out( context.deltaTime3 );
        await session.unform();
        process.send({ field : 'secondaryProcessPid', val : session._tempDirCleanProcess.pnd.pid });
      }
      catch( err )
      {
        if( session )
        await session.unform();
        throw _.err( err );
      }
    }
  }


}

//

async function servletRemoteResolve( test )
{
  let context = this;
  let a = context.assetFor( test, 'servlet' );

  a.reflect();

  let system = new _.starter.System({ verbosity : 7 }).form();

  let servlet = new _.starter.Servlet({ basePath : a.routinePath, allowedPath : { '/' : true }, system });
  await servlet.form();

  let Needle = require( 'needle' );

  test.case = 'glob for existing file'
  var response = await Needle( 'get', servlet.serverPath + '/.resolve/./*.js', { json : 1 });
  test.identical( response.body, [ '/F1.js' ] );

  test.case = 'glob for not existing file'
  var response = await Needle( 'get', servlet.serverPath + '/.resolve/./*.txt', { json : 1 });
  test.identical( response.body, [] );

  test.case = 'module'
  var response = await Needle( 'get', servlet.serverPath + '/.resolve/wTools', { json : 1 });
  test.true( _.strEnds( response.body, 'Layer1.s' ) );

  test.case = 'fail'
  var response = await Needle( 'get', servlet.serverPath + '/.resolve/unknown', { json : 1 });
  test.true( _.strIs( response.body.err ) );

  test.case = 'resolvingNpm disabled'
  servlet.resolvingNpm = false;
  var response = await Needle( 'get', servlet.serverPath + '/.resolve/wTools', { json : 1 });
  test.true( _.strIs( response.body.err ) );
  servlet.resolvingNpm = true;

  test.case = 'resolvingGlob disabled'
  servlet.resolvingGlob = false;
  var response = await Needle( 'get', servlet.serverPath + '/.resolve/./*.js', { json : 1 });
  test.true( _.strIs( response.body.err ) );
  servlet.resolvingGlob = true;

  return servlet.finit();
}

//

async function servletRemoteStat( test )
{
  let context = this;
  let a = context.assetFor( test, 'servlet' );

  a.reflect();

  let system = new _.starter.System({ verbosity : 7 }).form();

  let servlet = new _.starter.Servlet({ basePath : a.routinePath, allowedPath : { '/' : true }, system });
  await servlet.form();

  let Needle = require( 'needle' );

  test.case = 'absolute exists'
  var response = await Needle( 'get', servlet.serverPath + '/F1.js?stat=1', { json : 1 });
  test.identical( response.body, { exists : true } );

  test.case = 'absolute missing'
  var response = await Needle( 'get', servlet.serverPath + '/F2.js?stat=1', { json : 1 });
  test.identical( response.body, { exists : false } );

  test.case = 'relative'
  var dirName = a.fileProvider.path.name( a.routinePath )
  var response = await Needle( 'get', servlet.serverPath + `/../${dirName}/F1.js?stat=1`, { json : 1 });
  test.identical( response.body, { exists : true } );

  test.case = 'relative missing'
  var dirName = a.fileProvider.path.name( a.routinePath )
  var response = await Needle( 'get', servlet.serverPath + `/../${dirName}/F2.js?stat=1`, { json : 1 });
  test.identical( response.body, { exists : false } );

  return servlet.finit();

}

async function experiment( test )
{
  let context = this;
  let a = context.assetFor( test, false );

  let ChromeLauncher = require( 'chrome-launcher' );
  let ChromeDefaultFlags = require( 'chrome-launcher/dist/flags' ).DEFAULT_FLAGS
  let Cdp = require( 'chrome-remote-interface' );

  let installationPaths = ChromeLauncher.Launcher.getInstallations();
  let args = ChromeDefaultFlags.slice();

  args.push( `--remote-debugging-port=9222` )
  args.push( '--headless', '--disable-gpu' );

  let op =
  {
    execPath : _.strQuote( installationPaths[ 0 ] ),
    mode : 'spawn',
    detaching : 1,
    stdio : 'ignore',
    outputPiping : 0,
    inputMirroring : 0,
    throwingExitCode : 0,
    args
  }

  _.process.start( op )

  await op.conStart.then( () =>
  {
    op.disconnect();
    return _.time.out( 2000 );
  })

  let cdp = await Cdp({ port : 9222 });

  await cdp.Page.enable();
  await cdp.Page.navigate({ url : 'https://pptr.dev/' });
  await cdp.Page.loadEventFired();

  let cons = []

  let timer = _.time.periodic( 10, () =>
  {
    if( !_.process.isAlive( op.pnd.pid ) )
    return;

    let con = _.process.children({ pid : op.pnd.pid, format : 'list'})
    con.then( ( children ) =>
    {
      let names = children.filter( ( pnd ) => pnd.name !== 'chrome.exe' )
      test.identical( names.length, 0 )
      return null;
    })
    cons.push( con )

    return true;
  })

  await _.time.out( 5000 );
  cdp.Browser.close();
  await _.process.kill({ pid : op.pnd.pid, withChildren : 1 });

  return _.Consequence.AndKeep( cons )
}

// --
// declare
// --

let Self =
{

  name : 'Tools.Starter.Int',
  silencing : 1,
  enabled : 1,
  routineTimeOut : 60000,
  onSuiteBegin,
  onSuiteEnd,

  context :
  {

    assetFor,

    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
    willbeExecPath : null,
    find : null,

    deltaTime1 : 250,
    deltaTime2 : 3000,
    deltaTime3 : 15000,

  },

  tests :
  {

    // sourcesJoinFiles

    sourcesJoinFiles,

    // html for

    htmlForFilesBasic,
    htmlForFilesOptionTitle,
    htmlForFilesOptionWithStarter,

    // include

    includeCss,
    includeExcludingManual,
    includeModule,

    // worker

    workerWithInclude,
    includeModuleInWorker,
    includeModuleInWorkerThrowing,

    // curated run

    curatedRunWindowOpenCloseAutomatic,
    curatedRunWindowOpenCloseWindowManually,
    curatedRunWindowOpenClosePageManually,

    curatedRunEventsCloseAutomatic,
    curatedRunEventsCloseWindowManually,
    curatedRunEventsClosePageManually,

    // port

    curatedRunRandomPort,

    // etc

    browserUserTempDirCleanup,

    //servlet

    servletRemoteResolve,
    servletRemoteStat,

    experiment

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
