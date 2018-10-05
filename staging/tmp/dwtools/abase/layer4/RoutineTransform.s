(function _RoutineTransform_s_() {

'use strict';

var Self = _global_.wTools;
var _global = _global_;
var _ = _global_.wTools;

var _ArraySlice = Array.prototype.slice;
var _FunctionBind = Function.prototype.bind;
var _ObjectToString = Object.prototype.toString;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

// var __assert = _.assert;
var _arraySlice = _.longSlice;

// --
// routine
// --

function routineNew( routine,name,usingPrototype )
{
  _.assert( _.routineIs( routine ),'creating routine from string is not implemented' );

  if( usingPrototype === undefined ) usingPrototype = true;
  if( name === undefined ) name = '_noname_';

  var f = new Function( 'var _' + name + ' = arguments[ 0 ];\nreturn function ' + name + ' ()\n{\n  return ' + '_' + name + '(this, arguments) \n};' );
  var result = f( Function.prototype.apply.bind( routine ) );

  result._name = name;

  if( usingPrototype )
  result.prototype = routine.prototype;

  return result;
}

//

function routineInfo( routine )
{

  _.assert( _.routineIs( routine ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  var result = _routineInfo
  ({
    routine : routine,
    tab : '',
  });

  return result;
}

//

function _routineInfo( o )
{
  var result = '';
  var assets = _.mapOnly( o.routine, _routineAssets );

  result += o.routine.name || 'noname';
  result += '\n';
  result += _.toStr( assets,{ levels : 2, tab : o.tab, prependTab : 1, wrap : 0 });
  result += '\n----------------\n';

  o.tab += '  ';

  for( var i in o.routine.inline )
  {
    result += o.tab + i + ' : ';
    var opt = _.mapExtend( null,o );
    o.routine = o.routine.inline[ i ];
    result += _routineInfo( o );
  }

  return result;
}

//

function routineCollectAssets( dst,routine )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.routineIs( routine ) );

  return _routineCollectAssets( dst,routine,[] );
}

//

function _routineCollectAssets( dst,routine,visited )
{

  _.assert( _.routineIs( routine ) );
  _.assert( visited.indexOf( routine ) === -1 );
  visited.push( routine );

  if( routine.debugCollect )
  debugger;

  for( var a in _routineAssets )
  {

    if( !routine[ a ] )
    continue;

    dst[ a ] = dst[ a ] || {};
    _.assertMapHasNone( dst[ a ],routine[ a ] );
    dst[ a ] = _.mapsFlatten
    ({
      maps : [ dst[ a ],routine[ a ] ],
      assertingUniqueness : 1,
    });

  }

  if( dst.inline )
  for( var i in dst.inline )
  {

    if( visited.indexOf( dst.inline[ i ] ) === -1 )
    _routineCollectAssets( dst,dst.inline[ i ],visited );

  }

}
//

_global_._routineIsolate = [];
function routineIsolate( o )
{

  if( _.routineIs( o ) )
  o = { routine : o };
  _.assert( o.routine );
  _.assertMapHasOnly( o,routineIsolate.defaults );

  var name = o.name || o.routine.name;
  _.assert( _.strIs( name ) && name.length );

  _.routineCollectAssets( o,o.routine );

  //

  var parsed;

  if( o.inline || o.routine.inline )
  {

    parsed = _.routineParse
    ({
      routine : o.routine,
      inline : o.inline,
    });

  }
  else
  {

    parsed = { source : o.routine.toString() };

  }

  //

  if( o.routine.debugIsolate )
  debugger;

/*
  if( parsed.source.indexOf( 'doesAcceptZero' ) !== -1 )
  debugger;

  if( parsed.source.indexOf( 'doesAcceptZero' ) !== -1 )
  console.log( _.routineInfo( o.routine ) );

  if( parsed.source.indexOf( 'doesAcceptZero' ) !== -1 )
  _.routineCollectAssets( o,o.routine );

  if( parsed.source.indexOf( 'doesAcceptZero' ) !== -1 )
  debugger;
*/
  //

  var sconstant = '';
  if( o.constant )
  for( var s in o.constant )
  {
    sconstant += 'const ' + s + ' = ' + _.toStr( o.constant[ s ],{ levels : 99, escaping : 1 } ) + ';\n';
  }

  //

  var sexternal = '';
  if( o.external )
  {

    var descriptor = {};
    _routineIsolate.push( descriptor );
    descriptor.external = o.external;

    for( var s in o.external )
    {
      sexternal += 'const ' + s + ' = ' + '_routineIsolate[ ' + ( _routineIsolate.length-1 ) + ' ].external.' + s + '' + ';\n';
    }

  }

  //

  var source =
  sconstant + '\n' +
  sexternal + '\n' +
  ( o.debug ? 'debugger;\n' : '' ) +
  'return ( ' + parsed.source + ' );';

  //debugger;

  var result = new Function
  (
    o.args || [],
    source
  )();

  result.inline = o.inline;
  result.external = o.external;
  result.constant = o.constant;

  return result;
}

routineIsolate.defaults =
{
  routine : null,
  constant : null,
  external : null,
  inline : null,
  debug : 0,
  name : null,
}

//

function routineParse( o )
{
  if( _.routineIs( o ) )
  o = { routine : o };
  _.assert( o.routine );

  if( o.routine.debugParse )
  debugger;

  var source = o.routine.toString();
  var result = {};
  result.source = source;

  //

  function parse()
  {

    var r = /function\s+(\w*)\s*\(([^\)]*)\)(\s*{[^]*})$/;

    var parsed = r.exec( source );

    result.name = parsed[ 1 ];
    result.args = _.strSplitNonPreserving
    ({
      src : parsed[ 2 ],
      delimeter : ',',
      preservingDelimeters : 0,
    });
    result.body = parsed[ 3 ];

    result.reproduceSource = function()
    {
      return 'function ' + result.name + '( ' + result.args.join( ', ' ) + ' )\n' + result.body;
    }

    return result;
  }

  //

  if( o.routine.inline )
  {
    o.inline = o.inline || {};
    _.assertMapHasNone( o.inline,o.routine.inline );
    o.inline = _.mapsFlatten
    ({
      maps : [ o.inline,o.routine.inline ],
      assertingUniqueness : 1,
    });

  }

  //

  if( !o.inline || !Object.keys( o.inline ).length )
  return parse();

  //

  var inlined = 0;

  //

  function inlineFull( ins,sub )
  {

    var regexp = new RegExp( '(((var\\s+)?(\\w+)\\s*=\\s*)?|(\\W))(' + ins + ')\\s*\\.call\\s*\\(([^)]*)\\)','gm' );
    var rreturn = /return(\s+([^;}]+))?([;}]?)/mg;
    result.source = result.source.replace( regexp,function( original )
    {

      _.assert( sub.name );

      /* var */

      var r = '';
      var variableName = arguments[ 4 ];
      var body = sub.body;

      /* args */

      var args = _.strSplitNonPreserving
      ({
        src : arguments[ 7 ],
        delimeter : ',',
        preservingDelimeters : 0,
      });

      _.assert( args.length - 1 === sub.args.length );

      //debugger;
      var renamedArgs = _.strJoin( '_' + sub.name + '_', sub.args, '_' );
      /*var renamedArgs = _.strStick( sub.args.slice(),'_' + sub.name + '_', '_' );*/
      body = _.strReplaceWords( body, sub.args, renamedArgs );

      for( var a = 0 ; a < renamedArgs.length ; a++ )
      {
        r += '  var ' + renamedArgs[ a ] + ' = ' + args[ a+1 ] + ';';
      }

      /* return */

      if( variableName )
      r += 'var ' + variableName + ';\n';

      body = body.replace( rreturn,function()
      {
        debugger;
        throw _.err( 'not tested' );

        var rep = '{ ';
        rep += variableName;
        rep += ' = ';
        rep += _.strStrip( arguments[ 2 ] || '' ) ? arguments[ 2 ] : 'undefined';
        rep += arguments[ 3 ];
        rep += ' }';
        return rep;
      });

      /* body */

      r += body;

      r = '\n/* _inlineFull_' + ins + '_ */\n{\n' + r + '\n}\n/* _inlineFull_' + ins + '_ */\n';

      /* validation */

      if( Config.debug )
      if( r.indexOf( 'return' ) !== -1 )
      {
        debugger;
        throw _.err( 'not expected' );
      }

      inlined += 1;

      return r;
    });

  }

  //

  function inlineCall( ins,sub )
  {

    var regexp = new RegExp( '(\\W)(' + ins + ')\\s*\\.','gm' );
    result.source = result.source.replace( regexp,function( a,b,c,d,e )
    {
      inlined += 1;
      return b + '/* _inlineCall_' + ins + '_ */' + '( ' + sub.source + ' ).' + '/* _inlineCall_' + ins + '_ */';
    });

  }

  //

  function inlineRegular( ins,sub )
  {

    var regexp = new RegExp( '(\\W)(' + ins + ')(\\W)','gm' );
    result.source = result.source.replace( regexp,function( a,b,c,d,e )
    {
      inlined += 1;
      return b + '/* _inlineRegular_' + ins + '_ */( ' + sub.source + ' )/* _inlineRegular_' + ins + '_ */' + d;
    });

  }

  //

  function inline( ins,sub )
  {

    inlined = 0;

    if( !_.routineIs( sub ) )
    throw _.err( 'not tested' );

/*
    if( _.routineIs( sub ) )
    {
      sub = _.routineParse( sub );
    }
    else
    {
      var sub = { source : sub };
      throw _.err( 'not tested' );
    }
    */

    sub = _.routineParse( sub );

    var regexp = new RegExp( 'function\\s+' + ins + '\\s*\\(','gm' );
    sub.source = sub.source.replace( regexp,'function _' + ins + '_(' );

    /**/

    var returnCount = _.strCount( sub.source,'return' );
    if( returnCount === 0 && sub.body )
    {

      inlineFull( ins,sub );

    }

    inlineCall( ins,sub );
    inlineRegular( ins,sub );

    /**/

    return inlined;
  }

  //

  function inlines()
  {
    var r = 0;

    for( var i in o.inline )
    {
      r += inline( i,o.inline[ i ] );
    }

    return r;
  }

  //

  if( !inlines() )
  return parse();

  if( !inlines() )
  return parse();

  debugger;
  while( inlines() );
  debugger;

  return parse();
}

// var

var _routineAssets =
{
  inline : 'inline',
  external : 'external',
  constant : 'constant',
}

// --
// declare
// --

var Proto =
{

  routineNew : routineNew,
  routineInfo : routineInfo,

  routineCollectAssets : routineCollectAssets,
  _routineCollectAssets : _routineCollectAssets,
  routineIsolate : routineIsolate,
  routineParse : routineParse,

  _routineAssets : _routineAssets,

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

})();
