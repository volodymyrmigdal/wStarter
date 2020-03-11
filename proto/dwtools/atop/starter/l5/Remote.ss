( function _Remote_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  var Net = require( 'net' );
}

//

let Express = null;
let ExpressLogger = null;
let ExpressDir = null;
let Querystring = null;
let _ = _global_.wTools;
let Parent = null;
let Self = function wStarterRemote( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Remote';

// --
// inter
// --

function unform()
{
  let remote = this;

  _.assert( 0, 'not implemented' );

/*
qqq : implement please
*/

}

//

function form()
{
  let remote = this;
  let ready = _.Consequence().take( null );

  if( remote.logger === null )
  {
    remote.logger = new _.Logger({ output : _global_.logger });
    remote.logger.verbosity = 7;
  }

  let logger = remote.logger;

  _.process.on( 'exit', () =>
  {
    logger.begin({ verbosity : -5 });
    logger.log( `${remote.role} exit` );
    logger.end({ verbosity : -5 });
  });

  ready.then( () => remote.roleDetermine() );

  ready.then( ( arg ) =>
  {
    let ready = _.Consequence().take( arg );

    logger.begin({ verbosity : -5 });
    logger.log( `${remote.role} start` );
    logger.end({ verbosity : -5 });

    if( remote.role === 'slave' )
    {

      if( !remote.masterPath )
      {
        // debugger;
        ready.then( () => remote.slaveOpenMaster() );
      }

      ready.tap( () =>
      {
        // debugger
      });

      ready.then( () => remote.slaveConnectMaster() );

    }
    else
    {
      ready.then( () => remote.masterOpen() );
    }

    return ready;
  });

  return ready;
}

// //
//
// function _formServer()
// {
//   let remote = this;
//
//   return remote;
// }

//

function MasterPathFindOpened()
{
  return null;
}

//

function MasterPathFindFree()
{
  return 'http://0.0.0.0:13000';
}

//

function masterOpen()
{
  let remote = this;
  let logger = remote.logger;

  remote.masterPath = remote.MasterPathFindFree();
  _.assert( !!remote.masterPath );
  let masterPathParsed = _.uri.parse( remote.masterPath );
  masterPathParsed.port = _.strToNumberMaybe( masterPathParsed.port );
  _.assert( _.numberDefined( masterPathParsed.port ) );

  remote.server = Net.createServer( ( socket ) =>
  {
    debugger;
    logger.log( 'MASTER:', `${socket.remoteAddress} connected` );
    socket
    .on( 'data', ( data ) =>
    {
      logger.log( 'MASTER-RECIEVED:', data.toString() );
      debugger;
    })
    .on( 'end', () =>
    {
      logger.log( 'MASTER:', `${socket.remoteAddress} disconnected` );
      debugger;
    })
    socket.write( 'MASTER-SENDING: Hello! This is server speaking.' );
    // socket.end( 'MASTER: Closing connection now.' );
  })
  .on( 'error', ( err ) =>
  {
    logger.error( _.err( 'Server error\n', err ) );
    debugger;
  });

  remote.server.listen( masterPathParsed.port, () =>
  {
    debugger;
    logger.begin({ verbosity : -7 });
    logger.log( 'MASTER:', 'Opened server on', remote.server.address().port );
    logger.begin({ verbosity : -7 });
  });

  return remote;
}

//

function slaveOpenMaster()
{
  let remote = this;
  let logger = remote.logger;

  remote.masterPath = remote.MasterPathFindFree();

  _.assert( _.strDefined( remote.masterPath ) );
  _.assert( _.strDefined( remote.entryPath ) );
  _.assert( remote._process === null );

  let result = remote._process = _.process.startNode
  ({
    execPath : remote.entryPath,
    args : `role:master masterPath:${remote.masterPath}`,
    sync : 0,
    deasync : 0,
    detaching : 1,
    // stdio : 'inherit',
    stdio : 'pipe',
    // stdio : 'ignore',
  });

  result.then( ( process ) =>
  {
    _.assert( remote._process === result );
    remote._process = process;
    return process;
  });

  return result;
}

//

function slaveConnectMaster()
{
  let remote = this;
  let logger = remote.logger;

  _.assert( remote.role === 'slave' );

  let masterPathParsed = _.uri.parse( remote.masterPath );
  masterPathParsed.port = _.strToNumberMaybe( masterPathParsed.port );
  _.assert( _.numberDefined( masterPathParsed.port ) );

  remote.slaveConnectBegin();

  let o2 = { port : masterPathParsed.port };

  remote.connection = Net.createConnection( o2, () => remote.slaveConnectEnd() );
  remote.connection.on( 'data', ( data ) => remote.slaveRecieve({ data }) );
  remote.connection.on( 'error', ( err ) => remote.slaveErr( err ) );
  remote.connection.on( 'end', () =>
  {
    debugger;
    return remote.slaveDisconnectEnd();
  });

  _.assert( remote.channel === null );

  _.time.out( 5000, () =>
  {
    remote.slaveDisconnectMaster();
  });

  return remote;
}

//

function slaveDisconnectMaster()
{
  let remote = this;
  let logger = remote.logger;
  remote.connection.end();
  if( remote._process )
  {
    let process = remote._process;
    remote._process = null;
    process.disconnect();
  }
}

//

function slaveConnectBegin()
{
  let remote = this;
  let logger = remote.logger;
  remote.log( 'slaveConnectBegin' );
  debugger;
}

//

function slaveConnectEnd()
{
  let remote = this;
  let logger = remote.logger;
  remote.log( 'slaveConnectEnd' );
  remote.connection.write( 'SLAVE-SENDING: Hello this is client!' );
  debugger;
}

//

function slaveDisconnectEnd()
{
  let remote = this;
  let logger = remote.logger;
  logger.log( 'SLAVE: I disconnected from the server.' );
  debugger;
}

//

function slaveRecieve( o )
{
  let remote = this;
  let logger = remote.logger;
  logger.log( 'SLAVE-RECIEVED:', o.data.toString() );
  debugger;
}

slaveRecieve.defaults =
{
  data : null,
}

//

function slaveErr( err )
{
  let remote = this;
  let logger = remote.logger;
  logger.error( _.err( 'Slave error\n', err ) );
  debugger;
}

//

function masterConnectBegin()
{
  let remote = this;
  let logger = remote.logger;
  remote.log( 'masterConnectBegin' );
  debugger;
}

//

function masterConnectEnd()
{
  let remote = this;
  let logger = remote.logger;
  remote.log( 'masterConnectEnd' );
  debugger;
}

//

function roleDetermine()
{
  let remote = this;

  if( remote.role !== null )
  return end();

  if( remote.masterPath === null || remote.masterPath === undefined )
  remote.masterPath = remote.MasterPathFindOpened();

  if( remote.masterPath )
  return end( 'slave' );

  remote._roleDetermine();

  return end();

  function end( role )
  {
    if( role !== undefined )
    remote.role = role;
    _.assert( _.longHas( [ 'slave', 'master' ], remote.role ), () => `Unknown role ${remote.role}` );
    return remote.role;
  }
}

//

function _roleDetermine()
{
  let remote = this;

  _.assert( remote.role === null );

  let args = _.process.args();

  if( args.map.role !== undefined )
  {
    remote.role = args.map.role;
  }
  else
  {
    remote.role = 'slave';
  }

  return remote.role;
}

//

function log()
{
  let remote = this;
  let logger = remote.logger;
  logger.log( `${remote.role} . I connected to the server.` );
}

// //
//
// function webSocketServerRun()
// {
//
//   debugger;
//   var WebSocketServer = require( 'websocket' ).server;
//   var http = require( 'http' );
//
//   o.server = http.createServer( function( request, response )
//   {
//     logger.log( 'server request' ); debugger;
//   });
//   o.server.listen( 5001, function() { } );
//
//   o.webSocketServer = new WebSocketServer
//   ({
//     httpServer : o.server
//   });
//
//   o.webSocketServer.on( 'request', function( request )
//   {
//     logger.log( 'webSocketServer request' ); debugger;
//
//     var connection = request.accept( null, request.origin );
//
//     connection.on( 'message', function( message )
//     {
//       logger.log( 'webSocketServer message' ); debugger;
//       if( message.type === 'utf8' )
//       {
//       }
//     });
//
//     connection.on( 'close', function( connection )
//     {
//       logger.log( 'webSocketServer close' ); debugger;
//     });
//
//   });
//
// }
//
// let defaults = webSocketServerRun.defaults = Object.create( null );
//
// defaults.server = null;
// defaults.webSocketServer = null;

// --
// relationships
// --

let Composes =
{

  terminating : 0,
  terminationTimeOut : 15000,

  // verbosity : 3,
  // servingDirs : 0,
  // masterPath : 'http://127.0.0.1:5000',
  entryPath : null,
  masterPath : null,
  // masterPath : 'http://0.0.0.0:5000',
  // basePath : null,
  // allowedPath : '/',
  // templatePath : null,

  // incudingExts : _.define.own([ 's', 'js', 'ss' ]),
  // excludingExts : _.define.own([ 'raw', 'usefile' ]),

}

let Associates =
{
  logger : null,
  server : null,
  connection : null,
  object : null,
  _process : null,
  // server : null,
  // express : null,
}

let Restricts =
{
  role : null,
  // channel : null,
}

let Statics =
{
  MasterPathFindOpened,
  MasterPathFindFree,
}

let Accessor =
{
  // verbosity : { getter : _verbosityGet, readOnly : 1 }
}

// --
// prototype
// --

let Proto =
{

  unform,
  form,
  // _formServer,

  MasterPathFindOpened,
  MasterPathFindFree,

  masterOpen,
  slaveOpenMaster,
  slaveConnectMaster,
  slaveDisconnectMaster,

  slaveConnectBegin,
  slaveConnectEnd,
  slaveDisconnectEnd,
  slaveRecieve,
  slaveErr,

  roleDetermine,
  _roleDetermine,
  log,

  // requestPreHandler,
  // requestMidHandler,
  // requestPostHandler,
  // requestErrorHandler,

  // _verbosityGet,
  // openPathGet,

  /* */

  Composes,
  Associates,
  Restricts,
  Statics,
  Accessor,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_[ Self.shortName ] = Self;

})();
