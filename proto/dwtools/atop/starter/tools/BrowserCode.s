( function _Require_s_() {

'use strict';

let _ = wTools;

// --
// begin
// --

function _Begin()
{

  'use strict';

  let _starter_ = _global_._starter_ = _global_._starter_ || Object.create( null );
  let _ = _starter_;
  let path = _starter_.path = _starter_.path || Object.create( null );

  let FilesCache = Object.create( null );
  function fileReadAct( o )
  {
    let self = this;
    let Reqeust, request, total, result;

    _.assertRoutineOptions( fileReadAct, arguments );
    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.strIs( o.filePath ), 'fileReadAct :', 'Expects {-o.filePath-}' );

    if( FilesCache[ o.filePath ] )
    return FilesCache[ o.filePath ];

    /* advanced */

    o.advanced = _.routineOptions( fileReadAct, o.advanced, fileReadAct.advanced );
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
    request.responseType = 'text';

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
    return result;
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

      o.ended = 1;

      // con.error( err );
    }

    /* error event */

    function handleErrorEvent( e )
    {
      let err = _.err( 'Network error', e );
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
        if( !data ) return;
        if( !total ) total = this.getResponseHeader( 'Content-Length' );
        total = Number( total ) || 1;
        if( isNaN( total ) ) return;
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

  var defaults = fileReadAct.defaults = Object.create( null );
  defaults.sync = 1;
  defaults.filePath = null;

  var advanced = fileReadAct.advanced = Object.create( null );
  advanced.send = null;
  advanced.method = 'GET';
  advanced.user = null;
  advanced.password = null;

  //

  function fileRead( o )
  {
    if( _.strIs( o ) )
    o = { filePath : o };
    _.routineOptions( fileRead, o );
    return _.fileReadAct( o );
  }

  fileRead.defaults = Object.create( fileReadAct.defaults );

  //

  function _browserInclude( parentSource, basePath, filePath )
  {
    let resolvedFilePath = this._pathResolve( parentSource, basePath, filePath );
    let read = this.fileRead
    ({
      filePath : resolvedFilePath + '?running:0',
      sync : 1,
    });

    read += '\n//@ sourceURL=' + _realGlobal_.location.origin + '/' + resolvedFilePath + '\n'

    let script = document.createElement( 'script' );
    script.type = 'text/javascript';
    var scriptCode = document.createTextNode( read );
    script.appendChild( scriptCode );
    document.head.appendChild( script );

    let childSource = this._sourceForPathGet( resolvedFilePath );
    return this._sourceIncludeAct( parentSource, childSource );
  }

  //

  function _browserResolve( parentSource, basePath, filePath )
  {
    let resolvedFilePath = this._pathResolve( parentSource, basePath, filePath );
    debugger;
    try
    {
      let read = this.fileRead
      ({
        filePath : resolvedFilePath,
        sync : 1,
      });
      return resolvedFilePath;
    }
    catch( err )
    {
      debugger;
      return null;
    }
  }

  _browserInclude.resolve = _browserResolve;

}

// --
// end
// --

function _End()
{

  let Extend =
  {
    fileReadAct,
    fileRead,
    _browserInclude,
    _browserResolve,
  }

  Object.assign( _starter_, Extend );

  // _global_.require = _nativeInclude;

}

// --
// export
// --

let Self =
{
  begin : _Begin,
  end : _End,
}

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
