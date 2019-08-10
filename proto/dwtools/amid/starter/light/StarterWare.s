( function _StarterWare_s_() {

'use strict';

let _ = wTools;

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
  _global_.Config = {}
  if( _global_.Config.platform === undefined )
  _global_.Config.platform = ( ( typeof module !== 'undefined' ) && ( typeof process !== 'undefined' ) ) ? 'nodejs' : 'browser';
  if( _global_.Config.isWorker === undefined )
  _global_.Config.isWorker = !!( typeof self !== 'undefined' && self.self === self && typeof importScripts !== 'undefined' );

  if( _global._starter_ )
  return;

  let _starter_ = _global._starter_ = _global._starter_ || Object.create( null );
  let _ = _starter_;
  let path = _starter_.path = _starter_.path || Object.create( null );

  //

  function assert()
  {
  }

  //

  function assertRoutineOptions()
  {
  }

}

// --
// end
// --

function _End()
{

  let Extend =
  {

    assert,
    assertRoutineOptions,

    path,

  }

  Object.assign( _starter_, Extend );

}

// --
//
// --

let Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
