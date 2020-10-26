( function _WareCode_s_() {

'use strict';

let _ = _global_.wTools;

// debugger;
// let wasPrepareStackTrace = Error.prepareStackTrace;
// Error.prepareStackTrace = function( err, stack )
// {
//   debugger;
// }

// --
// begin
// --

function _Begin()
{

  'use strict';

  let _global = undefined;
  if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
  if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
  if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
  if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
  let _realGlobal = _global._realGlobal_ = _global;
  let _wasGlobal = _global._global_ || _global;
  _global = _wasGlobal;
  _global._global_ = _wasGlobal;

  if( !_global_.Config )
  _global_.Config = Object.create( null );
  if( _global_.Config.interpreter === undefined )
  _global_.Config.interpreter = ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) ? 'njs' : 'browser';
  if( _global_.Config.isWorker === undefined )
  _global_.Config.isWorker = !!( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' );

  // if( _global._starter_ && _global._starter_._inited )
  // return;

  let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
  let _ = _starter_;

  let path = _starter_.path = _starter_.path || Object.create( null );
  let uri = _starter_.uri = _starter_.uri || Object.create( null );
  _starter_.uri.path = _starter_.path;
  let introspector = _starter_.introspector = _starter_.introspector || Object.create( null );
  let error = _starter_.error = _starter_.error || Object.create( null );
  let setup = _starter_.setup = _starter_.setup || Object.create( null );
  let sourcesMap = _starter_.sourcesMap = _starter_.sourcesMap || Object.create( null );

  // let stackSymbol = Symbol.for( 'stack' );
  // let _diagnosticCodeExecuting = 0;
  // let _errorCounter = 0;
  // let _errorMaking = false;
  //
  // let _ArrayIndexOf = Array.prototype.indexOf;
  // let _ArrayIncludes = Array.prototype.includes;
  // if( !_ArrayIncludes )
  // _ArrayIncludes = function( e ){ _ArrayIndexOf.call( this, e ) }

  //

  function assert( good )
  {
    if( !good )
    {
      debugger;
      throw 'Something wrong!';
      return false;
    }
    return true;
  }

  //

  function assertRoutineOptions()
  {
    return arguments[ 0 ];
  }

  //

  function assertMapHasOnly()
  {
  }

  //

  function assertMapHasNoUndefine()
  {
  }

  //

  function dir( filePath )
  {
    let canonized = this.canonize( filePath );
    let splits = canonized.split( '/' );
    if( splits[ splits.length-1 ] )
    splits.pop();
    return splits.join( '/' );
  }

  //

  function nativize()
  {
    if( _global.process && _global.process.platform === 'win32' )
    this.nativize = this._nativizeWindows;
    else
    this.nativize = this._nativizePosix;
    return this.nativize.apply( this, arguments );
  }

  //

  function toStr( src )
  {
    try
    {
      return String( src );
    }
    catch( err )
    {
      debugger;
      return '{- UNKNOWN DATA TYPE -}';
    }
  }

  //

  function mapFields( src )
  {
    let result = Object.create( null );
    if( !src )
    return result;
    for( let s in src )
    result[ s ] = src[ s ];
    return result;
  }
  //
  // //
  //
  // debugger;
  // ProcedureInit = function init( o )
  // {
  //   let procedure = this; debugger;
  //
  //   // _.workpiece.initFields( procedure );
  //   // Object.preventExtensions( procedure );
  //   // procedure.copy( o );
  //   _.mapExtend( procedure, o );
  //
  //   _.assert( _.strIs( procedure._stack ) );
  //   // _.assert( procedure._sourcePath === null );
  //
  //   procedure._sourcePath = procedure._stack.split( '\n' )[ 0 ];
  //
  //   procedure._longNameMake();
  //
  //   _.arrayAppendOnceStrictly( _.Procedure.InstancesArray, procedure );
  //
  //   _.assert( _.strIs( procedure._sourcePath ) );
  //   _.assert( arguments.length === 1 );
  //   // _.assert( _.Procedure.NamesMap[ procedure._longName ] === procedure, () => `${procedure._longName} not found` );
  //
  //   return procedure;
  // };

}

// --
// end
// --

function _End()
{

  let StarterExtension =
  {

    assert,
    assertRoutineOptions,
    assertMapHasOnly,
    assertMapHasNoUndefine,
    toStr,
    mapFields,

    path,

  }

  Object.assign( _starter_, StarterExtension );

  let PathExtension =
  {

    dir,
    nativize,

  }

  Object.assign( _starter_.path, PathExtension );

  // let ProcedureExtension =
  // {
  //
  //   ProcedureInit
  //
  // }
  //
  // Object.assign( _starter_.Procedure.prototype, PathExtension );

}

// --
//
// --

let Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
