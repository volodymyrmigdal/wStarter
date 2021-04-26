( function _BroConsoleCode_s_()
{

'use strict';

const _ = _global_.wTools;

// --
// begin
// --

function _Begin()
{

  'use strict';

  const _global = _global_;
  let _starter_ = _global_._starter_;
  let _ = _starter_;
  let path = _starter_.path;
  let sourcesMap = _starter_.sourcesMap;

  if( _global._starter_ && _global._starter_._inited )
  return;

  //

  function _broSocketWrite( o )
  {
    let socket = _._sockets[ o.filePath ];

    if( socket )
    {
      socket.que.push( o.data );
      if( socket.readyState === WebSocket.OPEN )
      send();
    }
    else
    {
      // console._original.log.call( console, `new socket ${o.filePath}` );
      socket = _._sockets[ o.filePath ] = new WebSocket( o.filePath );
      socket.que = [];
      socket.que.push( o.data );
      socket.onopen = function( e )
      {
        send();
        setTimeout( () => handleTime(), 1000 );
      };
    }

    function handleTime()
    {
      if( socket.que.length )
      {
        send();
        setTimeout( () => handleTime(), 1000 );
        return;
      }
      socket.close();
      delete _._sockets[ o.filePath ];
      Object.freeze( socket.que );
    }

    function send()
    {
      while( socket.que.length )
      {
        let data = socket.que[ 0 ];
        socket.que.splice( 0, 1 );
        socket.send( JSON.stringify( data ) );
      }
    }

  }
  _broSocketWrite.defaults =
  {
    filePath : null,
    data : null,
  }

  //

  function _broLog( o )
  {
    let starter = this;

    _._socketCounter += 1;
    o.id = _._socketCounter;
    if( !_._socketSubject )
    _._socketSubject = Date.now();
    o.subject = _._socketSubject;
    o.clientTime = Date.now();

    let response = starter._broSocketWrite
    ({
      // filePath : 'ws://127.0.0.1:15000/.log/',
      filePath : _global_._starter_.loggingPath,
      data : o,
    });

    return;
  }

  _broLog.defaults =
  {
    methodName : null,
    args : null,
  }

  //

  function _broConsoleRedirect( o )
  {
    let starter = this;
    let MethodsNames =
    [
      'log', 'debug', 'error', 'warn', 'info',
      // 'assert', 'clear', 'count', 'dir', 'dirxml',
      // 'group', 'groupCollapsed', 'groupEnd',
      // 'table', 'time', 'timeEnd', 'timeStamp', 'trace'
    ];

    _.routine.options_( _broConsoleRedirect, o );

    if( o.console === null )
    o.console = console;

    let original = o.console._original = o.console._original || Object.create( null );

    if( o.enable )
    {
      _.assert( _.entity.lengthOf( original ) === 0 );

      for( let n = 0 ; n < MethodsNames.length ; n++ )
      {
        let name = MethodsNames[ n ];
        _.assert( _.routineIs( o.console[ name ] ) );
        original[ name ] = o.console[ name ];
        o.console[ name ] = starter._broConsoleMethodRedirect( o.console, name );
      }

    }
    else
    {
      _.assert( _.entity.lengthOf( original ) !== 0 );

      for( let n = 0 ; n < MethodsNames.length ; n++ )
      {
        let name = MethodsNames[ n ];
        _.assert( _.routineIs( o.console[ name ] ) );
        _.assert( _.routineIs( original[ name ] ) );
        o.console[ name ] = original[ name ];
        delete original[ name ];
      }

    }

  }

  _broConsoleRedirect.defaults =
  {
    console : null,
    enable : 1,
  }

  //

  function _broConsoleMethodRedirect( console, methodName )
  {
    let starter = this;
    let original = console[ methodName ];
    _.assert( _.routineIs( original ) );

    let wrap =
    {
      [ methodName ] : function()
      {
        let args = [];
        for( let i = 0 ; i < arguments.length ; i++ )
        args[ i ] = _.entity.exportString( arguments[ i ], { stringWrapper : '' } );
        args = starter.Logger.TransformCssStylingToDirectives( args );
        starter._broLog({ methodName, args });
        return original.apply( console, arguments );
      }
    }

    return wrap[ methodName ];
  }

}

// --
// end
// --

function _End()
{

  let Extension =
  {
    _broSocketWrite,

    _broLog,

    _broConsoleRedirect,
    _broConsoleMethodRedirect,

    // fields

    _socketCounter : 0,
    _socketSubject : null,
    _sockets : Object.create( null ),
  }

  Object.assign( _starter_, Extension );

}

// --
// export
// --

const Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
