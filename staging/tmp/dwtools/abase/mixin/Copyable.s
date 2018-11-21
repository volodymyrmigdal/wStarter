( function _Copyable_s_() {

'use strict';

/**
  @module Tools/base/CopyableMixin - Copyable mixin add copyability and clonability to your class. The module uses defined relation to deduce how to copy / clone the instanceCopyable mixin adds copyability and clonability to your class. The module uses defined relation to deduce how to copy / clone the instance.
*/

/**
 * @file Copyable.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    var toolsPath = '../../../dwtools/Base.s';
    var toolsExternal = 0;
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
  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wProto' );
  _.include( 'wCloner' );
  _.include( 'wStringer' );
  _.include( 'wLooker' );
  _.include( 'wComparator' );

}

//

var _global = _global_;
var _ = _global_.wTools;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

_.assert( !!_._cloner );

//

/**
 * Mixin this into prototype of another object.
 * @param {object} dstClass - constructor of class to mixin.
 * @method onMixin
 * @memberof wCopyable#
 */

function onMixin( mixinDescriptor, dstClass )
{

  var dstPrototype = dstClass.prototype;
  var has =
  {
    Composes : 'Composes',
    constructor : 'constructor',
  }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routineIs( dstClass ), () => 'mixin expects constructor, but got ' + _.strPrimitiveTypeOf( dstClass ) );
  _.assertMapOwnAll( dstPrototype, has );
  _.assert( _ObjectHasOwnProperty.call( dstPrototype,'constructor' ), 'prototype of object should has own constructor' );

  /* */

  _.mixinApply( this, dstPrototype );

  // _.mixinApply
  // ({
  //   dstPrototype : dstPrototype,
  //   descriptor : Self,
  // });

  /* instance accessors */

  var readOnly = { readOnlyProduct : 0, combining : 'supplement' };
  var names =
  {

    Self : readOnly,
    Parent : readOnly,
    className : readOnly,
    lowName : readOnly,
    nickName : readOnly,
    uname : readOnly,

    fieldsOfRelationsGroups : readOnly,
    fieldsOfCopyableGroups : readOnly,
    fieldsOfTightGroups : readOnly,
    fieldsOfInputGroups : readOnly,

  }

  _.accessor.readOnly
  ({
    object : dstPrototype,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* static accessors */

  var names =
  {
    Self : readOnly,
    Parent : readOnly,
    className : readOnly,
    lowName : readOnly,
    fieldsOfCopyableGroups : readOnly,
    fieldsOfTightGroups : readOnly,
    fieldsOfRelationsGroups : readOnly,
  }

  _.accessor.readOnly
  ({
    object : dstClass,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* */

  if( !Config.debug )
  return;

  if( _.routineIs( dstPrototype._equalAre ) )
  _.assert( dstPrototype._equalAre.length <= 1 );

  if( _.routineIs( dstPrototype.equalWith ) )
  _.assert( dstPrototype.equalWith.length <= 2 );

  _.assert( !!dstClass.prototype._fieldsOfRelationsGroupsGet );
  _.assert( !!dstClass._fieldsOfRelationsGroupsGet );
  _.assert( !!dstClass.fieldsOfRelationsGroups );
  _.assert( !!dstClass.prototype.fieldsOfRelationsGroups );
  // _.assert( _.mapKeys( dstClass.fieldsOfRelationsGroups ).length );

  _.assert( dstPrototype._fieldsOfRelationsGroupsGet === _fieldsOfRelationsGroupsGet );
  _.assert( dstPrototype._fieldsOfCopyableGroupsGet === _fieldsOfCopyableGroupsGet );
  _.assert( dstPrototype._fieldsOfTightGroupsGet === _fieldsOfTightGroupsGet );
  _.assert( dstPrototype._fieldsOfInputGroupsGet === _fieldsOfInputGroupsGet );

  _.assert( dstPrototype.constructor._fieldsOfRelationsGroupsGet === _fieldsOfRelationsGroupsStaticGet );
  _.assert( dstPrototype.constructor._fieldsOfCopyableGroupsGet === _fieldsOfCopyableGroupsStaticGet );
  _.assert( dstPrototype.constructor._fieldsOfTightGroupsGet === _fieldsOfTightGroupsStaticGet );
  _.assert( dstPrototype.constructor._fieldsOfInputGroupsGet === _fieldsOfInputGroupsStaticGet );

  _.assert( dstPrototype.finit.name !== 'finitEventHandler', 'wEventHandler mixin should goes after wCopyable mixin.' );
  _.assert( !_.mixinHas( dstPrototype,'wEventHandler' ), 'wEventHandler mixin should goes after wCopyable mixin.' );

}

//

/**
 * Default instance constructor.
 * @method init
 * @memberof wCopyable#
 */

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

}

//

/**
 * Instance descturctor.
 * @method finit
 * @memberof wCopyable#
 */

function finit()
{
  var self = this;
  _.instanceFinit( self );
}

//

/**
 * Is this instance finited.
 * @method finitedIs
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

function finitedIs()
{
  var self = this;
  return _.instanceIsFinited( self );
}

//

function From( src )
{
  var constr = this.Self;
  if( src instanceof constr )
  {
    _.assert( arguments.length === 1 );
    return src;
  }
  return new( _.constructorJoin( constr, arguments ) );
}

//

function Froms( srcs )
{
  var constr = this.Self;
  _.assert( arguments.length === 1 );
  if( srcs instanceof constr )
  {
    _.assert( arguments.length === 1 );
    return srcs;
  }
  if( _.arrayLike( srcs ) )
  {
    _.assert( arguments.length === 1 );
    var result = srcs.map( ( src ) =>
    {
      return constr.From( src );
    });
    return result;
  }
  return constr.From.apply( constr, arguments );
}

//

/**
 * Extend by data from another instance.
 * @param {object} src - another isntance.
 * @method extend
 * @memberof wCopyable#
 */

function extend( src )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src instanceof self.Self || _.mapIs( src ) );

  for( var s in src )
  {
    if( _.objectIs( self[ s ] ) )
    {
      if( _.routineIs( self[ s ].extend ) )
      self[ s ].extend( src[ s ] );
      else
      _.mapExtend( self[ s ],src[ s ] );
    }
    else
    {
      self[ s ] = src[ s ];
    }
  }

  return self;
}

//

/**
 * Copy data from another instance.
 * @param {object} src - another isntance.
 * @method copy
 * @memberof wCopyable#
 */

function copy( src )
{
  var self = this;
  var routine = ( self._traverseAct || _traverseAct );

  _.assert( arguments.length === 1,'Expects single argument' );
  _.assert( src instanceof self.Self || _.mapIs( src ),'Expects instance of Class or map as argument' );

  var o = { dst : self, src : src, technique : 'object' };
  var it = _._cloner( routine,o );

  return routine.call( self, it );
}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method copyCustom
 * @memberof wCopyable#
 */

function copyCustom( o )
{
  var self = this;
  var routine = ( self._traverseAct || _traverseAct );

  _.assert( arguments.length == 1 );

  if( o.dst === undefined )
  o.dst = self;

  var it = _._cloner( copyCustom,o );

  return routine.call( self, it );
}

copyCustom.iterationDefaults = Object.create( _._cloner.iterationDefaults );
copyCustom.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ),copyCustom.iterationDefaults );

//

function copyDeserializing( o )
{
  var self = this;

  _.assertMapHasAll( o,copyDeserializing.defaults )
  _.assertMapHasNoUndefine( o );
  _.assert( arguments.length == 1 );
  _.assert( _.objectIs( o ) );

  var optionsMerging = Object.create( null );
  optionsMerging.src = o;
  optionsMerging.proto = Object.getPrototypeOf( self );
  optionsMerging.dst = self;
  optionsMerging.deserializing = 1;

  var result = _.cloneObjectMergingBuffers( optionsMerging );

  return result;
}

copyDeserializing.defaults =
{
  descriptorsMap : null,
  buffer : null,
  data : null,
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneObject
 * @memberof wCopyable#
 */

function cloneObject( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.routineOptions( cloneObject,o );

  var it = _._cloner( cloneObject,o );

  return self._cloneObject( it );
}

cloneObject.iterationDefaults = Object.create( _._cloner.iterationDefaults );
cloneObject.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ),cloneObject.iterationDefaults );
cloneObject.defaults.technique = 'object';

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method _cloneObject
 * @memberof wCopyable#
 */

function _cloneObject( it )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.iterator.technique === 'object' );

  /* */

  if( !it.dst )
  {

    dst = it.dst = new it.src.constructor( it.src );
    if( it.dst === it.src )
    {
      debugger;
      dst = it.dst = new it.src.constructor();
      it.dst._traverseAct( it );
    }

  }
  else
  {

    debugger;
    it.dst._traverseAct( it );

  }

  return it.dst;
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneData
 * @memberof wCopyable#
 */

function cloneData( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  var it = _._cloner( cloneData,o );

  return self._cloneData( it );
}

cloneData.iterationDefaults = Object.create( _._cloner.iterationDefaults );
cloneData.iterationDefaults.dst = Object.create( null );
cloneData.iterationDefaults.copyingAggregates = 3;
cloneData.iterationDefaults.copyingAssociates = 0;
cloneData.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ), cloneData.iterationDefaults );
cloneData.defaults.technique = 'data';

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method _cloneData
 * @memberof wCopyable#
 */

function _cloneData( it )
{
  var self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.iterator.technique === 'data' );

  return self._traverseAct( it );
}

//

function _traverseActPre( it )
{
  var self = this;

  _.assert( _.objectIs( it ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  /* adjust */

  if( it.src === undefined )
  debugger;
  if( it.src === undefined )
  it.src = self;

  if( it.iterator.technique === 'data' )
  if( !it.dst )
  it.dst = Object.create( null );

  if( !it.proto && it.dst )
  it.proto = Object.getPrototypeOf( it.dst );
  if( !it.proto && it.src )
  it.proto = Object.getPrototypeOf( it.src );

}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method _traverseAct
 * @memberof wCopyable#
 */

var _empty = Object.create( null );
function _traverseAct( it )
{
  var self = this;

  /* adjust */

  self._traverseActPre( it );

  _.assert( _.objectIs( it.proto ) );

  /* var */

  var proto = it.proto;
  var src = it.src;
  var dst = it.dst;
  var dropFields = it.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;
  var Medials = proto.Medials || _empty;

  /* verification */

  _.assertMapHasNoUndefine( it );
  _.assertMapHasNoUndefine( it.iterator );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( src !== dst );
  _.assert( !!src );
  _.assert( _.objectIs( proto ) );
  _.assert( _.strIs( it.path ) );
  _.assert( _.objectIs( proto ),'Expects object {-proto-}, but got',_.strTypeOf( proto ) );
  _.assert( !it.customFields || _.objectIs( it.customFields ) );
  _.assert( it.level >= 0 );
  _.assert( _.numberIs( it.copyingDegree ) );
  _.assert( _.routineIs( self.__traverseAct ) );

  if( _.instanceIsStandard( src ) )
  _.assertMapOwnOnly( src, [ Composes, Aggregates, Associates, Restricts ], () => 'Options instance for ' + self.nickName + ' should not have fields' );
  else
  _.assertMapOwnOnly( src, [ Composes, Aggregates, Associates, Medials ], () => 'Options map for ' + self.nickName + ' should not have fields' );

  /* */

  if( it.dst === null )
  {

    dst = it.dst = new it.src.constructor( it.src );
    if( it.dst === it.src )
    {
      debugger;
      dst = it.dst = new it.src.constructor();
      self.__traverseAct( it );
    }

  }
  else
  {

    self.__traverseAct( it );

  }

  /* done */

  return dst;
}

_traverseAct.iterationDefaults = Object.create( _._cloner.iterationDefaults );
_traverseAct.defaults = _.mapSupplementOwn( Object.create( _._cloner.defaults ) , _traverseAct.iterationDefaults );

//

function __traverseAct( it )
{

  /* var */

  var proto = it.proto;
  var src = it.src;
  var dst = it.dst = it.dst;
  var dropFields = it.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;
  var Medials = proto.Medials || _empty;

  /* copy facets */

  function copyFacets( screen,copyingDegree )
  {

    _.assert( _.numberIs( copyingDegree ) );
    _.assert( it.dst === dst );
    _.assert( _.objectIs( screen ) || !copyingDegree );

    if( !copyingDegree )
    return;

    newIt.screenFields = screen;
    newIt.copyingDegree = Math.min( copyingDegree,it.copyingDegree );
    newIt.instanceAsMap = 1;

    _.assert( it.copyingDegree === 3,'not tested' );
    _.assert( newIt.copyingDegree === 1 || newIt.copyingDegree === 3,'not tested' );

    /* copyingDegree applicable to fields, so increment is needed */

    if( newIt.copyingDegree === 1 )
    newIt.copyingDegree += 1;

    _._traverseMap( newIt );

  }

  /* */

  var newIt = it.iterationClone();

  copyFacets( Composes,it.copyingComposes );
  copyFacets( Aggregates,it.copyingAggregates );
  copyFacets( Associates,it.copyingAssociates );
  copyFacets( _.mapOnly( Medials,Restricts ), it.copyingMedialRestricts );

  if( !_.instanceIsStandard( it.src ) )
  copyFacets( Medials,it.copyingMedials );

  copyFacets( Restricts,it.copyingRestricts );
  copyFacets( it.customFields,it.copyingCustomFields );

  /* done */

  return dst;
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneSerializing
 * @memberof wCopyable#
 */

function cloneSerializing( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  if( o.copyingMedials === undefined )
  o.copyingMedials = 0;

  if( o.copyingMedialRestricts === undefined )
  o.copyingMedialRestricts = 1;

  var result = _.cloneDataSeparatingBuffers( o );

  return result;
}

cloneSerializing.defaults =
{
  copyingMedialRestricts : 1,
}

cloneSerializing.defaults.__proto__ = _.cloneDataSeparatingBuffers.defaults;

//

/**
 * Clone instance.
 * @method clone
 * @param {object} [self] - optional destination
 * @memberof wCopyable#
 */

function clone()
{
  var self = this;

  _.assert( arguments.length === 0 );
  // _.assert( arguments.length <= 1 );

  // if( !dst )
  // {
    var dst = new self.constructor( self );
    _.assert( dst !== self );
    // if( dst === self )
    // {
    //   dst = new self.constructor();
    //   dst.copy( self );
    // }
  // }
  // else
  // {
  //   dst.copy( self );
  // }

  return dst;
}

//

function cloneOverriding( override )
{
  var self = this;

  _.assert( arguments.length <= 1 );

  if( !override )
  {
    debugger;
    var dst = new self.constructor( self );
    _.assert( dst !== self );
    // if( dst === self )
    // {
    //   dst = new self.constructor();
    //   dst.copy( self );
    // }
    return dst;
  }
  else
  {
    var src = _.mapOnly( self, self.Self.fieldsOfCopyableGroups );
    _.mapExtend( src,override );
    var dst = new self.constructor( src );
    _.assert( dst !== self && dst !== src );
    return dst;
  }

}

//

function cloneEmpty()
{
  var self = this;
  return self.clone();
}

// --
// etc
// --

/**
 * Gives descriptive string of the object.
 * @method toStr
 * @memberof wCopyable#
 */

function toStr( o )
{
  var self = this;
  var result = '';
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !o.jsLike && !o.jsonLike )
  result += self.nickName + '\n';

  var fields = self.fieldsOfTightGroups;

  var t = _.toStr( fields,o );
  _.assert( _.strIs( t ) );
  result += t;

  return result;
}

// --
// checker
// --

function _equalAre_functor( fieldsGroupsMap )
{
  _.assert( arguments.length <= 1 );

  fieldsGroupsMap = _.routineOptions( _equalAre_functor, fieldsGroupsMap );

  _.routineExtend( _equalAre, _._entityEqual );

  return _equalAre;

  function _equalAre( it )
  {

    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.objectIs( it.context ) );
    _.assert( it.context.strictTyping !== undefined );
    _.assert( it.context.containing !== undefined );

    if( !it.src )
    return false;

    if( !it.src2 )
    return false;

    if( it.context.strictTyping )
    if( it.src.constructor !== it.src2.constructor )
    return false;

    if( it.src === it.src2 )
    return end( true );

    /* */

    var fieldsMap = Object.create( null );
    for( var g in fieldsGroupsMap )
    if( fieldsGroupsMap[ g ] )
    _.mapExtend( fieldsMap, this[ g ] );

    /* */

    // debugger;
    for( var f in fieldsMap )
    {
      if( !it.looking || !it.iterator.looking )
      break;
      var newIt = it.iteration().select( f );
      if( !_.mapHas( it.src, f ) )
      return end( false );
      if( !_._entityEqual.body( newIt ) )
      return end( false );
    }

    /* */

    if( !it.context.containing )
    {

      if( !( it.src2 instanceof this.constructor ) )
      if( _.mapKeys( _.mapBut( it.src, fieldsMap ) ).length )
      return end( false );

    }

    if( !( it.src instanceof this.constructor ) )
    if( _.mapKeys( _.mapBut( it.src, fieldsMap ) ).length )
    return end( false );

    /* */

    return end( true );

    /* */

    function end( result )
    {
      it.looking = false;
      return result;
    }

  }

}

_equalAre_functor.defaults = Object.create( null );

var on = _.mapMake( _.DefaultFieldsGroupsCopyable );
var off = _.mapBut( _.DefaultFieldsGroups, _.DefaultFieldsGroupsCopyable );
_.mapValsSet( on, 1 );
_.mapValsSet( off, 0 );
_.mapExtend( _equalAre_functor.defaults, on, off );

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method equalWith
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var _equalAre = _equalAre_functor();

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method identicalWith
 * @param {object} src - another instance of the class
 * @memberof wCopyable#
 */

function identicalWith( src, opts )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !opts || _.mapIs( opts ), 'not tested' );

  var args = [ self, src, opts ];
  var it = self._equalAre.pre.call( self, self.identicalWith, args );
  var result = this._equalAre( it );

  return result;
}

_.routineExtend( identicalWith, _.entityIdentical );

//

/**
 * Is this instance equivalent with another one. Use relation maps to compare.
 * @method equivalentWith
 * @param {object} src - another instance of the class
 * @memberof wCopyable#
 */

function equivalentWith( src, opts )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !opts || _.mapIs( opts ), 'not tested' );

  var args = [ self, src, opts ];
  var it = self._equalAre.pre.call( self, self.equivalentWith, args );
  var result = this._equalAre( it );

  return result;
}

_.routineExtend( equivalentWith, _.entityEquivalent );

//

/**
 * Does this instance contain with another instance or map.
 * @method contains
 * @param {object} src - another instance of the class
 * @memberof wCopyable#
 */

function contains( src, opts )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( !opts || _.mapIs( opts ), 'not tested' );

  var args = [ self, src, opts ];
  var it = self._equalAre.pre.call( self, self.contains, args );
  var result = this._equalAre( it );

  return result;
}

_.routineExtend( contains, _.entityContains );

//

function instanceIs()
{
  _.assert( arguments.length === 0 );
  return _.instanceIs( this );
}

//

function prototypeIs()
{
  _.assert( arguments.length === 0 );
  return _.prototypeIs( this );
}

//

function constructorIs()
{
  _.assert( arguments.length === 0 );
  return _.constructorIs( this );
}

// --
// field
// --

/**
 * Get map of all fields.
 * @method _fieldsOfRelationsGroupsGet
 * @memberof wCopyable
 */

function _fieldsOfRelationsGroupsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _fieldsOfRelationsGroupsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapOnly( self, _fieldsOfRelationsGroupsStaticGet.call( self ) );

  return result;
}

//

/**
 * Get map of copyable fields.
 * @method _fieldsOfCopyableGroupsGet
 * @memberof wCopyable
 */

function _fieldsOfCopyableGroupsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _fieldsOfCopyableGroupsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapOnly( self, self.Self.fieldsOfCopyableGroups );
  return result;
}

//

/**
 * Get map of loggable fields.
 * @method _fieldsOfTightGroupsGet
 * @memberof wCopyable
 */

function _fieldsOfTightGroupsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _fieldsOfTightGroupsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapOnly( self, self.Self.fieldsOfTightGroups );
  return result;
}

//

function _fieldsOfInputGroupsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _fieldsOfInputGroupsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapOnly( self, self.Self.fieldsOfInputGroups );
  return result;
}

//

function fieldDescriptorGet( nameOfField )
{
  var proto = _.prototypeGet( this );
  var report = Object.create( null );

  _.assert( _.strDefined( nameOfField ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  for( var f in _.DefaultFieldsGroups )
  {
    var facility = _.DefaultFieldsGroups[ f ];
    if( proto[ facility ] )
    if( proto[ facility ][ nameOfField ] !== undefined )
    report[ facility ] = true;
  }

  return report;
}

//

/**
 * Get map of all relations fields.
 * @method _fieldsOfRelationsGroupsStaticGet
 * @memberof wCopyable#
 */

function _fieldsOfRelationsGroupsStaticGet()
{
  return _.fieldsOfRelationsGroups( this );
}

//

/**
 * Get map of copyable fields.
 * @method _fieldsOfCopyableGroupsStaticGet
 * @memberof wCopyable#
 */

function _fieldsOfCopyableGroupsStaticGet()
{
  return _.fieldsOfCopyableGroups( this );
}

//

/**
 * Get map of tight fields.
 * @method _fieldsOfTightGroupsStaticGet
 * @memberof wCopyable#
 */

function _fieldsOfTightGroupsStaticGet()
{
  return _.fieldsOfTightGroups( this );
}

//

/**
 * Get map of input fields.
 * @method _fieldsOfInputGroupsStaticGet
 * @memberof wCopyable#
 */

function _fieldsOfInputGroupsStaticGet()
{
  return _.fieldsOfInputGroups( this );
}

//

function hasField( fieldName )
{
  debugger;
  return _.prototypeHasField( this,fieldName );
}

// --
// class
// --

/**
 * Return own constructor.
 * @method _SelfGet
 * @memberof wCopyable#
 */

function _SelfGet()
{
  var result = _.constructorGet( this );
  return result;
}

//

/**
 * Return parent's constructor.
 * @method _ParentGet
 * @memberof wCopyable#
 */

function _ParentGet()
{
  var result = _.parentGet( this );
  return result;
}

// --
// name
// --

function _lowNameGet()
{
  var name = this.className;
  name = _.strDecapitalize( name );
  return name;
}

//

/**
 * Return name of class constructor.
 * @method _classNameGet
 * @memberof wCopyable#
 */

function _classNameGet()
{
  _.assert( this.constructor === null || _.strIs( this.constructor.name ) || _.strIs( this.constructor._name ) );
  return this.constructor ? ( this.constructor.name || this.constructor._name ) : '';
}

//

/**
 * Nick name of the object.
 * @method _nickNameGet
 * @memberof wCopyable#
 */

function _nickNameGet()
{
  var self = this;
  var result = ( self.key || self.name || '' );
  var index = '';
  if( _.numberIs( self.instanceIndex ) )
  result += '#in' + self.instanceIndex;
  if( Object.hasOwnProperty.call( self,'id' ) )
  result += '#id' + self.id;
  return self.className + '( ' + result + ' )';
}

//

function unameGet()
{
  var self = this;
  return self.className + '( ' + '#id' + self.id + ' )';
}


//
//
// /**
//  * Unique name of the object.
//  * @method _uniqueNameGet
//  * @memberof wCopyable#
//  */
//
// function _uniqueNameGet()
// {
//   var self = this;
//   var result = '';
//   var index = '';
//   if( _.numberIs( self.instanceIndex ) )
//   result += '#in' + self.instanceIndex;
//   if( Object.hasOwnProperty.call( self,'id' ) )
//   result += '#id' + self.id;
//   return self.className + '( ' + result + ' )';
// }

// --
// relations
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

var Medials =
{
}

var Statics =
{

  From : From,
  Froms : Froms,

  instanceIs : instanceIs,
  prototypeIs : prototypeIs,
  constructorIs : constructorIs,

  '_fieldsOfRelationsGroupsGet' : _fieldsOfRelationsGroupsStaticGet,
  '_fieldsOfCopyableGroupsGet' : _fieldsOfCopyableGroupsStaticGet,
  '_fieldsOfTightGroupsGet' : _fieldsOfTightGroupsStaticGet,
  '_fieldsOfInputGroupsGet' : _fieldsOfInputGroupsStaticGet,

  hasField : hasField,

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,
  '_classNameGet' : _classNameGet,
  '_lowNameGet' : _lowNameGet,

}

Object.freeze( Composes );
Object.freeze( Aggregates );
Object.freeze( Associates );
Object.freeze( Restricts );
Object.freeze( Medials );
Object.freeze( Statics );

// --
// declare
// --

var Supplement =
{

  init : init,
  finit : finit,
  finitedIs : finitedIs,

  From : From,
  Froms : Froms,

  extend : extend,
  copy : copy,

  copyCustom : copyCustom,
  copyDeserializing : copyDeserializing,

  _traverseActPre : _traverseActPre,
  _traverseAct : _traverseAct,
  __traverseAct : __traverseAct,

  cloneObject : cloneObject,
  _cloneObject : _cloneObject,

  cloneData : cloneData,
  _cloneData : _cloneData,

  cloneSerializing : cloneSerializing,
  clone : clone,
  cloneOverriding : cloneOverriding,
  cloneEmpty : cloneEmpty,

  // etc

  toStr : toStr,

  // checker

  _equalAre_functor : _equalAre_functor,
  _equalAre : _equalAre,

  identicalWith : identicalWith,
  equivalentWith : equivalentWith,
  contains : contains,

  instanceIs : instanceIs,
  prototypeIs : prototypeIs,
  constructorIs : constructorIs,

  // field

  '_fieldsOfRelationsGroupsGet' : _fieldsOfRelationsGroupsGet,
  '_fieldsOfCopyableGroupsGet' : _fieldsOfCopyableGroupsGet,
  '_fieldsOfTightGroupsGet' : _fieldsOfTightGroupsGet,
  '_fieldsOfInputGroupsGet' : _fieldsOfInputGroupsGet,
  fieldDescriptorGet : fieldDescriptorGet,

  // class

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,

  // name

  '_lowNameGet' : _lowNameGet,
  '_classNameGet' : _classNameGet,
  '_nickNameGet' : _nickNameGet,
  // '_uniqueNameGet' : _uniqueNameGet,
  unameGet : unameGet,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Medials : Medials,
  Statics : Statics,

}

//

var Self = _.mixinDelcare
({
  supplement : Supplement,
  onMixin : onMixin,
  name : 'wCopyable',
  shortName : 'Copyable',
});

//

_.assert( !Self.copy );
_.assert( _.routineIs( Self.prototype.copy ) );
_.assert( _.strIs( Self.shortName ) );
_.assert( _.objectIs( Self.__mixin__ ) );
_.assert( !Self.onMixin );
_.assert( _.routineIs( Self.mixin ) );

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
