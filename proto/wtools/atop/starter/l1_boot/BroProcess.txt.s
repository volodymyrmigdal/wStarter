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

  let _process = _global.process = Object.create( null );

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

  function on( o )
  {
    o = _.event.on.head( _.event.on, arguments );
    return _.event.on( _process._ehandler, o );
  }

  on.defaults =
  {
    callbackMap : null,
  };

  /* */

  function once( o )
  {
    o = _.event.once.head( _.event.once, arguments );
    return _.event.once( _process._ehandler, o );
  }

  once.defaults =
  {
    callbackMap : null,
  };

  /* */

  function off( o )
  {
    o = _.event.off.head( _.event.off, arguments );
    return _.event.off( _process._ehandler, o );
  }

  off.defaults =
  {
    callbackMap : null,
  };

  /* */

  function eventHasHandler( o )
  {
    o = _.event.eventHasHandler.head( _.event.eventHasHandler, arguments );
    return _.event.eventHasHandler( _process._ehandler, o );
  }

  eventHasHandler.defaults =
  {
    eventName : null,
    eventHandler : null,
  }

  function eventGive()
  {
    return _.event.eventGive( _process._ehandler, ... arguments );
  }

  eventGive.defaults =
  {
    ... _.event.eventGive.defaults,
  }

  /* */

  _realGlobal_.onerror = function onerror()
  {
    _process.eventGive({ event : 'uncaughtException', args : arguments });
  }

  _realGlobal_.onunhandledrejection = function onunhandledrejection()
  {
    _process.eventGive({ event : 'unhandledRejection', args : arguments });
  }

}

// --
// end
// --

function _End()
{

  let Events =
  {
    'uncaughtError' : [],
    'uncaughtException' : [],
    'unhandledRejection' : []
  }

  let _ehandler =
  {
    events : Events,
  }

  let Extension =
  {
    _ehandler,

    exit,

    on,
    once,
    off,
    eventHasHandler,
    eventGive,

    nextTick,

    // fields

    env : Object.create( null ),
    execArgv : [],

    _exitCode : 0

  }

  Object.assign( _global.process, Extension );

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
