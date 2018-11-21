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
// Looker.Iteration.apath = null;
Looker.Iteration.query = null;
Looker.Iteration.queryParsed = null;
Looker.Iteration.writeToDown = null;
Looker.Iteration.isFinal = null;
Looker.Iteration.isRelative = false;
Looker.Iteration.isGlob = false;
Looker.Iteration.writingDown = true;

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
      'Cant select', _.strQuote( c.query ),
      '\nbecause', _.strQuote( it.query ), 'does not exist',
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
      'Cant go down', _.strQuote( c.query ),
      '\nbecause', _.strQuote( it.query ), 'does not exist',
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
    'Cant set', _.strQuote( c.query ),
    'of container', _.toStr( c.container )
  );
}

//

function _select_pre( routine, args )
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
  _.assert( o.onUpBegin === null || _.routineIs( o.onUpBegin ) );
  _.assert( o.onDownBegin === null || _.routineIs( o.onDownBegin ) );
  _.assert( _.strIs( o.query ) );
  _.assert( _.strIs( o.downToken ) );
  // _.assert( !_.strHas( o.query, '.' ) || _.strHas( o.query, '..' ), 'Temporary : query should not have dots', o.query );
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
    o2.onUp = up;
    o2.onDown = down;
    o2.onIterate = iterate;
    // o2.onTerminal = o.onTerminal;
    o2.looker = Looker;
    o2.trackingVisits = o.trackingVisits;
    o2.it = o.it;
    o2._inherited = o._inherited;

    _.assert( arguments.length === 1 );

    return o2;
  }

  /* */

  function up()
  {
    let it = this;
    let c = it.context;

    // debugger;

    it.query = c.aquery[ it.logicalLevel-1 ];
    it.result = it.src;

    it.writeToDown = function writeToDown( eit )
    {
      this.result = eit.result;
    }

    if( c.onUpBegin )
    c.onUpBegin.call( it );

    it.isRelative = it.query === c.downToken;
    it.isFinal = it.query === undefined;
    it.isGlob = it.query ? _.strHas( it.query, '*' ) : false;

    // debugger;

    if( it.isFinal )
    upFinal.call( this );
    else if( it.query === c.downToken )
    upDown.call( this );
    else if( it.isGlob )
    upGlob.call( this );
    else
    upSingle.call( this );

    if( c.onUpEnd )
    c.onUpEnd.call( it );

  }

  /* */

  function iterate( onIteration )
  {
    let it = this;
    let c = it.context;

    // debugger;

    if( it.isFinal )
    iterateFinal.call( this, onIteration );
    else if( it.query === c.downToken )
    iterateDown.call( this, onIteration );
    else if( it.isGlob )
    iterateGlob.call( this, onIteration );
    else
    iterateSingle.call( this, onIteration );

  }

  /* */

  function down()
  {
    let it = this;
    let c = it.context;

    if( c.onDownBegin )
    c.onDownBegin.call( it );

    // debugger;

    if( it.isFinal )
    downFinal.call( this );
    else if( it.query === c.downToken )
    downDown.call( this );
    else if( it.isGlob )
    downGlob.call( this );
    else
    downSingle.call( this );

    if( c.setting && it.isFinal )
    {
      if( it.down && it.down.src )
      it.down.src[ it.key ] = c.set;
      else
      errCantSetThrow( it );
    }

    if( c.onDownEnd )
    c.onDownEnd.call( it );

    if( it.down )
    {
      _.assert( _.routineIs( it.down.writeToDown ) );
      if( it.writingDown )
      it.down.writeToDown( it );
    }

    return it.result;
  }

  /* - */

  function upFinal()
  {
    let it = this;
    let c = it.context;

    /* actual node */
    it.looking = false;
    it.result = it.src;

  }

  /* */

  function upDown()
  {
    let it = this;
    let c = it.context;

    // it.isRelative = true;
    _.assert( it.isRelative === true )
    it.writeToDown = function( eit )
    {
      this.result = eit.result;
    }

  }

  /* */

  function upGlob()
  {
    let it = this;
    let c = it.context;

    /* !!! qqq : teach it to parse more than single "*=" */

    let regexp = /(.*){?\*=(\d*)}?(.*)/;
    let match = it.query.match( regexp );
    it.queryParsed = it.queryParsed || Object.create( null );

    if( !match )
    {
      it.queryParsed.glob = it.query;
    }
    else
    {
      _.sure( _.strCount( it.query, '=' ) <= 1, () => 'Does not support query with several assertions, like ' + _.strQuote( it.query ) );
      it.queryParsed.glob = match[ 1 ] + '*' + match[ 3 ];
      if( match[ 2 ].length > 0 )
      {
        it.queryParsed.limit = _.numberFromStr( match[ 2 ] );
        _.sure( !isNaN( it.queryParsed.limit ) && it.queryParsed.limit >= 0, () => 'Epects non-negative number after "=" in ' + _.strQuote( it.query ) );
      }
    }

    // debugger;
    if( it.queryParsed.glob !== '*' && c.usingGlob )
    it.src = _.path.globFilter( it.queryParsed.glob, it.src );
    // debugger;

    if( _.arrayLike( it.src ) )
    {
      it.result = [];
      it.writeToDown = function( eit )
      {
        if( c.missingAction === 'ignore' && eit.result === undefined )
        return;
        this.result.push( eit.result );
      }
    }
    else if( _.objectLike( it.src ) )
    {
      it.result = Object.create( null );
      it.writeToDown = function( eit )
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

  /* */

  function upSingle()
  {
    let it = this;
    let c = it.context;
  }

  /* - */

  function iterateFinal( onIteration )
  {
    let it = this;
    let c = it.context;
  }

  /* */

  function iterateDown( onIteration )
  {
    let it = this;
    let c = it.context;
    let counter = 0;
    let dit = it.down;

    if( !dit )
    return errNoDownThrow( it );

    while( dit.query === c.downToken || dit.isFinal || counter > 0 )
    {
      if( dit.query === c.downToken )
      counter += 1;
      else if( !dit.isFinal )
      counter -= 1;
      dit = dit.down;
      if( !dit )
      return errNoDownThrow( it );

    }

    _.assert( _.iterationIs( dit ) );

    it.visitEndMaybe();
    dit.visitEndMaybe();

    let nit = it.iteration();
    nit.select( it.query );
    nit.src = dit.src;
    nit.result = undefined;

    onIteration.call( it, nit );

    return true;
  }

  /* */

  function iterateGlob( onIteration )
  {
    let it = this;
    let c = it.context;

    // let filtered = _.globFilter( it.query, it.src );

    _.Looker.Defaults.onIterate.call( this, onIteration );

  }

  /* */

  function iterateSingle( onIteration )
  {
    let it = this;
    let c = it.context;

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

    let eit = it.iteration().select( it.query ).select2( it.query ); /* !!! is select2 required? */

    onIteration.call( it, eit );

  }

  /* - */

  function downFinal()
  {
    let it = this;
    let c = it.context;
  }

  /* */

  function downDown()
  {
    let it = this;
    let c = it.context;
  }

  /* */

  function downGlob()
  {
    let it = this;
    let c = it.context;

    // debugger;

    if( it.queryParsed.limit !== undefined )
    {
      let length = _.entityLength( it.result );
      if( length !== it.queryParsed.limit )
      {
        debugger;
        throw _.ErrorLooking
        (
          'Select constraint ' + _.strQuote( it.query ) + ' failed'
          + ', got ' + length + ' elements'
          + ' in query ' + _.strQuote( c.query )
        );
      }
    }

  }

  /* */

  function downSingle()
  {
    let it = this;
    let c = it.context;
  }

}

//

function _selectAct_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.looker ) );
  _.assert( _.prototypeOf( it.looker, it ) );
  it.context.iteration = _.look.body( it );
  return it;
}

_selectAct_body.defaults =
{
  it : null,
  container : null,
  query : null,
  missingAction : 'undefine',
  usingIndexedAccessToMap : 0,
  usingGlob : 1,
  trackingVisits : 1,
  upToken : '/',
  downToken : '..',
  onUpBegin : null,
  onUpEnd : null,
  onDownBegin : null,
  onDownEnd : null,
  // onTerminal : null,
  set : null,
  setting : null,
  _inherited : null,
}

//

let selectAct = _.routineFromPreAndBody( _select_pre, _selectAct_body );

//

function _select_body( it )
{
  let it2 = _.selectAct.body( it );
  _.assert( it2 === it )
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( it.context.missingAction === 'error' && it.error )
  return it.error;
  return it.result;
}

_.routineExtend( _select_body, selectAct );

//

let select = _.routineFromPreAndBody( _select_pre, _select_body );

//

let selectSet = _.routineFromPreAndBody( select.pre, select.body );

var defaults = selectSet.defaults;

defaults.set = null;
defaults.setting = 1;

//

function _selectUnique_body( o )
{
  _.assert( arguments.length === 1 );

  let result = _.select.body( o );
  if( _.arrayHas( o.aquery, '*' ) )
  result = _.arrayUnique( result );

  return result;
}

_.routineExtend( _selectUnique_body, select.body );

let selectUnique2 = _.routineFromPreAndBody( select.pre, _selectUnique_body );

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
  o.all = _.select( _.mapOnly( o, _.select.defaults ) );
  o.onElement = function( it ){ return it.up };
  o.parents = _.select( _.mapOnly( o, _.select.defaults ) );
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

entityProbeField.defaults = Object.create( select.defaults );
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

  selectAct : selectAct,
  select : select,
  selectSet : selectSet,
  selectUnique : selectUnique2,

  _entityProbeReport : _entityProbeReport,
  entityProbeField : entityProbeField,
  entityProbe : entityProbe,

}

_.mapSupplement( Self, Proto );

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
