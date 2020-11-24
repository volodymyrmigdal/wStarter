( function _BroCode_s_()
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

  //

  let FilesCache = Object.create( null );
  function _broFileReadAct( o )
  {
    let self = this;
    let Reqeust, request, total, result, error;

    _.assertRoutineOptions( _broFileReadAct, arguments );
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( o.filePath ), '_broFileReadAct :', 'Expects {-o.filePath-}' );

    if( FilesCache[ o.filePath ] )
    return FilesCache[ o.filePath ];

    /* advanced */

    o.advanced = _.routineOptions( _broFileReadAct, o.advanced, _broFileReadAct.advanced );
    o.advanced.method = o.advanced.method.toUpperCase();

    /* http request */

    if( typeof XMLHttpRequest !== 'undefined' )
    Reqeust = XMLHttpRequest;
    else if( typeof ActiveXObject !== 'undefined' )
    Reqeust = new ActiveXObject( 'Microsoft.XMLHTTP' );
    else
    {
      throw _.err( 'not implemented' );
    }

    /* set */

    request = o.request = new Reqeust();

    if( !o.sync )
    {
      if( o.encoding === 'buffer.bytes' )
      request.responseType = 'arraybuffer';
      else if( o.encoding === 'json' )
      request.responseType = 'json';
    }

    request.addEventListener( 'progress', handleProgress );
    request.addEventListener( 'load', handleEnd );
    request.addEventListener( 'error', handleErrorEvent );
    request.addEventListener( 'timeout', handleErrorEvent );
    request.addEventListener( 'readystatechange', handleState );
    request.open( o.advanced.method, o.filePath, !o.sync, o.advanced.user, o.advanced.password );
    /*request.setRequestHeader( 'Content-type', 'application/octet-stream' );*/

    handleBegin();

    try
    {
      if( o.advanced && o.advanced.send !== null )
      request.send( o.advanced.send );
      else
      request.send();
    }
    catch( err )
    {
      handleError( err );
    }

    _.assert( o.sync );
    if( o.sync )
    {
      if( error )
      {
        // debugger;
        throw _.err( error );
      }
      return result;
    }
    // else
    // return con;

    /* - */

    /* handler */

    function getData( response )
    {
      if( request.responseType === 'text' )
      return response.responseText || response.response;
      if( request.responseType === 'document' )
      return response.responseXML || response.response;
      return response.response;
    }

    /* begin */

    function handleBegin()
    {

      // debugger;
      // console.log( 'request.responseType', request.responseType );
      // if( !o.sync )
      // request.responseType = encoder.responseType;

    }

    /* end */

    function handleEnd( e )
    {

      if( o.ended )
      return;

      try
      {

        result = getData( request );
        o.ended = 1;

        if( !_.strBegins( o.filePath, '.resolve/' ) )
        FilesCache[ o.filePath ] = result;

        // con.take( result );
      }
      catch( err )
      {
        handleError( err );
      }

    }

    /* progress */

    function handleProgress( e )
    {
    }

    /* error */

    function handleError( err )
    {
      error = err;
      // error = _.err( err );
      o.ended = 1;
      // con.error( err );
    }

    /* error event */

    function handleErrorEvent( e )
    {
      let err = _.err( err, '\nNetwork error' );
      return handleError( err );
    }

    /* state */

    function handleState( e )
    {

      if( o.ended )
      return;

      if( this.readyState === 2 )
      {

      }
      else if( this.readyState === 3 )
      {

        let data = getData( this );
        if( !data )
        return;
        if( !total ) total = this.getResponseHeader( 'Content-Length' );
        total = Number( total ) || 1;
        if( isNaN( total ) )
        return;
        handleProgress( data.length / total, o );

      }
      else if( this.readyState === 4 )
      {

        if( o.ended )
        return;

        if( this.status === 200 )
        {
          handleEnd( e );
        }
        else if( this.status === 0 )
        {
        }
        else
        {
          handleError( '#' + this.status );
        }

      }

    }

  }

  var defaults = _broFileReadAct.defaults = Object.create( null );
  defaults.sync = 1;
  defaults.filePath = null;
  defaults.encoding = 'utf8';

  var advanced = _broFileReadAct.advanced = Object.create( null );
  advanced.send = null;
  advanced.method = 'GET';
  advanced.user = null;
  advanced.password = null;

  //

  function _broFileRead( o )
  {
    if( _.strIs( o ) )
    o = { filePath : o };
    _.routineOptions( _broFileRead, o );
    return _._broFileReadAct( o );
  }

  _broFileRead.defaults = Object.create( _broFileReadAct.defaults );

  //

  function _broSourceFile( sourceFile, op )
  {
  }

  //

  function _broPathResolveRemote( filePath )
  {
    let starter = this;

    if( _.path.isGlob( filePath ) || _.path.isRelative( filePath ) )
    {
      filePath = starter._broFileRead
      ({
        filePath : '/.resolve/' + filePath,
        encoding : 'json',
      });
      try
      {
        filePath = JSON.parse( filePath );
      }
      catch( err )
      {
        debugger;
        console.error( filePath );
        throw _.err( err );
      }
      return filePath;
    }

    return filePath;
  }

  //

  function _sourceResolveAct( parentSource, basePath, filePath )
  {

    let resolvedFilePath = this._pathResolveLocal( parentSource, basePath, filePath );
    let isAbsolute = resolvedFilePath[ 0 ] === '/';

    try
    {
      if( !isAbsolute )
      throw _.err( 'not tested' );
      if( !isAbsolute )
      resolvedFilePath = starter._broPathResolveRemote( joinedFilePath );
      return resolvedFilePath;
    }
    catch( err )
    {
      return null;
    }
  }

  //

  function _includeAct( parentSource, basePath, filePath )
  {
    let starter = this;
    let joinedFilePath = this._pathResolveLocal( parentSource, basePath, filePath );
    let resolvedFilePath = starter._broPathResolveRemote( joinedFilePath );

    if( _.arrayIs( resolvedFilePath ) )
    {
      if( resolvedFilePath !== joinedFilePath && !resolvedFilePath.length )
      {
        throw _.err( `No source file found for "${joinedFilePath}"` );
      }
      let result = [];
      for( let f = 0 ; f < resolvedFilePath.length ; f++ )
      {
        if( starter.exclude )
        {
          if( starter.exclude.test( resolvedFilePath[ f ] ) )
          continue;
        }
        let r = starter._sourceInclude( parentSource, basePath, resolvedFilePath[ f ] );
        if( r !== undefined )
        _.arrayAppendArrays( result, r );
        else
        result.push( r );
      }
      return result;
    }

    starter._includingSource = resolvedFilePath;

    try
    {
      // if( _.strHas( resolvedFilePath, 'Tools.s' ) )
      // debugger;
      if( typeof window === 'undefined' )
      {
        return this._broIncludeActInWorkerResolved( parentSource, resolvedFilePath );
      }
      else
      {
        return this._broIncludeResolved( parentSource, resolvedFilePath );
      }
      end();
    }
    catch( err )
    {
      end();
      debugger;
      throw _.err( err );
    }

    function end()
    {
      starter._includingSource = null;
    }

  }

  //

  function _broIncludeActInWorkerResolved( parentSource, resolvedFilePath )
  {
    let starter = this;
    let result;

    _.assert( typeof importScripts !== 'undefined' );

    importScripts( resolvedFilePath );

    let childSource = starter._sourceForPathGet( resolvedFilePath );
    result = starter._sourceIncludeResolvedCalling( parentSource, childSource, resolvedFilePath );

    return result;
  }

  //

  function _broIncludeResolved( parentSource, resolvedFilePath )
  {
    let starter = this;

    let read = starter._broFileRead
    ({
      filePath : resolvedFilePath,
      sync : 1,
    });

    let ext = _.path.ext( resolvedFilePath );
    if( ext === 'css' || ext === 'less' )
    {
      let link = document.createElement( 'link' );
      link.href = resolvedFilePath;
      link.rel = 'stylesheet'
      link.type = 'text/' + ext
      document.head.appendChild( link );
    }
    else
    {
      // read = '//@ sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n' + read;
      read = read + '\n//@ sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n'
      read = read + '\n//# sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n'

      let script = document.createElement( 'script' );
      script.type = 'text/javascript';
      let scriptCode = document.createTextNode( read );
      script.appendChild( scriptCode );

      if( resolvedFilePath === '/wtools/atop/testing/l7/TesterTop.s' )
      debugger;

      document.head.appendChild( script );

      if( resolvedFilePath === '/wtools/atop/testing/l7/TesterTop.s' )
      debugger;

      let childSource = starter._sourceForPathGet( resolvedFilePath );
      let result = starter._sourceIncludeResolvedCalling( parentSource, childSource, resolvedFilePath );

      if( resolvedFilePath === '/wtools/atop/testing/l7/TesterTop.s' )
      debugger;

      return result;
    }

  }

  //

  function _sourceCodeModule()
  {
    let result = Object.create( null );

    accesor( '_cache', cacheGet, cacheSet );

    this.exports = result;

    function cacheGet()
    {
      return _starter_.sourcesMap;
    }

    function cacheSet( src )
    {
      return _starter_.sourcesMap = src;
    }

    function accesor( fieldName, onGet, onSet )
    {
      let property =
      {
        enumerable : true,
        configurable : true,
        get : onGet,
        set : onSet,
      }
      Object.defineProperty( result, fieldName, property );
    }

  }

  //

  function _SetupAct()
  {
    let starter = this;
    starter._sourceMake( 'module', '/', _sourceCodeModule );

    if( starter.redirectingConsole === null || starter.redirectingConsole )
    starter._broConsoleRedirect({ console });

  }

}

// --
// end
// --

function _End()
{

  let Extension =
  {

    //

    _broFileReadAct,
    _broFileRead,

    _broSourceFile,
    _broPathResolveRemote,
    _sourceResolveAct,

    _includeAct,
    _broIncludeActInWorkerResolved,
    _broIncludeResolved,


    _SetupAct,
    _sourceCodeModule,

  }

  Object.assign( _starter_, Extension );

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
