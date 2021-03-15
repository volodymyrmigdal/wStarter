( function _WareCode_s_()
{

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

  let _global = _global_;
  let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
  let _ = _starter_;

  let entity = _starter_.entity = _starter_.entity || Object.create( null );
  let path = _starter_.path = _starter_.path || Object.create( null );
  let uri = _starter_.uri = _starter_.uri || Object.create( null );
  let property = _starter_.property = _starter_.property || Object.create( null );
  _starter_.uri.path = _starter_.path;
  let introspector = _starter_.introspector = _starter_.introspector || Object.create( null );
  let error = _starter_.error = _starter_.error || Object.create( null );
  let setup = _starter_.setup = _starter_.setup || Object.create( null );
  let event = _starter_.event = _starter_.event || Object.create( null );
  let sourcesMap = _starter_.sourcesMap = _starter_.sourcesMap || Object.create( null );
  let color = _starter_.color = _starter_.color || Object.create( null );
  let Logger = _starter_.Logger = _starter_.Logger || Object.create( null );
  let vector = _starter_.vector = _starter_.vector || Object.create( null );
  let primitive = _starter_.primitive = _starter_.primitive || Object.create( null );
  let number = _starter_.number = _starter_.number || Object.create( null );
  let aux = _starter_.aux = _starter_.aux || Object.create( null );
  let constructible = _starter_.constructible = _starter_.constructible || Object.create( null );
  let argumentsArray = _starter_.argumentsArray = _starter_.argumentsArray || Object.create( null );
  let object = _starter_.object = _starter_.object || Object.create( null );
  let set = _starter_.set = _starter_.set || Object.create( null );
  let hashMap = _starter_.hashMap = _starter_.hashMap || Object.create( null );
  let symbol = _starter_.symbol = _starter_.symbol || Object.create( null );
  let routine = _starter_.routine = _starter_.routine || Object.create( null );
  let map = _starter_.map = _starter_.map || Object.create( null );
  let bool = _starter_.bool = _starter_.bool || Object.create( null );

  //

  function assert( good )
  {
    if( !good )
    {
      debugger;
      throw new Error( 'Something wrong!' );
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
