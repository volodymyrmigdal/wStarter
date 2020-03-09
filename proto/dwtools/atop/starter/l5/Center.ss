( function _Center_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  var _ = require( '../include/Mid.s' );
  var Net = require( 'net' );
  module.exports = _;
}

//

var _ = _global_.wTools;
let Express = null;
let ExpressLogger = null;
let ExpressDir = null;
let Querystring = null;
let Parent = null;
let Self = function wStarterCenter( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Center';

// --
// routine
// --

// function MasterPathFindOpened()
// {
//   return undefined;
// }
//
// //
//
// function MasterPathFindFree()
// {
//   return 'http://0.0.0.0:13000';
// }
//
// //
//
// function openServer()
// {
//   let center = this;
//
//   center.masterPath = center.MasterPathFindFree();
//
//   _.assert( _.strDefined( center.masterPath ) );
//
//   let result = _.process.startNode
//   ({
//     execPath : __filename,
//     args : `_role:master masterPath:${center.masterPath}`,
//   });
//
//   let masterPathParsed = _.uri.parse( center.masterPath );
//   _.assert( _.numberDefined( masterPathParsed.port ) );
//
//   center.connection = Net.createConnection({ port : masterPathParsed.port }, () =>
//   {
//     console.log( 'CLIENT: I connected to the server.' );
//     center.connection.write( 'CLIENT: Hello this is client!' );
//   });
//
//   center.connection.on( 'data', ( data ) =>
//   {
//     console.log(data.toString());
//     center.connection.end();
//   });
//
//   center.connection.on( 'end', () => {
//     console.log( 'CLIENT: I disconnected from the server.' );
//   });
//
//   _.assert( center._channel === null );
//   _.assert( center._role === null );
//   center._role = 'slave';
//
// }

//

function unform()
{
  let center = this;

  _.assert( 0, 'not implemented' );

/*
qqq : implement please
*/

}

//

function form()
{
  let center = this;

  // let masterPath = center.MasterPathFindOpened();
  //
  // if( masterPath === undefined )
  // {
  //   center.openServer();
  // }

  center.remote = _.Remote
  ({
    object : center,
    entryPath : __filename,
  });

  return center.remote.form();
}

//

function Exec()
{
  let center = new this.Self();
  return center.exec();
}

//

function exec()
{
  let center = this;
  return center.form();
}

// //
//
// function _formServer()
// {
//   let center = this;
//   let starter = center.starter;
//
//   if( starter.servletsMap[ center.servePath ] && starter.servletsMap[ center.servePath ] !== center )
//   throw _.err( 'Center at ' + center.servePath + ' is already launched' );
//
//   starter.servletsMap[ center.servePath ] = center;
//
//   let parsedMasterPath = _.center.masterPathParse({ full : center.masterPath });
//   center.masterPath = parsedMasterPath.full;
//   _.sure( _.numberIsFinite( parsedMasterPath.port ), () => 'Expects number {-port-}, but got ' + _.toStrShort( parsedMasterPath.port ) );
//
//   /* - */
//
//   if( !center.express )
//   {
//     if( !Express )
//     Express = require( 'express' );
//     center.express = Express();
//   }
//
//   let express = center.express;
//
//   express.use( ( request, response, next ) => center.requestPreHandler({ request, response, next }) );
//
//   if( Config.debug && starter.verbosity )
//   {
//     if( !ExpressLogger )
//     ExpressLogger = require( 'morgan' );
//     express.use( ExpressLogger( 'dev' ) );
//   }
//
//   express.use( ( request, response, next ) => center.requestMidHandler({ request, response, next }) );
//
//   express.use( parsedMasterPath.localWebPath, Express.static( _.path.nativize( center.basePath ) ) );
//
//   if( center.servingDirs )
//   {
//     if( !ExpressDir )
//     ExpressDir = require( 'serve-index' );
//     let directoryOptions =
//     {
//       'icons' : true,
//       'hidden' : true,
//     }
//     express.use( parsedMasterPath.localWebPath, ExpressDir( _.path.nativize( center.basePath ), directoryOptions ) );
//   }
//
//   express.use( ( request, response, next ) => center.requestPostHandler({ request, response, next }) );
//   express.use( ( error, request, response, next ) => center.requestErrorHandler({ error, request, response, next }) );
//
//   let o3 = _.center.controlExpressStart
//   ({
//     name : center.qualifiedName,
//     verbosity : starter.verbosity - 1,
//     server : center.server,
//     express : center.express,
//     masterPath : center.masterPath,
//   });
//
//   center.server = o3.server;
//   center.express = o3.express;
//   center.masterPath = o3.masterPath;
//
//   /* - */
//
//   return center;
// }
//
// //
//
// function requestPreHandler( o )
// {
//   let center = this;
//
//   _.center.controlRequestPreHandle
//   ({
//     allowCrossDomain : center.allowCrossDomain,
//     verbosity : center.verbosity,
//     request : o.request,
//     response : o.response,
//     next : o.next,
//   });
//
//   o.next();
// }
//
// //
//
// function requestMidHandler( o )
// {
//   let center = this;
//
//   // debugger;
//   // let filePath = _.uri.reroot( center.basePath, o.request.originalUrl );
//   // _.assert( _.uri.isLocal( filePath ) );
//
//   o.next();
// }
//
// //
//
// function requestPostHandler( o )
// {
//   let center = this;
//
//   debugger;
//   _.center.controlRequestPostHandle
//   ({
//     verbosity : center.verbosity,
//     request : o.request,
//     response : o.response,
//     next : o.next,
//   });
//
//   o.next();
// }
//
// //
//
// function requestErrorHandler( o )
// {
//   debugger;
//   if( o.response.headersSent )
//   return o.next( o.error );
//   o.error = _.err( o.error );
//
//   _.errLogOnce( o.error )
//
//   o.response.status( 500 );
//   o.response.send( o.error.message );
//   // o.response.write( o.error.message );
//   // o.response.end();
//   // o.response.render( 'error', { error : o.error } );
// }

// //
//
// function _verbosityGet()
// {
//   let center = this;
//   if( !center.starter )
//   return 9;
//   return center.starter.verbosity;
// }

// //
//
// function openPathGet()
// {
//   let center = this;
//
//   let parsedMasterPath = _.uri.parseAtomic({ full : center.masterPath });
//
//   if( parsedMasterPath.host === '0.0.0.0' )
//   parsedMasterPath.host = '127.0.0.1';
//
//   return _.uri.str( parsedMasterPath );
// }

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
//     console.log( 'server request' ); debugger;
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
//     console.log( 'webSocketServer request' ); debugger;
//
//     var connection = request.accept( null, request.origin );
//
//     connection.on( 'message', function( message )
//     {
//       console.log( 'webSocketServer message' ); debugger;
//       if( message.type === 'utf8' )
//       {
//       }
//     });
//
//     connection.on( 'close', function( connection )
//     {
//       console.log( 'webSocketServer close' ); debugger;
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

  // verbosity : 3,

  // servingDirs : 0,
  // masterPath : 'http://127.0.0.1:5000',
  // masterPath : 'http://0.0.0.0:5000',
  // basePath : null,
  // allowedPath : '/',
  // templatePath : null,

  // incudingExts : _.define.own([ 's', 'js', 'ss' ]),
  // excludingExts : _.define.own([ 'raw', 'usefile' ]),

}

let Associates =
{
  // starter : null,
  // server : null,
  // express : null,
  remote : null,
}

let Restricts =
{
  // _role : null,
  // _channel : null,
}

let Statics =
{
  Exec,
  // MasterPathFindOpened,
  // MasterPathFindFree,
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

  // MasterPathFindOpened,
  // MasterPathFindFree,
  // openServer,

  unform,
  form,

  Exec,
  exec,

  // _formServer,
  //
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

_.starter[ Self.shortName ] = Self;

if( !module.parent )
Self.Exec();

})();
