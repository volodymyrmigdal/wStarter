(function _Diagnostics_s_() {

'use strict';

var _ArraySlice = Array.prototype.slice;
var _FunctionBind = Function.prototype.bind;
var _ObjectToString = Object.prototype.toString;
var _ObjectHasOwnProperty = Object.hasOwnProperty;
var _propertyIsEumerable = Object.propertyIsEnumerable;
var _ceil = Math.ceil;
var _floor = Math.floor;

var _global = _global_;
var _ = _global.wTools;
var _err = _._err;
var Self = _;

//

function diagnosticVariate( o )
{
  _.routineOptions( diagnosticVariate,o );

  if( _.arrayIs( o.routine ) )
  {
    _.assert( _.routineIs( o.routine[ 1 ] ) );
    if( !o.variates && o.routine[ 1 ].variates )
    o.variates = o.routine[ 1 ].variates;
    o.routine = _.routineJoin.apply( _,o.routine );
  }

  _.assert( _.routineIs( o.routine ) );
  _.assert( _.objectIs( o.variates ) );

  var vals = _.mapExtend( null,o.variates );
  vals = _.proxyNoUndefined( vals );

  if( o.test === null )
  o.test = function vtest( got,o )
  {
    return _.entityEquivalent( got,o.expected,{ /*eps*/accuracy : o./*eps*/accuracy } );
  }

  var found = 0;
  var nsamples = _.eachSample
  ({

    onEach : function( sample,i )
    {
      var got = o.routine( sample );
      var res = o.test( got,o );
      if( res )
      found += 1;
      if( res || !o.printingValidOnly )
      {
        logger.log( 'routine',o.routine.name,'gave',got,'expected',o.expected,'#',i );
        if( res )
        {
          logger.log( 'sample :',sample );
          logger.log( got );
        }
      }
    },

    sets : o.variates,
    sample : vals,
    result : null,

  });

  logger.log( 'Found',found,'/',nsamples );

}

diagnosticVariate.defaults =
{
  routine : null,
  test : null,

  expected : null,
  variates : null,
  /*eps*/accuracy : 1e-3,
  printingValidOnly : 1,
}

// --
// diagnostics
// --

function _diagnosticStripPath( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.strIs( src ) )
  {
    src = src.replace( /^\s+/,'' );
    // src = src.replace( /^at/,'' );
    // src = src.replace( /^\s+/,'' );
  }

  return src;
}

//

// function diagnosticScript( path )
// {
//
//   if( typeof document !== 'undefined' && document.scripts )
//   {
//     var scripts = document.scripts;
//     for( var s = 0 ; s < scripts.length ; s++ )
//     if( scripts[ s ].src === path )
//     return scripts[ s ];
//   }
//   else
//   {
//     debugger;
//   }
//
// }

//

function diagnosticLocation( o )
{

  if( _.numberIs( o ) )
  o = { level : o }
  else if( _.strIs( o ) )
  o = { stack : o, level : 0 }
  else if( _.errIs( o ) )
  o = { error : o, level : 0 }
  else if( o === undefined )
  o = { stack : _.diagnosticStack( 1 ) };

  /* */

  for( var e in o )
  {
    if( diagnosticLocation.defaults[ e ] === undefined )
    throw 'Unknown option ' + e;
  }

  for( var e in diagnosticLocation.defaults )
  {
    if( o[ e ] === undefined )
    o[ e ] = diagnosticLocation.defaults[ e ];
  }

  if( !( arguments.length === 0 || arguments.length === 1 ) )
  throw 'Expects single argument or none';

  if( !( _.objectIs( o ) ) )
  throw 'Expects options map';

  // _.routineOptions( diagnosticLocation,o );
  // _.assert( arguments.length === 0 || arguments.length === 1 );
  // _.assert( _.objectIs( o ),'diagnosticLocation expects integer {-level-} or string ( stack ) or object ( options )' );

  /* */

  if( !o.location )
  o.location = Object.create( null );

  /* */

  if( o.error )
  {
    var location2 = o.error.location || Object.create( null );

    o.location.path = _.arrayLeftDefined([ location2.path, o.location.path, o.error.filename, o.error.fileName ]).element;
    o.location.line = _.arrayLeftDefined([ location2.line, o.location.line, o.error.line, o.error.linenumber, o.error.lineNumber, o.error.lineNo, o.error.lineno ]).element;
    o.location.col = _.arrayLeftDefined([ location2.col, o.location.col, o.error.col, o.error.colnumber, o.error.colNumber, o.error.colNo, o.error.colno ]).element;

    if( o.location.path && _.numberIs( o.location.line ) )
    return end();
  }

  /* */

  if( !o.stack )
  {
    if( o.error )
    {
      o.stack = _.diagnosticStack( o.error );
    }
    else
    {
      o.stack = _.diagnosticStack();
      o.level += 1;
    }
  }

  routineFromStack( o.stack );

  var had = !!o.location.path;
  if( !had )
  o.location.path = fromStack( o.stack );

  if( !_.strIs( o.location.path ) )
  return end();

  if( !_.numberIs( o.location.line ) )
  o.location.path = lineColFromPath( o.location.path );

  if( !_.numberIs( o.location.line ) && had )
  {
    var path = fromStack( o.stack );
    if( path )
    lineColFromPath( path );
  }

  return end();

  /* end */

  function end()
  {

    var path = o.location.path;

    /* full */

    // if( path )
    {
      o.location.full = path || '';
      if( o.location.line !== undefined )
      o.location.full += ':' + o.location.line;
    }

    /* name long */

    if( o.location.full )
    {
      o.location.fullWithRoutine = o.location.routine + ' @ ' + o.location.full;
    }

    /* name */

    if( path )
    {
      var name = path;
      var i = name.lastIndexOf( '/' );
      if( i !== -1 )
      name = name.substr( i+1 );
      o.location.name = name;
    }

    /* name long */

    if( path )
    {
      var nameLong = o.location.name;
      if( o.location.line !== undefined )
      {
        nameLong += ':' + o.location.line;
        if( o.location.col !== undefined )
        nameLong += ':' + o.location.col;
      }
      o.location.nameLong = nameLong;
    }

    return o.location;
  }

  /* routine from stack */

  function routineFromStack( stack )
  {
    var path;

    if( !stack )
    return;

    if( _.strIs( stack ) )
    stack = stack.split( '\n' );

    path = stack[ o.level ];

    if( !_.strIs( path ) )
    return '(-routine anonymous-)';

    // debugger;

    var t = /^\s*(at\s+)?([\w\.]+)\s*.+/;
    var executed = t.exec( path );
    if( executed )
    path = executed[ 2 ] || '';

    if( _.strEnds( path, '.' ) )
    path += '?';

    o.location.routine = path;
    o.location.service = 0;
    if( o.location.service === 0 )
    if( _.strBegins( path , '__' ) || path.indexOf( '.__' ) !== -1 )
    o.location.service = 2;
    if( o.location.service === 0 )
    if( _.strBegins( path , '_' ) || path.indexOf( '._' ) !== -1 )
    o.location.service = 1;

    return path;
  }

  /* path from stack */

  function fromStack( stack )
  {
    var path;

    if( !stack )
    return;

    if( _.strIs( stack ) )
    stack = stack.split( '\n' );

    path = stack[ o.level ];

    if( !_.strIs( path ) )
    return end();

    path = path.replace( /^\s+/,'' );
    path = path.replace( /^\w+@/,'' );
    path = path.replace( /^at/,'' );
    path = path.replace( /^\s+/,'' );
    path = path.replace( /\s+$/,'' );

    if( _.strEnds( path,')' ) )
    path = _.strIsolateInsideOrAll( path,'(',')' )[ 2 ];

    return path;
  }

  /* line / col number from path */

  function lineColFromPath( path )
  {

    var lineNumber,colNumber;
    var postfix = /(.+?):(\d+)(?::(\d+))?[^:/]*$/;
    var parsed = postfix.exec( path );

    if( parsed )
    {
      path = parsed[ 1 ];
      lineNumber = parsed[ 2 ];
      colNumber = parsed[ 3 ];
    }

    // var postfix = /:(\d+)$/;
    // colNumber = postfix.exec( o.location.path );
    // if( colNumber )
    // {
    //   o.location.path = _.strRemoveEnd( o.location.path,colNumber[ 0 ] );
    //   colNumber = colNumber[ 1 ];
    //   lineNumber = postfix.exec( o.location.path );
    //   if( lineNumber )
    //   {
    //     o.location.path = _.strRemoveEnd( o.location.path,lineNumber[ 0 ] );
    //     lineNumber = lineNumber[ 1 ];
    //   }
    //   else
    //   {
    //     lineNumber = colNumber;
    //     colNumber = undefined;
    //   }
    // }

    lineNumber = parseInt( lineNumber );
    colNumber = parseInt( colNumber );

    if( isNaN( o.location.line ) && !isNaN( lineNumber ) )
    o.location.line = lineNumber;

    if( isNaN( o.location.col ) && !isNaN( colNumber ) )
    o.location.col = colNumber;

    return path;
  }

}

diagnosticLocation.defaults =
{
  level : 0,
  stack : null,
  error : null,
  location : null,
}

//

let _diagnosticCodeExecuting = 0;
function diagnosticCode( o )
{

  _.routineOptions( diagnosticCode,o );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( _diagnosticCodeExecuting )
  return;
  _diagnosticCodeExecuting += 1;

  try
  {

    if( !o.location )
    {
      if( o.error )
      o.location = _.diagnosticLocation({ error : o.error, level : o.level });
      else
      o.location = _.diagnosticLocation({ stack : o.stack, level : o.stack ? o.level : o.level+1 });
    }

    if( !_.numberIs( o.location.line ) )
    return end();

    /* */

    if( !o.sourceCode )
    {

      if( !o.location.path )
      return end();

      var codeProvider = _.codeProvider || _.fileProvider;

      if( !codeProvider )
      return end();

      try
      {

        // if( _global._starter_ )
        // debugger;
        // if( _global._starter_ )
        // _global._starter_.fileProvider.fileRead( _.weburi.parse( o.location.path ).localPath );

        o.sourceCode = codeProvider.fileRead
        ({
          filePath : o.location.path,
          sync : 1,
          throwing : 0,
        })

      }
      catch( err )
      {
        o.sourceCode = 'CANT LOAD SOURCE CODE ' + _.strQuote( o.location.path );
      }

      if( !o.sourceCode )
      return end();

    }

    /* */

    var result = _.strLinesSelect
    ({
      src : o.sourceCode,
      line : o.location.line,
      numberOfLines : o.numberOfLines,
      selectMode : o.selectMode,
      zero : 1,
      number : 1,
    });

    if( o.withPath )
    result = o.location.full + '\n' + result;

    return end( result );

  }
  catch( err )
  {
    console.log( err.toString() );
    return;
  }

  /* */

  function end( result )
  {
    _diagnosticCodeExecuting -= 1;
    return result;
  }

}

diagnosticCode.defaults =
{
  level : 0,
  numberOfLines : 3,
  withPath : 1,
  selectMode : 'center',
  stack : null,
  error : null,
  location : null,
  sourceCode : null,
}

//

/**
 * Return stack trace as string.
 * @example
  var stack;
  function function1()
  {
    function2();
  }

  function function2()
  {
    function3();
  }

  function function3()
  {
    stack = wTools.diagnosticStack();
  }

  function1();
  console.log( stack );
 //"    at function3 (<anonymous>:10:17)
 // at function2 (<anonymous>:6:2)
 // at function1 (<anonymous>:2:2)
 // at <anonymous>:1:1"
 *
 * @returns {String} Return stack trace from call point.
 * @function stack
 * @memberof wTools
 */

function diagnosticStack( stack,first,last )
{

  if( last-first === 1 )
  debugger;

  if( _.numberIs( arguments[ 0 ] ) || arguments[ 0 ] === undefined )
  {

    var first = arguments[ 0 ] ? arguments[ 0 ] + 1 : 1;
    var last = arguments[ 1 ] >= 0 ? arguments[ 1 ] + 1 : arguments[ 1 ];

    return diagnosticStack( new Error(),first,last );
  }

  if( arguments.length !== 1 && arguments.length !== 2 && arguments.length !== 3 )
  {
    debugger;
    throw Error( 'diagnosticStack : expects one, two or three arguments if error provided' );
  }

  if( !_.numberIs( first ) && first !== undefined )
  {
    debugger;
    throw Error( 'diagnosticStack : expects number {-first-}, got ' + _.strTypeOf( first ) );
  }

  if( !_.numberIs( last ) && last !== undefined )
  {
    debugger;
    throw Error( 'diagnosticStack : expects number {-last-}, got' + _.strTypeOf( last ) );
  }

  var errIs = 0;
  if( _.errIs( stack ) )
  {
    stack = stack.stack;
    errIs = 1;
  }

  if( !stack )
  return '';

  if( !_.arrayIs( stack ) && !_.strIs( stack ) )
  return;

  if( !_.arrayIs( stack ) && !_.strIs( stack ) )
  debugger;
  if( !_.arrayIs( stack ) && !_.strIs( stack ) )
  throw 'diagnosticStack expects array or string';

  if( !_.arrayIs( stack ) )
  stack = stack.split( '\n' );

  /* remove redundant lines */

  if( !errIs )
  console.debug( 'REMINDER : problem here if !errIs' ); /* xxx */
  if( !errIs )
  debugger;

  if( errIs )
  {
    // debugger;
    while( stack.length )
    {
      var splice = 0;
      // if( stack[ 0 ].indexOf( '@' ) !== -1 )
      // debugger;
      // if( stack[ 0 ].indexOf( '@' ) !== -1 )
      // return '';
      splice |= ( stack[ 0 ].indexOf( 'at ' ) === -1 && stack[ 0 ].indexOf( '@' ) === -1 );
      splice |= stack[ 0 ].indexOf( '(vm.js:' ) !== -1;
      splice |= stack[ 0 ].indexOf( '(module.js:' ) !== -1;
      splice |= stack[ 0 ].indexOf( '(internal/module.js:' ) !== -1;
      if( splice )
      stack.splice( 0,1 );
      else break;
    }
    // debugger;
  }

  // if( stack[ 0 ].indexOf( '@' ) === -1 )
  // stack[ 0 ] = _.strIsolateBeginOrNone( stack[ 0 ],'@' )[ 1 ];

  // if( !stack[ 0 ] )
  // return '... stack is empty ...';

  // debugger;
  if( stack[ 0 ] )
  if( stack[ 0 ].indexOf( 'at ' ) === -1 && stack[ 0 ].indexOf( '@' ) === -1 )
  {
    debugger;
    console.error( 'diagnosticStack : cant parse stack\n' + stack );
  }

  /* */

  var first = first === undefined ? 0 : first;
  var last = last === undefined ? stack.length : last;

  if( _.numberIs( first ) )
  if( first < 0 )
  first = stack.length + first;

  if( _.numberIs( last ) )
  if( last < 0 )
  last = stack.length + last + 1;

  /* */

  // if( last-first === 1 )
  // {
  //   debugger;
  //   // stack = stack[ first ];
  //   //
  //   // if( _.strIs( stack ) )
  //   // {
  //   //   stack = _._diagnosticStripPath( stack );
  //   // }
  //   //
  //   // return stack;
  // }

  if( first !== 0 || last !== stack.length )
  {
    stack = stack.slice( first || 0,last );
  }

  /* */

  stack = String( stack.join( '\n' ) );

  return stack;
}

//

function diagnosticStackPurify( stack )
{

  if( arguments.length !== 1 )
  throw 'expects single arguments';
  if( !_.strIs( stack ) )
  throw 'expects string';

  stack = stack.split( '\n' );

  for( var s = 1 ; s < stack.length ; s++ )
  if( /(\w)_entry(\W|$)/.test( stack[ s ] ) )
  {
    stack.splice( s+1,stack.length );
    break;
  }

  for( var s = stack.length-1 ; s >= 1 ; s-- )
  {
    if( /(\W|^)__\w+/.test( stack[ s ] ) )
    stack.splice( s,1 )
  }

  return stack.join( '\n' );
}

//

/*

_.diagnosticWatchFields
({
  target : _global_,
  names : 'Uniforms',
});

_.diagnosticWatchFields
({
  target : state,
  names : 'filterColor',
});

_.diagnosticWatchFields
({
  target : _global_,
  names : 'Config',
});

_.diagnosticWatchFields
({
  target : _global_,
  names : 'logger',
});

_.diagnosticWatchFields
({
  target : self,
  names : 'catalogPath',
});

*/

function diagnosticWatchFields( o )
{

  if( arguments[ 1 ] !== undefined )
  o = { target : arguments[ 0 ], names : arguments[ 1 ] }
  o = _.routineOptions( diagnosticWatchFields,o );

  if( o.names )
  o.names = _.nameFielded( o.names );
  else
  o.names = o.target;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( o.target ) );
  _.assert( _.objectLike( o.names ) );

  for( var f in o.names ) ( function()
  {

    var fieldName = f;
    var fieldSymbol = Symbol.for( f );
    //o.target[ fieldSymbol ] = o.target[ f ];
    var val = o.target[ f ];

    /* */

    function read()
    {
      //var result = o.target[ fieldSymbol ];
      var result = val;
      if( o.verbosity > 1 )
      console.log( 'reading ' + fieldName + ' ' + _.toStr( result ) );
      else
      console.log( 'reading ' + fieldName );
      if( o.debugging > 1 )
      debugger;
      return result;
    }

    /* */

    function write( src )
    {
      if( o.verbosity > 1 )
      console.log( 'writing ' + fieldName + ' ' + _.toStr( o.target[ fieldName ] ) + ' -> ' + _.toStr( src ) );
      else
      console.log( 'writing ' + fieldName );
      if( o.debugging )
      debugger;
      //o.target[ fieldSymbol ] = src;
      val = src;
    }

    /* */

    if( o.debugging > 1 )
    debugger;

    if( o.verbosity > 1 )
    console.log( 'watching for',fieldName,'in',o.target );
    Object.defineProperty( o.target, fieldName,
    {
      enumerable : true,
      configurable : true,
      get : read,
      set : write,
    });

  })();

}

diagnosticWatchFields.defaults =
{
  target : null,
  names : null,
  verbosity : 2,
  debugging : 1,
}

//

/*

_.diagnosticProxyFields
({
  target : _.field,
});

_.diagnosticWatchFields
({
  target : _,
  names : 'field',
});

*/

function diagnosticProxyFields( o )
{

  if( arguments[ 1 ] !== undefined )
  o = { target : arguments[ 0 ], names : arguments[ 1 ] }
  o = _.routineOptions( diagnosticWatchFields,o );

  // if( o.names )
  // o.names = _.nameFielded( o.names );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( o.target ) );
  _.assert( _.objectLike( o.names ) || o.names === null );

  var handler =
  {
    set : function( obj, k, e )
    {
      if( o.names && !( k in o.names ) )
      return;
      if( o.verbosity > 1 )
      console.log( 'writing ' + k + ' ' + _.toStr( o.target[ k ] ) + ' -> ' + _.toStr( e ) );
      else
      console.log( 'writing ' + k );
      if( o.debug )
      debugger;
      obj[ k ] = e;
      return true;
    }
  }

  var result = new Proxy( o.target, handler );
  if( o.verbosity > 1 )
  console.log( 'watching for',o.target );

  if( o.debug )
  debugger;

  return result;
}

diagnosticProxyFields.defaults =
{
}

diagnosticProxyFields.defaults.__proto__ == diagnosticWatchFields.defaults

//

function beep()
{
  // console.log( _.diagnosticStack() );
  console.log( '\x07' );
}

//

function checkInstanceOrClass( _constructor, _this )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  debugger;
  var result =
  (
    _this === _constructor ||
    _this instanceof _constructor ||
    Object.isPrototypeOf.call( _constructor,_this ) ||
    Object.isPrototypeOf.call( _constructor,_this.prototype )
  );
  return result;
}

//

function sureInstanceOrClass( _constructor, _this )
{
  _.sure( arguments.length === 2, 'expects exactly two arguments' );
  _.sure( _.checkInstanceOrClass( _constructor, _this ) );
}

//

function assertInstanceOrClass( _constructor, _this )
{
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.checkInstanceOrClass( _constructor, _this ) );
}

//

function checkOwnNoConstructor( ins )
{
  _.assert( _.objectLikeOrRoutine( ins ) );
  _.assert( arguments.length === 1 );
  var result = !_ObjectHasOwnProperty.call( ins,'constructor' );
  return result;
}

//

function sureOwnNoConstructor( ins )
{
  _.sure( _.objectLikeOrRoutine( ins ) );
  var args = _.longSlice( arguments );
  args[ 0 ] = _.checkOwnNoConstructor( ins );
  _.sure.apply( _, args );
}

//

function assertOwnNoConstructor( ins )
{
  _.assert( _.objectLikeOrRoutine( ins ) );
  var args = _.longSlice( arguments );
  args[ 0 ] = _.checkOwnNoConstructor( ins );

  if( args.length === 1 )
  args.push( () => 'Entity should not own constructor, but own ' + _.toStrShort( ins ) );

  _.assert.apply( _, args );
}

// --
// declare
// --

var Proto =
{

  diagnosticVariate : diagnosticVariate,

  _diagnosticStripPath : _diagnosticStripPath,
  diagnosticLocation : diagnosticLocation,
  diagnosticCode : diagnosticCode,
  diagnosticStack : diagnosticStack,
  diagnosticStackPurify : diagnosticStackPurify,
  diagnosticWatchFields : diagnosticWatchFields, /* experimental */
  diagnosticProxyFields : diagnosticProxyFields, /* experimental */

  beep : beep,

  checkInstanceOrClass : checkInstanceOrClass,
  sureInstanceOrClass : sureInstanceOrClass,
  assertInstanceOrClass : assertInstanceOrClass,

  checkOwnNoConstructor : checkOwnNoConstructor,
  sureOwnNoConstructor : sureOwnNoConstructor,
  assertOwnNoConstructor : assertOwnNoConstructor,

}

Object.assign( Self,Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
