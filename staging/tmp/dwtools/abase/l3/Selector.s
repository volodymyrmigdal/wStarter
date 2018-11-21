( function _Selector_s_() {

'use strict';

/**
  @module Tools/base/Selector - Collection of routines to select a sub-structure from a complex data structure. Use the module to transform a data structure with the help of a short query string.
*/

/**
 * @file Selector.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wLooker' );
  _.include( 'wPathFundamentals' );

}

let _global = _global_;
let Self = _global_.wTools;
let _ = _global_.wTools;

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

_.assert( !!_realGlobal_ );

// --
// selector
// --

let Looker = _.mapExtend( null, _.look.defaults.looker );
Looker.Iteration = _.mapExtend( null, Looker.Iteration );
Looker.Iteration.apath = null;
Looker.Iteration.query = null;
Looker.Iteration.onResultWrite = null;
Looker.Iteration.isActual = null;
Looker.Iteration.isRelative = 0;

// Looker.Iterator = _.mapExtend( null, Looker.Iterator );
// Looker.Defaults = _.mapExtend( null, Looker.Defaults );
// Looker.Defaults.aquery = null;

//

function errDoesNotExistThrow( it )
{
  let c = it.context;
  it.looking = false;
  if( c.missingAction === 'undefine' || c.missingAction === 'ignore' )
  {
    it.result = undefined
  }
  else
  {
    // debugger;
    let err = _.ErrorLooking
    (
      'Cant select', _.strQuote( it.context.query ),
      '\nbecause', _.strQuote( _.path.join.apply( _.path, it.apath ) ), 'does not exist',
      '\nat', _.strQuote( it.path ),
      '\nin container', _.toStr( c.container )
    );
    // debugger;
    it.result = undefined;
    it.iterator.error = err;
    if( c.missingAction === 'throw' )
    throw err;
  }
}

//

function errNoDownThrow( it )
{
  let c = it.context;
  debugger;
  it.looking = false;
  if( c.missingAction === 'undefine' || c.missingAction === 'ignore' )
  {
    it.result = undefined
  }
  else
  {
    debugger;
    let err = _.ErrorLooking
    (
      'Cant go down', _.strQuote( it.context.query ),
      '\nbecause', _.strQuote( _.path.join.apply( _.path, it.apath ) ), 'does not exist',
      '\nat', _.strQuote( it.path ),
      '\nin container', _.toStr( c.container )
    );
    debugger;
    it.result = undefined;
    it.iterator.error = err;
    if( c.missingAction === 'throw' )
    throw err;
  }
}

//

function errCantSetThrow( it )
{
  let c = it.context;
  debugger;
  throw _.err
  (
    'Cant set', _.strQuote( it.context.query ),
    'of container', _.toStr( c.container )
  );
}

//

function _entitySelect_pre( routine, args )
{

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    if( _.iterationIs( args[ 0 ] ) )
    o = { it : args[ 0 ], query : args[ 1 ] }
    else
    o = { container : args[ 0 ], query : args[ 1 ] }
  }

  _.routineOptionsPreservingUndefines( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( o.onTransient === null || _.routineIs( o.onTransient ) );
  _.assert( o.onActual === null || _.routineIs( o.onActual ) );
  _.assert( _.strIs( o.query ) );
  _.assert( _.strIs( o.downToken ) );
  _.assert( !_.strHas( o.query, '.' ) || _.strHas( o.query, '..' ), 'Temporary : query should not have dots' );
  _.assert( _.arrayHas( [ 'undefine', 'ignore', 'throw', 'error' ], o.missingAction ), 'Unknown missing action', o.missingAction );
  _.assert( o.aquery === undefined );

  o.prevContext = null;

  if( o.it )
  {
    _.assert( o.container === null );
    _.assert( _.iterationIs( o.it ) );
    _.assert( _.strIs( o.it.context.query ) );
    o.container = o.it.src;
    o.query = o.it.context.query + _.strsShortest( o.it.iterator.upToken ) + o.query;
    o.prevContext = o.it.context;
  }

  if( _.numberIs( o.query ) )
  o.aquery = [ o.query ];
  else
  o.aquery = _.strSplit
  ({
    src : o.query,
    delimeter : o.upToken,
    preservingDelimeters : 0,
    preservingEmpty : 0,
    stripping : 1,
  });

  if( o.setting === null && o.set !== null )
  o.setting = 1;

  let o2 = optionsFor( o );

  let it = _.look.pre( _.look, [ o2 ] );

  _.assert( it.context === o.prevContext || it.context === o );
  it.iterator.context = o;
  _.assert( it.context === o );

  return it;

  /* */

  function optionsFor( o )
  {

    let o2 = Object.create( null );
    o2.src = o.container;
    o2.context = o;
    o2.onUp = handleUp;
    o2.onDown = handleDown;
    o2.onIterate = handleIterate;
    o2.looker = Looker;
    // o2.trackingVisits = 0;
    o2.it = o.it;

    _.assert( arguments.length === 1 );

    return o2;
  }

  /* */

  function handleUp()
  {
    let it = this;
    let c = it.context;

    it.query = it.down ? c.aquery[ it.down.apath.length ] : c.aquery[ 0 ];
    it.apath = it.down ? it.down.apath.slice() : [];
    if( it.query !== undefined )
    it.apath.push( it.query );
    it.isActual = it.query === undefined;
    it.result = it.src;

    if( it.down && it.down.isRelative )
    {
      it.trackingVisits = 0;
    }

    // if( it.context && it.context.prevContext )
    // debugger;

    if( it.isActual )
    {
      /* actual node */
      it.looking = false;
      it.result = it.src;

      /* help if iteration reused */
      it.onResultWrite = function( eit )
      {
        this.result = eit.result;
      }

    }
    else if( it.query === c.downToken )
    {
      // it.trackingVisits = 0;
      it.isRelative = 1;
      it.onResultWrite = function( eit )
      {
        this.result = eit.result;
      }
    }
    else if( _.strBegins( it.query, '*' ) )
    {
      /* all selector */
      if( _.arrayLike( it.src ) )
      {
        it.result = [];
        it.onResultWrite = function( eit )
        {
          if( c.missingAction === 'ignore' && eit.result === undefined )
          return;
          this.result.push( eit.result );
        }
      }
      else if( _.objectLike( it.src ) )
      {
        it.result = Object.create( null );
        it.onResultWrite = function( eit )
        {
          if( c.missingAction === 'ignore' && eit.result === undefined )
          return;
          this.result[ eit.key ] = eit.result;
        }
      }
      else
      {
        errDoesNotExistThrow( it );
      }
    }
    else
    {
      /* select single */

      // it.looking = false;
      it.onResultWrite = function( eit )
      {
        this.result = eit.result;
      }

    }

  }

  /* */

  function handleIterate( onElement )
  {
    let it = this;
    let c = it.context;

    // if( it.context && it.context.prevContext )
    // debugger;

    if( !it.query )
    {
    }
    else if( it.query === c.downToken )
    {
      let counter = 0;
      let dit = it.down;
      let rit = it; /* !!! simply use down maybe? could fail maybe? */

      if( !dit )
      return errNoDownThrow( it );

      while( dit.query === c.downToken || dit.isActual || counter > 0 )
      {
        if( dit.query === c.downToken )
        counter += 1;
        else if( !dit.isActual )
        counter -= 1;
        dit = dit.down;
        rit = rit.down;
        if( !dit )
        return errNoDownThrow( it );
      }

      _.assert( _.iterationIs( dit ) );

      rit.visitEndMaybe();

      let src = dit.src;
      dit = dit.iteration();
      dit.path = it.path;
      dit.down = it;
      dit.select( it.query );
      dit.src = src;

      onElement( dit, it );

    }
    else if( _.strBegins( it.query, '*' ) )
    {
      _.Looker.Defaults.onIterate.call( this, onElement );
    }
    else
    {

      if( _.primitiveIs( it.src ) )
      {
        errDoesNotExistThrow( it );
      }
      else if( it.context.usingIndexedAccessToMap && _.objectLike( it.src ) && !isNaN( _.numberFromStr( it.query ) ) )
      {
        let q = _.numberFromStr( it.query );
        it.query = _.mapKeys( it.src )[ q ];
        if( it.query === undefined )
        return errDoesNotExistThrow( it );
      }
      else if( it.src[ it.query ] === undefined )
      {
        errDoesNotExistThrow( it );
      }
      else
      {
      }

      let eit = it.iteration().select( it.query );

      onElement( eit )

    }

  }

  /* */

  function handleDown()
  {
    let it = this;
    let c = it.context;

    // if( it.context && it.context.prevContext )
    // debugger;

    /* */

    if( !it.query )
    {
    }
    else if( it.query === c.downToken )
    {
    }
    else if( _.strBegins( it.query, '*' ) )
    {
      if( it.query !== '*' )
      {
        let number = _.numberFromStr( _.strRemoveBegin( it.query, '*' ) );
        _.sure( !isNaN( number ) && number >= 0 );
        _.sure( _.entityLength( it.result ) === number );
      }
    }
    else
    {
    }

    /* */

    if( it.context.onTransient )
    it.context.onTransient( it );

    if( it.context.onActual && it.isActual )
    it.context.onActual( it );

    if( it.context.setting && it.isActual )
    {
      if( it.down && it.down.src )
      it.down.src[ it.key ] = it.context.set;
      else
      errCantSetThrow( it );
    }

    if( it.down )
    {
      _.assert( _.routineIs( it.down.onResultWrite ) );
      it.down.onResultWrite( it );
    }

    return it.result;
  }

}

//

function _entitySelectAct_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.looker ) );
  _.assert( _.prototypeOf( it.looker, it ) );
  it.context.iteration = _.look.body( it );
  return it;
}

_entitySelectAct_body.defaults =
{
  it : null,
  container : null,
  query : null,
  missingAction : 'undefine',
  usingIndexedAccessToMap : 0,
  upToken : '/',
  downToken : '..',
  onTransient : null,
  onActual : null,
  set : null,
  setting : null,
}

//

let entitySelectAct = _.routineFromPreAndBody( _entitySelect_pre, _entitySelectAct_body );

//

function _entitySelect_body( it )
{
  let it2 = _.entitySelectAct.body( it );
  _.assert( it2 === it )
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( it.context.missingAction === 'error' && it.error )
  return it.error;
  return it.result;
}

_.routineExtend( _entitySelect_body, entitySelectAct );

//

let entitySelect = _.routineFromPreAndBody( _entitySelect_pre, _entitySelect_body );

//

let entitySelectSet = _.routineFromPreAndBody( entitySelect.pre, entitySelect.body );

var defaults = entitySelectSet.defaults;

defaults.set = null;
defaults.setting = 1;

//

function _entitySelectUnique_body( o )
{
  _.assert( arguments.length === 1 );

  let result = _.entitySelect.body( o );
  if( _.arrayHas( o.aquery, '*' ) )
  result = _.arrayUnique( result );

  return result;
}

_.routineExtend( _entitySelectUnique_body, entitySelect.body );

let entitySelectUnique2 = _.routineFromPreAndBody( entitySelect.pre, _entitySelectUnique_body );

//

function _entityProbeReport( o )
{

  _.assert( arguments.length );
  o = _.routineOptions( _entityProbeReport,o );

  /* report */

  if( o.report )
  {
    if( !_.strIs( o.report ) )
    o.report = '';
    o.report += o.title + ' : ' + o.total + '\n';
    for( let r in o.result )
    {
      let d = o.result[ r ];
      o.report += o.tab;
      if( o.prependingByAsterisk )
      o.report += '*.';
      o.report += r + ' : ' + d.having.length;
      if( d.values )
      o.report += ' ' + _.toStrShort( d.values );
      o.report += '\n';
    }
  }

  return o.report;
}

_entityProbeReport.defaults =
{
  title : null,
  report : null,
  result : null,
  total : null,
  prependingByAsterisk : 1,
  tab : '  ',
}

//

function entityProbeField( o )
{

  if( arguments[ 1 ] !== undefined )
  {
    o = Object.create( null );
    o.container = arguments[ 0 ];
    o.query = arguments[ 1 ];
  }

  _.routineOptions( entityProbeField,o );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o.all = _entitySelect( _.mapOnly( o, _entitySelectOptions.defaults ) );
  o.onElement = function( it ){ return it.up };
  o.parents = _entitySelect( _.mapOnly( o, _entitySelectOptions.defaults ) );
  o.result = Object.create( null );

  /* */

  for( let i = 0 ; i < o.all.length ; i++ )
  {
    let val = o.all[ i ];
    if( !o.result[ val ] )
    {
      let d = o.result[ val ] = Object.create( null );
      d.having = [];
      d.notHaving = [];
      d.value = val;
    }
    let d = o.result[ val ];
    d.having.push( o.parents[ i ] );
  }

  for( let k in o.result )
  {
    let d = o.result[ k ];
    for( let i = 0 ; i < o.all.length ; i++ )
    {
      let element = o.all[ i ];
      let parent = o.parents[ i ];
      if( !_.arrayHas( d.having, parent ) )
      d.notHaving.push( parent );
    }
  }

  /* */

  if( o.report )
  {
    if( o.title === null )
    o.title = o.query;
    o.report = _._entityProbeReport
    ({
      title : o.title,
      report : o.report,
      result : o.result,
      total : o.all.length,
      prependingByAsterisk : 0,
    });
  }

  return o;
}

entityProbeField.defaults = Object.create( entitySelect.defaults );

entityProbeField.defaults.title = null;
entityProbeField.defaults.report = 1;

//

function entityProbe( o )
{

  if( _.arrayIs( o ) )
  o = { src : o }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( entityProbe,o );
  _.assert( _.arrayIs( o.src ) || _.objectIs( o.src ) );

  o.result = o.result || Object.create( null );
  o.all = o.all || [];

  /* */

  _.entityMap( o.src, function( src,k )
  {

    o.total += 1;

    if( !_.longIs( src ) || !o.recursive )
    {
      _.assert( _.objectIs( src ) );
      if( src !== undefined )
      extend( o.result, src );
      return src;
    }

    for( let s = 0 ; s < src.length ; s++ )
    {
      if( _.arrayIs( src[ s ] ) )
      entityProbe
      ({
        src : src[ s ],
        result : o.result,
        assertingUniqueness : o.assertingUniqueness,
      });
      else if( _.objectIs( src[ s ] ) )
      extend( o.result, src );
      else
      throw _.err( 'array should have only maps' );
    }

    return src;
  });

  /* not having */

  for( let a = 0 ; a < o.all.length ; a++ )
  {
    let map = o.all[ a ];
    for( let r in o.result )
    {
      let field = o.result[ r ];
      if( !_.arrayHas( field.having,map ) )
      field.notHaving.push( map );
    }
  }

  if( o.report )
  o.report = _._entityProbeReport
  ({
    title : o.title,
    report : o.report,
    result : o.result,
    total : o.total,
    prependingByAsterisk : 1,
  });

  return o;

  /* */

  function extend( result,src )
  {

    o.all.push( src );

    if( o.assertingUniqueness )
    _.assertMapHasNone( result,src );

    for( let s in src )
    {
      if( !result[ s ] )
      {
        let r = result[ s ] = Object.create( null );
        r.times = 0;
        r.values = [];
        r.having = [];
        r.notHaving = [];
      }
      let r = result[ s ];
      r.times += 1;
      let added = _.arrayAppendedOnce( r.values,src[ s ] ) !== -1;
      r.having.push( src );
    }

  }

}

entityProbe.defaults =
{
  src : null,
  result : null,
  recursive : 0,
  report : 1,
  total : 0,
  all : null,
  title : 'Probe',
}

// --
// declare
// --

let Proto =
{

  errDoesNotExistThrow : errDoesNotExistThrow,
  errNoDownThrow : errNoDownThrow,
  errCantSetThrow : errCantSetThrow,

  entitySelectAct : entitySelectAct,
  entitySelect : entitySelect,
  entitySelectSet : entitySelectSet,
  entitySelectUnique : entitySelectUnique2,

  _entityProbeReport : _entityProbeReport,
  entityProbeField : entityProbeField,
  entityProbe : entityProbe,

}

_.mapSupplement( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
