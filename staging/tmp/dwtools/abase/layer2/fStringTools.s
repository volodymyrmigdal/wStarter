(function _fStringTools_s_() {

'use strict';

/*

= articles

- strIsolate* difference

*/

//

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

// let __assert = _.assert;
let _arraySlice = _.longSlice;
let strTypeOf = _.strTypeOf;


// --
// checker
// --

function strIsMultilined( src )
{
  if( !_.strIs( src ) )
  return false;
  if( src.indexOf( '\n' ) !== -1 )
  return true;
  return false;
}

//

function strHas( src,ins )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( src ) );
  _.assert( _.strIs( ins ) );

  return src.indexOf( ins ) !== -1;
}

//

function strHasAny( src,ins )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( strHas( src,ins[ i ] ) )
    return true;
    return false;
  }

  return strHas( src,ins );
}

//

function strHasAll( src,ins )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( !strHas( src,ins[ i ] ) )
    return false;
    return true;
  }

  return strHas( src,ins );
}

//

function strHasNone( src,ins )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( strHas( src,ins[ i ] ) )
    return false;
    return true;
  }

  return !strHas( src,ins );
}

//

function strHasSeveral( src,ins )
{
  let result = 0;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.arrayIs( ins ) )
  {
    for( let i = 0 ; i < ins.length ; i++ )
    if( strHas( src,ins[ i ] ) )
    result += 1;
    return result;
  }

  return strHas( src,ins ) ? 1 : 0;
}

//

function strsAnyHas( srcs, ins )
{
  _.assert( _.strIs( srcs ) || _.strsAre( srcs ) );
  _.assert( _.strIs( ins ) );

  if( _.strIs( srcs ) )
  return _.strHas( srcs, ins );

  return srcs.some( ( src ) => _.strHas( src, ins ) );
}

//

function strsAllHas( srcs, ins )
{
  _.assert( _.strIs( srcs ) || _.strsAre( srcs ) );
  _.assert( _.strIs( ins ) );

  if( _.strIs( srcs ) )
  return _.strHas( srcs, ins );

  return srcs.every( ( src ) => _.strHas( src, ins ) );
}

//

function strsNoneHas( srcs, ins )
{
  _.assert( _.strIs( srcs ) || _.strsAre( srcs ) );
  _.assert( _.strIs( ins ) );

  if( _.strIs( srcs ) )
  return !_.strHas( srcs, ins );

  return srcs.every( ( src ) => !_.strHas( src, ins ) );
}

// --
// evaluator
// --

/**
 * Returns number of occurrences of a substring( ins ) in a string( src ),
 * Expects two objects in order: source string, substring.
 * Returns zero if one of arguments is empty string.
 *
 * @param {string} src - Source string.
 * @param {string} ins - Substring.
 * @returns {Number} Returns number of occurrences of a substring in a string.
 *
 * @example
 * //returns 2
 * _.strCount( 'aabab','ab' );
 *
 * @example
 * //returns 0
 * _.strCount( 'aabab','' );
 *
 * @method strCount
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if( ins ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 2.
 * @memberof wTools
 *
 */

function strCount( src,ins )
{
  let result = -1;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( src ) );
  _.assert( _.strIs( ins ) );

  if( !ins.length )
  return 0;

  let i = -1;
  do
  {
    result += 1;
    i = src.indexOf( ins,i+1 );
  }
  while( i !== -1 );

  return result;
}

//

function strCountLeft( src,ins )
{
  let result = 0;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( src ) );
  _.assert( _.strIs( ins ) );

  if( !ins.length )
  return 0;

  let i = 0;
  do
  {
    if( src.substring( i,i+ins.length ) !== ins )
    break;
    result += 1;
    i += ins.length;
  }
  while( i < src.length );

  return result;
}

//

function strCountRight( src,ins )
{
  let result = 0;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( src ) );
  _.assert( _.strIs( ins ) );

  throw _.err( 'not tested' );

  if( !ins.length )
  return 0;

  let i = src.length;
  do
  {
    if( src.substring( i-ins.length,i ) !== ins )
    break;
    result += 1;
    i -= ins.length;
  }
  while( i > 0 );

  return result;
}

// --
// replacer
// --

function _strRemovedBegin( src,begin )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( src ), 'expects string {-src-}' );

  let result = src;
  let beginOf = _._strBeginOf( result, begin );
  if( beginOf !== false )
  result = result.substr( beginOf.length, result.length );

  // if( _.strIs( begin ) )
  // {
  //   if( _._strBeginOf( result, begin ) !== false )
  //   {
  //     result = result.substr( begin.length, result.length );
  //     return result;
  //   }
  // }
  // else if( _.regexpIs( begin ) )
  // {
  //   let matched = begin.exec( result );
  //   if( matched && matched.index === 0 )
  //   result = result.substring( matched[ 0 ].length, result.length );
  //   return result;
  // }
  // else _.assert( 0,'expects string or regexp {-begin-}' );

  return result;
}

//

/**
 * Finds substring prefix ( begin ) occurrence from the very begining of source ( src ) and removes it.
 * Returns original string if source( src ) does not have occurrence of ( prefix ).
 *
 * @param { String } src - Source string to parse.
 * @param { String } prefix - String that is to be dropped.
 * @returns { String } Returns string with result of prefix removement.
 *
 * @example
 * //returns mple
 * _.strRemoveBegin( 'example','exa' );
 *
 * @example
 * //returns example
 * _.strRemoveBegin( 'example','abc' );
 *
 * @function strRemoveBegin
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if( prefix ) is not a String.
 * @throws { Exception } Throws a exception if( arguments.length ) is not equal 2.
 * @memberof wTools
 *
 */

function strRemoveBegin( src,begin )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( src ) || _.strIs( src ), 'expects string or array of strings {-src-}' );
  _.assert( _.longIs( begin ) || _.strIs( begin ) || _.regexpIs( begin ), 'expects string/regexp or array of strings/regexps {-begin-}' );

  let result = [];
  let srcIsArray = _.longIs( src );

  if( _.strIs( src ) && !_.longIs( begin ) )
  return _._strRemovedBegin( src, begin );

  src = _.arrayAs( src );
  begin = _.arrayAs( begin );
  for( let s = 0, slen = src.length ; s < slen ; s++ )
  {
    let beginOf = false;
    let src1 = src[ s ]
    for( let b = 0, blen = begin.length ; b < blen ; b++ )
    {
      beginOf = _._strBeginOf( src1, begin[ b ] );
      if( beginOf !== false )
      break;
    }
    if( beginOf !== false )
    src1 = src1.substr( beginOf.length, src1.length );
    result[ s ] = src1;
  }

  if( !srcIsArray )
  return result[ 0 ];

  return result;
}

//

function _strRemovedEnd( src, end )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( src ), 'expects string {-src-}' );

  let result = src;
  let endOf = _._strEndOf( result, end );
  if( endOf !== false )
  result = result.substr( 0, result.length - endOf.length );

  return result;
}

//

/**
 * Removes occurrence of postfix ( end ) from the very end of string( src ).
 * Returns original string if no occurrence finded.
 * @param { String } src - Source string to parse.
 * @param { String } postfix - String that is to be dropped.
 * @returns { String } Returns string with result of postfix removement.
 *
 * @example
 * //returns examp
 * _.strRemoveEnd( 'example','le' );
 *
 * @example
 * //returns example
 * _.strRemoveEnd( 'example','abc' );
 *
 * @function strRemoveEnd
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if( postfix ) is not a String.
 * @throws { Exception } Throws a exception if( arguments.length ) is not equal 2.
 * @memberof wTools
 *
 */

function strRemoveEnd( src, end )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( src ) || _.strIs( src ), 'expects string or array of strings {-src-}' );
  _.assert( _.longIs( end ) || _.strIs( end ) || _.regexpIs( end ), 'expects string/regexp or array of strings/regexps {-end-}' );

  let result = [];
  let srcIsArray = _.longIs( src );

  if( _.strIs( src ) && !_.longIs( end ) )
  return _._strRemovedEnd( src, end );

  src = _.arrayAs( src );
  end = _.arrayAs( end );

  for( let s = 0, slen = src.length ; s < slen ; s++ )
  {
    let endOf = false;
    let src1 = src[ s ]
    for( let b = 0, blen = end.length ; b < blen ; b++ )
    {
      endOf = _._strEndOf( src1, end[ b ] );
      if( endOf !== false )
      break;
    }
    if( endOf !== false )
    src1 = src1.substr( 0,src1.length - endOf.length );
    result[ s ] = src1;
  }

  if( !srcIsArray )
  return result[ 0 ];

  return result;
}

// function strRemoveEnd( src,end )
// {
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//   _.assert( _.longIs( src ) || _.strIs( src ) );
//   _.assert( _.longIs( end ) || _.strIs( end ) );
//
//   end = _.arrayAs( end );
//
//   let result = _.arrayAs( src ).slice();
//
//   for( let k = 0, srcLength = result.length; k < srcLength; k++ )
//   for( let j = 0, endLength = end.length; j < endLength; j++ )
//   if( _.strEnds( result[ k ],end[ j ] ) )
//   {
//     result[ k ] = result[ k ].substring( 0,result[ k ].length-end[ j ].length )
//     break;
//   }
//
//   if( result.length === 1 && _.strIs( src ) )
//   return result[ 0 ];
//
//   return result;
// }

//

function strReplaceBegin( src,begin,ins )
{
  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( _.strIs( ins ) || _.longIs( ins ),'expects {-ins-} as string/array of strings' );
  if( _.longIs( begin ) && _.longIs( ins ) )
  _.assert( begin.length === ins.length );

  begin = _.arrayAs( begin );
  let result = _.arrayAs( src ).slice();

  for( let k = 0, srcLength = result.length; k < srcLength; k++ )
  for( let j = 0, beginLength = begin.length; j < beginLength; j++ )
  if( _.strBegins( result[ k ],begin[ j ] ) )
  {
    let prefix = _.longIs( ins ) ? ins[ j ] : ins;
    _.assert( _.strIs( prefix ) );
    //result[ k ] = prefix + result[ k ].substr( begin[ j ].length,result[ k ].length );
    result[ k ] = prefix + _.strRemoveBegin( result[ k ] , begin[ j ] );
    break;
  }

  if( result.length === 1 && _.strIs( src ) )
  return result[ 0 ];

  return result;
}

//

function strReplaceEnd( src,end,ins )
{
  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( _.strIs( ins ) || _.longIs( ins ),'expects {-ins-} as string/array of strings' );
  if( _.longIs( end ) && _.longIs( ins ) )
  _.assert( end.length === ins.length );

  end = _.arrayAs( end );
  let result = _.arrayAs( src ).slice();

  for( let k = 0, srcLength = result.length; k < srcLength; k++ )
  for( let j = 0, endLength = end.length; j < endLength; j++ )
  if( _.strEnds( result[ k ],end[ j ] ) )
  {
    logger.log( result[ k ] , end[ j ] )
    logger.log('It ends')
    let postfix = _.longIs( ins ) ? ins[ j ] : ins;
    _.assert( _.strIs( postfix ) );
    // result[ k ] = result[ k ].substring( 0,result[ k ].length-end[ j ].length ) + postfix;
    result[ k ] = _.strRemoveEnd( result[ k ] , end[ j ] ) + postfix;
  }

  if( result.length === 1 && _.strIs( src ) )
  return result[ 0 ];

  return result;
}

//

/**
  * Prepends string( begin ) to the source( src ) if prefix( begin ) is not match with first chars of string( src ),
  * otherwise returns original string.
  * @param { String } src - Source string to parse.
  * @param { String } begin - String to prepend.
  *
  * @example
  * _.strPrependOnce( 'test', 'test' );
  * //returns 'test'
  *
  * @example
  * _.strPrependOnce( 'abc', 'x' );
  * //returns 'xabc'
  *
  * @returns { String } Returns result of prepending string( begin ) to source( src ) or original string.
  * @function strPrependOnce
  * @memberof wTools
  */

function strPrependOnce( src,begin )
{
  _.assert( _.strIs( src ) && _.strIs( begin ),'expects {-src-} and {-begin-} as strings' );
  if( src.lastIndexOf( begin,0 ) === 0 )
  return src;
  else
  return begin + src;
}

//

/**
  * Appends string( end ) to the source( src ) if postfix( end ) is not match with last chars of string( src ),
  * otherwise returns original string.
  * @param {string} src - Source string to parse.
  * @param {string} end - String to append.
  *
  * @example
  * _.strAppendOnce( 'test', 'test' );
  * //returns 'test'
  *
  * @example
  * _.strAppendOnce( 'abc', 'x' );
  * //returns 'abcx'
  *
  * @returns {string} Returns result of appending string( end ) to source( src ) or original string.
  * @function strAppendOnce
  * @memberof wTools
  */

function strAppendOnce( src,end )
{
  _.assert( _.strIs( src ) && _.strIs( end ),'expects {-src-} and {-end-} as strings' );
  if( src.indexOf( end, src.length - end.length ) !== -1 )
  return src;
  else
  return src + end;
}

// --
// etc
// --

/**
 * Replaces occurrence of each word from array( ins ) in string( src ) with word
 * from array( sub ) considering it position.
 * @param {string} src - Source string to parse.
 * @param {array} ins - Array with strings to replace.
 * @param {string} sub - Array with new strings.
 * @returns {string} Returns string with result of replacements.
 *
 * @example
 * //returns ' your cars are'
 * _.strReplaceWords( ' my name is',[ 'my','name','is' ],[ 'your','cars','are' ] )
 *
 * @method strReplaceWords
 * @throws { Exception } Throws a exception if( ins ) is not a Array.
 * @throws { Exception } Throws a exception if( sub ) is not a Array.
 * @throws { TypeError } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if( arguments.length ) is not equal 3.
 * @memberof wTools
 *
 */

function strReplaceWords( src,ins,sub )
{
  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( _.strIs( src ) );
  _.assert( _.arrayIs( ins ) );
  _.assert( _.arrayIs( sub ) );
  _.assert( ins.length === sub.length );

  let result = src;
  for( let i = 0 ; i < ins.length ; i++ )
  {
    _.assert( _.strIs( ins[ i ] ) );
    let r = new RegExp( '(\\W|^)' + ins[ i ] + '(?=\\W|$)','gm' );
    result = result.replace( r, function( original )
    {

      if( original[ 0 ] !== sub[ i ][ 0 ] )
      return original[ 0 ] + sub[ i ];
      else
      return sub[ i ];

    });
  }

  return result;
}

// --
// etc
// --

/**
 * Finds common symbols from the begining of all strings passed to arguments list. Uses first argument( ins ) as pattern.
 * If some string doesn`t have same first symbol with pattern( ins ) function returns empty string.
 * Otherwise returns symbol sequence that appears from the start of each string.
 *
 * @param {string} ins - Sequence of possible symbols.
 * @returns {string} Returns found common symbols.
 *
 * @example 'a'
 * _.strCommonLeft( 'abcd', 'ab', 'abc', 'a' );
 *
 * @example 'abc'
 * _.strCommonLeft( 'abcd', 'abc', 'abcd' );
 *
 * @example ''
 * _.strCommonLeft( 'abcd', 'abc', 'd' )
 *
 * @method strCommonLeft
 * @throws {exception} If( ins ) is not a String.
 * @memberof wTools
 *
 */

function strCommonLeft( ins )
{

  if( arguments.length === 0 )
  return '';
  if( arguments.length === 1 )
  return ins;

  _.assert( _.strIs( ins ) );

  let length = +Infinity;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    length = Math.min( length,src.length );
  }

  let i = 0;
  for( ; i < length ; i++ )
  for( let a = 1 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    if( src[ i ] !== ins[ i ] )
    return ins.substring( 0,i );
  }

  return ins.substring( 0,i );
}

//

/**
 * Finds common symbols from the end of all strings passed to arguments list. Uses first argument( ins ) as pattern.
 * If some string doesn`t have same last symbol with pattern( ins ) function returns empty string.
 * Otherwise returns symbol sequence that appears from the end of each string.
 *
 * @param {string} ins - Sequence of possible symbols.
 * @returns {string} Returns found common symbols.
 *
 * @example 'ame'
 * _.strCommonRight( 'ame', 'same', 'name' );
 *
 * @example 'c'
 * _.strCommonRight( 'abc', 'dbc', 'ddc', 'aac' );
 *
 * @example ''
 * _.strCommonRight( 'abc', 'dba', 'abc' );
 *
 * @method strCommonRight
 * @throws {exception} If( ins ) is not a String.
 * @memberof wTools
 *
 */

function strCommonRight( ins )
{

  if( arguments.length === 0 )
  return '';
  if( arguments.length === 1 )
  return ins;

  _.assert( _.strIs( ins ) );

  let length = +Infinity;

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    length = Math.min( length,src.length );
  }

  let i = 0;
  for( ; i < length ; i++ )
  for( let a = 1 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];
    if( src[ src.length - i - 1 ] !== ins[ ins.length - i - 1 ] )
    return ins.substring( ins.length-i );
  }

  return ins.substring( ins.length-i );
}

// --
// formatter
// --

function strForRange( range )
{
  let result;

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( range ) );

  result = '[ ' + range[ 0 ] + '..' + range[ 1 ] + ' ]';

  return result;
}

//

function strForCall( nameOfRoutine,args,ret,o )
{
  let result = nameOfRoutine + '( ';
  let first = true;

  _.assert( _.arrayIs( args ) || _.objectIs( args ) );
  _.assert( arguments.length <= 4 );

  _.each( args,function( e,k )
  {

    if( first === false )
    result += ', ';

    if( _.objectIs( e ) )
    result += k + ' :' + _.toStr( e,o );
    else
    result += _.toStr( e,o );

    first = false;

  });

  result += ' )';

  if( arguments.length >= 3 )
  result += ' -> ' + _.toStr( ret,o );

  return result;
}

//

/**
 * Returns source string( src ) with limited number( limit ) of characters.
 * For example: src : 'string', limit : 4, result -> ''st'...'ng''.
 * Function can be called in two ways:
 * - First to pass only source string and limit;
 * - Second to pass all options map. Example: ( { src : 'string', limit : 4, wrap : 0, escaping : 0 } ).
 *
 * @param {string|object} o - String to parse or object with options.
 * @param {string} [ o.src=null ] - Source string.
 * @param {number} [ o.limit=40 ] - Limit of characters in output.
 * @param {string} [ o.wrap='\'' ] - String wrapper. Use zero or false to disable.
 * @param {string} [ o.escaping=1 ] - Escaping characters appears in output.
 * @returns {string} Returns simplified source string.
 *
 * @example
 * //returns ''st' ... 'ng''
 * _.strShortSrt( 'string', 4 );
 *
 * @example
 * //returns ''s' ... 'ng''
 * _.strShortSrt( 's\ntring', 4 );
 *
 * @example
 * //returns 'string'
 * _.strShortSrt( 'string', 0 );
 *
 * @example
 * //returns ''st' ... 'ng''
 * _.strShortSrt( { src : 'string', limit : 4, wrap : '\'' } );
 *
 * @example
 * //returns 'si ... le'
 *  _.strShortSrt( { src : 'simple', limit : 4, wrap : 0 } );
 *
 * @example
 * //returns ''si' ... 'le''
 *  _.strShortSrt( { src : 'si\x01mple', limit : 5, wrap : '\'' } );
 *
 * @example
 * //returns ''s\u0001' ... ' string''
 *  _.strShortSrt( 's\x01t\x01ing string string', 14 );
 *
 * @method strShortSrt
 * @throws { Exception } If no argument provided.
 * @throws { Exception } If( arguments.length ) is not equal 1 or 2.
 * @throws { Exception } If( o ) is extended with unknown property.
 * @throws { Exception } If( o.src ) is not a String.
 * @throws { Exception } If( o.limit ) is not a Number.
 * @throws { Exception } If( o.wrap ) is not a String.
 *
 * @memberof wTools
 *
 */

function strShortSrt( o )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  o = { src : arguments[ 0 ], limit : arguments[ 1 ] };
  else if( arguments.length === 1 )
  if( _.strIs( o ) )
  o = { src : arguments[ 0 ] };

  _.routineOptions( strShortSrt, o );
  _.assert( _.strIs( o.src ) );
  _.assert( _.numberIs( o.limit ) );

  let str = o.src;

  if( str.length > o.limit && o.limit > 0  )
  {
    let b = Math.ceil( o.limit / 2 );
    let e = o.limit - b;

    let begin = str.substr( 0, b );
    let end = str.slice( -e );

    if( o.escaping )
    {
      function check( s, l )
      {
        let temp = _.strEscape( s );

        if( temp.length > l )
        for( let i = s.length - 1; i >= 0 ; --i )
        {
          if( temp.length <= l )
          break;
          temp = temp.slice( 0, - ( _.strEscape( s[ i ] ).length ) );
        }

        return temp;
      }

      begin = check( begin, b );
      end = check( end, e );

    }

    if( o.wrap )
    {
      _.assert( _.strIs( o.wrap ) );

      begin = o.wrap + begin + o.wrap;
      end = o.wrap + end + o.wrap;
    }

    if( o.limit === 1 )
    str = begin;
    else
    str = begin + ' ... ' +  end ;

  }
  else
  {
    if( o.escaping )
    str = _.strEscape( str );
  }

  return str;
}

strShortSrt.defaults =
{
  src : null,
  limit : 40,
  wrap : '\'',
  escaping : 1
}

//

function strQuote( o )
{

  if( !_.mapIs( o ) )
  o = { src : o };

  if( o.quote === undefined || o.quote === null )
  o.quote = strQuote.defaults.quote;

  _.assertMapHasOnly( o, strQuote.defaults );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.arrayIs( o.src ) )
  {
    let result = [];
    for( let s = 0 ; s < o.src.length ; s++ )
    result.push( _.strQuote({ src : o.src[ s ], quote : o.quote }) );
    return result;
  }

  let src = o.src;

  if( !_.primitiveIs( src ) )
  src = _.toStr( src );

  _.assert( _.primitiveIs( src ) );

  let result = o.quote + String( src ) + o.quote;

  return result;
}

strQuote.defaults =
{
  src : null,
  quote : '"',
}

// --
// transformer
// --

/**
 * Returns string with first letter converted to upper case.
 * Expects one object: the string to be formatted.
 *
 * @param {string} src - Source string.
 * @returns {String} Returns a string with the first letter capitalized.
 *
 * @example
 * //returns Test string
 * _.strCapitalize( 'test string' );
 *
 * @example
 * //returns Another_test_string
 * _.strCapitalize( 'another_test_string' );
 *
 * @method strCapitalize
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1.
 * @memberof wTools
 *
 */

function strCapitalize( src )
{
  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  /*_.assert( src.length > 0 );*/
  /*_.assert( src.match(/(^\W)/) === null );*/

  if( src.length === 0 )
  return src;

  return src[ 0 ].toUpperCase() + src.substring( 1 );
}

//

function strDecapitalize( src )
{
  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( src.length === 0 )
  return src;

  return src[ 0 ].toLowerCase() + src.substring( 1 );
}

//

/**
 * Disables escaped characters in source string( src ).
 * Example: '\n' -> '\\n', '\u001b' -> '\\u001b' etc.
 * Returns string with disabled escaped characters, source string if nothing changed or  empty string if source is zero length.
 * @param {string} src - Source string.
 * @returns {string} Returns string with disabled escaped characters.
 *
 * @example
 * //returns '\nhello\u001bworld\n'
 * _.strEscape( '\nhello\u001bworld\n' );
 *
 * @example
 * //returns 'string'
 * _.strEscape( 'string' );
 *
 * @example
 * //returns 'str\''
 * _.strEscape( 'str\'' );
 *
 * @example
 * //returns ''
 * _.strEscape( '' );
 *
 * @method strEscape
 * @throw { Exception } If( src ) is not a String.
 * @memberof wTools
 *
 */

function strEscape( o )
{

    // 007f : ''
    // . . .
    // 009f : ''

    // 00ad : '­'

    // \' 	single quote 	byte 0x27 in ASCII encoding
    // \' 	double quote 	byte 0x22 in ASCII encoding
    // \\ 	backslash 	byte 0x5c in ASCII encoding
    // \b 	backspace 	byte 0x08 in ASCII encoding
    // \f 	form feed - new page 	byte 0x0c in ASCII encoding
    // \n 	line feed - new line 	byte 0x0a in ASCII encoding
    // \r 	carriage return 	byte 0x0d in ASCII encoding
    // \t 	horizontal tab 	byte 0x09 in ASCII encoding
    // \v 	vertical tab 	byte 0x0b in ASCII encoding
    // source : http://en.cppreference.com/w/cpp/language/escape

  // console.log( _.appMemoryUsageInfo(), o.src.length );
  // if( o.src.length === 111691 )
  // debugger;

  if( _.strIs( o ) )
  o = { src : o }

  _.assert( _.strIs( o.src ), 'expects string {-o.src-}, but got', _.strTypeOf( o.src ) );
  _.routineOptions( strEscape, o );

  let result = '';
  // let src = o.src.split( '' );
  // debugger;
  let stringWrapperCode = o.stringWrapper.charCodeAt( 0 );
  for( let s = 0 ; s < o.src.length ; s++ )
  {
    // let c = o.src[ s ];
    // let c = src[ s ];
    // let code = c.charCodeAt( 0 );
    let code = o.src.charCodeAt( s );

    // if( o.stringWrapper === '`' && c === '$' )
    if( o.stringWrapper === '`' && code === 0x24 /* $ */ )
    {
      result += '\\$';
    }
    else if( o.stringWrapper && code === stringWrapperCode )
    {
      result += '\\' + o.stringWrapper;
    }
    else if( 0x007f <= code && code <= 0x009f || code === 0x00ad /*|| code >= 65533*/ )
    {
      // result += _.strUnicodeEscape( c );
      result += _.strCodeUnicodeEscape( code );
    }
    else switch( code )
    {

      case 0x5c /* '\\' */ :
        result += '\\\\';
        break;

      case 0x08 /* '\b' */ :
        result += '\\b';
        break;

      case 0x0c /* '\f' */ :
        result += '\\f';
        break;

      case 0x0a /* '\n' */ :
        result += '\\n';
        break;

      case 0x0d /* '\r' */ :
        result += '\\r';
        break;

      case 0x09 /* '\t' */ :
        result += '\\t';
        break;

      default :

        if( code < 32 )
        {
          result += _.strCodeUnicodeEscape( code );
        }
        else
        {
          result += String.fromCharCode( code );
        }

    }

  }

  return result;
}

strEscape.defaults =
{
  src : null,
  stringWrapper : '\'',
}

//

/**
 * Converts source string( src ) into unicode representation by replacing each symbol with its escaped unicode equivalent.
 * Example: ( 't' -> '\u0074' ). Returns result of conversion as new string or empty string if source has zero length.
 * @param {string} str - Source string to parse.
 * @returns {string} Returns string with result of conversion.
 *
 * @example
 * //returns \u0061\u0062\u0063;
 * _.strUnicodeEscape( 'abc' );
 *
 * @example
 * //returns \u0077\u006f\u0072\u006c\u0064
 * _.strUnicodeEscape( 'world' );
 *
 * @example
 * //returns \u002f\u002f\u0074\u0065\u0073\u0074\u002f\u002f
 * _.strUnicodeEscape( '//test//' );
 *
 * @method strUnicodeEscape
 * @throws { Exception } Throws a exception if no argument provided.
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @memberof wTools
 *
 */

function strCodeUnicodeEscape( code )
{
  let result = '';

  _.assert( _.numberIs( code ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  let h = code.toString( 16 );
  let d = _.strDup( '0', 4-h.length ) + h;

  result += '\\u' + d;

  return result;
}

//

/**
 * Converts source string( src ) into unicode representation by replacing each symbol with its escaped unicode equivalent.
 * Example: ( 't' -> '\u0074' ). Returns result of conversion as new string or empty string if source has zero length.
 * @param {string} str - Source string to parse.
 * @returns {string} Returns string with result of conversion.
 *
 * @example
 * //returns \u0061\u0062\u0063;
 * _.strUnicodeEscape( 'abc' );
 *
 * @example
 * //returns \u0077\u006f\u0072\u006c\u0064
 * _.strUnicodeEscape( 'world' );
 *
 * @example
 * //returns \u002f\u002f\u0074\u0065\u0073\u0074\u002f\u002f
 * _.strUnicodeEscape( '//test//' );
 *
 * @method strUnicodeEscape
 * @throws { Exception } Throws a exception if no argument provided.
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @memberof wTools
 *
 */

function strUnicodeEscape( src )
{
  let result = '';

  _.assert( _.strIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  for( let i = 0 ; i < src.length ; i++ )
  {
    let code = src.charCodeAt( i );
    result += _.strCodeUnicodeEscape( code );
  }

  return result;
}

//

function strReverse( srcStr )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  let result = '';
  for( let i = 0 ; i < srcStr.length ; i++ )
  result = srcStr[ i ] + result;
  return result;
}

// --
// stripper
// --

/**
 * Removes leading and trailing characters occurrences from source string( o.src ) finded by mask( o.stripper ).
 * If( o.stripper ) is not defined function removes leading and trailing whitespaces and escaped characters from( o.src ).
 * Function can be called in two ways:
 * - First to pass only source string and use default options;
 * - Second to pass map like ({ src : ' acb ', stripper : ' ' }).
 *
 * @param {string|object} o - Source string to parse or map with source( o.src ) and options.
 * @param {string} [ o.src=null ]- Source string to strip.
 * @param {string|array} [ o.stripper=' ' ]- Contains characters to remove.
 * @returns {string} Returns result of removement in a string.
 *
 * @example
 * //returns 'b'
 * _.strStrip( { src : 'aabaa', stripper : 'a' } );
 *
 * @example
 * //returns 'b'
 * _.strStrip( { src : 'xaabaax', stripper : [ 'a', 'x' ] } )
 *
 * @example
 * //returns 'b'
 * _.strStrip( { src : '   b  \n' } )
 *
 * @method strStrip
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1.
 * @throws { Exception } Throw an exception if( o ) is not Map.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.stripper ) is not a String or Array.
 * @throws { Exception } Throw an exception if object( o ) has been extended by invalid property.
 * @memberof wTools
 *
 */

function strStrip( o )
{

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { src : o };

  _.routineOptions( strStrip,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.arrayIs( o.src ) )
  {
    let result = [];
    for( let s = 0 ; s < o.src.length ; s++ )
    {
      let optionsForStrip = _.mapExtend( null,o );
      optionsForStrip.src = optionsForStrip.src[ s ];
      result[ s ] = strStrip( optionsForStrip );
    }
    return result;
  }

  _.assert( _.strIs( o.src ),'expects string or array o.src, got',_.strTypeOf( o.src ) );
  _.assert( _.strIs( o.stripper ) || _.arrayIs( o.stripper ) || _.regexpIs( o.stripper ),'expects string or array or regexp ( o.stripper )' );

  if( _.strIs( o.stripper ) || _.regexpIs( o.stripper ) )
  {
    let exp = o.stripper;
    if( _.strIs( exp ) )
    {
      exp = _.regexpEscape( exp );
      exp = new RegExp( exp, 'g' );
    }

    return o.src.replace( exp,'' );
  }
  else
  {

    _.assert( _.arrayIs( o.stripper ) );

    if( Config.debug )
    for( let s of o.stripper )
    _.assert( _.strIs( s,'expects string {-stripper[ * ]-}' ) );

    let b = 0;
    for( ; b < o.src.length ; b++ )
    if( o.stripper.indexOf( o.src[ b ] ) === -1 )
    break;

    let e = o.src.length-1;
    for( ; e >= 0 ; e-- )
    if( o.stripper.indexOf( o.src[ e ] ) === -1 )
    break;

    if( b >= e )
    return '';

    return o.src.substring( b, e+1 );
  }

}

strStrip.defaults =
{
  src : null,
  stripper : /^(\s|\n|\0)+|(\s|\n|\0)+$/gm,
}

//

function strStripLeft( o )
{

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { src : o };

  _.routineOptions( strStrip,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  return _.strStrip( o );
}

strStripLeft.defaults =
{
  stripper : /^(\s|\n|\0)+/gm,
}

strStripLeft.defaults.__proto__ = strStrip.defaults;

//

function strStripRight( o )
{

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { src : o };

  _.routineOptions( strStrip,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  return _.strStrip( o );
}

strStripRight.defaults =
{
  stripper : /(\s|\n|\0)+$/gm,
}

strStripRight.defaults.__proto__ = strStrip.defaults;

//

/**
 * Removes whitespaces from source( src ).
 * If argument( sub ) is defined, function replaces whitespaces with it.
 *
 * @param {string} src - Source string to parse.
 * @param {string} sub - Substring that replaces whitespaces.
 * @returns {string} Returns a string with removed whitespaces.
 *
 * @example
 * //returns abcde
 * _.strRemoveAllSpaces( 'a b c d e' );
 *
 * @example
 * //returns a*b*c*d*e
 * _.strRemoveAllSpaces( 'a b c d e','*' );
 *
 * @method strRemoveAllSpaces
 * @memberof wTools
 *
*/

function strRemoveAllSpaces( src,sub )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( src ) );

  if( sub === undefined )
  sub = '';

  return src.replace( /\s/g,sub );
}

//

/**
 * Removes empty lines from the string passed by argument( srcStr ).
 *
 * @param {string} srcStr - Source string to parse.
 * @returns {string} Returns a string with empty lines removed.
 *
 * @example
 * //returns
 * //first
 * //second
 * _.strStripEmptyLines( 'first\n\nsecond' );
 *
 * @example
 * //returns
 * //zero
 * //first
 * //second
 * _.strStripEmptyLines( 'zero\n\nfirst\n\nsecond' );
 *
 * @method strStripEmptyLines
 * @throws { Exception } Throw an exception if( srcStr ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1.
 * @memberof wTools
 *
 */

function strStripEmptyLines( srcStr )
{
  let result = '';
  let lines = srcStr.split( '\n' );

  _.assert( _.strIs( srcStr ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  for( let l = 0; l < lines.length; l += 1 )
  {
    let line = lines[ l ];

    if( !_.strStrip( line ) )
    continue;

    result += line + '\n';
  }

  result = result.substring( 0, result.length - 1 );
  return result;
}

// --
// splitter
// --

/*

_.strIsolateBeginOrAll
_.strIsolateBeginOrNone
_.strIsolateEndOrAll
_.strIsolateEndOrNone

_.strIsolateBeginOrNone( 'a b c',' ' )
(3) [ 'a', ' ', 'b c' ]
_.strIsolateEndOrNone( 'a b c',' ' )
(3) [ 'a b', ' ', 'c' ]
_.strIsolateEndOrAll( 'a b c',' ' )
(3) [ 'a b', ' ', 'c' ]
_.strIsolateBeginOrAll( 'a b c',' ' )
(3) [ 'a', ' ', 'b c' ]
_.strIsolateBeginOrNone( 'abc',' ' )
(3) [ '', '', 'abc' ]
_.strIsolateEndOrNone( 'abc',' ' )
(3) [ 'abc', '', '' ]
_.strIsolateEndOrAll( 'abc',' ' )
(3) [ '', '', 'abc' ]
_.strIsolateBeginOrAll( 'abc',' ' )
(3) [ 'abc', '', '' ]

used to be

_.strCutOffLeft( 'a b c',' ' )
(3) [ 'a', ' ', 'b c' ]
_.strCutOffRight( 'a b c',' ' )
(3) [ 'a b', ' ', 'c' ]
_.strCutOffAllLeft( 'a b c',' ' )
(3) [ 'a b', ' ', 'c' ]
_.strCutOffAllRight( 'a b c',' ' )
(3) [ 'a', ' ', 'b c' ]
_.strCutOffLeft( 'abc',' ' )
(3) [ '', '', 'abc' ]
_.strCutOffRight( 'abc',' ' )
(3) [ 'abc', '', '' ]
_.strCutOffAllLeft( 'abc',' ' )
(3) [ '', '', 'abc' ]
_.strCutOffAllRight( 'abc',' ' )
(3) [ 'abc', '', '' ]

*/

function _strCutOff_pre( routine, args )
{
  let o;

  if( args.length > 1 )
  {
    o = { src : args[ 0 ], delimeter : args[ 1 ], number : args[ 2 ] };
  }
  else
  {
    o = args[ 0 ];
    _.assert( args.length === 1, 'expects single argument' );
  }

  _.routineOptions( routine, o );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( o.src ) );
  _.assert( _.strIs( o.delimeter ) || _.arrayIs( o.delimeter ) );

  return o;
}

//

/**
* @typedef {object} wTools~toStrInhalfOptions
* @property {string} [ o.src=null ] - Source string.
* @property {string | array} [ o.delimeter=' ' ] - Splitter of the string.
* @property {boolean} [ o.left=1 ] - Finds occurrence from begining of the string.
*/

/**
 * Finds occurrence of delimeter( o.delimeter ) in source( o.src ) and splits string in finded position by half.
 * If function finds  more then one occurrence, it separates string in the position of the last.
 *
 * @param {wTools~toStrInhalfOptions} o - Contains data and options {@link wTools~toStrInhalfOptions}.
 * @returns {array} Returns array with separated parts of string( o.src ) or original string if nothing finded.
 *
 * @example
 * //returns [ 'sample', 'string' ]
 * _._strIsolate( { src : 'sample,string', delimeter : [ ',' ] } );
 *
 * @example
 * //returns [ 'sample', 'string' ]
 *_._strIsolate( { src : 'sample string', delimeter : ' ' } )
 *
 * @example
 * //returns [ 'sample string,name', 'string' ]
 * _._strIsolate( { src : 'sample string,name string', delimeter : [ ',', ' ' ] } )
 *
 * @method _strIsolate
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o ) is not a Map.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.delimeter ) is not a Array or String.
 * @throws { Exception } Throw an exception if( o ) is extended by uknown property.
 * @memberof wTools
 *
 */

function _strIsolate( o )
{
  let result = [];
  let number = o.number;
  let delimeter
  let index = o.left ? -1 : o.src.length;

  // let result = [ o.src.substring( 0,i ), o.delimeter, o.src.substring( i+o.delimeter.length,o.src.length ) ];

  _.assertRoutineOptions( _strIsolate, o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( o.src ), 'expects string {-o.src-}, got',_.strTypeOf( o.src ) );
  _.assert( _.strIs( o.delimeter ) || _.arrayIs( o.delimeter ) );
  _.assert( _.numberIs( o.number ) );

  /* */

  if( !( number >= 1 ) )
  {
    // debugger;
    return whatLeft( o.left ^ o.none );
  }

  if( _.arrayIs( o.delimeter ) && o.delimeter.length === 1 )
  o.delimeter = o.delimeter[ 0 ];

  let closest = o.left ? entityMin : entityMax;

  /* */

  while( number > 0 )
  {

    index += o.left ? +1 : -1;

    if( _.arrayIs( o.delimeter ) )
    {

      if( !o.delimeter.length )
      {
        // debugger;
        return whatLeft( o.left ^ o.none );
      }

      let c = closest( index )

      delimeter = c.element;
      index = c.value;

      if( o.number === 1 && index === o.src.length && o.left )
      index = -1;

    }
    else
    {

      delimeter = o.delimeter;
      index = o.left ? o.src.indexOf( delimeter,index ) : o.src.lastIndexOf( delimeter,index );

      if( o.left && !( index >= 0 ) && o.number > 1 )
      {
        index = o.src.length;
        break;
      }

    }

    /* */

    if( !o.left && number > 1 && index === 0  )
    {
      // debugger;
      return whatLeft( !o.none )
    }

    if( !( index >= 0 ) && o.number === 1 )
    {
      // debugger;
      return whatLeft( o.left ^ o.none )
    }

    number -= 1;

  }

  /* */

  result.push( o.src.substring( 0,index ) );
  result.push( delimeter );
  result.push( o.src.substring( index + delimeter.length ) );

  return result;

  /* */

  function whatLeft( side )
  {
    return ( side ) ? [ o.src, '', '' ] : [ '', '', o.src ];
  }

  /* */

  function entityMin( index )
  {
    return _.entityMin( o.delimeter,function( a )
    {
      let i = o.src.indexOf( a,index );
      if( i === -1 )
      return o.src.length;
      return i;
    });
  }

  /* */

  function entityMax( index )
  {
    return _.entityMax( o.delimeter,function( a )
    {
      let i = o.src.lastIndexOf( a,index );
      return i;
    });
  }

}

_strIsolate.defaults =
{
  src : null,
  delimeter : ' ',
  left : 1,
  number : 1,
  none : 1,
}

//

/**
 * Short-cut for _strIsolate function.
 * Finds occurrence of delimeter( o.delimeter ) from begining of ( o.src ) and splits string in finded position by half.
 *
 * @param {wTools~toStrInhalfOptions} o - Contains data and options {@link wTools~toStrInhalfOptions}.
 * @returns {array} Returns array with separated parts of string( o.src ) or original string if nothing finded.
 *
 * @example
 * //returns [ 'sample', 'string' ]
 * _.strIsolateBeginOrNone( { src : 'sample,string', delimeter : [ ',' ] } );
 *
 * @example
 * //returns [ 'sample', 'string' ]
 *_.strIsolateBeginOrNone( { src : 'sample string', delimeter : ' ' } )
 *
 * @example
 * //returns [ 'sample string,name', 'string' ]
 * _.strIsolateBeginOrNone( 'sample string,name string', ',' )
 *
 * @method strIsolateBeginOrNone
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o ) is not a Map.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @memberof wTools
 *
 */

function _strIsolateBeginOrNone_body( o )
{
  o.left = 1;
  o.none = 1;
  let result = _strIsolate( o );
  return result;
}

_strIsolateBeginOrNone_body.defaults =
{
  src : null,
  delimeter : ' ',
  number : 1,
}

let strIsolateBeginOrNone = _.routineForPreAndBody( _strCutOff_pre, _strIsolateBeginOrNone_body );

//

/**
 * Short-cut for _strIsolate function.
 * Finds occurrence of delimeter( o.delimeter ) from end of ( o.src ) and splits string in finded position by half.
 *
 * @param {wTools~toStrInhalfOptions} o - Contains data and options {@link wTools~toStrInhalfOptions}.
 * @returns {array} Returns array with separated parts of string( o.src ) or original string if nothing finded.
 *
 * @example
 * //returns [ 'sample', 'string' ]
 * _.strIsolateEndOrNone( { src : 'sample,string', delimeter : [ ',' ] } );
 *
 * @example
 * //returns [ 'sample', 'string' ]
 *_.strIsolateEndOrNone( { src : 'sample string', delimeter : ' ' } )
 *
 * @example
 * //returns [ 'sample, ', 'string' ]
 * _.strIsolateEndOrNone( { src : 'sample,  string', delimeter : [ ',', ' ' ] } )
 *
 * @method strIsolateEndOrNone
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o ) is not a Map.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @memberof wTools
 *
 */

function _strIsolateEndOrNone_body( o )
{
  o.left = 0;
  o.none = 1;
  let result = _strIsolate( o );
  return result;
}

_strIsolateEndOrNone_body.defaults =
{
  src : null,
  delimeter : ' ',
  number : 1,
}

let strIsolateEndOrNone = _.routineForPreAndBody( _strCutOff_pre, _strIsolateEndOrNone_body );

//

function _strIsolateEndOrAll_body( o )
{
  o.left = 0;
  o.none = 0;
  let result = _strIsolate( o );
  return result;

  // let i = o.src.lastIndexOf( o.delimeter );
  //
  // if( i === -1 )
  // return [ '', '', o.src ];
  //
  // let result = [ o.src.substring( 0,i ), o.delimeter, o.src.substring( i+o.delimeter.length,o.src.length ) ];
  //
  // return result;
}

_strIsolateEndOrAll_body.defaults =
{
  src : null,
  delimeter : ' ',
  number : 1,
}

let strIsolateEndOrAll = _.routineForPreAndBody( _strCutOff_pre, _strIsolateEndOrAll_body );

//

function _strIsolateBeginOrAll_body( o )
{
  o.left = 1;
  o.none = 0;
  let result = _strIsolate( o );
  return result;

  // let i = o.src.indexOf( o.delimeter );
  //
  // if( i === -1 )
  // return [ o.src, '', '' ];
  //
  // let result = [ o.src.substring( 0,i ), o.delimeter, o.src.substring( i+o.delimeter.length,o.src.length ) ];
  //
  // return result;
}

_strIsolateBeginOrAll_body.defaults =
{
  src : null,
  delimeter : ' ',
  number : 1,
}

let strIsolateBeginOrAll = _.routineForPreAndBody( _strCutOff_pre, _strIsolateBeginOrAll_body );

//

/**
 * Parses a source string( src ) and separates numbers and string values
 * in to object with two properties: 'str' and 'number', example of result: ( { str: 'bd', number: 1 } ).
 *
 * @param {string} src - Source string.
 * @returns {object} Returns the object with two properties:( str ) and ( number ),
 * with values parsed from source string. If a string( src ) doesn't contain number( s ),
 * function returns the object with value of string( src ).
 *
 * @example
 * //returns { str: 'bd', number: 1 }
 * _.strSplitStrNumber( 'bd1' );
 *
 * @example
 * //returns { str: 'bdxf' }
 * _.strSplitStrNumber( 'bdxf' );
 *
 * @method strSplitStrNumber
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if no argument provided.
 * @memberof wTools
 *
 */

function strSplitStrNumber( src )
{
  let result = Object.create( null );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );

  let mnumber = src.match(/\d+/);
  if( mnumber && mnumber.length )
  {
    let mstr = src.match(/[^\d]*/);
    result.str = mstr[ 0 ];
    result.number = _.numberFrom( mnumber[0] );
  }
  else
  {
    result.str = src;
  }

  return result;
}

//

function strSplitChunks( o )
{
  let result = Object.create( null );
  result.chunks = [];

  if( arguments.length === 2 )
  {
    o = arguments[ 1 ] || Object.create( null );
    o.src = arguments[ 0 ];
  }
  else
  {
    _.assert( arguments.length === 1, 'expects single argument' );
    if( _.strIs( arguments[ 0 ] ) )
    o = { src : arguments[ 0 ] };
  }

  _.routineOptions( strSplitChunks,o );
  _.assert( _.strIs( o.src ),'expects string (-o.src-), but got',_.strTypeOf( o.src ) );

  if( !_.regexpIs( o.prefix ) )
  o.prefix = RegExp( _.regexpEscape( o.prefix ),'m' );

  if( !_.regexpIs( o.postfix ) )
  o.postfix = RegExp( _.regexpEscape( o.postfix ),'m' );

  let src = o.src;

  /* */

  let line = 0;
  let column = 0;
  let chunkIndex = 0;
  let begin = -1;
  let end = -1;
  do
  {

    /* begin */

    begin = src.search( o.prefix );
    if( begin === -1 ) begin = src.length;

    /* text chunk */

    if( begin > 0 )
    makeChunkStatic( begin );

    /* break */

    if( !src )
    {
      if( !result.chunks.length )
      makeChunkStatic( 0 );
      break;
    }

    /* end */

    end = src.search( o.postfix );
    if( end === -1 )
    {
      result.lines = src.split( '\n' ).length;
      result.error = _.err( 'Openning prefix',o.prefix,'of chunk #' + result.chunks.length,'at'+line,'line does not have closing tag :',o.postfix );
      return result;
    }

    /* code chunk */

    let chunk = makeChunkDynamic();

    /* wind */

    chunkIndex += 1;
    line += _.strLinesCount( chunk.prefix + chunk.code + chunk.postfix ) - 1;

  }
  while( src );

  return result;

  /* - */

  function colAccount( text )
  {
    let i = text.lastIndexOf( '\n' );

    if( i === -1 )
    {
      column += text.length;
    }
    else
    {
      column = text.length - i;
    }

    _.assert( column >= 0 );
  }

  /* - */

  function makeChunkStatic( begin )
  {
    let chunk = Object.create( null );
    chunk.line = line;
    chunk.text = src.substring( 0,begin );
    chunk.index = chunkIndex;
    chunk.kind = 'static';
    result.chunks.push( chunk );

    src = src.substring( begin );
    line += _.strLinesCount( chunk.text ) - 1;
    chunkIndex += 1;

    colAccount( chunk.text );
  }

  /* - */

  function makeChunkDynamic()
  {
    let chunk = Object.create( null );
    chunk.line = line;
    chunk.column = column;
    chunk.index = chunkIndex;
    chunk.kind = 'dynamic';
    chunk.prefix = src.match( o.prefix )[ 0 ];
    chunk.code = src.substring( chunk.prefix.length, end );
    if( o.investigate )
    {
      chunk.lines = chunk.code.split( '\n' );
      chunk.tab = /^\s*/.exec( chunk.lines[ chunk.lines.length-1 ] )[ 0 ];
    }

    /* postfix */

    src = src.substring( chunk.prefix.length + chunk.code.length );
    chunk.postfix = src.match( o.postfix )[ 0 ];
    src = src.substring( chunk.postfix.length );

    result.chunks.push( chunk );
    return chunk;
  }

}

strSplitChunks.defaults =
{
  src : null,
  investigate : 1,
  prefix : '//>-' + '->//',
  postfix : '//<-' + '-<//',
}

//

function _strSplitsQuotedRejoin_pre( routine, args )
{
  let o = args[ 0 ];

  _.routineOptions( routine, o );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( args.length === 1, 'expects one or two arguments' );
  _.assert( _.objectIs( o ) );

  if( o.quoting )
  {

    if( _.boolLike( o.quoting ) )
    {
      if( !o.quotingPrefixes )
      o.quotingPrefixes = [ '"' ];
      if( !o.quotingPostfixes )
      o.quotingPostfixes = [ '"' ];
    }
    else if( _.strIs( o.quoting ) || _.regexpIs( o.quoting ) || _.arrayIs( o.quoting ) )
    {
      _.assert( !o.quotingPrefixes );
      _.assert( !o.quotingPostfixes );
      o.quoting = _.arrayAs( o.quoting );
      o.quotingPrefixes = o.quoting;
      o.quotingPostfixes = o.quoting;
      o.quoting = true;
    }
    else _.assert( 0, 'unexpected type of {-o.quoting-}' );

    _.assert( o.quotingPrefixes.length === o.quotingPostfixes.length );
    _.assert( _.boolLike( o.quoting ) );

  }

  return o;
}

//

function _strSplitsQuotedRejoin_body( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.splits ) );

  /* quoting */

  if( o.quoting )
  for( let s = 1 ; s < o.splits.length ; s += 1 )
  {
    let split = o.splits[ s ];
    let s2;

    let q = o.quotingPrefixes.indexOf( split );
    if( q >= 0 )
    {
      let postfix = o.quotingPostfixes[ q ];
      for( s2 = s+2 ; s2 < o.splits.length ; s2 += 1 )
      {
        let split2 = o.splits[ s2 ];
        if( split2 === postfix )
        {
          let bextra = 0;
          let eextra = 0;
          if( o.inliningQuoting )
          {
            s -= 1;
            bextra += 1;
            s2 += 1;
            eextra += 1;
          }
          let splitNew = o.splits.splice( s, s2-s+1, null );
          if( !o.preservingQuoting )
          {
            splitNew.splice( bextra, 1 );
            splitNew.splice( splitNew.length-1-eextra, 1 );
          }
          splitNew = splitNew.join( '' );
          o.splits[ s ] = splitNew;
          s2 = s;
          break;
        }
      }
    }

    /* if complementing postfix not found */

    if( s2 >= o.splits.length )
    {
      if( !_.arrayHas( o.delimeter, split ) )
      {
        let splitNew = o.splits.splice( s, 2 ).join( '' );
        o.splits[ s-1 ] = o.splits[ s-1 ] + splitNew;
      }
      else
      {
      }
    }

  }

  return o.splits;
}

_strSplitsQuotedRejoin_body.defaults =
{
  quoting : 1,
  quotingPrefixes : null,
  quotingPostfixes : null,
  preservingQuoting : 1,
  inliningQuoting : 1,
  // quotingRejoining : 0,
  splits : null,
  delimeter : null,
}

//

let strSplitsQuotedRejoin = _.routineForPreAndBody( _strSplitsQuotedRejoin_pre, _strSplitsQuotedRejoin_body );

// --
//
// --

function _strSplitsDropDelimeters_pre( routine, args )
{
  let o = args[ 0 ];

  _.routineOptions( routine, o );

  if( _.strIs( o.delimeter ) )
  o.delimeter = [ o.delimeter ];

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( args.length === 1 );
  _.assert( _.objectIs( o ) );

  return o;
}

//

function _strSplitsDropDelimeters_body( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.splits ) );

  /* stripping */

  if( o.delimeter.some( ( d ) => _.regexpIs( d ) ) )
  debugger;

  for( let s = o.splits.length-1 ; s >= 0 ; s-- )
  {
    let split = o.splits[ s ];

    if( _.regexpsTestAny( o.delimeter, split ) )
    o.splits.splice( s,1 );

    // if( _.arrayHas( o.delimeter, split ) )
    // o.splits.splice( s,1 );
    //
    // if( s % 2 === 1 )
    // o.splits.splice( s,1 );

  }

  return o.splits;
}

_strSplitsDropDelimeters_body.defaults =
{
  splits : null,
  delimeter : null,
}

//

let strSplitsDropDelimeters = _.routineForPreAndBody( _strSplitsDropDelimeters_pre, _strSplitsDropDelimeters_body );

// --
//
// --

function _strSplitsStrip_pre( routine, args )
{
  let o = args[ 0 ];

  _.routineOptions( routine, o );

  if( o.stripping && _.boolLike( o.stripping ) )
  o.stripping = _.strStrip.defaults.stripper;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( args.length === 1 );
  _.assert( _.objectIs( o ) );
  _.assert( !o.stripping || _.strIs( o.stripping ) || _.regexpIs( o.stripping ) );

  return o;
}

//

function _strSplitsStrip_body( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.splits ) );

  /* stripping */

  for( let s = 0 ; s < o.splits.length ; s++ )
  {
    let split = o.splits[ s ];

    if( o.stripping )
    split = _.strStrip({ src : split, stripper : o.stripping });

    o.splits[ s ] = split;

  }

  return o.splits;
}

_strSplitsStrip_body.defaults =
{
  stripping : 1,
  splits : null,
}

//

let strSplitsStrip = _.routineForPreAndBody( _strSplitsStrip_pre, _strSplitsStrip_body );

// --
//
// --

function _strSplitsDropEmpty_pre( routine, args )
{
  let o = args[ 0 ];

  _.routineOptions( routine, o );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( args.length === 1 );
  _.assert( _.objectIs( o ) );

  return o;
}

//

function _strSplitsDropEmpty_body( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.splits ) );

  /* stripping */

  for( let s = 0 ; s < o.splits.length ; s++ )
  {
    let split = o.splits[ s ];

    if( !split )
    {
      o.splits.splice( s,1 );
      s -= 1;
    }

  }

  return o.splits;
}

_strSplitsDropEmpty_body.defaults =
{
  splits : null,
}

//

let strSplitsDropEmpty = _.routineForPreAndBody( _strSplitsDropEmpty_pre, _strSplitsDropEmpty_body );

//

function strSplitsGroupCoupled( o )
{
  o = _.routineOptions( strSplitsGroupCoupled, arguments );

  o.prefix = _.arrayAs( o.prefix );
  o.postfix = _.arrayAs( o.postfix );

  _.assert( arguments.length === 1 );
  _.assert( _.regexpsLike( o.prefix ) );
  _.assert( _.regexpsLike( o.postfix ) );

  let level = 0;
  let begins = [];
  for( let i = 0 ; i < o.splits.length ; i++ )
  {
    let element = o.splits[ i ];

    if( _.regexpsTestAny( o.prefix, element ) )
    {
      begins.push( i );
    }
    else if( _.regexpsTestAny( o.postfix, element ) )
    {
      if( begins.length === 0 && !o.allowedUncoupledPostfix )
      throw _.err( _.strQuote( element ), 'does not have complementing openning\n' );

      if( begins.length === 0 )
      continue;

      let begin = begins.pop();
      let end = i;
      let l = end-begin;

      _.assert( l >= 0 )
      let newElement = o.splits.splice( begin, l+1, null );
      o.splits[ begin ] = newElement;

      i -= l;
    }

  }

  if( begins.length && !o.allowedUncoupledPrefix )
  throw _.err( _.strQuote( begins[ begins.length-1 ] ), 'does not have complementing closing\n' );

  return o.splits;
}

strSplitsGroupCoupled.defaults =
{
  splits : null,
  prefix : '"',
  postfix : '"',
  allowedUncoupledPrefix : 0,
  allowedUncoupledPostfix : 0,
}

// --
//
// --

function _strSplitFast_pre( routine, args )
{
  let o = args[ 0 ];

  if( args.length === 2 )
  o = { src : args[ 0 ], delimeter : args[ 1 ] }
  else if( _.strIs( args[ 0 ] ) )
  o = { src : args[ 0 ] }

  _.routineOptions( routine, o );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( args.length === 1 || args.length === 2, 'expects one or two arguments' );
  _.assert( _.strIs( o.src ) );
  _.assert( _.objectIs( o ) );

  return o;
}

//

function _strSplitFast_body( o )
{
  let result;
  let closests;
  let position;
  let closestPosition;
  let closestIndex;
  let hasEmptyDelimeter;

  o.delimeter = _.arrayAs( o.delimeter );

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.delimeter ) );
  _.assert( _.boolLike( o.preservingDelimeters ) );

  /* */

  if( !o.preservingDelimeters && o.delimeter.length === 1 )
  {

    result = o.src.split( o.delimeter[ 0 ] );

    if( !o.preservingEmpty )
    result = result.filter( ( e ) => e ? e : false );

  }
  else
  {

    if( !o.delimeter.length )
    {
      result = [ o.src ];
      return result;
    }

    result = [];
    closests = [];
    position = 0;
    closestPosition = 0;
    closestIndex = -1;
    hasEmptyDelimeter = false;

    for( let d = 0 ; d < o.delimeter.length ; d++ )
    {
      if( o.delimeter[ d ].length === 0 )
      hasEmptyDelimeter = true;
      closests[ d ] = delimeterNext( d, position );
    }

    let delimeter;

    do
    {
      closestWhich();

      if( closestPosition === o.src.length )
      break;

      delimeter = o.delimeter[ closestIndex ];

      if( !delimeter.length )
      position += 1;

      ordinaryAdd( o.src.substring( position, closestPosition ) );

      if( delimeter.length > 0 || position < o.src.length )
      delimeterAdd( delimeter );

      position = closests[ closestIndex ] + ( delimeter.length ? delimeter.length : 1 );

      for( let d = 0 ; d < o.delimeter.length ; d++ )
      if( closests[ d ] < position )
      closests[ d ] = delimeterNext( d, position );

    }
    while( position < o.src.length );

    if( delimeter || !hasEmptyDelimeter )
    ordinaryAdd( o.src.substring( position, o.src.length ) );

  }

  return result;

  /* */

  function delimeterAdd( delimeter )
  {

    if( o.preservingDelimeters )
    if( o.preservingEmpty || delimeter )
    result.push( delimeter );

  }

  /*  */

  function ordinaryAdd( ordinary )
  {
    if( o.preservingEmpty || ordinary )
    result.push( ordinary );
  }

  /* */

  function closestWhich()
  {

    closestPosition = o.src.length;
    closestIndex = -1;
    for( let d = 0 ; d < o.delimeter.length ; d++ )
    {
      if( closests[ d ] < o.src.length && closests[ d ] < closestPosition )
      {
        closestPosition = closests[ d ];
        closestIndex = d;
      }
    }

  }

  /* */

  function delimeterNext( d, position )
  {
    _.assert( position <= o.src.length );
    let result = o.src.indexOf( o.delimeter[ d ], position );
    if( result === -1 )
    return o.src.length;
    return result;
  }

}

_strSplitFast_body.defaults =
{
  src : null,
  delimeter : ' ',
  preservingEmpty : 1,
  preservingDelimeters : 1,
}

//

/**
 * Divides source string( o.src ) into parts using delimeter provided by argument( o.delimeter ).
 * If( o.stripping ) is true - removes leading and trailing whitespace characters.
 * If( o.preservingEmpty ) is true - empty lines are saved in the result array.
 * If( o.preservingDelimeters ) is true - leaves word delimeters in result array, otherwise removes them.
 * Function can be called in two ways:
 * - First to pass only source string and use default options;
 * - Second to pass map like ( { src : 'a,b,c', delimeter : ',', stripping : 1 } ).
 * Returns result as array of strings.
 *
 * @param {string|object} o - Source string to split or map with source( o.src ) and options.
 * @param {string} [ o.src=null ] - Source string.
 * @param {string|array} [ o.delimeter=' ' ] - Word divider in source string.
 * @param {boolean} [ o.preservingEmpty=false ] - Leaves empty strings in the result array.
 * @param {boolean} [ o.preservingDelimeters=false ] - Puts delimeters into result array in same order how they was in the source string.
 * @param {boolean} [ o.stripping=true ] - Removes leading and trailing whitespace characters occurrences from source string.
 * @returns {object} Returns an array of strings separated by( o.delimeter ).
 *
 * @example
 * //returns [ 'first', 'second', 'third' ]
 * _.strSplitFast( ' first second third ' );
 *
 * @example
 * //returns [ 'a', 'b', 'c', 'd' ]
 * _.strSplitFast( { src : 'a,b,c,d', delimeter : ','  } );
 *
 * @example
 * //returns [ 'a', 'b', 'c', 'd' ]
 * _.strSplitFast( { src : 'a.b,c.d', delimeter : [ '.', ',' ]  } );
 *
 * @example
 * //returns [ '    a', 'b', 'c', 'd   ' ]
   * _.strSplitFast( { src : '    a,b,c,d   ', delimeter : [ ',' ], stripping : 0  } );
 *
 * @example
 * //returns [ 'a', ',', 'b', ',', 'c', ',', 'd' ]
 * _.strSplitFast( { src : 'a,b,c,d', delimeter : [ ',' ], preservingDelimeters : 1  } );
 *
 * @example
 * //returns [ 'a', '', 'b', '', 'c', '', 'd' ]
 * _.strSplitFast( { src : 'a ., b ., c ., d', delimeter : [ ',', '.' ], preservingEmpty : 1  } );
 *
 * @method strSplitFast
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1 or 2.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.delimeter ) is not a String or an Array.
 * @throws { Exception } Throw an exception if object( o ) has been extended by invalid property.
 * @memberof wTools
 *
 */

let strSplitFast = _.routineForPreAndBody( _strSplitFast_pre, _strSplitFast_body );

_.assert( strSplitFast.pre === _strSplitFast_pre );
_.assert( strSplitFast.body === _strSplitFast_body );
_.assert( _.objectIs( strSplitFast.defaults ) );

//

function _strSplit_body( o )
{

  o.delimeter = _.arrayAs( o.delimeter );

  if( !o.stripping && !o.quoting && !o.onDelimeter )
  {
    return _.strSplitFast.body( _.mapOnly( o, _.strSplitFast.defaults ) );
  }

  /* */

  _.assert( arguments.length === 1 );

  /* */

  let result = [];
  let fastOptions = _.mapOnly( o, _.strSplitFast.defaults );
  fastOptions.preservingEmpty = 1;
  fastOptions.preservingDelimeters = 1;

  if( o.quoting )
  fastOptions.delimeter = _.arrayPrependArraysOnce( [], [ o.quotingPrefixes, o.quotingPostfixes, fastOptions.delimeter ] );

  o.splits = _.strSplitFast.body( fastOptions );

  if( o.quoting )
  _.strSplitsQuotedRejoin.body( o );

  if( !o.preservingDelimeters )
  _.strSplitsDropDelimeters.body( o );

  if( o.stripping )
  _.strSplitsStrip.body( o );

  if( !o.preservingEmpty )
  _.strSplitsDropEmpty.body( o );

  /* */

  return o.splits;
}

var defaults = _strSplit_body.defaults = Object.create( _strSplitFast_body.defaults );

defaults.preservingEmpty = 1;
defaults.preservingDelimeters = 1;
defaults.preservingQuoting = 1;
defaults.inliningQuoting = 1;

defaults.stripping = 1;
defaults.quoting = 1;
// defaults.quotingRejoining = 0;
defaults.quotingPrefixes = null;
defaults.quotingPostfixes = null;

defaults.onDelimeter = null;
defaults.onQuote = null;

//

/**
 * Divides source string( o.src ) into parts using delimeter provided by argument( o.delimeter ).
 * If( o.stripping ) is true - removes leading and trailing whitespace characters.
 * If( o.preservingEmpty ) is true - empty lines are saved in the result array.
 * If( o.preservingDelimeters ) is true - leaves word delimeters in result array, otherwise removes them.
 * Function can be called in two ways:
 * - First to pass only source string and use default options;
 * - Second to pass map like ( { src : 'a,b,c', delimeter : ',', stripping : 1 } ).
 * Returns result as array of strings.
 *
 * @param {string|object} o - Source string to split or map with source( o.src ) and options.
 * @param {string} [ o.src=null ] - Source string.
 * @param {string|array} [ o.delimeter=' ' ] - Word divider in source string.
 * @param {boolean} [ o.preservingEmpty=false ] - Leaves empty strings in the result array.
 * @param {boolean} [ o.preservingDelimeters=false ] - Puts delimeters into result array in same order how they was in the source string.
 * @param {boolean} [ o.stripping=true ] - Removes leading and trailing whitespace characters occurrences from source string.
 * @returns {object} Returns an array of strings separated by( o.delimeter ).
 *
 * @example
 * //returns [ 'first', 'second', 'third' ]
 * _.strSplit( ' first second third ' );
 *
 * @example
 * //returns [ 'a', 'b', 'c', 'd' ]
 * _.strSplit( { src : 'a,b,c,d', delimeter : ','  } );
 *
 * @example
 * //returns [ 'a', 'b', 'c', 'd' ]
 * _.strSplit( { src : 'a.b,c.d', delimeter : [ '.', ',' ]  } );
 *
 * @example
 * //returns [ '    a', 'b', 'c', 'd   ' ]
   * _.strSplit( { src : '    a,b,c,d   ', delimeter : [ ',' ], stripping : 0  } );
 *
 * @example
 * //returns [ 'a', ',', 'b', ',', 'c', ',', 'd' ]
 * _.strSplit( { src : 'a,b,c,d', delimeter : [ ',' ], preservingDelimeters : 1  } );
 *
 * @example
 * //returns [ 'a', '', 'b', '', 'c', '', 'd' ]
 * _.strSplit( { src : 'a ., b ., c ., d', delimeter : [ ',', '.' ], preservingEmpty : 1  } );
 *
 * @method strSplit
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1 or 2.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.delimeter ) is not a String or an Array.
 * @throws { Exception } Throw an exception if object( o ) has been extended by invalid property.
 * @memberof wTools
 *
 */

let pre = [ strSplitFast.pre, strSplitsQuotedRejoin.pre, strSplitsDropDelimeters.pre, strSplitsStrip.pre, strSplitsDropEmpty.pre ];
let strSplit = _.routineForPreAndBody( pre, _strSplit_body );

_.assert( strSplit.pre !== strSplitFast.pre );
_.assert( _.routineIs( strSplit.pre ) );
_.assert( strSplit.body === _strSplit_body );
_.assert( _.objectIs( strSplit.defaults ) );

//

let strSplitNonPreserving = _.routineForPreAndBody( strSplit.pre, strSplit.body );

var defaults = strSplitNonPreserving.defaults;

defaults.preservingEmpty = 0
defaults.preservingDelimeters = 0;

//

function _strSplitNaive_body( o )
{

  if( o.quoting )
  {
    if( _.numberIs( o.quoting ) || _.boolIs( o.quoting ) )
    o.quoting = '\"';
    if( o.preservingDelimeters === null || o.preservingDelimeters === undefined )
    o.preservingDelimeters = 1;
    _.assert( _.strIs( o.quoting ) );
  }

  _.assert( arguments.length === 1 );

  o.delimeter = _.arrayAs( o.delimeter );
  let delimeter = o.delimeter;
  let preservingDelimeters = o.preservingDelimeters;
  let preservingEmpty = o.preservingEmpty;
  let result = [];

  if( o.quoting )
  {
    if( o.preservingDelimeters === null )
    o.preservingDelimeters = 1;
    _.assert( o.preservingDelimeters );
    _.arrayAppendOnce( delimeter, o.quoting );
  }

  if( o.preservingDelimeters === null )
  o.preservingDelimeters = 0;

  /* */

  if( o.preservingDelimeters )
  {

    let right = [];
    let prevPosition = o.src.length;

    for( let s = 0 ; s < delimeter.length ; s++ )
    right[ s ] = nextDelimeter( s,o.src.length );

    while( true )
    {
      let splitterIndex = -1;
      let position = -1;
      for( let s = 0 ; s < delimeter.length ; s++ )
      {
        /* if one delimeter coontain another one, it's possible right is invalid at this point */
        if( right[ s ] >= prevPosition )
        {
          right[ s ] = nextDelimeter( s,prevPosition-delimeter[ s ].length );
        }
        if( right[ s ] > position )
        {
          splitterIndex = s;
          position = right[ s ];
        }
      }

      if( position === -1 )
      break;

      if( right[ splitterIndex ] > 0 )
      right[ splitterIndex ] = nextDelimeter( splitterIndex,right[ splitterIndex ]-delimeter[ splitterIndex ].length*2 );
      else
      right[ splitterIndex ] = -1;

      let r = [ position,prevPosition ];
      if( r[ 0 ] < r[ 1 ] )
      result.unshift( o.src.substring( r[ 0 ],r[ 1 ] ) );
      else
      result.unshift( '' );

      if( delimeter[ splitterIndex ].length )
      result.unshift( delimeter[ splitterIndex ] );

      prevPosition = position-delimeter[ splitterIndex ].length;

    }

    result.unshift( o.src.substring( 0,prevPosition ) );

  }
  else
  {

    result = o.src.split( delimeter[ 0 ] );
    for( let s = 1 ; s < delimeter.length ; s++ )
    {

      for( let r = result.length-1 ; r >= 0 ; r-- )
      {

        let sub = result[ r ].split( delimeter[ s ] );
        if( sub.length > 1 )
        _.arrayCutin( result,[ r,r+1 ],sub );

      }

    }

  }

  /* quoting */

  if( o.quoting )
  {
    let newResult = [];

    function _sliceAndJoin( l, r )
    {
      let arr = result.slice( l,r );
      let res = '';
      for( let i = 0; i < arr.length; i++ )
      {
        res += arr[ i ];
      }
      return res;
    }

    let l = -1;
    let r = -1;

    for( let i = 0; i < result.length; i++ )
    {
      if( result[ i ] === o.quoting )
      {
        if( i === result.length - o.quoting.length )
        if( l < 0 )
        {
          newResult[ newResult.length - 1 ] += o.quoting;
          break;
        }

        if( l < 0 )
        l = i;
        else
        r = i;
      }
      else if( !result[ i ].length )
      {
        if( !preservingEmpty )
        continue;

        if( result[ i + 1 ] === o.quoting || result[ i - 1 ] === o.quoting )
        continue;
      }
      else if( _.arrayHas( o.delimeter, result[ i ] ) )
      {
        if( !preservingDelimeters )
        continue;
      }

      if( l >= 0 && r >= 0 )
      {
        newResult.push( _sliceAndJoin( l + 1, r ) );
        l = r = -1;
      }
      else
      if( l < 0 && r < 0 )
      newResult.push( result[ i ] );
    }

    result = newResult;
  }

  /* stripping and removing empty */

  for( let r = result.length-1 ; r >= 0 ; r-- )
  {

    if( o.stripping )
    result[ r ] = _.strStrip( result[ r ] );

    if( !o.preservingEmpty )
    if( !result[ r ] )
    result.splice( r,1 );

  }

  return result;

  /* */

  function nextDelimeter( d,last )
  {
    if( last < 0 )
    return last;
    let result = o.src.lastIndexOf( delimeter[ d ],last );
    if( result >= 0 )
    result += delimeter[ d ].length;
    return result;
  }

}

_strSplitNaive_body.defaults =
{
  src : null,
  delimeter : ' ',
  stripping : 1,
  quoting : 0,
  preservingEmpty : 0,
  preservingDelimeters : null,
}

//

/**
 * Divides source string( o.src ) into parts using delimeter provided by argument( o.delimeter ).
 * If( o.stripping ) is true - removes leading and trailing whitespace characters.
 * If( o.preservingEmpty ) is true - empty lines are saved in the result array.
 * If( o.preservingDelimeters ) is true - leaves word delimeters in result array, otherwise removes them.
 * Function can be called in two ways:
 * - First to pass only source string and use default options;
 * - Second to pass map like ( { src : 'a,b,c', delimeter : ',', stripping : 1 } ).
 * Returns result as array of strings.
 *
 * @param {string|object} o - Source string to split or map with source( o.src ) and options.
 * @param {string} [ o.src=null ] - Source string.
 * @param {string|array} [ o.delimeter=' ' ] - Word divider in source string.
 * @param {boolean} [ o.preservingEmpty=false ] - Leaves empty strings in the result array.
 * @param {boolean} [ o.preservingDelimeters=false ] - Puts delimeters into result array in same order how they was in the source string.
 * @param {boolean} [ o.stripping=true ] - Removes leading and trailing whitespace characters occurrences from source string.
 * @returns {object} Returns an array of strings separated by( o.delimeter ).
 *
 * @example
 * //returns [ 'first', 'second', 'third' ]
 * _.strSplitNaive( ' first second third ' );
 *
 * @example
 * //returns [ 'a', 'b', 'c', 'd' ]
 * _.strSplitNaive( { src : 'a,b,c,d', delimeter : ','  } );
 *
 * @example
 * //returns [ 'a', 'b', 'c', 'd' ]
 * _.strSplitNaive( { src : 'a.b,c.d', delimeter : [ '.', ',' ]  } );
 *
 * @example
 * //returns [ '    a', 'b', 'c', 'd   ' ]
   * _.strSplitNaive( { src : '    a,b,c,d   ', delimeter : [ ',' ], stripping : 0  } );
 *
 * @example
 * //returns [ 'a', ',', 'b', ',', 'c', ',', 'd' ]
 * _.strSplitNaive( { src : 'a,b,c,d', delimeter : [ ',' ], preservingDelimeters : 1  } );
 *
 * @example
 * //returns [ 'a', '', 'b', '', 'c', '', 'd' ]
 * _.strSplitNaive( { src : 'a ., b ., c ., d', delimeter : [ ',', '.' ], preservingEmpty : 1  } );
 *
 * @method strSplitNaive
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1 or 2.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.delimeter ) is not a String or an Array.
 * @throws { Exception } Throw an exception if object( o ) has been extended by invalid property.
 * @memberof wTools
 *
 */

let strSplitNaive = _.routineForPreAndBody( _strSplitFast_pre, _strSplitNaive_body );

_.assert( strSplitNaive.pre === _strSplitFast_pre );
_.assert( strSplitNaive.body === _strSplitNaive_body );
_.assert( _.objectIs( strSplitNaive.defaults ) );

// --
// extractor
// --

function strSub( srcStr, range )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( srcStr ) );
  _.assert( _.rangeIs( range ) );

  return srcStr.substring( range[ 0 ], range[ 1 ] );
}

//

function _strExtractInlined_body( o )
{

  _.assert( arguments.length === 1, 'expects single options map' );

  if( o.delimeter === null )
  o.delimeter = '#';

  let splitArray = _.strSplit
  ({
    src : o.src,
    delimeter : o.delimeter,
    stripping : o.stripping,
    quoting : o.quoting,
    preservingEmpty : 1,
    preservingDelimeters : 1,
  });

  if( splitArray.length <= 1 )
  {
    if( !o.preservingEmpty )
    if( splitArray[ 0 ] === '' )
    splitArray.splice( 0,1 );
    return splitArray;
  }

  /*
  first - for tracking index to insert ordinary text
  onInlined should be called first and
  if undefined returned escaped text shoud be treated as ordinary
  so tracking index to insert ordinary text ( in case not undefined returned ) required
  */

  let first = 0;
  let result = [];
  let i = 0;
  for( ; i < splitArray.length ; i += 4 )
  {

    if( splitArray.length-i >= 4 )
    {
      if( handleTriplet() )
      handleOrdinary();
    }
    else
    {
      if( splitArray.length > i+1 )
      {
        splitArray[ i ] = splitArray.slice( i, splitArray.length ).join( '' );
        splitArray.splice( i+1, splitArray.length-i-1 );
      }
      handleOrdinary();
      _.assert( i+1 === splitArray.length, 'Openning delimeter', o.delimeter, 'does not have closing' );
    }

  }

  return result;

  /* */

  function handleTriplet()
  {

    let delimeter1 = splitArray[ i+1 ];
    let escaped = splitArray[ i+2 ];
    let delimeter2 = splitArray[ i+3 ];

    if( o.onInlined )
    escaped = o.onInlined( escaped, o, [ delimeter1, delimeter2 ] );

    if( escaped === undefined )
    {
      _.assert( _.strIs( splitArray[ i+4 ] ) );
      splitArray[ i+2 ] = splitArray[ i+0 ] + splitArray[ i+1 ] + splitArray[ i+2 ];
      splitArray.splice( i,2 );
      i -= 4;
      return false;
    }

    first = result.length;

    if( o.preservingDelimeters && delimeter1 !== undefined )
    if( o.preservingEmpty || delimeter1 )
    result.push( delimeter1 );

    if( o.preservingInlined && escaped !== undefined )
    if( o.preservingEmpty || escaped )
    result.push( escaped );

    if( o.preservingDelimeters && delimeter2 !== undefined )
    if( o.preservingEmpty || delimeter2 )
    result.push( delimeter2 );

    return true;
  }

  /* */

  function handleOrdinary()
  {
    let ordinary = splitArray[ i+0 ];

    if( o.onOrdinary )
    ordinary = o.onOrdinary( ordinary, o );

    if( o.preservingOrdinary && ordinary !== undefined )
    if( o.preservingEmpty || ordinary )
    result.splice( first, 0, ordinary );

    first = result.length;
  }

}

_strExtractInlined_body.defaults =
{

  src : null,
  delimeter : null,
  // delimeterLeft : null,
  // delimeterRight : null,
  stripping : 0,
  quoting : 0,

  onOrdinary : null,
  onInlined : ( e ) => [ e ],

  preservingEmpty : 1,
  preservingDelimeters : 0,
  preservingOrdinary : 1,
  preservingInlined : 1,

}

//

let strExtractInlined = _.routineForPreAndBody( _strSplitFast_pre, _strExtractInlined_body );

//

function _strExtractInlinedStereo_body( o )
{

  _.assert( arguments.length === 1, 'expects single options map argument' );

  let splitArray = _.strSplit
  ({
    src : o.src,
    delimeter : o.prefix,
    stripping : o.stripping,
    quoting : o.quoting,
    preservingEmpty : 1,
    preservingDelimeters : 0,
  });

  if( splitArray.length <= 1 )
  {
    if( !o.preservingEmpty )
    if( splitArray[ 0 ] === '' )
    splitArray.splice( 0,1 );
    return splitArray;
  }

  let result = [];

  /* */

  if( splitArray[ 0 ] )
  result.push( splitArray[ 0 ] );

  /* */

  for( let i = 1; i < splitArray.length; i++ )
  {
    let halfs = _.strIsolateBeginOrNone( splitArray[ i ], o.postfix );

    _.assert( halfs.length === 3 );

    let inlined = halfs[ 2 ];

    inlined = o.onInlined ? o.onInlined( inlined ) : inlined;

    if( inlined !== undefined )
    {
      result.push( halfs[ 0 ] );
      result.push( inlined );
      // if( inlined[ 2 ] )
      // result.push( inlined[ 2 ] );
    }
    else
    {
      if( result.length )
      debugger;
      else
      debugger;
      if( result.length )
      result[ result.length-1 ] += o.prefix + splitArray[ i ];
      else
      result.push( o.prefix + splitArray[ i ] );
    }

  }

  return result;
}

_strExtractInlinedStereo_body.defaults =
{
  src : null,

  prefix : '#',
  postfix : '#',
  stripping : 0,
  quoting : 0,

  onInlined : null,

  preservingEmpty : 1,
  preservingDelimeters : 0,
  preservingOrdinary : 1,
  preservingInlined : 1,

}

//

/**
 * Extracts words enclosed by prefix( o.prefix ) and postfix( o.postfix ) delimeters
 * Function can be called in two ways:
 * - First to pass only source string and use default options;
 * - Second to pass source string and options map like ( { prefix : '#', postfix : '#' } ) as function context.
 *
 * Returns result as array of strings.
 *
 * Function extracts words in two attempts:
 * First by splitting source string by ( o.prefix ).
 * Second by splitting each element of the result of first attempt by( o.postfix ).
 * If splitting by ( o.prefix ) gives only single element then second attempt is skipped,otherwise function
 * splits all elements except first by ( o.postfix ) into two halfs and calls provided ( o.onInlined ) function on first half.
 * If result of second splitting( by o.postfix ) is undefined function appends value of element from first splitting attempt
 * with ( o.prefix ) prepended to the last element of result array.
 *
 * @param {string} src - Source string.
 * @param {object} o - Options map.
 * @param {string} [ o.prefix = '#' ] - delimeter that marks begining of enclosed string
 * @param {string} [ o.postfix = '#' ] - delimeter that marks ending of enclosed string
 * @param {string} [ o.onInlined = null ] - function called on each splitted part of a source string
 * @returns {object} Returns an array of strings separated by( o.delimeter ).
 *
 * @example
 * _.strExtractInlinedStereo( '#abc#' );
 * //returns [ '', 'abc', '' ]
 *
 * @example
 * _.strExtractInlinedStereo.call( { prefix : '#', postfix : '$' }, '#abc$' );
 * //returns [ 'abc' ]
 *
 * @example
 * function onInlined( strip )
 * {
 *   if( strip.length )
 *   return strip.toUpperCase();
 * }
 * _.strExtractInlinedStereo.call( { postfix : '$', onInlined : onInlined }, '#abc$' );
 * //returns [ 'ABC' ]
 *
 * @method strExtractInlinedStereo
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 1 or 2.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.delimeter ) is not a String or an Array.
 * @throws { Exception } Throw an exception if object( o ) has been extended by invalid property.
 * @memberof wTools
 *
 */

// let strExtractInlinedStereo = _.routineForPreAndBody( _strSplitFast_pre, _strExtractInlinedStereo_body );

function strExtractInlinedStereo( o )
{

  if( _.strIs( o ) )
  o = { src : o }

  _.assert( this === _ );
  _.assert( _.strIs( o.src ) );
  _.assert( _.objectIs( o ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( strExtractInlinedStereo, o );

  let result = [];
  let splitted = o.src.split( o.prefix );

  if( splitted.length === 1 )
  return splitted;

  /* */

  if( splitted[ 0 ] )
  result.push( splitted[ 0 ] );

  /* */

  for( let i = 1; i < splitted.length; i++ )
  {
    let halfs = _.strIsolateBeginOrNone( splitted[ i ],o.postfix );
    let strip = o.onInlined ? o.onInlined( halfs[ 0 ] ) : halfs[ 0 ];

    _.assert( halfs.length === 3 );

    if( strip !== undefined )
    {
      result.push( strip );
      if( halfs[ 2 ] )
      result.push( halfs[ 2 ] );
    }
    else
    {
      if( result.length )
      debugger;
      else
      debugger;
      if( result.length )
      result[ result.length-1 ] += o.prefix + splitted[ i ];
      else
      result.push( o.prefix + splitted[ i ] );
    }

  }

  return result;
}

strExtractInlinedStereo.defaults =
{
  src : null,
  prefix : '#',
  postfix : '#',
  onInlined : null,
}

// --
// joiner
// --

/**
 * Appends string to it itself n-times.
 * Expects two object: source string( s ) and number of concatenations( times ).
 *
 * @param {string} s - Source string.
 * @param {number} times - Number of concatenation cycles.
 * @returns {String} Returns a string concatenated n-times.
 *
 * @example
 * //returns WordWordWordWordWord
 * _.strDup( 'Word',5 );
 *
 * @example
 * //returns 1 21 2
 * _.strDup( '1 '+'2',2 );
 *
 * @method strDup
 * @throws { Exception } Throw an exception if( s ) is not a String.
 * @throws { Exception } Throw an exception if( times ) is not a Number.
 * @throws { Exception } Throw an exception if( arguments.length ) is not equal 2.
 * @memberof wTools
 *
 */

function _strDup( s,times )
{
  let result = '';

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( s ) );
  _.assert( _.numberIs( times ) );

  for( let t = 0 ; t < times ; t++ )
  result += s;

  return result;
}

//

/**
 * Joins objects from arguments list together by concatenating their values in orded that they are specified.
 * Function works with strings,numbers and arrays. If any arrays are provided they must have same length.
 * Joins arrays by concatenating all elements with same index into one string and puts it into new array at same position.
 * Joins array with other object by concatenating each array element with that object value. Examples: ( [ 1, 2 ], 3 ) -> ( [ '13', '23' ] ),
 * ( [ 1, 2 ], [ 1, 2] ) -> ( [ '11', '23' ] ).
 *
 * @param {array-like} arguments - Contains provided objects.
 * @returns {object} Returns concatenated objects as string or array. Return type depends from arguments type.
 *
 * @example
 * //returns '123'
 * _.strJoin( 1, 2, 3 );
 *
 * @example
 * //returns [ '12', '22', '32' ]
 * _.strJoin( [ 1, 2, 3 ], 2 );
 *
 * @example
 * //returns [ '11', '23' ]
 * _.strJoin( [ 1, 2 ], [ 1, 3 ] );
 *
 * @example
 * //returns [ '1236', '1247', '1258' ]
 * _.strJoin( 1, 2, [ 3, 4, 5 ], [ 6, 7, 8 ] );
 *
 * @method strJoin
 * @throws { Exception } If some object from( arguments ) is not a Array, String or Number.
 * @throws { Exception } If length of arrays passed as arguments is different.
 * @memberof wTools
 *
 */

function strJoin()
{
  let result = [ '' ];
  let arrayEncountered = 0;
  let arrayLength;

  function join( s,src )
  {
    result[ s ] += src;
  }

  /**/

  for( let a = 0 ; a < arguments.length ; a++ )
  {
    let src = arguments[ a ];

    _.assert( _.strIs( src ) || _.numberIs( src ) || _.arrayIs( src ) );

    if( _.arrayIs( src ) )
    {

      if( arrayEncountered === 0 )
      for( let s = 1 ; s < src.length ; s++ )
      result[ s ] = result[ 0 ];

      _.assert( arrayLength === undefined || arrayLength === src.length, 'strJoin : all arrays should has same length' );
      arrayLength = src.length;

      arrayEncountered = 1;
      for( let s = 0 ; s < src.length ; s++ )
      join( s,src[ s ] );

    }
    else
    {

      for( let s = 0 ; s < result.length ; s++ )
      join( s,src );

    }

  }

  if( arrayEncountered )
  return result;
  else
  return result[ 0 ];

}

//

function strConcat( srcs, o )
{

  o = _.routineOptions( strConcat, o || Object.create( null ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( this.strConcat === strConcat );
  o.optionsForToStr = _.mapSupplement( null, o.optionsForToStr, strConcat.defaults.optionsForToStr );

  if( !_.arrayLike( srcs ) )
  srcs = [ srcs ];

  let result = '';
  if( !srcs.length )
  return result;

  /* */

  let nl = 1;
  for( let a = 0 ; a < srcs.length ; a++ )
  {
    let src = srcs[ a ];
    src = _.toStr( src,o.optionsForToStr );
    if( !nl )
    {
      let i = src.lastIndexOf( o.lineDelimter );
      if( i === -1 )
      {
        result += o.delimeter;
      }
      else
      {
        if( i !== 0 )
        result += o.lineDelimter;
      }
    }
    if( src.length )
    nl = src[ src.length-1 ] === o.lineDelimter;
    result += src;
  }

  /* */

  if( o.linePrefix || o.linePostfix )
  {
    result = result.split( o.lineDelimter );
    result = o.linePrefix + result.join( o.linePostfix + o.lineDelimter + o.linePrefix ) + o.linePostfix;
  }

  /* */

  return result;
}

strConcat.defaults =
{
  linePrefix : '',
  linePostfix : '',
  lineDelimter : '\n',
  delimeter : ' ',
  optionsForToStr :
  {
    stringWrapper : '',
  },
}

//

/**
 * Splits string( srcStr ) into parts using array( maskArray ) as mask and returns them as array.
 * Mask( maskArray ) contains string(s) separated by marker( strUnjoin.any ). Mask must starts/ends with first/last letter from source
 * or can be replaced with marker( strUnjoin.any ). Position of( strUnjoin.any ) determines which part of source string will be splited:
 * - If( strUnjoin.any ) is before string it marks everything before that string. Example: ( [ _.strUnjoin.any, 'postfix' ] ).
 * - If( strUnjoin.any ) is after string it marks everything after that string. Example: ( [ 'prefix', _.strUnjoin.any ] ).
 * - If( strUnjoin.any ) is between two strings it marks everything between them. Example: ( [ 'prefix', _.strUnjoin.any, 'postfix' ] ).
 * - If( strUnjoin.any ) is before and after string it marks all except that string. Example: ( [ '_.strUnjoin.any', something, '_.strUnjoin.any' ] ).
 *
 * @param {string} srcStr - Source string.
 * @param {array} maskArray - Contains mask for source string.
 * @returns {array} Returns array with unjoined string part.
 *
 * @example
 * //returns [ 'prefix', '_something_', 'postfix' ]
 * _.strUnjoin( 'prefix_something_postfix',[ 'prefix', _.strUnjoin.any, 'postfix' ] );
 *
 * @example
 * //returns [ 'prefix_', 'something', '_', 'postfix' ]
 * _.strUnjoin( 'prefix_something_postfix',[ _.strUnjoin.any, 'something', _.strUnjoin.any, 'postfix' ] );
 *
 * @example
 * //returns [ 'prefix_something_', 'postfix' ]
 * _.strUnjoin( 'prefix_something_postfix',[ _.strUnjoin.any, 'postfix' ] );
 *
 * @example
 * //returns [ 'prefix', '_something_postfix' ]
 * _.strUnjoin( 'prefix_something_postfix', [ 'prefix', _.strUnjoin.any ] );
 *
 * @example
 * //returns [ 'prefi', 'x', '_something_', 'p', 'ostfix' ]
 * _.strUnjoin( 'prefix_something_postfix', [ _.strUnjoin.any, 'x', _.strUnjoin.any, 'p', _.strUnjoin.any ] );
 *
 * @method strUnjoin
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( srcStr ) is not a String.
 * @throws { Exception } If( maskArray ) is not a Array.
 * @throws { Exception } If( maskArray ) value is not String or strUnjoin.any.
 * @memberof wTools
 *
 */

function strUnjoin( srcStr, maskArray )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( srcStr ) );
  _.assert( _.arrayIs( maskArray ) );

  let result = [];
  let index = 0;
  let rindex = -1;

  /**/

  for( let m = 0 ; m < maskArray.length ; m++ )
  {

    let mask = maskArray[ m ];

    if( !checkMask( mask ) )
    return;

  }

  if( rindex !== -1 )
  {
    index = srcStr.length;
    if( !checkToken() )
    return;
  }

  if( index !== srcStr.length )
  return;

  /**/

  return result;

  /**/

  function checkToken()
  {

    if( rindex !== -1 )
    {
      _.assert( rindex <= index );
      result.push( srcStr.substring( rindex,index ) );
      rindex = -1;
      return true;
    }

    return false;
  }

  /**/

  function checkMask( mask )
  {

    _.assert( _.strIs( mask ) || mask === strUnjoin.any , 'expects string or strUnjoin.any, got' , _.strTypeOf( mask ) );

    if( _.strIs( mask ) )
    {
      index = srcStr.indexOf( mask,index );

      if( index === -1 )
      return false;

      if( rindex === -1 && index !== 0 )
      return false;

      checkToken();

      result.push( mask );
      index += mask.length;

    }
    else if( mask === strUnjoin.any )
    {
      rindex = index;
    }
    else _.assert( 0, 'unexpected mask' );

    return true;
  }

}

strUnjoin.any = _.any;
_.assert( _.routineIs( strUnjoin.any ) );

// --
// liner
// --

/**
 * Adds indentation character(s) to passed string.
 * If( src ) is a multiline string, function puts indentation character( tab ) before first
 * and every next new line in a source string( src ).
 * If( src ) represents single line, function puts indentation at the begining of the string.
 * If( src ) is a Array, function prepends indentation character( tab ) to each line( element ) of passed array.
 *
 * @param { String/Array } src - Source string to parse or array of lines( not array of texts ).
 * With line we mean it does not have eol. Otherwise please join the array to let the routine to resplit the text,
 * like that: _.strIndentation( array.join( '\n' ), '_' ).
 * @param { String } tab - Indentation character.
 * @returns { String } Returns indented string.
 *
 * @example
 *  _.strIndentation( 'abc', '_' )
 * //returns '_abc'
 *
 * @example
 * _.strIndentation( 'a\nb\nc', '_' )
 * //returns
 * _a
 * _b
 * _c
 *
 * @example
 * _.strIndentation( [ 'a', 'b', 'c' ], '_' )
 * //returns
 * _a
 * _b
 * _c
 *
 * @example
 * let array = [ 'a\nb', 'c\nd' ];
 * _.strIndentation( array.join( '\n' ), '_' )
 * //returns
 * _a
 * _b
 * _c
 * _d
 *
 * @method strIndentation
 * @throws { Exception } Throw an exception if( src ) is not a String or Array.
 * @throws { Exception } Throw an exception if( tab ) is not a String.
 * @throws { Exception } Throw an exception if( arguments.length ) is not a equal 2.
 * @memberof wTools
 *
 */

function strIndentation( src,tab )
{

  _.assert( _.strIs( src ) || _.arrayIs( src ),'strIndentation : expects src as string or array' );
  _.assert( _.strIs( tab ),'strIndentation : expects string tab' );
  _.assert( arguments.length === 2,'strIndentation : expects two arguments' );

  if( _.strIs( src ) )
  {

    if( src.indexOf( '\n' ) === -1 )
    return tab + src;

    src = src.split( '\n' );

  }

  let result = tab + src.join( '\n' + tab );

  return result;
}

//

function strLinesSplit( src )
{
  _.assert( _.strIs( src ) || _.arrayIs( src ) );
  if( _.arrayIs( src ) )
  return src;
  return src.split( '\n' );
}

//

/**
 * Puts line counter before each line/element of provided source( o.src ).
 * If( o.src ) is a string, function splits it into array using new line as splitter, then puts line counter at the begining of each line( element ).
 * If( o.src ) is a array, function puts line counter at the begining of each line( element ).
 * Initial value of a counter can be changed by defining( o.first ) options( o ) property.
 * Can be called in two ways:
 * - First by passing all options in one object;
 * - Second by passing source only and using default value of( first ).
 *
 * @param { Object } o - options.
 * @param { String/Array } [ o.src=null ] - Source string or array of lines( not array of texts ).
 * With line we mean it does not have eol. Otherwise please join the array to let the routine to resplit the text,
 * like that: _.strLinesNumber( array.join( '\n' ) ).
 * @param { Number} [ o.first=1 ] - Sets initial value of a counter.
 * @returns { String } Returns string with line enumeration.
 *
 * @example
 * _.strLinesNumber( 'line' );
 * //returns '1 : line'
 *
 * @example
 * _.strLinesNumber( 'line1\nline2\nline3' );
 * //returns
 * // 1: line1
 * // 2: line2
 * // 3: line3
 *
 * @example
 * _.strLinesNumber( [ 'line', 'line', 'line' ] );
 * //returns
 * // 1: line1
 * // 2: line2
 * // 3: line3
 *
 * @example
 * _.strLinesNumber( { src:'line1\nline2\nline3', first : 2 } );
 * //returns
 * // 2: line1
 * // 3: line2
 * // 4: line3
 *
 * @method strLinesNumber
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o.src ) is not a String or Array.
 * @memberof wTools
 */

function strLinesNumber( o )
{

  if( !_.objectIs( o ) )
  o = { src : arguments[ 0 ], first : arguments[ 1 ] };

  _.routineOptions( strLinesNumber,o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( o.src ) || _.strsAre( o.src ),'expects string or strings {-o.src-}' );

  let lines = _.strIs( o.src ) ? o.src.split( '\n' ) : o.src;

  if( o.onLine ) for( let l = 0; l < lines.length; l += 1 )
  {
    lines[ l ] = o.onLine( [ ( l + o.first ), ' : ', lines[ l ] ], o );
    if( lines[ l ] === undefined )
    {
      lines.splice( l,1 );
      l -= 1;
    }
    _.assert( _.strIs( lines[ l ] ) );
  }
  else for( let l = 0; l < lines.length; l += 1 )
  {
    lines[ l ] = ( l + o.first ) + ' : ' + lines[ l ];
  }

  return lines.join( '\n' );
}

strLinesNumber.defaults =
{
  src : null,
  first : 1,
  onLine : null,
}

//

// function strLinesAt( code,line,radius )
// {
//   _.assert( arguments.length === 3, 'expects exactly three argument' );
//   _.assert( _.strIs( code ) || _.arrayIs( code ) );
//   _.assert( _.numberIs( line ) );
//
//   if( radius === undefined )
//   radius = 2;
//
//   debugger;
//
//   let lines = code.split( '\n' );
//   let result = lines.slice( line-radius,line+radius-1 );
//   result = _.strLinesNumber( result,line-radius+1 );
//
//   return result;
// }

//

/**
 * Selects range( o.range ) of lines from source string( o.src ).
 * If( o.range ) is not specified and ( o.line ) is provided function uses it with ( o.selectMode ) option to generate new range.
 * If( o.range ) and ( o.line ) are both not provided function generates range by formula: [ 0, n + 1 ], where n: number of ( o.delimteter ) in source( o.src ).
 * Returns selected lines range as string or empty string if nothing selected.
 * Can be called in three ways:
 * - First by passing all parameters in one options object( o ) ;
 * - Second by passing source string( o.src ) and range( o.range ) as array or number;
 * - Third by passing source string( o.src ), range start and end position.
 *
 * @param {Object} o - Options.
 * @param {String} [ o.src=null ] - Source string.
 * @param {Array|Number} [ o.range=null ] - Sets range of lines to select from( o.src ) or single line number.
 * @param {Number} [ o.zero=1 ] - Sets base value for a line counter.
 * @param {Number} [ o.number=0 ] - If true, puts line counter before each line by using o.range[ 0 ] as initial value of a counter.
 * @param {String} [ o.delimteter='\n' ] - Sets new line character.
 * @param {String} [ o.line=null ] - Sets line number from which to start selecting, is used only if ( o.range ) is null.
 * @param {Number} [ o.numberOfLines=3 ] - Sets maximal number of lines to select, is used only if ( o.range ) is null and ( o.line ) option is specified.
 * @param {String} [ o.selectMode='center' ] - Determines in what way funtion must select lines, works only if ( o.range ) is null and ( o.line ) option is specified.
 * Possible values:
 * - 'center' - uses ( o.line ) index as center point and selects ( o.numberOfLines ) lines in both directions.
 * - 'begin' - selects ( o.numberOfLines ) lines from start point ( o.line ) in forward direction;
 * - 'end' - selects ( o.numberOfLines ) lines from start point ( o.line ) in backward direction.
 * @returns {string} Returns selected lines as new string or empty if nothing selected.
 *
 * @example
 * //selecting single line
 * _.strLinesSelect( 'a\nb\nc', 1 );
 * //returns 'a'
 *
 * @example
 * //selecting first two lines
 * _.strLinesSelect( 'a\nb\nc', [ 1, 3 ] );
 * //returns
 * 'a
 * b'
 *
 * @example
 * //selecting first two lines, second way
 * _.strLinesSelect( 'a\nb\nc', 1, 3 );
 * //returns
 * 'a
 * b'
 *
 * @example
 * //custom new line character
 * _.strLinesSelect({ src : 'a b c', range : [ 1, 3 ], delimteter : ' ' });
 * //returns 'a b'
 *
 * @example
 * //setting preferred number of lines to select, line option must be specified
 * _.strLinesSelect({ src : 'a\nb\nc', line : 2, numberOfLines : 1 });
 * //returns 'b'
 *
 * @example
 * //selecting 2 two next lines starting from second
 * _.strLinesSelect({ src : 'a\nb\nc', line : 2, numberOfLines : 2, selectMode : 'begin' });
 * //returns
 * 'b
 * c'
 *
 * @example
 * //selecting 2 two lines starting from second in backward direction
 * _.strLinesSelect({ src : 'a\nb\nc', line : 2, numberOfLines : 2, selectMode : 'end' });
 * //returns
 * 'a
 * b'
 *
 * @method strLinesSelect
 * @throws { Exception } Throw an exception if no argument provided.
 * @throws { Exception } Throw an exception if( o.src ) is not a String.
 * @throws { Exception } Throw an exception if( o.range ) is not a Array or Number.
 * @throws { Exception } Throw an exception if( o ) is extended by unknown property.
 * @memberof wTools
 */

function strLinesSelect( o )
{

  if( arguments.length === 2 )
  {

    if( _.arrayIs( arguments[ 1 ] ) )
    o = { src : arguments[ 0 ], range : arguments[ 1 ] };
    else if( _.numberIs( arguments[ 1 ] ) )
    o = { src : arguments[ 0 ], range : [ arguments[ 1 ],arguments[ 1 ]+1 ] };
    else _.assert( 0,'unexpected argument',_.strTypeOf( range ) );

  }
  else if( arguments.length === 3 )
  {
    o = { src : arguments[ 0 ], range : [ arguments[ 1 ],arguments[ 2 ] ] };
  }

  _.assert( arguments.length <= 3 );
  _.assert( _.strIs( o.src ) );
  _.routineOptions( strLinesSelect,o );

  /* range */

  if( !o.range )
  {
    if( o.line !== null )
    {
      if( o.selectMode === 'center' )
      o.range = [ o.line - Math.ceil( ( o.numberOfLines + 1 ) / 2 ) + 1,o.line + Math.floor( ( o.numberOfLines - 1 ) / 2 ) + 1 ];
      else if( o.selectMode === 'begin' )
      o.range = [ o.line,o.line + o.numberOfLines ];
      else if( o.selectMode === 'end' )
      o.range = [ o.line - o.numberOfLines+1,o.line+1 ];
    }
    else
    {
      o.range = [ 0,_.strCount( o.src,o.delimteter )+1 ];
    }
  }

  _.assert( _.longIs( o.range ) );

  /* */

  let f = 0;
  let counter = o.zero;
  while( counter < o.range[ 0 ] )
  {
    f = o.src.indexOf( o.delimteter,f );
    if( f === -1 )
    return '';
    f += o.delimteter.length;
    counter += 1;
  }

  /* */

  let l = f-1;
  while( counter < o.range[ 1 ] )
  {
    l += 1;
    l = o.src.indexOf( o.delimteter,l );
    if( l === -1 )
    {
      l = o.src.length;
      break;
    }
    counter += 1;
  }

  /* */

  let result = f < l ? o.src.substring( f,l ) : '';

  /* number */

  if( o.number )
  result = _.strLinesNumber( result,o.range[ 0 ] );

  return result;
}

strLinesSelect.defaults =
{
  src : null,
  range : null,

  line : null,
  numberOfLines : 3,
  selectMode : 'center',

  number : 0,
  zero : 1,
  delimteter : '\n',
}

//

function strLinesNearest_pre( routine, args )
{

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { src : args[ 0 ], charsRange : args[ 1 ] };

  _.routineOptions( routine, o );

  return o;
}

//

function strLinesNearest_body( o )
{
  let result;
  let resultCharRange = [];
  let i, numberOfLines;

  /* */

  if( o.numberOfLines === 0 )
  {
    result = [];
    result[ 0 ] = '';
    result[ 1 ] = o.src.substring( o.charsRange[ 0 ],o.charsRange[ 1 ] );
    result[ 2 ] = '';
    return result;
  }

  /* */

  let numberOfLinesLeft = Math.ceil( ( o.numberOfLines+1 ) / 2 );
  numberOfLines = numberOfLinesLeft;
  if( numberOfLines > 0 )
  {
    for( i = o.charsRange[ 0 ]-1 ; i >= 0 ; i-- )
    {
      if( o.src[ i ] === '\n' )
      numberOfLines -= 1;
      if( numberOfLines <= 0 )
      break;
    }
    i = i+1;
  }
  resultCharRange[ 0 ] = i;

  // 0 -> 0 + 0 = 0
  // 1 -> 1 + 1 = 2
  // 2 -> 2 + 1 = 3
  // 3 -> 2 + 2 = 4

  /* */

  let numberOfLinesRight = o.numberOfLines + 1 - numberOfLinesLeft;
  numberOfLines = numberOfLinesRight;
  if( numberOfLines > 0 )
  {
    for( i = o.charsRange[ 1 ] ; i < o.src.length ; i++ )
    {
      if( o.src[ i ] === '\n' )
      numberOfLines -= 1;
      if( numberOfLines <= 0 )
      break;
    }
  }
  resultCharRange[ 1 ] = i;

  /* */

  result = [];
  result[ 0 ] = o.src.substring( resultCharRange[ 0 ],o.charsRange[ 0 ] );
  result[ 1 ] = o.src.substring( o.charsRange[ 0 ],o.charsRange[ 1 ] );
  result[ 2 ] = o.src.substring( o.charsRange[ 1 ],resultCharRange[ 1 ] );

  return result;
}

strLinesNearest_body.defaults =
{
  src : null,
  charsRange : null,
  numberOfLines : 3,
}

let strLinesNearest = _.routineForPreAndBody( strLinesNearest_pre, strLinesNearest_body );

//

/**
 * Returns a count of lines in a string.
 * Expects one object: the string( src ) to be processed.
 *
 * @param {string} src - Source string.
 * @returns {number} Returns a number of lines in string.
 *
 * @example
 * //returns 2
 * _.strLinesCount( 'first\nsecond' );
 *
 * @example
 * //returns 4
 * _.strLinesCount( 'first\nsecond\nthird\n' );
 *
 * @method strLinesCount
 * @throws { Exception } Throw an exception if( src ) is not a String.
 * @throws { Exception } Throw an exception if no argument provided.
 * @memberof wTools
 *
*/

function strLinesCount( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );
  let result = src.indexOf( '\n' ) !== -1 ? src.split( '\n' ).length : 1;
  return result;
}

//

function strLinesRangeWithCharRange_pre( routine, args )
{

  let o = args[ 0 ];
  if( args[ 1 ] !== undefined )
  o = { src : args[ 0 ], charsRange : args[ 1 ] }

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( _.rangeIs( o.charsRange ) );
  _.assert( _.strIs( o.src ) );
  _.routineOptions( routine, o );

  return o;
}

//

function strLinesRangeWithCharRange_body( o )
{

  let pre = o.src.substring( 0, o.charsRange[ 0 ] );
  let mid = o.src.substring( o.charsRange[ 0 ], o.charsRange[ 1 ] );
  let result = []

  result[ 0 ] = _.strLinesCount( pre )-1;
  result[ 1 ] = result[ 0 ] + _.strLinesCount( mid );

  return result;
}

strLinesRangeWithCharRange_body.defaults =
{
  src : null,
  charsRange : null,
}

let strLinesRangeWithCharRange = _.routineForPreAndBody( strLinesRangeWithCharRange_pre, strLinesRangeWithCharRange_body );

//

function strLinesNearestReport_body( o )
{
  let result = Object.create( null );

  result.nearest = _.strLinesNearest.body( o );
  // result.linesRange = _.strLinesRangeWithCharRange.body( o );

  result.report = result.nearest.slice();
  if( !o.gray )
  result.report[ 1 ] = _.color.strUnescape( _.color.strFormat( result.report[ 1 ], { fg : 'yellow' } ) );
  result.report = result.report.join( '' );

  result.report = _.strLinesSplit( result.report );
  if( !o.gray )
  result.report = _.color.strEscape( result.report );

  let f = _.strLinesCount( o.src.substring( 0, o.charsRange[ 0 ] ) )-1;
  result.report = _.strLinesNumber
  ({
    src : result.report,
    first : f,
    onLine : ( line ) =>
    {
      if( !o.gray )
      {
        line[ 0 ] = _.color.strFormat( line[ 0 ], { fg : 'bright black' } );
        line[ 1 ] = _.color.strFormat( line[ 1 ], { fg : 'bright black' } );
      }
      return line.join( '' );
    }
  });

  debugger;
  return result;
}

strLinesNearestReport_body.defaults =
{
  src : null,
  charsRange : null,
  numberOfLines : 3,
  gray : 0,
}

let strLinesNearestReport = _.routineForPreAndBody( strLinesNearest_pre, strLinesNearestReport_body );

// --
// declare
// --

let Proto =
{

  // checker

  strIsMultilined : strIsMultilined,
  strHas : strHas,
  strHasAny : strHasAny,
  strHasAll : strHasAll,
  strHasNone : strHasNone,
  strHasSeveral : strHasSeveral,

  strsAnyHas : strsAnyHas,
  strsAllHas : strsAllHas,
  strsNoneHas : strsNoneHas,

  // evaluator

  strCount : strCount,
  strCountLeft : strCountLeft,
  strCountRight : strCountRight,

  // replacer

  _strRemovedBegin : _strRemovedBegin,
  strRemoveBegin : strRemoveBegin,
  _strRemovedEnd : _strRemovedEnd,
  strRemoveEnd : strRemoveEnd,

  strReplaceBegin : strReplaceBegin,
  strReplaceEnd : strReplaceEnd,

  strPrependOnce : strPrependOnce,
  strAppendOnce : strAppendOnce,

  strReplaceWords : strReplaceWords,

  // etc

  strCommonLeft : strCommonLeft, /* document me */
  strCommonRight : strCommonRight, /* document me */

  // formatter

  strForRange : strForRange, /* experimental */
  strForCall : strForCall, /* experimental */
  strShortSrt : strShortSrt,
  strQuote : strQuote,

  // transformer

  strCapitalize : strCapitalize,
  strDecapitalize : strDecapitalize,
  strEscape : strEscape,
  strCodeUnicodeEscape : strCodeUnicodeEscape,
  strUnicodeEscape : strUnicodeEscape, /* document me */
  strReverse : strReverse,

  // stripper

  strStrip : strStrip,
  strStripLeft : strStripLeft,
  strStripRight : strStripRight,
  strRemoveAllSpaces : strRemoveAllSpaces,
  strStripEmptyLines : strStripEmptyLines,

  // splitter

  _strIsolate : _strIsolate,
  strIsolateBeginOrNone : strIsolateBeginOrNone,
  strIsolateEndOrNone : strIsolateEndOrNone,
  strIsolateEndOrAll : strIsolateEndOrAll,
  strIsolateBeginOrAll : strIsolateBeginOrAll,

  strSplitStrNumber : strSplitStrNumber, /* experimental */
  strSplitChunks : strSplitChunks, /* experimental */

  strSplitsQuotedRejoin : strSplitsQuotedRejoin,
  strSplitsDropDelimeters : strSplitsDropDelimeters,
  strSplitsStrip : strSplitsStrip,
  strSplitsDropEmpty : strSplitsDropEmpty,

  strSplitsGroupCoupled : strSplitsGroupCoupled,

  strSplitFast : strSplitFast,
  strSplit : strSplit,
  strSplitNonPreserving : strSplitNonPreserving,

  strSplitNaive : strSplitNaive,

// extractor

  strSub : strSub,
  strExtractInlined : strExtractInlined,
  strExtractInlinedStereo : strExtractInlinedStereo,

  // joiner

  strDup : _.routineVectorize_functor( _strDup ), /* document me */
  strJoin : strJoin, /* document me */
  strUnjoin : strUnjoin, /* document me */
  strConcat : strConcat,

  // liner

  strIndentation : strIndentation,
  strLinesSplit : strLinesSplit,
  strLinesNumber : strLinesNumber,
  strLinesSelect : strLinesSelect,
  strLinesNearest : strLinesNearest,
  strLinesCount : strLinesCount,
  strLinesRangeWithCharRange : strLinesRangeWithCharRange,
  strLinesNearestReport : strLinesNearestReport,

}

_.mapExtend( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

  // qqq
  //
  // strStrip : strStrip,
  // strStripLeft : strStripLeft,
  // strStripRight : strStripRight,
  // strRemoveAllSpaces : strRemoveAllSpaces,
  // strStripEmptyLines : strStripEmptyLines,
  //
  // strSub : strSub,
  //
  // strDup : strDup, /* document me */
  // strJoin : strJoin, /* document me */
  // strUnjoin : strUnjoin, /* document me */

})();
