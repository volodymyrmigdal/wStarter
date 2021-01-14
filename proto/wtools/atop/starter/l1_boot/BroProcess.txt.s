( function _BroProcessCode_s_()
{

'use strict';

let _ = _global_.wTools;

// --
// begin
// --

function _Begin()
{

  'use strict';

  let _global = _global_;
  let _starter_ = _global_._starter_;
  let _ = _starter_;
  let path = _starter_.path;
  let sourcesMap = _starter_.sourcesMap;

  if( _global._starter_ && _global._starter_._inited )
  return;

  let _process = _global.process = _global._starter_.process = Object.create( null );

  //

  function exit( exitCode )
  {
    _process.exitCode = exitCode;

    let body = { routine : 'exit', arguments : [ _process._exitCode ] };
    let op =
    {
      method: 'post',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify( body )
    }
    fetch( '/.process', op );
  }

  /* */

  function on( signal, handler )
  {

  }

  /* */

  function once( signal, handler )
  {
  }

  /* */

  function off( signal, handler )
  {
  }

  /* */

  function nextTick( h )
  {
    return setTimeout( h, 0 )
  }

  /* */

  function exitCodeSet( code )
  {
    _.assert( _.numberIs( code ) );
    _process._exitCode = code;

    let op =
    {
      method: 'post',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ routine : 'exitCode', arguments : [ _process._exitCode ] })
    }
    fetch( '/.process', op );
  }

  function exitCodeGet()
  {
    return _process._exitCode;
  }

  Object.defineProperty( _process, 'exitCode',
  {
    set : exitCodeSet,
    get : exitCodeGet,
  });

  /* */

}

// --
// end
// --

function _End()
{

  let Extension =
  {
    exit,

    on,
    once,
    off,

    nextTick,

    // fields

    env : Object.create( null ),
    execArgv : [],

    _exitCode : 0

  }

  Object.assign( _starter_.process, Extension );

}

// --
// export
// --

let Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
