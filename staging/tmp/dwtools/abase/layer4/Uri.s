( function _Uri_s_() {

'use strict';

/**
  @module Tools/base/Uri - Collection of routines to operate URIs ( URLs ) in the reliable and consistent way. Path leverages parsing, joining, extracting, normalizing, nativizing, resolving paths. Use the module to get uniform experience from playing with paths on different platforms.

*/

/**
 * @file Uri.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  let _ = _global_.wTools;

  _.include( 'wPathFundamentals' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.path;
let Self = _.uri = _.uri || Object.create( Parent );

// --
// internal
// --

function _filterOnlyUrl( e,k,c )
{
  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Url' ) )
    return true;
    else
    return false
  }
  return this.is( e );
}

//

function _filterNoInnerArray( arr )
{
  return arr.every( ( e ) => !_.arrayIs( e ) );
}

// --
// uri checker
// --

  // '^(https?:\\/\\/)?'                                     // protocol
  // + '(\\/)?'                                              // relative
  // + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
  // + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
  // + '(\\:\\d+)?'                                          // port
  // + '(\\/[-a-z\\d%_.~+]*)*'                               // path
  // + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
  // + '(\\#[-a-z\\d_]*)?$';                                 // anchor

let isRegExpString =
  '^([\w\d]*:\\/\\/)?'                                    // protocol
  + '(\\/)?'                                              // relative
  + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
  + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
  + '(\\:\\d+)?'                                          // port
  + '(\\/[-a-z\\d%_.~+]*)*'                               // path
  + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
  + '(\\#[-a-z\\d_]*)?$';                                 // anchor

let isRegExp = new RegExp( isRegExpString, 'i' );
function is( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  return _.strIs( path );
}

//

function isGlobal( path )
{
  _.assert( _.strIs( path ) );
  return _.strHas( path, '://' );
}

//

function isSafe( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.isSafe( path );
}

//

function isNormalized( path )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) );
  return this.normalize( path ) === path;
}

//

function isAbsolute( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.isAbsolute( path );
}

// --
// uri
// --

/**
 *
 * The URL component object.
 * @typedef {Object} UrlComponents
 * @property {string} protocol the URL's protocol scheme.;
 * @property {string} host host portion of the URL;
 * @property {string} port property is the numeric port portion of the URL
 * @property {string} localPath the entire path section of the URL.
 * @property {string} query the entire "query string" portion of the URL, not including '?' character.
 * @property {string} hash property consists of the "fragment identifier" portion of the URL.

 * @property {string} uri the whole URL
 * @property {string} hostWithPort host portion of the URL, including the port if specified.
 * @property {string} origin protocol + host + port
 * @private
 */

let UriComponents =
{

  /* atomic */

  protocol : null, /* 'svn+http' */
  host : null, /* 'www.site.com' */
  port : null, /* '13' */
  localPath : null, /* '/path/name' */
  query : null, /* 'query=here&and=here' */
  hash : null, /* 'anchor' */

  /* composite */

  // qqq !!! : implement queries
  // queries : null, /* { query : here, and : here } */
  longPath : null, /* www.site.com:13/path/name */
  protocols : null, /* [ 'svn','http' ] */
  hostWithPort : null, /* 'www.site.com:13' */
  origin : null, /* 'svn+http://www.site.com:13' */
  full : null, /* 'svn+http://www.site.com:13/path/name?query=here&and=here#anchor' */

}

//

/*
http://www.site.com:13/path/name?query=here&and=here#anchor
2 - protocol
3 - hostWithPort( host + port )
5 - localPath
6 - query
8 - hash
*/

// let _uriParseRegexpStr = '^';
// _uriParseRegexpStr += '(?:([^:/\\?#]*):)?'; /* protocol */
// _uriParseRegexpStr += '(?:\/\/(([^:/\\?#]*)(?::([^/\\?#]*))?))?'; /* host and port */
// _uriParseRegexpStr += '([^\\?#]*)'; /* local path */
// _uriParseRegexpStr += '(?:\\?([^#]*))?'; /* query */
// _uriParseRegexpStr += '(?:#(.*))?'; /* hash */
// _uriParseRegexpStr += '$';

let _uriParseRegexpStr = '^';

let _uriParseRegexpProtocolStr = '([^:/\\?#]*):'; /* protocol */
let _uriParseRegexpHostAndPortStr = '\/\/(([^:/\\?#]*)(?::([^/\\?#]*))?)'; /* host and port */

_uriParseRegexpStr = '(?:' + _uriParseRegexpProtocolStr + _uriParseRegexpHostAndPortStr + ')?';

_uriParseRegexpStr += '([^#]*\\?[^=#]*|[^\\?#]*)'; /* local path */
_uriParseRegexpStr += '(?:\\?([^#]*))?'; /* query */
_uriParseRegexpStr += '(?:#(.*))?'; /* hash */
_uriParseRegexpStr += '$';

let _uriParseRegexp = new RegExp( _uriParseRegexpStr );

// '^'
// '(?:([^:/\\?#]*):)?'
// '(?:\/\/(([^:/\\?#]*)(?::([^/\\?#]*))?))?'
// '([^\\?#]*)'
// '(?:\\?([^#]*))?'
// '(?:#(.*))?$'

// let _uriParseRegexp = new RegExp( '^(?:([^:/\\?#]*):)?(?:\/\/(([^:/\\?#]*)(?::([^/\\?#]*))?))?([^\\?#]*)(?:\\?([^#]*))?(?:#(.*))?$' );

function _uriParse( o )
{
  let result = Object.create( null );

  _.routineOptions( this._uriParse, o );
  _.assert( _.strIs( o.srcPath ) || _.mapIs( o.srcPath ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.arrayHas( _uriParse.Kind, o.kind ) );

  if( _.mapIs( o.srcPath ) )
  {
    _.assertMapHasOnly( o.srcPath, this.UriComponents );
    if( o.srcPath.protocols )
    {
      debugger;
      return o.srcPath;
    }
    else if( o.srcPath.full )
    o.srcPath = o.srcPath.full;
    else
    o.srcPath = this.str( o.srcPath );
  }

  let e = _uriParseRegexp.exec( o.srcPath );
  _.sure( !!e, 'Cant parse :',o.srcPath );

  if( _.strIs( e[ 1 ] ) )
  result.protocol = e[ 1 ];
  if( _.strIs( e[ 3 ] ) )
  result.host = e[ 3 ];
  if( _.strIs( e[ 4 ] ) )
  result.port = e[ 4 ];
  if( _.strIs( e[ 5 ] ) )
  result.localPath = e[ 5 ];
  if( _.strIs( e[ 6 ] ) )
  result.query = e[ 6 ];
  if( _.strIs( e[ 7 ] ) )
  result.hash = e[ 7 ];

  /**/

  if( o.kind === 'all' )
  {
    let hostWithPort = e[ 2 ] || '';
    result.longPath = hostWithPort + result.localPath;
    if( result.protocol )
    result.protocols = result.protocol.split( '+' );
    else
    result.protocols = [];
    if( _.strIs( e[ 2 ] ) )
    result.hostWithPort = e[ 2 ];
    if( _.strIs( result.protocol ) || _.strIs( result.hostWithPort ) )
    result.origin = ( _.strIs( result.protocol ) ? result.protocol + '://' : '//' ) + result.hostWithPort;
    result.full = o.srcPath;
    // result.full = this.str( result ); // xxx
  }
  else if( o.kind === 'consecutive' )
  {
    let hostWithPort = e[ 2 ] || '';
    result.longPath = hostWithPort + result.localPath;
    delete result.host;
    delete result.port;
    delete result.localPath;
  }

  return result;
}

_uriParse.defaults =
{
  srcPath : null,
  kind : 'all',
}

_uriParse.components = UriComponents;

_uriParse.Kind = [ 'all', 'atomic', 'consecutive' ];

//

/**
 * Method parses URL string, and returns a UrlComponents object.
 * @example
 *
   let uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor'

   wTools.uri.parse( uri );

   // {
   //   protocol : 'http',
   //   hostWithPort : 'www.site.com:13',
   //   localPath : /path/name,
   //   query : 'query=here&and=here',
   //   hash : 'anchor',
   //   host : 'www.site.com',
   //   port : '13',
   //   origin : 'http://www.site.com:13'
   // }

 * @param {string} path Url to parse
 * @param {Object} o - parse parameters
    included into result
 * @returns {UrlComponents} Result object with parsed uri components
 * @throws {Error} If passed `path` parameter is not string
 * @method parse
 * @memberof wTools.uri
 */

function parse( srcPath )
{

  let result = this._uriParse
  ({
    srcPath : srcPath,
    kind : 'all',
  });

  _.assert( arguments.length === 1, 'expects single argument' );

  return result;
}

parse.components = UriComponents;

//

function parseAtomic( srcPath )
{
  let result = this._uriParse
  ({
    srcPath : srcPath,
    kind : 'atomic',
  });

  _.assert( arguments.length === 1, 'expects single argument' );

  return result;
}

parseAtomic.components = UriComponents;

//

function parseConsecutive( srcPath )
{
  let result = this._uriParse
  ({
    srcPath : srcPath,
    kind : 'consecutive',
  });

  _.assert( arguments.length === 1, 'expects single argument' );

  return result;
}

//

/**
 * Assembles uri string from components
 *
 * @example
 *
   let components =
     {
       protocol : 'http',
       host : 'www.site.com',
       port : '13',
       localPath : '/path/name',
       query : 'query=here&and=here',
       hash : 'anchor',
     };
   wTools.uri.str( UrlComponents );
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 * @param {UrlComponents} components Components for uri
 * @returns {string} Complete uri string
 * @throws {Error} If `components` is not UrlComponents map
 * @see {@link UrlComponents}
 * @method str
 * @memberof wTools.uri
 */

function str( c )
{
  let self = this;
  let result = '';

  _.assert( c.longPath === undefined || c.longPath === null || longPathHas( c ), 'Codependent components of URI map are not consistent', 'something wrong with {-longPath-}' );
  _.assert( c.protocols === undefined || c.protocols === null || protocolsHas( c ), 'Codependent components of URI map are not consistent', 'something wrong with {-protocols-}' );
  _.assert( c.hostWithPort === undefined || c.hostWithPort === null || hostWithPortHas( c ), 'Codependent components of URI map are not consistent', 'something wrong with {-hostWithPort-}' );
  _.assert( c.origin === undefined || c.origin === null || originHas( c ), 'Codependent components of URI map are not consistent', 'something wrong with {-origin-}' );
  _.assert( c.full === undefined || c.full === null || fullHas( c ), 'Codependent components of URI map are not consistent', 'something wrong with {-full-}' );

  _.assert( _.strIs( c ) || _.mapIs( c ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.strIs( c ) )
  return c;

  _.assertMapHasOnly( c, this.UriComponents );
  // _.assert( _.strIs( c.longPath ) );

  if( c.full )
  {
    _.assert( _.strIsNotEmpty( c.full ) );
    return c.full;
  }

  var protocol = c.protocol;
  var host = c.host;
  var port = c.port;

  if( c.origin && ( protocol === null || protocol === undefined ) )
  if( _.strHas( c.origin, '://' ) )
  {
    protocol = _.strIsolateBeginOrNone( c.origin, '://' )[ 0 ];
  }

  if( c.origin && ( host === null || host === undefined ) )
  {
    host = _.strIsolateInsideOrAll( c.origin, '://', ':' )[ 2 ];
  }

  if( c.origin && ( port === null || port === undefined ) )
  if( _.strHas( c.origin, ':' ) )
  {
    port = _.strIsolateEndOrNone( c.origin, ':' )[ 2 ];
  }

  // if( c.origin && ( c.protocol === null || c.protocol === undefined ) )
  // if( _.strHas( c.origin, '://' ) )
  // {
  //   c.protocol = _.strIsolateBeginOrNone( c.origin, '://' )[ 0 ];
  // }
  //
  // if( c.origin && ( c.host === null || c.host === undefined ) )
  // {
  //   c.host = _.strIsolateInsideOrAll( c.origin, '://', ':' )[ 2 ];
  // }
  //
  // if( c.origin && ( c.port === null || c.port === undefined ) )
  // if( _.strHas( c.origin, ':' ) )
  // {
  //   c.port = _.strIsolateEndOrNone( c.origin, ':' )[ 2 ];
  // }

  // /* atomic */
  //
  // protocol : null, /* 'svn+http' */
  // host : null, /* 'www.site.com' */
  // port : null, /* '13' */
  // localPath : null, /* '/path/name' */
  // query : null, /* 'query=here&and=here' */
  // hash : null, /* 'anchor' */
  //
  // /* composite */
  //
  // longPath : null, /* www.site.com:13/path/name */
  // protocols : null, /* [ 'svn','http' ] */
  // hostWithPort : null, /* 'www.site.com:13' */
  // origin : null, /* 'svn+http://www.site.com:13' */
  // full : null, /* 'svn+http://www.site.com:13/path/name?query=here&and=here#anchor' */

  return fullFrom( c );

  /* */

  return result;

  /**/

  function longPathFrom( c )
  {

    let hostWithPort = c.hostWithPort;
    if( !_.strIs( hostWithPort ) )
    hostWithPort = hostWithPortFrom( c );

    if( _.strIs( c.localPath ) )
    {
      if( c.localPath && hostWithPort && !_.strBegins( c.localPath, self._upStr ) )
      return hostWithPort + self._upStr + c.localPath;
      else
      return hostWithPort + c.localPath;
    }
    else
    {
      debugger;
      _.assert( _.strBegins( c.longPath, hostWithPort ) );
      return c.longPath;
    }

  }

  /* */

  function longPathHas( c )
  {

    if( c.host )
    if( !_.strBegins( c.longPath, c.host ) )
    return false;

    if( c.port !== undefined && c.port !== null )
    if( !_.strHas( c.longPath, String( c.port ) ) )
    return false;

    if( c.localPath )
    if( !_.strEnds( c.longPath, c.localPath ) )
    return false;

    return true;
  }

  /* */

  function protocolsFrom( c )
  {
    return protocol.split( '+' );
  }

  /* */

  function protocolsHas( c )
  {
    if( c.protocol !== null && c.protocol !== undefined )
    if( c.protocols.join( '+' ) !== c.protocol )
    return false;
    return true;
  }

  /* */

  function hostWithPortFrom( c )
  {

    // if( host === undefined || host === null )
    // return c.hostWithPort;

    let hostWithPort = '';
    if( _.strIs( host ) )
    hostWithPort = host;
    if( port !== undefined && port !== null )
    if( hostWithPort )
    hostWithPort += ':' + port;
    else
    hostWithPort = ':' + port;
    return hostWithPort;
  }

  /* */

  function hostWithPortHas( c )
  {

    if( c.host )
    if( !_.strBegins( c.hostWithPort, c.host ) )
    return false;

    if( c.port !== null && c.port !== undefined )
    if( !_.strHas( c.hostWithPort, String( c.port ) ) )
    return false;

    return true;
  }

  /* */

  function originFrom( c )
  {
    let result = '';
    let hostWithPort;

    if( c.hostWithPort )
    {
      hostWithPort = c.hostWithPort;
    }
    else
    {
      hostWithPort = hostWithPortFrom( c );
    }

    if( _.strIs( protocol ) && !hostWithPort )
    hostWithPort = '';

    if( _.strIs( protocol ) || _.strIs( hostWithPort ) )
    result += ( _.strIs( protocol ) ? protocol + '://' : '//' ) + hostWithPort;

    return result;
  }

  /* */

  function originHas( c )
  {

    if( c.protocol )
    if( !_.strBegins( c.origin, c.protocol ) )
    return false;

    if( c.host )
    if( !_.strHas( c.origin, c.host ) )
    return false;

    if( c.port !== null && c.port !== undefined )
    if( !_.strHas( c.origin, String( c.port ) ) )
    return false;

    return true;
  }

  /* */

  function fullFrom( c )
  {

    if( _.strIs( protocol ) || _.strIs( c.hostWithPort ) || _.strIs( host ) )
    result += _.strIs( protocol ) ? protocol + '://' : '//';

    if( c.longPath )
    {
      result += c.longPath;
    }
    else
    {
      result += longPathFrom( c );
    }

    /**/

    _.assert( !c.query || _.strIs( c.query ) );

    if( c.query !== undefined )
    result += '?' + c.query;

    if( c.hash !== undefined )
    result += '#' + c.hash;

    return result;
  }

  /* */

  function fullHas( c )
  {
    if( c.protocol )
    if( !_.strBegins( c.full, c.protocol ) )
    return false;

    if( c.host )
    if( !_.strHas( c.full, c.host ) )
    return false;

    if( c.port !== null && c.port !== undefined )
    if( !_.strHas( c.full, String( c.host ) ) )
    return false;

    if( c.localPath )
    if( !_.strHas( c.full, String( c.localPath ) ) )
    return false;

    if( c.query )
    if( !_.strHas( c.full, String( c.query ) ) )
    return false;

    if( c.hash )
    if( !_.strHas( c.full, String( c.hash ) ) )
    return false;

    if( c.longPath )
    if( !_.strHas( c.full, String( c.longPath ) ) )
    return false;

    return true;
  }

}

str.components = UriComponents;

// function str( components )
// {
//   let result = '';
//
//   _.assert( _.strIs( components ) || _.mapIs( components ) );
//   _.assert( arguments.length === 1, 'expects single argument' );
//   _.assertMapHasOnly( components, this.UriComponents );
//   _.assert( components.uri === undefined );
//
//   if( components.full )
//   {
//     _.assert( _.strIsNotEmpty( components.full ) );
//     return components.full;
//   }
//
//   if( _.strIs( components ) )
//   return components;
//
//   /* */
//
//   if( components.origin )
//   {
//     result += components.origin;
//   }
//   else
//   {
//
//     let hostWithPort;
//     if( components.hostWithPort )
//     {
//       hostWithPort = components.hostWithPort;
//     }
//     else
//     {
//       if( components.host !== undefined )
//       hostWithPort = components.host;
//       if( components.port !== undefined && components.port !== null )
//       if( hostWithPort )
//       hostWithPort += ':' + components.port;
//       else
//       hostWithPort = ':' + components.port;
//     }
//
//     if( _.strIs( components.protocol ) && !hostWithPort )
//     hostWithPort = '';
//
//     if( _.strIs( components.protocol ) || _.strIs( hostWithPort ) )
//     // if( _.strIs( components.protocol ) || _.strIsNotEmpty( hostWithPort ) )
//     result += ( _.strIs( components.protocol ) ? components.protocol + '://' : '//' ) + hostWithPort;
//
//   }
//
//   /* */
//
//   if( components.localPath )
//   result += _.strPrependOnce( components.localPath, this._upStr );
//
//   _.assert( !components.query || _.strIs( components.query ) );
//
//   if( components.query !== undefined )
//   result += '?' + components.query;
//
//   if( components.hash !== undefined )
//   result += '#' + components.hash;
//
//   return result;
// }
//
//
//
// /**
//  * Complements current window uri origin by components passed in o.
//  * All components of current origin is replaced by appropriates components from o if they exist.
//  * If { o.full } exists and valid, method returns it.
//  * @example
//  * // current uri http://www.site.com:13/foo/baz
//    let components =
//    {
//      localPath : '/path/name',
//      query : 'query=here&and=here',
//      hash : 'anchor',
//    };
//    let res = wTools.uri.from(o);
//    // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
//  *
//  * @returns {string} composed uri
//  * @method from
//  * @memberof wTools.uri
//  */
//
// function from( o )
// {
//
//   _.assert( arguments.length === 1 );
//   _.assert( _.mapIs( o ) );
//   _.assertMapHasOnly( o, this.UriComponents );
//
//   if( o.full )
//   return this.str( o );
//
//   let currentUri = this.server();
//   let carentParsed = this.parseAtomic( currentUri );
//
//   _.mapExtend( carentParsed, o );
//
//   return this.str( carentParsed );
// }
//
//

/**
 * Complements current window uri origin by components passed in o.
 * All components of current origin is replaced by appropriates components from o if they exist.
 * If { o.full } exists and valid, method returns it.
 * @example
 * // current uri http://www.site.com:13/foo/baz
   let components =
   {
     localPath : '/path/name',
     query : 'query=here&and=here',
     hash : 'anchor',
   };
   let res = wTools.uri.full( o );
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 *
 * @returns {string} composed uri
 * @method full
 * @memberof wTools.uri
 */

function full( o )
{

  _.assert( arguments.length === 1 );
  _.assert( this.is( o ) || _.mapIs( o ) );

  if( _.strIs( o ) )
  o = this.parseAtomic( o )

  _.assertMapHasOnly( o, this.UriComponents );

  // if( o.full )
  // return this.str( o );

  let serverUri = this.server();
  let serverParsed = this.parseAtomic( serverUri );

  _.mapExtend( serverParsed, o );

  return this.str( serverParsed );
}

//

function refine( fileUri )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( fileUri ) );

  if( this.isGlobal( fileUri ) )
  fileUri = this.parseConsecutive( fileUri );
  else
  return parent.refine( fileUri );

  // fileUri.localPath = null; xxx

  if( _.strIsNotEmpty( fileUri.longPath ) )
  fileUri.longPath = parent.refine( fileUri.longPath );

  return this.str( fileUri );
}

//

let urisRefine = _.routineVectorize_functor
({
  routine : refine,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

let urisOnlyRefine = _.routineVectorize_functor
({
  routine : refine,
  fieldFilter : _filterOnlyUrl,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

function normalize( fileUri )
{
  let parent = this.path;
  if( _.strIs( fileUri ) )
  {
    if( this.isGlobal( fileUri ) )
    fileUri = this.parseConsecutive( fileUri );
    else
    return parent.normalize( fileUri );
  }
  _.assert( !!fileUri );
  // fileUri.localPath = null; xxx
  fileUri.longPath = parent.normalize( fileUri.longPath );
  return this.str( fileUri );
}

//

let urisNormalize = _.routineVectorize_functor
({
  routine : normalize,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

let urisOnlyNormalize = _.routineVectorize_functor
({
  routine : normalize,
  fieldFilter : _._filterOnlyPath,
  vectorizingArray : 1,
  vectorizingMap : 1,
});

//

function normalizeTolerant( fileUri )
{
  let parent = this.path;
  if( _.strIs( fileUri ) )
  {
    if( this.isGlobal( fileUri ) )
    fileUri = this.parseConsecutive( fileUri );
    else
    return parent.normalizeTolerant( fileUri );
  }
  _.assert( !!fileUri );
  // fileUri.localPath = null;
  fileUri.longPath = parent.normalizeTolerant( fileUri.longPath );
  return this.str( fileUri );
}

//
//
// /**
//  * Joins filesystem paths fragments or uris fragment into one path/URI. Uses '/' level delimeter.
//  * @param {Object} o join o.
//  * @param {String[]} p.paths - Array with paths to join.
//  * @param {boolean} [o.isUri=false] If true, method returns URI which consists from joined fragments, beginning
//  * from element that contains '//' characters. Else method will join elements in `paths` array as os path names.
//  * @param {boolean} [o.reroot=false] If this parameter set to false (by default), method joins all elements in
//  * `paths` array, starting from element that begins from '/' character, or '* :', where '*' is any drive name. If it
//  * is set to true, method will join all elements in array. Result
//  * @returns {string}
//  * @private
//  * @throws {Error} If missed arguments.
//  * @throws {Error} If elements of `paths` are not strings
//  * @throws {Error} If o has extra parameters.
//  * @method _uriJoin_body
//  * @memberof wTools.uri
//  */
//
// function _uriJoin_body( o )
// {
//   let self = this;
//   let result = null;
//   let prepending = true;
//
//   /* */
//
//   debugger;
//   _.assert( Object.keys( o ).length === 4 );
//   _.assert( o.paths.length > 0 );
//   _.assert( _.boolLike( o.reroot ) );
//
//   /* */
//
//   for( let a = o.paths.length-1 ; a >= 0 ; a-- )
//   {
//     let src = o.paths[ a ];
//     _.sure( _.strIs( src ) || src === null, () => 'expects strings as path arguments, but #' + a + ' argument is ' + _.strTypeOf( src ) );
//   }
//
//   /* */
//
//   for( let a = o.paths.length-1 ; a >= 0 ; a-- )
//   {
//     let src = o.paths[ a ];
//
//     if( o.allowingNull )
//     if( src === null )
//     break;
//
//     if( result === null )
//     result = '';
//
//     // _.assert( _.strIs( src ), () => 'expects strings as path arguments, but #' + a + ' argument is ' + _.strTypeOf( src ) );
//
//     prepending = prepend( src );
//     if( prepending === false && !o.isUri )
//     break;
//
//   }
//
//   /* */
//
//   if( result === '' )
//   return '.';
//
//   return result;
//
//   /* */
//
//   function prepend( src )
//   {
//
//     if( o.isUri )
//     src = self.refine( src );
//     else
//     src = self.refine( src );
//
//     if( !src )
//     return prepending;
//
//     let doPrepend = prepending;
//     if( !doPrepend && o.isUri )
//     {
//       if( src.indexOf( '//' ) !== -1 )
//       {
//         let i = src.indexOf( '//' );
//         i = src.indexOf( '/', i+2 );
//         if( i >= 0 )
//         {
//           src = src.substr( 0,i );
//         }
//         doPrepend = 1;
//       }
//     }
//
//     if( doPrepend )
//     {
//
//       if( !o.isUri )
//       src = src.replace( /\\/g,'/' );
//
//       if( result && src[ src.length-1 ] === '/' && !_.strEnds( src, '//' ) )
//       if( src.length > 1 || result[ 0 ] === '/' )
//       src = src.substr( 0,src.length-1 );
//
//       if( src && src[ src.length-1 ] !== '/' && result && result[ 0 ] !== '/' )
//       result = '/' + result;
//
//       result = src + result;
//
//     }
//
//     if( o.isUri )
//     {
//       if( src.indexOf( '//' ) !== -1 )
//       {
//         return false;
//       }
//     }
//
//     if( !o.reroot )
//     {
//       if( src[ 0 ] === '/' )
//       return false;
//       // if( src[ 1 ] === ':' )
//       // console.warn( 'WARNING : Path could be native for windows, but should not',src );
//       // if( src[ 1 ] === ':' )
//       // debugger;
//       // if( src[ 1 ] === ':' )
//       // if( src[ 2 ] !== '/' || src[ 3 ] !== '/' )
//       // return false;
//     }
//
//     return prepending;
//   }
//
// }
//
// _uriJoin_body.defaults =
// {
//   paths : null,
//   reroot : 0,
//   isUri : 0,
//   allowingNull : 1,
// }

//

function _joining_functor( gen )
{

  if( arguments.length === 2 )
  gen = { routineName : arguments[ 0 ], web : arguments[ 1 ] }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( _joining_functor, gen );

  let routineName = gen.routineName;
  let web = gen.web;

  return function joining()
  {

    let parent = this.path;
    let result = Object.create( null );
    let srcs = [];
    let parsed = false;

    /* */

    if( web )
    {

      for( let s = 0 ; s < arguments.length ; s++ )
      {
        if( arguments[ s ] !== null && this.isGlobal( arguments[ s ] ) )
        {
          parsed = true;
          srcs[ s ] = this.parseAtomic( arguments[ s ] );
        }
        else
        {
          srcs[ s ] = { localPath : arguments[ s ] };
        }
      }

    }
    else
    {

      for( let s = 0 ; s < arguments.length ; s++ )
      {
        if( arguments[ s ] !== null && this.isGlobal( arguments[ s ] ) )
        {
          parsed = true;
          srcs[ s ] = this.parseConsecutive( arguments[ s ] );
        }
        else
        {
          srcs[ s ] = { longPath : arguments[ s ] };
        }
      }

    }

    /* */

    if( web )
    {
      result.localPath = undefined;
    }
    else
    {
      result.longPath = undefined;
    }

    /* */

    for( let s = srcs.length-1 ; s >= 0 ; s-- )
    {
      let src = srcs[ s ];

      if( web )
      if( result.protocol && src.protocol )
      if( result.protocol !== src.protocol )
      continue;

      if( !result.protocol && src.protocol !== undefined )
      result.protocol = src.protocol;

      if( web )
      {

        let hostWas = result.host;
        if( !result.host && src.host !== undefined )
        result.host = src.host;

        if( !result.port && src.port !== undefined )
        if( !hostWas || !src.host || hostWas === src.host )
        result.port = src.port;

        if( !result.localPath && src.localPath !== undefined )
        result.localPath = src.localPath;
        else if( src.localPath )
        result.localPath = parent[ routineName ]( src.localPath, result.localPath );

        if( src.localPath === null )
        break;

      }
      else
      {

        if( result.longPath === undefined && src.longPath !== undefined )
        result.longPath = src.longPath;
        else if( src.longPath )
        result.longPath = parent[ routineName ]( src.longPath, result.longPath );

        if( src.longPath === null )
        break;

      }

      if( src.query !== undefined )
      if( !result.query )
      result.query = src.query;
      else
      result.query = src.query + '&' + result.query;

      if( !result.hash && src.hash !==undefined )
      result.hash = src.hash;

    }

    /* */

    if( !parsed )
    {
      if( web )
      return result.localPath;
      else
      return result.longPath;
    }

    return this.str( result );
  }

}

_joining_functor.defaults =
{
  routineName : null,
  web : 0,
}

//

let join = _joining_functor( 'join', 0 );

//

let urisJoin = _.path._pathMultiplicator_functor
({
  routine : join
});

//

function resolve()
{
  let parent = this.path;
  let joined = this.join.apply( this, arguments );
  let parsed = { longPath : joined };
  if( joined !== null )
  parsed = this.parseConsecutive( joined );
  parsed.longPath = parent.resolve( parsed.longPath );
  return this.str( parsed );
}

//

function relative( o )
{
  let parent = this.path;

  if( arguments[ 1 ] !== undefined )
  {
    o = { relative : arguments[ 0 ], path : arguments[ 1 ] }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( this._relative, o );

  if( !this.isGlobal( o.relative ) && !this.isGlobal( o.path ) )
  return this._relative( o );

  let relative = this.parseConsecutive( o.relative );
  let path = this.parseConsecutive( o.path );

  let o2 = _.mapExtend( null,o );
  o2.relative = relative.longPath;
  o2.path = path.longPath;

  relative.longPath = this._relative( o2 );

  return this.str( relative );
}

relative.defaults = Object.create( _.path._relative.defaults );

//

/*
qqq : teach it to work with uri maps
*/

function common()
{
  let parent = this.path;
  let self = this;
  let uris = _.longSlice( arguments );

  _.assert( _.strsAre( arguments ) );

  /* */

  let isRelative = null;
  for( let i = 0, len = uris.length; i < len; i++ )
  {
    uris[ i ] = parse( uris[ i ] );
    let isThisRelative = parent.isRelative( uris[ i ].longPath );
    _.assert( isRelative === isThisRelative || isRelative === null, 'Attempt to combine relative with absolutue paths' );
    isRelative = isThisRelative;
  }

  /* */

  let result = uris[ 0 ];
  let protocol = null;
  let withoutProtocol = 0;

  /* */

  for( let i = 0, len = uris.length; i < len; i++ )
  {
    let uri = uris[ i ];

    let protocol2 = uri.protocol || '';

    if( protocol === null )
    {
      protocol = uri.protocol;
      continue;
    }

    if( uri.protocol === protocol )
    continue;

    if( uri.protocol && protocol )
    return '';

    withoutProtocol = 1;

  }

  if( withoutProtocol )
  protocol = '';
  result.protocol = protocol;

  /* */

  for( let i = 1, len = uris.length; i < len; i++ )
  {
    let uri = uris[ i ];
    result.longPath = parent._common( uri.longPath, result.longPath );
  }

  /* */

  return this.str( result );

  /* */

  function parse( uri )
  {
    let result;

    if( _.strIs( uri ) )
    if( self.isGlobal( uri ) )
    {
      result = self.parseConsecutive( uri );
    }
    else
    {
      result = { longPath : uri };
    }

    return result;
  }

}

//

function rebase( srcPath, oldPath, newPath )
{
  let parent = this.path;
  _.assert( arguments.length === 3, 'expects exactly three argument' );

  srcPath = this.parseConsecutive( srcPath );
  oldPath = this.parseConsecutive( oldPath );
  newPath = this.parseConsecutive( newPath );

  let dstPath = _.mapExtend( null, srcPath, _.mapSelect( newPath, _.mapKeys( srcPath ) ) );

  // if( srcPath.protocol !== undefined && oldPath.protocol !== undefined )
  // {
  //   if( srcPath.protocol === oldPath.protocol && newPath.protocol === undefined )
  //   delete dstPath.protocol;
  // }
  //
  // if( srcPath.host !== undefined && oldPath.host !== undefined )
  // {
  //   if( srcPath.host === oldPath.host && newPath.host === undefined )
  //   delete dstPath.host;
  // }

  // dstPath.localPath = null; xxx
  dstPath.longPath = parent.rebase( srcPath.longPath, oldPath.longPath, newPath.longPath );

  return this.str( dstPath );
}

//

function name( o )
{
  let parent = this.path;
  if( _.strIs( o ) )
  o = { path : o }

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( o.path ) );
  _.routineOptions( name, o );

  if( !this.isGlobal( o.path ) )
  return parent.name( o );

  let path = this.parseConsecutive( o.path );

  let o2 = _.mapExtend( null,o );
  o2.path = path.longPath;
  return parent.name( o2 );
}

name.defaults = Object.create( _.path.name.defaults );

//

function ext( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( path ) );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.ext( path );
}

//

function exts( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( this.isGlobal( path ) )
  path = this.parseConsecutive( path ).longPath;

  return parent.exts( path );
}

//

function changeExt( path, ext )
{
  let parent = this.path;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIsNotEmpty( path ) );
  _.assert( _.strIs( ext ) );

  if( !this.isGlobal( path ) )
  return parent.changeExt( path, ext );

  path = this.parseConsecutive( path );

  // path.localPath = null;
  path.longPath = this.changeExt( path.longPath, ext );
  // path.full = null;
  // path.origin = null;

  return this.str( path );
}

//

function dir( path )
{
  let parent = this.path;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( path ) );

  if( !this.isGlobal( path ) )
  return parent.dir( path );

  path = this.parseConsecutive( path );
  // path.localPath = null;
  path.longPath = this.dir( path.longPath );

  // path.full = null;
  // path.origin = null;

  return this.str( path );
}

//

/**
 * Returns origin plus path without query part of uri string.
 * @example
 *
   let path = 'https://www.site.com:13/path/name?query=here&and=here#anchor';
   wTools.uri.uri.documentGet( path, { withoutProtocol : 1 } );
   // 'www.site.com:13/path/name'
 * @param {string} path uri string
 * @param {Object} [o] o - options
 * @param {boolean} o.withoutServer if true rejects origin part from result
 * @param {boolean} o.withoutProtocol if true rejects protocol part from result uri
 * @returns {string} Return document uri.
 * @method documentGet
 * @memberof wTools.uri
 */

function documentGet( path, o )
{
  o = o || Object.create( null );

  if( path === undefined )
  path = _realGlobal_.location.href;

  if( path.indexOf( '//' ) === -1 )
  {
    path = 'http:/' + ( path[ 0 ] === '/' ? '' : '/' ) + path;
  }

  let a = path.split( '//' );
  let b = a[ 1 ].split( '?' );

  /* */

  if( o.withoutServer )
  {
    let i = b[ 0 ].indexOf( '/' );
    if( i === -1 ) i = 0;
    return b[ 0 ].substr( i );
  }
  else
  {
    if( o.withoutProtocol ) return b[0];
    else return a[ 0 ] + '//' + b[ 0 ];
  }

}

documentGet.defaults =
{
  path : null,
  withoutServer : null,
  withoutProtocol : null,
}

//

/**
 * Return origin (protocol + host + port) part of passed `path` string. If missed arguments, returns origin of
 * current document.
 * @example
 *
   let path = 'http://www.site.com:13/path/name?query=here'
   wTools.uri.server( path );
   // 'http://www.site.com:13/'
 * @param {string} [path] uri
 * @returns {string} Origin part of uri.
 * @method server
 * @memberof wTools.uri
 */

function server( path )
{
  let a,b;

  if( path === undefined )
  path = _realGlobal_.location.origin;

  if( path.indexOf( '//' ) === -1 )
  {
    if( path[ 0 ] === '/' ) return '/';
    a = [ '',path ]
  }
  else
  {
    a = path.split( '//' );
    a[ 0 ] += '//';
  }

  b = a[ 1 ].split( '/' );

  return a[ 0 ] + b[ 0 ] + '/';
}

//

/**
 * Returns query part of uri. If method is called without arguments, it returns current query of current document uri.
 * @example
   let uri = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
   wTools.uri.query( uri ); // 'query=here&and=here#anchor'
 * @param {string } [path] uri
 * @returns {string}
 * @method query
 * @memberof wTools.uri
 */

function query( path )
{
  if( path === undefined )
  path = _realGlobal_.location.href;
  if( path.indexOf( '?' ) === -1 ) return '';
  return path.split( '?' )[ 1 ];
}

//

/**
 * Parse a query string passed as a 'query' argument. Result is returned as a dictionary.
 * The dictionary keys are the unique query variable names and the values are decoded from uri query variable values.
 * @example
 *
   let query = 'k1=&k2=v2%20v3&k3=v4_v4';

   let res = wTools.uri.dequery( query );
   // {
   //   k1 : '',
   //   k2 : 'v2 v3',
   //   k3 : 'v4_v4'
   // },

 * @param {string} query query string
 * @returns {Object}
 * @method dequery
 * @memberof wTools.uri
 */

function dequery( query )
{

  let result = Object.create( null );
  query = query || _global.location.search.split('?')[1];
  if( !query || !query.length )
  return result;
  let vars = query.split( '&' );

  for( let i = 0 ; i < vars.length ; i++ )
  {

    let w = vars[ i ].split( '=' );
    w[ 0 ] = decodeURIComponent( w[ 0 ] );
    if( w[ 1 ] === undefined ) w[ 1 ] = '';
    else w[ 1 ] = decodeURIComponent( w[ 1 ] );

    if( (w[ 1 ][ 0 ] == w[ 1 ][ w[ 1 ].length-1 ] ) && ( w[ 1 ][ 0 ] == '"') )
    w[ 1 ] = w[ 1 ].substr( 1,w[ 1 ].length-1 );

    if( result[ w[ 0 ] ] === undefined )
    {
      result[ w[ 0 ] ] = w[ 1 ];
    }
    else if( _.strIs( result[ w[ 0 ] ] ) )
    {
      result[ w[ 0 ] ] = result[ result[ w[ 0 ] ], w[ 1 ] ]
    }
    else
    {
      result[ w[ 0 ] ].push( w[ 1 ] );
    }

  }

  return result;
}

// --
// declare Fields
// --

let Fields =
{

  single : Self,
  UriComponents : UriComponents,

}

// --
// declare routines
// --

let Routines =
{

  // internal

  _filterOnlyUrl : _filterOnlyUrl,
  _filterNoInnerArray : _filterNoInnerArray,

  // uri checker

  is : is,
  isGlobal : isGlobal,
  isSafe : isSafe,
  isNormalized : isNormalized,
  isAbsolute : isAbsolute,

  // uri

  _uriParse : _uriParse,
  parse : parse,
  parseAtomic : parseAtomic,
  parseConsecutive : parseConsecutive,

  str : str,
  full : full,
  // from : from,

  refine : refine,
  urisRefine : urisRefine,
  urisOnlyRefine : urisOnlyRefine,

  normalize : normalize,
  urisNormalize : urisNormalize,
  urisOnlyNormalize : urisOnlyNormalize,

  normalizeTolerant : normalizeTolerant,

  // _uriJoin_body : _uriJoin_body,
  _joining_functor : _joining_functor,

  join : join,
  urisJoin : urisJoin,
  resolve : resolve,

  relative : relative,
  common : common,
  rebase : rebase,

  name : name,
  ext : ext,
  exts : exts,
  changeExt : changeExt,
  dir : dir,

  documentGet : documentGet,
  server : server,
  query : query,
  dequery : dequery,

}

_.mapSupplementOwn( Self, Fields );
_.mapSupplementOwn( Self, Routines );

Self.Init();

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
