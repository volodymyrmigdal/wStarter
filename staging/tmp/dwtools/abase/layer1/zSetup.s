(function _zSetup_s_() {

'use strict';

var _global = _global_;
var _ = _global.wTools;
var Self = _global.wTools;

// --
// setup
// --

function _setupConfig()
{

  if( _global.WTOOLS_PRIVATE )
  return;

  /* config */

  if( !_global.Config )
  _global.Config = Object.create( null );

  if( _global.Config.debug === undefined )
  _global.Config.debug = true;

  _global.Config.debug = !!_global.Config.debug;

}

//

function _setupUnhandledErrorHandler()
{

  if( _global._setupUnhandledErrorHandlerDone )
  return;

  _global._setupUnhandledErrorHandlerDone = true;

  var handlerWas = null;

  // console.info( 'REMINDER : fix unhandled error handler' );

  if( _global.process && _.routineIs( _global.process.on ) )
  {
    _global.process.on( 'uncaughtException', handleError );
  }
  else if( Object.hasOwnProperty.call( _global,'onerror' ) )
  {
    handlerWas = _global.onerror;
    _global.onerror = handleBrowserError;
  }

  /**/

  function handleBrowserError( message, sourcePath, lineno, colno, error )
  {
    if( _._err )
    var err = _._err
    ({
      args : [ error ],
      level : 1,
      fallBackStack : 'at handleError @ ' + sourcePath + ':' + lineno,
      location :
      {
        path : sourcePath,
        line : lineno,
        col : colno,
      },
    });

    handleError( err );

    if( handlerWas )
    handlerWas.call( this, message, sourcePath, lineno, colno, error );
  }

  /* */

  function handleError( err )
  {

    try
    {
      if( _.errIsAttended( err ) )
      return
    }
    catch( err2 )
    {
      console.error( err2.toString() );
    }

    console.error( '------------------------------- unhandled errorr ------------------------------->' );

    try
    {

      if( _.appExitCode )
      _.appExitCode( -1 )

      if( !err.originalMessage )
      {
        if( _.objectLike( err ) )
        {
          if( _.toStr && _.field )
          console.error( _.toStr.fields( err,{ errorAsMap : 1 } ) );
          else
          console.error( err );
        }
        debugger;
        if( _.errLog )
        _.errLog( 'Uncaught exception\n', err );
        else
        console.error( 'Uncaught exception\n', err );
      }
      else
      {
        if( _.errLog )
        _.errLog( 'Uncaught exception\n', err );
        else
        console.error( 'Uncaught exception\n', err );
      }

    }
    catch( err2 )
    {
      debugger;

      if( err2 && _.routineIs( err2.toString ) )
      console.error( err2.toString() );
      else
      console.error( err2 );

      if( err && _.routineIs( err.toString ) )
      console.error( err.toString() + '\n' + err.stack );
      else
      console.error( err );

    }

    console.error( '------------------------------- unhandled errorr -------------------------------<' );
    debugger;

  }

}

//

function _setupLoggerPlaceholder()
{

  if( !_global.console.debug )
  _global.console.debug = function debug()
  {
    this.log.apply( this,arguments );
  }

  if( !_global.logger )
  _global.logger =
  {
    log : function log() { console.log.apply( console,arguments ); },
    logUp : function logUp() { console.log.apply( console,arguments ); },
    logDown : function logDown() { console.log.apply( console,arguments ); },
    error : function error() { console.error.apply( console,arguments ); },
    errorUp :  function errorUp() { console.error.apply( console,arguments ); },
    errorDown : function errorDown() { console.error.apply( console,arguments ); },
  }

}

//

function _setupTesterPlaceholder()
{

  if( !_global.wTestSuite )
  _global.wTestSuite = function wTestSuite( testSuit )
  {

    if( !_realGlobal_.wTests )
    _realGlobal_.wTests = Object.create( null );

    if( !testSuit.suiteFilePath )
    testSuit.suiteFilePath = _.diagnosticLocation( 1 ).path;

    if( !testSuit.suiteFileLocation )
    testSuit.suiteFileLocation = _.diagnosticLocation( 1 ).full;

    _.assert( _.strIsNotEmpty( testSuit.suiteFileLocation ),'Test suit expects a mandatory option ( suiteFileLocation )' );
    _.assert( _.objectIs( testSuit ) );

    // if( testSuit.name === 'Chaining test' )
    // debugger;

    if( !testSuit.abstract )
    _.assert( !_realGlobal_.wTests[ testSuit.name ],'Test suit with name "' + testSuit.name + '" already registered!' );
    _realGlobal_.wTests[ testSuit.name ] = testSuit;

    testSuit.inherit = function inherit()
    {
      this.inherit = _.longSlice( arguments );
    }

    return testSuit;
  }

  /* */

  if( !_.Tester )
  {
    _.Tester = Object.create( null );
    _.Tester.test = function test( testSuitName )
    {
      if( _.workerIs() )
      return;
      _.assert( arguments.length === 0 || arguments.length === 1 );
      _.assert( _.strIs( testSuitName ) || testSuitName === undefined,'test : expects string {-testSuitName-}' );
      _.timeReady( function()
      {
        if( _.Tester.test === test )
        throw _.err( 'Cant wTesting.test, missing wTesting package' );
        _.Tester.test.call( _.Tester,testSuitName );
      });
    }
  }

}

//

function _setupLater()
{

  _.assert( _.objectIs( _.regexpsEscape ) );
  _.Later.for( _ );
  _.assert( _.routineIs( _.regexpsEscape ) );

  // for( var l in _.Later )
  // {
  //   var later = _.Later[ l ];
  //   delete _.Later[ l ];
  //
  //   _.assert( _[ l ] === null );
  //
  //   if( later.length === 3 )
  //   if( !_.arrayIs( later[ 2 ] ) )
  //   later[ 2 ] = [ later[ 2 ] ];
  //
  //   _[ l ] = _.routineCall.apply( _,later );
  //
  // }

}

//

function _setup()
{

  // Self.timeNow = Self._timeNow_functor();
  Self._sourcePath = _.diagnosticStack( 1 );

  if( _global._WTOOLS_SETUP_EXPECTED_ !== false )
  {
    _._setupConfig();
    _._setupUnhandledErrorHandler();
    _._setupLoggerPlaceholder();
    _._setupTesterPlaceholder();
    _._setupLater();
  }

  _.assert( !!Self.timeNow );

}

// --
// routines
// --

var Routines =
{

  _setupConfig : _setupConfig,
  _setupUnhandledErrorHandler : _setupUnhandledErrorHandler,

  _setupLoggerPlaceholder : _setupLoggerPlaceholder,
  _setupTesterPlaceholder : _setupTesterPlaceholder,

  _setupLater : _setupLater,

  _setup : _setup,

}

Object.assign( Self,Routines );

Self._setup();

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
