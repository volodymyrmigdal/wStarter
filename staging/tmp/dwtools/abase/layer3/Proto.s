( function _Proto_s_() {

'use strict';

/**
  @module Tools/base/Proto - Relations module. Collection of routines to define classes and relations between them. Proto leverages multiple inheritances, mixins, accessors, fields groups defining, introspection and more. Use it as a skeleton of the application.
*/

/*
  xxx : replace var -> let
*/

/**
* Definitions :

*  self :: current object.
*  Self :: current class.
*  Parent :: parent class.
*  Statics :: static fields.
*  extend :: extend destination with all properties from source.
*  supplement :: supplement destination with those properties from source which do not belong to source.

*  routine :: arithmetical,logical and other manipulations on input data, context and globals to get output data.
*  function :: routine which does not have side effects and don't use globals or context.
*  procedure :: routine which use globals, possibly modify global's states.
*  method :: routine which has context, possibly modify context's states.

* Synonym :

  A composes B
    :: A consists of B.s
    :: A comprises B.
    :: A made up of B.
    :: A exists because of B, and B exists because of A.
    :: A складається із B.
  A aggregates B
    :: A has B.
    :: A exists because of B, but B exists without A.
    :: A має B.
  A associate B
    :: A has link on B
    :: A is linked with B
    :: A посилається на B.
  A restricts B
    :: A use B.
    :: A has occasional relation with B.
    :: A використовує B.
    :: A має обмежений, не чіткий, тимчасовий звязок із B.

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

  if( !_global_.wTools.nameFielded )
  try
  {
    require( './NameTools.s' );
  }
  catch( err )
  {
  }

}

var Self = _global_.wTools;
var _global = _global_;
var _ = _global_.wTools;

var _ObjectHasOwnProperty = Object.hasOwnProperty;
var _propertyIsEumerable = Object.propertyIsEnumerable;
var _nameFielded = _.nameFielded;

_.assert( _.objectIs( _.field ),'wProto needs wTools/staging/dwtools/abase/layer1/FieldMapper.s' );
_.assert( _.routineIs( _nameFielded ),'wProto needs wTools/staging/dwtools/abase/layer3/NameTools.s' );

// --
// accessor
// --

/**
 * Generates options object for _accessor, _accessorForbid functions.
 * Can be called in three ways:
 * - First by passing all options in one object;
 * - Second by passing object and name options;
 * - Third by passing object,names and message option as third parameter.
 * @param {wTools~accessorOptions} o - options {@link wTools~accessorOptions}.
 *
 * @example
 * //returns
 * // { object: [Function],
 * // methods: [Function],
 * // names: { a: 'a', b: 'b' },
 * // message: [ 'set/get call' ] }
 *
 * var Self = function ClassName( o ) { };
 * _._accessor_pre( Self,{ a : 'a', b : 'b' }, 'set/get call' );
 *
 * @private
 * @method _accessor_pre
 * @memberof wTools
 */

function _accessor_pre( routine, args )
{
  var o;

  _.assert( arguments.length === 2 );

  if( args.length === 1 )
  {
    o = args[ 0 ];
  }
  else
  {
    o = Object.create( null );
    o.object = args[ 0 ];
    o.names = args[ 1 ];
    _.assert( args.length >= 2 );
  }

  // if( !o.methods )
  // o.methods = o.object;
  // else
  // o.methods = _.mapExtend( null, o.methods );

  // if( !_.arrayIs( o.names ) )
  // o.names = _nameFielded( o.names );
  // else
  // o.names = o.names;

  if( args.length > 2 )
  {
    o.message = _.longSlice( args, 2 );
  }

  if( _.strIs( o.names ) )
  o.names = { [ o.names ] : o.names }

  _.routineOptions( routine, o );
  _.assert( !_.primitiveIs( o.object ),'expects object as argument but got', o.object );
  _.assert( _.objectIs( o.names ) || _.arrayIs( o.names ),'expects object names as argument but got', o.names );

  return o;
}

//

function _accessorRegister( o )
{

  _.routineOptions( _accessorRegister, arguments );
  _.assert( _.prototypeIsStandard( o.proto ), 'expects formal prototype' );
  _.assert( _.strIsNotEmpty( o.declaratorName ) );
  _.assert( _.arrayIs( o.declaratorArgs ) );
  _.fieldsGroupFor( o.proto, '_Accessors' );

  var accessors = o.proto._Accessors;

  if( o.combining && o.combining !== 'rewrite' && o.combining !== 'supplement' )
  debugger;

  if( Config.debug )
  if( !o.combining )
  {
    var stack = accessors[ o.name ] ? accessors[ o.name ].stack : '';
    _.assert
    (
      !accessors[ o.name ],
      'defined at' + '\n',
      stack,
      '\naccessor',o.name,'of',o.proto.constructor.name
    );
    if( accessors[ o.name ] )
    debugger;
  }

  _.assert( !o.combining || o.combining === 'rewrite' || o.combining === 'append' || o.combining === 'supplement', 'not supported ( o.combining )',o.combining );
  _.assert( _.strIs( o.name ) );

  if( accessors[ o.name ] && o.combining === 'supplement' )
  return;

  var descriptor =
  {
    name : o.name,
    declaratorName : o.declaratorName,
    declaratorArgs : o.declaratorArgs,
    declaratorKind : o.declaratorKind,
    combining : o.combining,
  }

  if( Config.debug )
  descriptor.stack = _.diagnosticStack();

  if( o.combining === 'append' )
  {
    if( _.arrayIs( accessors[ o.name ] ) )
    accessors[ o.name ].push( descriptor );
    else
    accessors[ o.name ] = [ descriptor ];
  }

  accessors[ o.name ] = descriptor;

  return descriptor;
}

_accessorRegister.defaults =
{
  name : null,
  proto : null,
  declaratorName : null,
  declaratorArgs : null,
  declaratorKind : null,
  combining : 0,
}

//

var AccessorDefaults =
{
  strict : 1,
  preserveValues : 1,
  prime : 1,
  combining : null,

  readOnly : 0,
  readOnlyProduct : 0,
  enumerable : 1,
  configurable : 0,
}

function _accessorAct( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.name ) );
  _.assertRoutineOptions( _accessorAct, arguments );

  // var appending = 0;

  if( o.combining === 'append' )
  debugger;

  // if( o.name === 'array' )
  // debugger;

  /* */

  var propertyDescriptor = _.propertyDescriptorForAccessor( o.object, o.name );
  if( propertyDescriptor.descriptor )
  {

    _.assert
    (
      _.strIs( o.combining ), () =>
      'overriding of property ' + o.name + '\n' +
      '{-o.combining-} suppose to be ' + _.strQuote( Combining ) + ' if accessor overided, ' +
      'but is' + _.strQuote( o.combining )
    );

    _.assert( o.combining === 'rewrite' || o.combining === 'append' || o.combining === 'supplement','not implemented' );

    if( o.combining === 'supplement' )
    return;

    _.assert( o.combining === 'rewrite', 'not implemented' );
    _.assert( propertyDescriptor.object !== o.object, () => 'Attempt to redefine own accessor ' + _.strQuote( o.name ) + ' of ' + _.toStrShort( o.object ) );

    // if( o.combining === 'append' )
    // {
    //
    //   debugger;
    //
    //   if( o.methods[ '_' + rawName + 'Set' ] === propertyDescriptor.descriptor.set )
    //   o.methods[ '_' + rawName + 'Set' ] = null;
    //   if( o.methods[ rawName + 'Set' ] === propertyDescriptor.descriptor.set )
    //   o.methods[ rawName + 'Set' ] = null;
    //   if( o.methods[ '_' + rawName + 'Get' ] === propertyDescriptor.descriptor.get )
    //   o.methods[ '_' + rawName + 'Get' ] = null;
    //   if( o.methods[ rawName + 'Get' ] === propertyDescriptor.descriptor.get )
    //   o.methods[ rawName + 'Get' ] = null;
    //
    //   var settrGetterSecond = _propertyGetterSetterMake( o,o.methods,rawName );
    //
    //   if( o.methods[ '_' + rawName + 'Set' ] )
    //   o.methods[ '_' + rawName + 'Set' ] = null;
    //   if( o.methods[ rawName + 'Set' ] )
    //   o.methods[ rawName + 'Set' ] = null;
    //   if( o.methods[ '_' + rawName + 'Get' ] )
    //   o.methods[ '_' + rawName + 'Get' ] = null;
    //   if( o.methods[ rawName + 'Get' ] )
    //   o.methods[ rawName + 'Get' ] = null;
    //
    //   o.methods[ '_' + rawName + 'Set' ] = function appendingSet( src )
    //   {
    //     debugger;
    //     src = propertyDescriptor.descriptor.set.call( this,src );
    //     _.assert( src !== undefined );
    //     return settrGetterSecond.set.call( this,src );
    //   }
    //
    //   o.methods[ '_' + rawName + 'Get' ] = settrGetterSecond.get;
    //
    //   appending = 1;
    // }

  }

  /* */

  var settrGetter = _._propertyGetterSetterMake
  ({
    name : o.name,
    methods : o.methods,
    object : o.object,
    preserveValues : o.preserveValues,
    readOnly : o.readOnly,
    readOnlyProduct : o.readOnlyProduct,
  });

  /* */

  if( o.prime )
  {

    var o2 = _.mapExtend( null,o );
    o2.names = o.name;
    if( o2.methods === o2.object )
    o2.methods = Object.create( null );
    o2.object = null;

    if( settrGetter.set )
    o2.methods[ '_' + o.name + 'Set' ] = settrGetter.set;
    if( settrGetter.get )
    o2.methods[ '_' + o.name + 'Get' ] = settrGetter.get;

    _._accessorRegister
    ({
      proto : o.object,
      name : o.name,
      declaratorName : 'accessor',
      // declaratorName : null,
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  /* */

  var forbiddenName = '_' + o.name;
  var fieldSymbol = Symbol.for( o.name );

  if( o.preserveValues )
  if( _ObjectHasOwnProperty.call( o.object, o.name ) )
  o.object[ fieldSymbol ] = o.object[ o.name ];

  /* define accessor */

  Object.defineProperty( o.object, o.name,
  {
    set : settrGetter.set,
    get : settrGetter.get,
    enumerable : !!o.enumerable,
    configurable : !!o.configurable,
    // configurable : o.combining === 'append',
  });

  /* forbid underscore field */

  if( o.strict && !propertyDescriptor.descriptor  )
  {

    var m =
    [
      'use Symbol.for( \'' + o.name + '\' ) ',
      'to get direct access to property\'s field, ',
      'not ' + forbiddenName,
    ].join( '' );

    if( !_.prototypeIsStandard( o.object ) || ( _.prototypeIsStandard( o.object ) && !_.prototypeHasField( o.object,forbiddenName ) ) )
    _.accessorForbid
    ({
      object : o.object,
      names : forbiddenName,
      message : [ m ],
      prime : 0,
      strict : 1,
    });

  }

}

var defaults = _accessorAct.defaults = Object.create( AccessorDefaults );

defaults.name = null;
defaults.object = null;
defaults.methods = null;

//

/**
 * Accessor options
 * @typedef{object} wTools~accessorOptions
 * @property{object} [ object=null ] - source object wich properties will get getter/setter defined.
 * @property{object} [ names=null ] - properties of that object represent names of fields for wich function defines setter/getter.
 * Function uses values( rawName ) of object( o.names ) properties to check if fields of( o.object ) have setter/getter.
 * Example : if( rawName ) is 'a', function searchs for '_aSet' or 'aSet' and same for getter.
 * @property{object} [ methods=null ] - object where function searchs for existing setter/getter of property.
 * @property{array} [ message=null ] - setter/getter prints this message when called.
 * @property{boolean} [ strict=true ] - makes object field private if no getter defined but object must have own constructor.
 * @property{boolean} [ enumerable=true ] - sets property descriptor enumerable option.
 * @property{boolean} [ preserveValues=true ] - saves values of existing object properties.
 * @property{boolean} [ readOnly=false ] - if true function doesn't define setter to property.
 **/

/**
 * Defines set/get functions on source object( o.object ) properties if they dont have them.
 * If property specified by( o.names ) doesn't exist on source( o.object ) function creates it.
 * If ( o.object.constructor.prototype ) has property with getter defined function forbids set/get access
 * to object( o.object ) property. Field can be accessed by use of Symbol.for( rawName ) function,
 * where( rawName ) is value of property from( o.names ) object.
 *
 * @param {wTools~accessorOptions} o - options {@link wTools~accessorOptions}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var o = _._accessor_pre( Self, { a : 'a', b : 'b' }, [ 'set/get call' ] );
 * _._accessor( o );
 * Self.a = 1; // returns [ 'set/get call' ]
 * Self.b = 2; // returns [ 'set/get call' ]
 * console.log( Self.a );
 * // returns [ 'set/get call' ]
 * // 1
 * console.log( Self.b );
 * // returns [ 'set/get call' ]
 * // 2
 *
 * @private
 * @method _accessor
 * @throws {exception} If( o.object ) is not a Object.
 * @throws {exception} If( o.names ) is not a Object.
 * @throws {exception} If( o.methods ) is not a Object.
 * @throws {exception} If( o.message ) is not a Array.
 * @throws {exception} If( o ) is extented by unknown property.
 * @throws {exception} If( o.strict ) is true and object doesn't have own constructor.
 * @throws {exception} If( o.readOnly ) is true and property has own setter.
 * @memberof wTools
 */

function _accessor( o )
{

  _.assertRoutineOptions( _accessor, arguments );

  if( _.arrayLike( o.object ) )
  {
    // debugger;
    _.each( o.object, ( object ) =>
    {
      var o2 = _.mapExtend( null, o );
      o2.object = object;
      _accessor( o2 );
    });
    // debugger;
    return;
  }

  if( !o.methods )
  o.methods = o.object;

  /* verification */

  _.assert( !_.primitiveIs( o.object ) );
  _.assert( !_.primitiveIs( o.methods ) );

  if( o.strict )
  {

    var has =
    {
      constructor : 'constructor',
    }

    _.assertMapOwnAll( o.object,has );
    _.accessorForbid
    ({
      object : o.object,
      names : DefaultForbiddenNames,
      prime : 0,
      strict : 0,
    });

  }

  // debugger;
  _.assert( _.objectLikeOrRoutine( o.object ), () => 'expects object {-object-}, but got ' + _.toStrShort( o.object ) );
  _.assert( _.objectIs( o.names ), () => 'expects object {-names-}, but got ' + _.toStrShort( o.names ) );

  /* */

  for( var n in o.names )
  {

    var o2 = o.names[ n ];

    _.assert( _.strIs( o2 ) || _.objectIs( o2 ) );

    if( _.strIs( o2 ) )
    {
      _.assert( o2 === n,'map for forbid should have same key and value' );
      o2 = _.mapExtend( null, o );
    }
    else
    {
      _.assertMapHasOnly( o2, _.AccessorDefaults );
      o2 = _.mapExtend( null, o, o2 );
      _.assert( !!o2.object );
    }

    o2.name = n;
    delete o2.names;

    _._accessorAct( o2 );

  }

}

var defaults = _accessor.defaults = Object.create( _accessorAct.defaults );

defaults.names = null;

// {
//
//   object : null,
//   names : null,
//   methods : null,
//
//   // message : null,
//
//   strict : 1,
//   enumerable : 1,
//   preserveValues : 1,
//   readOnly : 0,
//   readOnlyProduct : 0,
//   prime : 1,
//   combining : 0,
//
// }

//

/**
 * Short-cut for _accessor function.
 * Defines set/get functions on source object( o.object ) properties if they dont have them.
 * For more details @see {@link wTools._accessor }.
 * Can be called in three ways:
 * - First by passing all options in one object( o );
 * - Second by passing ( object ) and ( names ) options;
 * - Third by passing ( object ), ( names ) and ( message ) option as third parameter.
 *
 * @param {wTools~accessorOptions} o - options {@link wTools~accessorOptions}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * _.accessor( Self,{ a : 'a' }, 'set/get call' )
 * Self.a = 1; // set/get call
 * Self.a;
 * // returns
 * // set/get call
 * // 1
 *
 * @method accessor
 * @memberof wTools
 */

function accessor( o )
{
  var o = _accessor_pre( accessor, arguments );
  return _accessor( o );
}

accessor.defaults = Object.create( _accessor.defaults );

//

function accessorForbid( o )
{

  // o.methods = o.methods || Object.create( null );

  var o = _accessor_pre( accessorForbid, arguments );
  // var object = o.object;
  // var names = o.names;

  if( !o.methods )
  o.methods = Object.create( null );

  if( _.arrayLike( o.object ) )
  {
    debugger;
    _.each( o.object, ( object ) =>
    {
      var o2 = _.mapExtend( null, o );
      o2.object = object;
      accessorForbid( o2 );
    });
    debugger;
    return;
  }

  if( _.objectIs( o.names ) )
  o.names = _.mapExtend( null, o.names );

  if( o.combining === 'rewrite' && o.strict === undefined )
  o.strict = 0;

  if( o.prime === null )
  o.prime = _.prototypeIsStandard( o.object );

  /* verification */

  _.assert( _.objectLikeOrRoutine( o.object ), () => 'expects object {-o.object-} but got ' + _.toStrShort( o.object ) );
  _.assert( _.objectIs( o.names ) || _.arrayIs( o.names ), () => 'expects object {-o.names-} as argument but got ' + _.toStrShort( o.names ) );

  /* message */

  var _constructor = o.object.constructor || Object.getPrototypeOf( o.object );
  _.assert( _.routineIs( _constructor ) || _constructor === null );
  _.assert( _constructor === null || _.strIs( _constructor.name ) || _.strIs( _constructor._name ), 'object should have name' );
  if( !o.protoName )
  o.protoName = ( _constructor ? ( _constructor.name || _constructor._name || '' ) : '' ) + '.';
  if( !o.message )
  o.message = 'is deprecated';
  else
  o.message = _.arrayIs( o.message ) ? o.message.join( ' : ' ) : o.message;

  // if( o.protoName === 'wPrinterTop.' && o.names.Static )
  // debugger;

  // /* _accessorForbid */
  //
  // var encodedName,rawName;

  /* property */

  if( _.objectIs( o.names ) )
  {

    for( var n in o.names )
    {
      var name = o.names[ n ];
      // var encodedName = n;
      // var rawName = names[ n ];
      var o2 = _.mapExtend( null, o );
      o2.fieldName = name;
      // o2.fieldValue = o.names[ n ];
      _.assert( n === name, 'key and value should be the same' );
      if( !_accessorForbid( o2 ) )
      delete o.names[ name ];
    }

  }
  else
  {

    var namesArray = o.names;
    o.names = Object.create( null );
    // debugger;
    for( var n = 0 ; n < namesArray.length ; n++ )
    {
      var name = namesArray[ n ];
      // var encodedName = namesArray[ n ];
      // var rawName = namesArray[ n ];
      var o2 = _.mapExtend( null, o );
      o2.fieldName = name;
      // o2.fieldValue = namesArray[ n ];
      // _.assert( n === namesArray[ n ] );
      // names[ encodedName ] = rawName;
      if( _accessorForbid( o2 ) )
      o.names[ name ] = name;
    }
    // debugger;

  }

  // o.names = names;
  // o.object = object;
  // o.methods = methods;
  o.strict = 0;
  o.prime = 0;

  return _accessor( _.mapOnly( o, _accessor.defaults ) );
}

var defaults = accessorForbid.defaults = Object.create( _accessor.defaults );

defaults.preserveValues = 0;
defaults.enumerable = 0;
defaults.prime = null;
defaults.strict = 1;
defaults.combining = 'rewrite';
defaults.message = null;

//

function _accessorForbid()
{
  var o = _.routineOptions( _accessorForbid, arguments );
  var setterName = '_' + o.fieldName + 'Set';
  var getterName = '_' + o.fieldName + 'Get';
  var messageLine = o.protoName + o.fieldName + ' : ' + o.message;

  // _.assert( o.fieldName === o.fieldValue );
  _.assert( _.strIs( o.protoName ) );
  _.assert( _.objectIs( o.methods ) );

  /* */

  var propertyDescriptor = _.propertyDescriptorForAccessor( o.object, o.fieldName );
  if( propertyDescriptor.descriptor )
  {
    _.assert( _.strIs( o.combining ), 'accessorForbid : if accessor overided expect ( o.combining ) is',Combining.join() );

    if( _.routineIs( propertyDescriptor.descriptor.get ) && propertyDescriptor.descriptor.get.name === 'forbidden' )
    {
      // delete names[ encodedName ];
      return false;
    }

  }

  /* check fields */

  if( o.strict )
  // if( _ObjectHasOwnProperty.call( o.object, o.fieldName ) )
  if( propertyDescriptor.object === o.object )
  {
    if( _.accessorForbidOwns( o.object, o.fieldName ) )
    {
      // delete names[ encodedName ];
      return false;
    }
    else
    {
      // debugger;
      // let pd = _.propertyDescriptorForAccessor( o.object, '_pathGet' );
      forbidden();
    }
  }

  /* check fields group */

  if( o.strict && _.prototypeIsStandard( o.object ) )
  if( _.prototypeHasField( o.object, o.fieldName ) )
  {
    forbidden();
  }

  /* */

  if( !Object.isExtensible( o.object ) )
  {
    // delete names[ encodedName ];
    return false;
  }

  o.methods[ setterName ] = forbidden;
  o.methods[ getterName ] = forbidden;
  forbidden.isForbid = true;

  /* */

  if( o.prime )
  {

    /* !!! not tested */
    var o2 = _.mapExtend( null,o );
    o2.names = o.fieldName;
    o2.object = null;
    delete o2.protoName;
    delete o2.fieldName;

    _._accessorRegister
    ({
      proto : o.object,
      name : o.fieldName,
      declaratorName : 'accessorForbid',
      declaratorArgs : [ o2 ],
      combining : o.combining,
    });

  }

  /* */

  return true;

  /* */

  function forbidden()
  {
    debugger;
    throw _.err( messageLine );
  }

}

var defaults = _accessorForbid.defaults = Object.create( accessorForbid.defaults );

defaults.fieldName = null;
// defaults.fieldValue = null;
defaults.protoName = null;

//

function accessorForbidOwns( object,name )
{
  if( !_ObjectHasOwnProperty.call( object,name ) )
  return false;

  var descriptor = Object.getOwnPropertyDescriptor( object,name );
  if( _.routineIs( descriptor.get ) && descriptor.get.isForbid )
  {
    return true;
  }
  else
  {
    return false;
  }

}

//

function accessorReadOnly( object, names )
{
  var o = _accessor_pre( accessorReadOnly, arguments );
  _.assert( o.readOnly );
  return _accessor( o );
}

var defaults = accessorReadOnly.defaults = Object.create( _accessor.defaults );

defaults.readOnly = true;

//

function accessorsSupplement( dst,src )
{

  _.fieldsGroupFor( dst,'_Accessors' );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _ObjectHasOwnProperty.call( dst,'_Accessors' ),'accessorsSupplement : dst should has _Accessors map' );
  _.assert( _ObjectHasOwnProperty.call( src,'_Accessors' ),'accessorsSupplement : src should has _Accessors map' );

  /* */

  function supplement( accessor )
  {

    _.assert( _.arrayIs( accessor.declaratorArgs ) );
    _.assert( !accessor.combining || accessor.combining === 'rewrite' || accessor.combining === 'supplement' || accessor.combining === 'append','not implemented' );

    if( _.objectIs( dst._Accessors[ a ] ) )
    return;

    if( accessor.declaratorName !== 'accessor' )
    {
      _.assert( _.routineIs( dst[ accessor.declaratorName ] ),'dst does not have accessor maker',accessor.declaratorName );
      dst[ accessor.declaratorName ].apply( dst,accessor.declaratorArgs );
    }
    else
    {
      _.assert( accessor.declaratorArgs.length === 1 );
      var optionsForAccessor = _.mapExtend( null,accessor.declaratorArgs[ 0 ] );
      optionsForAccessor.object = dst;
      if( !optionsForAccessor.methods )
      optionsForAccessor.methods = dst;
      _.accessor( optionsForAccessor );
    }

  }

  /* */

  for( var a in src._Accessors )
  {

    var accessor = src._Accessors[ a ];

    if( _.objectIs( accessor ) )
    supplement( accessor );
    else for( var i = 0 ; i < accessor.length ; i++ )
    supplement( accessor[ i ] );

  }

}

//

/**
 * Makes constants properties on object by creating new or replacing existing properties.
 * @param {object} dstPrototype - prototype of class which will get new constant property.
 * @param {object} namesObject - name/value map of constants.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Constants = { num : 100  };
 * _.constant ( Self.prototype,Constants );
 * console.log( Self.prototype ); // returns { num: 100 }
 * Self.prototype.num = 1;// error assign to read only property
 *
 * @method constant
 * @throws {exception} If no argument provided.
 * @throws {exception} If( dstPrototype ) is not a Object.
 * @throws {exception} If( name ) is not a Map.
 * @memberof wTools
 */

function constant( dstPrototype, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstPrototype ), () => 'dstPrototype is needed, but got ' + _.toStrShort( dstPrototype ) );

  if( _.containerIs( name ) )
  {
    _.eachName( name, ( n, v ) =>
    {
      if( value !== undefined )
      _.constant( dstPrototype, n, value );
      else
      _.constant( dstPrototype, n, v );
    });
    return;
  }

  if( value === undefined )
  value = dstPrototype[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  // for( var n in name )
  // {
  //   var encodedName = n;
  //   var value = name[ n ];

  Object.defineProperty( dstPrototype, name,
  {
    value : value,
    enumerable : true,
    writable : false,
    configurable : true,
  });

}

//

function hide( dstPrototype, name, value )
{

  _.assert( arguments.length === 2 || arguments.length === 3 );
  _.assert( !_.primitiveIs( dstPrototype ), () => 'dstPrototype is needed, but got ' + _.toStrShort( dstPrototype ) );

  if( _.containerIs( name ) )
  {
    _.eachName( name, ( n, v ) =>
    {
      if( value !== undefined )
      _.hide( dstPrototype, n, value );
      else
      _.hide( dstPrototype, n, v );
    });
    return;
  }

  if( value === undefined )
  value = dstPrototype[ name ];

  _.assert( _.strIs( name ), 'name is needed, but got', name );

  // for( var n in name )
  // {
  //   var encodedName = n;
  //   var value = name[ n ];

  Object.defineProperty( dstPrototype, name,
  {
    value : value,
    enumerable : false,
    writable : true,
    configurable : true,
  });

}

//

/**
 * Makes properties of object( dstPrototype ) read only without changing their values. Uses properties names from argument( namesObject ).
 * Sets undefined for property that not exists on source( dstPrototype ).
 * @param {object} dstPrototype - prototype of class which properties will get read only state.
 * @param {object|string} namesObject - property name as string/map with properties.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * Self.prototype.num = 100;
 * var ReadOnly = { num : null, num2 : null  };
 * _.restrictReadOnly ( Self.prototype,ReadOnly );
 * console.log( Self.prototype ); // returns { num: 100, num2: undefined }
 * Self.prototype.num2 = 1; // error assign to read only property
 *
 * @method restrictReadOnly
 * @throws {exception} If no argument provided.
 * @throws {exception} If( dstPrototype ) is not a Object.
 * @throws {exception} If( namesObject ) is not a Map.
 * @memberof wTools
 */

function restrictReadOnly( dstPrototype, namesObject )
{

  if( _.strIs( namesObject ) )
  {
    namesObject = Object.create( null );
    namesObject[ namesObject ] = namesObject;
  }

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectLikeOrRoutine( dstPrototype ),'_.constant :','dstPrototype is needed :', dstPrototype );
  _.assert( _.mapIs( namesObject ),'_.constant :','namesObject is needed :', namesObject );

  for( var n in namesObject )
  {

    var encodedName = n;
    var value = namesObject[ n ];

    Object.defineProperty( dstPrototype, encodedName,
    {
      value : dstPrototype[ n ],
      enumerable : true,
      writable : false,
    });

  }

}

//

function accessorToElement( o )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectIs( o.names ) );
  _.routineOptions( accessorToElement,o );

  var names = Object.create( null );
  for( var n in o.names ) (function()
  {
    names[ n ] = n;

    var arrayName = o.arrayName;
    var index = o.names[ n ];
    _.assert( _.numberIs( index ) );
    _.assert( index >= 0 );

    var setterGetter = _propertyGetterSetterGet( o.object, n );

    if( !setterGetter.set )
    o.object[ setterGetter.setName ] = function accessorToElementSet( src )
    {
      this[ arrayName ][ index ] = src;
    }

    if( !setterGetter.get )
    o.object[ setterGetter.getName ] = function accessorToElementGet()
    {
      return this[ arrayName ][ index ];
    }

  })();

  _.accessor
  ({
    object : o.object,
    names : names,
  });

}

accessorToElement.defaults =
{
  object : null,
  names : null,
  arrayName : null,
}

//

function accessorHas( proto, name )
{
  var accessors = proto._Accessors;
  if( !accessors )
  return false;
  return !!accessors[ name ];
}

// --
// fields group
// --

function fieldsGroupsGet( src )
{
  _.assert( _.objectIs( src ), () => 'expects map {-src-}, but got ' + _.strTypeOf( src ) );
  _.assert( src.Groups === undefined || _.objectIs( src.Groups ) );

  if( src.Groups )
  return src.Groups;

  return _.DefaultFieldsGroups;
}

//

function fieldsGroupFor( dst, fieldsGroupName )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( fieldsGroupName ) );
  _.assert( !_.primitiveIs( dst ) );

  if( !_ObjectHasOwnProperty.call( dst, fieldsGroupName ) )
  {
    var field = dst[ fieldsGroupName ];
    dst[ fieldsGroupName ] = Object.create( null );
    if( field )
    Object.setPrototypeOf( dst[ fieldsGroupName ], field );
  }

  if( Config.debug )
  {
    var parent = Object.getPrototypeOf( dst );
    if( parent && parent[ fieldsGroupName ] )
    _.assert( Object.getPrototypeOf( dst[ fieldsGroupName ] ) === parent[ fieldsGroupName ] );
  }

  return dst;
}

//

/**
* Default options for fieldsGroupDeclare function
* @typedef {object} wTools~protoAddDefaults
* @property {object} [ o.fieldsGroupName=null ] - object that contains class relationship type name.
* Example : { Composes : 'Composes' }. See {@link wTools~DefaultFieldsGroupsRelations}
* @property {object} [ o.dstPrototype=null ] - prototype of class which will get new constant property.
* @property {object} [ o.srcMap=null ] - name/value map of defaults.
* @property {bool} [ o.extending=false ] - to extending defaults if exist.
*/

/**
 * Adds own defaults to object. Creates new defaults container, if there is no such own.
 * @param {wTools~protoAddDefaults} o - options {@link wTools~protoAddDefaults}.
 * @private
 *
 * @example
 * var Self = function ClassName( o ) { };
 * _.fieldsGroupDeclare
 * ({
 *   fieldsGroupName : { Composes : 'Composes' },
 *   dstPrototype : Self.prototype,
 *   srcMap : { a : 1, b : 2 },
 * });
 * console.log( Self.prototype ); // returns { Composes: { a: 1, b: 2 } }
 *
 * @method fieldsGroupDeclare
 * @throws {exception} If no argument provided.
 * @throws {exception} If( o.srcMap ) is not a Object.
 * @throws {exception} If( o ) is extented by unknown property.
 * @memberof wTools
 */

function fieldsGroupDeclare( o )
{
  var o = o || Object.create( null );

  _.routineOptions( fieldsGroupDeclare,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.srcMap === null || !_.primitiveIs( o.srcMap ),'expects object {-o.srcMap-}, got', _.strTypeOf( o.srcMap ) );
  _.assert( _.strIs( o.fieldsGroupName ) );
  _.assert( _.routineIs( o.filter ) && _.strIs( o.filter.functionFamily ) );

  _.fieldsGroupFor( o.dstPrototype, o.fieldsGroupName );

  var fieldGroup = o.dstPrototype[ o.fieldsGroupName ];

  if( o.srcMap )
  _.mapExtendConditional( o.filter, fieldGroup, o.srcMap );

}

fieldsGroupDeclare.defaults =
{
  dstPrototype : null,
  srcMap : null,
  filter : _.field.mapper.bypass,
  fieldsGroupName : null,
}

//

/**
 * Adds own defaults( Composes ) to object. Creates new defaults container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Composes = { tree : null };
 * _.fieldsGroupComposesExtend( Self.prototype, Composes );
 * console.log( Self.prototype ); // returns { Composes: { tree: null } }
 *
 * @method fieldsGroupComposesExtend
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupComposesExtend( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Composes';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    // filter : _.field.mapper.bypass,
  });

}

//

/**
 * Adds own aggregates to object. Creates new aggregates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Aggregates = { tree : null };
 * _.fieldsGroupAggregatesExtend( Self.prototype, Aggregates );
 * console.log( Self.prototype ); // returns { Aggregates: { tree: null } }
 *
 * @method fieldsGroupAggregatesExtend
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupAggregatesExtend( dstPrototype,srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Aggregates';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    // filter : _.field.mapper.bypass,
  });

}

//

/**
 * Adds own associates to object. Creates new associates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Associates = { tree : null };
 * _.fieldsGroupAssociatesExtend( Self.prototype, Associates );
 * console.log( Self.prototype ); // returns { Associates: { tree: null } }
 *
 * @method fieldsGroupAssociatesExtend
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupAssociatesExtend( dstPrototype,srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Associates';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    // filter : _.field.mapper.bypass,
  });

}

//

/**
 * Adds own restricts to object. Creates new restricts container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Restricts = { tree : null };
 * _.fieldsGroupRestrictsExtend( Self.prototype, Restricts );
 * console.log( Self.prototype ); // returns { Restricts: { tree: null } }
 *
 * @method fieldsGroupRestrictsExtend
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupRestrictsExtend( dstPrototype,srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Restricts';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    // filter : _.field.mapper.bypass,
  });

}

//

/**
 * Adds own defaults( Composes ) to object. Creates new defaults container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Composes = { tree : null };
 * _.fieldsGroupComposesSupplement( Self.prototype, Composes );
 * console.log( Self.prototype ); // returns { Composes: { tree: null } }
 *
 * @method fieldsGroupComposesSupplement
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupComposesSupplement( dstPrototype, srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Composes';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    filter : _.field.mapper.dstNotHas,
  });

}

//

/**
 * Adds own aggregates to object. Creates new aggregates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Aggregates = { tree : null };
 * _.fieldsGroupAggregatesSupplement( Self.prototype, Aggregates );
 * console.log( Self.prototype ); // returns { Aggregates: { tree: null } }
 *
 * @method fieldsGroupAggregatesSupplement
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupAggregatesSupplement( dstPrototype,srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Aggregates';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    filter : _.field.mapper.dstNotHas,
  });

}

//

/**
 * Adds own associates to object. Creates new associates container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Associates = { tree : null };
 * _.fieldsGroupAssociatesSupplement( Self.prototype, Associates );
 * console.log( Self.prototype ); // returns { Associates: { tree: null } }
 *
 * @method fieldsGroupAssociatesSupplement
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupAssociatesSupplement( dstPrototype,srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Associates';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    filter : _.field.mapper.dstNotHas,
  });

}

//

/**
 * Adds own restricts to object. Creates new restricts container, if there is no such own.
 * @param {array-like} arguments - for arguments details see {@link wTools~protoAddDefaults}.
 *
 * @example
 * var Self = function ClassName( o ) { };
 * var Restricts = { tree : null };
 * _.fieldsGroupRestrictsSupplement( Self.prototype, Restricts );
 * console.log( Self.prototype ); // returns { Restricts: { tree: null } }
 *
 * @method fieldsGroupRestrictsSupplement
 * @throws {exception} If no arguments provided.
 * @memberof wTools
 */

function fieldsGroupRestrictsSupplement( dstPrototype,srcMap )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  var fieldsGroupName = 'Restricts';
  return _.fieldsGroupDeclare
  ({
    fieldsGroupName : fieldsGroupName,
    dstPrototype : dstPrototype,
    srcMap : srcMap,
    filter : _.field.mapper.dstNotHas,
  });

}

//

function fieldsGroupsDeclare( o )
{

  _.routineOptions( fieldsGroupsDeclare,o );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.srcMap === null || !_.primitiveIs( o.srcMap ),'expects object {-o.srcMap-}, got', _.strTypeOf( o.srcMap ) );

  if( !o.srcMap )
  return;

  if( !o.fieldsGroups )
  o.fieldsGroups = _.fieldsGroupsGet( o.dstPrototype );

  _.assert( _.subOf( o.fieldsGroups, _.DefaultFieldsGroups ) );

  for( var f in o.fieldsGroups )
  {

    if( !o.srcMap[ f ] )
    continue;

    _.fieldsGroupDeclare
    ({
      fieldsGroupName : f,
      dstPrototype : o.dstPrototype,
      srcMap : o.srcMap[ f ],
      filter : o.filter,
    });

    if( !_.DefaultFieldsGroupsRelations[ f ] )
    continue;

    if( Config.debug )
    {
      for( var f2 in _.DefaultFieldsGroupsRelations )
      if( f2 === f )
      {
        continue;
      }
      else for( var k in o.srcMap[ f ] )
      {
        _.assert( o.dstPrototype[ f2 ][ k ] === undefined,'Fields group','"'+f2+'"','already has fields','"'+k+'"','fields group','"'+f+'"','should not have the same' );
      }
    }

  }

}

fieldsGroupsDeclare.defaults =
{
  dstPrototype : null,
  srcMap : null,
  fieldsGroups : null,
  filter : fieldsGroupDeclare.defaults.filter,
}

//

function fieldsGroupsDeclareForEachFilter( o )
{

  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( fieldsGroupsDeclareForEachFilter, arguments );
  _.assertMapHasNoUndefine( o );

  var oldFieldsGroups = _.fieldsGroupsGet( o.dstPrototype );
  var newFieldsGroups = Object.create( oldFieldsGroups )
  if( ( o.extendMap && o.extendMap.Groups ) || ( o.supplementOwnMap && o.supplementOwnMap.Groups ) || ( o.supplementMap && o.supplementMap.Groups ) )
  {
    if( o.supplementMap && o.supplementMap.Groups )
    _.mapSupplement( newFieldsGroups, o.supplementMap.Groups );
    if( o.supplementOwnMap && o.supplementOwnMap.Groups )
    _.mapSupplementOwn( newFieldsGroups, o.supplementOwnMap.Groups );
    if( o.extendMap && o.extendMap.Groups )
    _.mapExtend( newFieldsGroups, o.extendMap.Groups );
  }

  // if( fieldsGroups === _.DefaultFieldsGroups )

  if( !o.dstPrototype.Groups )
  o.dstPrototype.Groups = Object.create( _.DefaultFieldsGroups );

  for( var f in newFieldsGroups )
  _.fieldsGroupFor( o.dstPrototype, f );

  // _.fieldsGroupDeclare
  // ({
  //   fieldsGroupName : 'Group',
  //   dstPrototype : o.dstPrototype,
  //   srcMap : newFieldsGroups,
  //   filter : _.field.mapper.bypass,
  // });

  _.fieldsGroupsDeclare
  ({
    dstPrototype : o.dstPrototype,
    srcMap : o.extendMap,
    fieldsGroups : newFieldsGroups,
    filter : _.field.mapper.bypass,
  });
  _.fieldsGroupsDeclare
  ({
    dstPrototype : o.dstPrototype,
    srcMap : o.supplementOwnMap,
    fieldsGroups : newFieldsGroups,
    filter : _.field.mapper.dstNotOwn,
  });

  // if( o.dstPrototype.constructor.name === 'wPrinterBase' )
  // debugger;

  _.fieldsGroupsDeclare
  ({
    dstPrototype : o.dstPrototype,
    srcMap : o.supplementMap,
    fieldsGroups : newFieldsGroups,
    filter : _.field.mapper.dstNotHas,
  });

}

fieldsGroupsDeclareForEachFilter.defaults =
{
  dstPrototype : null,
  extendMap : null,
  supplementOwnMap : null,
  supplementMap : null,
}

// --
// getter / setter functors
// --

function setterMapCollection_functor( o )
{

  _.assertMapHasOnly( o,setterMapCollection_functor.defaults );
  _.assert( _.strIs( o.name ) );
  _.assert( _.routineIs( o.elementMaker ) );
  var symbol = Symbol.for( o.name );
  var elementMakerOriginal = o.elementMaker;
  var elementMaker = o.elementMaker;
  var friendField = o.friendField;

  if( friendField )
  elementMaker = function elementMaker( src )
  {
    src[ friendField ] = this;
    return elementMakerOriginal.call( this,src );
  }

  return function _setterMapCollection( src )
  {
    var self = this;

    _.assert( _.objectIs( src ) );

    if( self[ symbol ] )
    {

      if( src !== self[ symbol ] )
      for( var d in self[ symbol ] )
      delete self[ symbol ][ d ];

    }
    else
    {

      self[ symbol ] = Object.create( null );

    }

    for( var d in src )
    {
      if( src[ d ] !== null )
      self[ symbol ][ d ] = elementMaker.call( self,src[ d ] );
    }

    return self[ symbol ];
  }

}

setterMapCollection_functor.defaults =
{
  name : null,
  elementMaker : null,
  friendField : null,
}

//

function setterArrayCollection_functor( o )
{

  _.assertMapHasOnly( o,setterMapCollection_functor.defaults );
  _.assert( _.strIs( o.name ) );
  _.assert( _.routineIs( o.elementMaker ) );
  var symbol = Symbol.for( o.name );
  var elementMakerOriginal = o.elementMaker;
  var elementMaker = o.elementMaker;
  var friendField = o.friendField;

  if( friendField )
  elementMaker = function elementMaker( src )
  {
    src[ friendField ] = this;
    return elementMakerOriginal.call( this,src );
  }

  return function _setterMapCollection( src )
  {
    var self = this;

    _.assert( _.arrayIs( src ) );

    if( self[ symbol ] )
    {

      if( src !== self[ symbol ] )
      self[ symbol ].splice( 0,self[ symbol ].length );

    }
    else
    {

      self[ symbol ] = [];

    }

    if( src !== self[ symbol ] )
    for( var d = 0 ; d < src.length ; d++ )
    {
      if( src[ d ] !== null )
      self[ symbol ].push( elementMaker.call( self,src[ d ] ) );
    }
    else for( var d = 0 ; d < src.length ; d++ )
    {
      if( src[ d ] !== null )
      src[ d ] = elementMaker.call( self,src[ d ] );
    }

    return self[ symbol ];
  }

}

setterArrayCollection_functor.defaults =
{
  name : null,
  elementMaker : null,
  friendField : null,
}

//

function setterFriend_functor( o )
{

  var name = _.nameUnfielded( o.name ).coded;
  var nameOfLink = o.nameOfLink;
  var maker = o.maker;
  var symbol = Symbol.for( name );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( name ) );
  _.assert( _.strIs( nameOfLink ) );
  _.assert( _.routineIs( maker ) );
  _.assertMapHasOnly( o,setterFriend_functor.defaults );

  return function setterFriend( src )
  {

    var self = this;
    _.assert( src === null || _.objectIs( src ),'setterFriend : expects null or object, but got ' + _.strTypeOf( src ) );

    if( !src )
    {

      self[ symbol ] = src;
      return;

    }
    else if( !self[ symbol ] )
    {

      if( _.mapIs( src ) )
      {
        var o = Object.create( null );
        o[ nameOfLink ] = self;
        o.name = name;
        self[ symbol ] = maker( o );
        self[ symbol ].copy( src );
      }
      else
      {
        self[ symbol ] = src;
      }

    }
    else
    {

      if( self[ symbol ] !== src )
      self[ symbol ].copy( src );

    }

    if( self[ symbol ][ nameOfLink ] !== self )
    self[ symbol ][ nameOfLink ] = self;

    return self[ symbol ];
  }

}

setterFriend_functor.defaults =
{
  name : null,
  nameOfLink : null,
  maker : null,
}

//

function setterCopyable_functor( o )
{

  var name = _.nameUnfielded( o.name ).coded;
  var maker = o.maker;
  var symbol = Symbol.for( name );
  var debug = o.debug;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( name ) );
  _.assert( _.routineIs( maker ) );
  _.assertMapHasOnly( o,setterCopyable_functor.defaults );

  return function setterCopyable( data )
  {
    var self = this;

    if( debug )
    debugger;

    if( data === null )
    {
      if( self[ symbol ] && self[ symbol ].finit )
      self[ symbol ].finit();
      self[ symbol ] = null;
      return self[ symbol ];
    }

    if( !_.objectIs( self[ symbol ] ) )
    {

      self[ symbol ] = maker( data );

    }
    else
    {

      if( self[ symbol ] !== data )
      {
        _.assert( _.routineIs( self[ symbol ].copy ) );
        self[ symbol ].copy( data );
      }

    }

    return self[ symbol ];
  }

}

setterCopyable_functor.defaults =
{
  name : null,
  maker : null,
  debug : 0,
}

//

function setterBufferFrom_functor( o )
{

  var name = _.nameUnfielded( o.name ).coded;
  var bufferConstructor = o.bufferConstructor;
  var symbol = Symbol.for( name );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( name ) );
  _.assert( _.routineIs( bufferConstructor ) );
  _.routineOptions( setterBufferFrom_functor,o );

  return function setterBufferFrom( data )
  {
    var self = this;

    if( data === null || data === false )
    {
      data = null;
    }
    else
    {
      data = _.bufferFrom({ src : data, bufferConstructor : bufferConstructor });
    }

    self[ symbol ] = data;
    return data;
  }

}

setterBufferFrom_functor.defaults =
{
  name : null,
  bufferConstructor : null,
}

//

function setterChangesTracking_functor( o )
{

  var name = Symbol.for( _.nameUnfielded( o.name ).coded );
  var nameOfChangeFlag = Symbol.for( _.nameUnfielded( o.nameOfChangeFlag ).coded );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( setterChangesTracking_functor,o );

  throw _.err( 'not tested' );

  return function setterChangesTracking( data )
  {
    var self = this;

    if( data === self[ name ] )
    return;

    self[ name ] = data;
    self[ nameOfChangeFlag ] = true;

    return data;
  }

}

setterChangesTracking_functor.defaults =
{
  name : null,
  nameOfChangeFlag : 'needsUpdate',
  bufferConstructor : null,
}

//

function setterAlias_functor( o )
{

  var original = o.original;
  var alias = o.alias;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( setterAlias_functor,o );

  return function setterAlias( src )
  {
    var self = this;

    self[ original ] = src;

    return self[ original ];
  }

}

setterAlias_functor.defaults =
{
  original : null,
  alias : null,
}

//

function getterAlias_functor( o )
{

  var original = o.original;
  var alias = o.alias;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.routineOptions( getterAlias_functor,o );

  return function getterAlias( src )
  {
    var self = this;
    return self[ original ];
  }

}

getterAlias_functor.defaults =
{
  original : null,
  alias : null,
}

// --
// property
// --

function propertyDescriptorForAccessor( object, name )
{
  var result = Object.create( null );
  result.object = null;
  result.descriptor = null;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  do
  {
    let descriptor = Object.getOwnPropertyDescriptor( object,name );
    if( descriptor && !( 'value' in descriptor ) )
    {
      result.descriptor = descriptor;
      result.object = object;
      return result;
    }
    object = Object.getPrototypeOf( object );
  }
  while( object );

  return result;
}

//

function propertyDescriptorGet( object, name )
{
  var result = Object.create( null );
  result.object = null;
  result.descriptor = null;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  do
  {
    let descriptor = Object.getOwnPropertyDescriptor( object,name );
    if( descriptor )
    {
      result.descriptor = descriptor;
      result.object = object;
      return result;
    }
    object = Object.getPrototypeOf( object );
  }
  while( object );

  return result;
}

//

function _propertyGetterSetterNames( propertyName )
{
  var result = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( propertyName ) );

  result.set = '_' + propertyName + 'Set';
  result.get = '_' + propertyName + 'Get';

  /* xxx : use it more extensively */

  return result;
}

//

// function _propertyGetterSetterMake( o, object, name )
function _propertyGetterSetterMake( o )
{
  var result = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.objectLikeOrRoutine( o.methods ) );
  _.assert( _.strIs( o.name ) );
  _.assert( !o.readOnlyProduct || o.readOnly );
  _.assert( !!o.object );
  _.assertRoutineOptions( _propertyGetterSetterMake, o );

  if( o.methods[ '' + o.name + 'Set' ] )
  result.set = o.methods[ o.name + 'Set' ];
  else if( o.methods[ '_' + o.name + 'Set' ] )
  result.set = o.methods[ '_' + o.name + 'Set' ];

  if( o.methods[ '' + o.name + 'Get' ] )
  result.get = o.methods[ o.name + 'Get' ];
  else if( o.methods[ '_' + o.name + 'Get' ] )
  result.get = o.methods[ '_' + o.name + 'Get' ];

  var fieldName = '_' + o.name;
  var fieldSymbol = Symbol.for( o.name );

  if( o.preserveValues )
  if( _ObjectHasOwnProperty.call( o.methods,o.name ) )
  o.object[ fieldSymbol ] = o.object[ o.name ];

  /* set */

  if( !result.set && !o.readOnly )
  // if( o.message )
  // result.set = function set( src )
  // {
  //   // console.info.apply( console,o.message );
  //   this[ fieldSymbol ] = src;
  //   return src;
  // }
  // else
  result.set = function set( src )
  {
    this[ fieldSymbol ] = src;
    return src;
  }

  /* get */

  // _.assert( !o.readOnlyProduct || !result.get,'not tested' );

  if( !result.get )
  {

    if( !o.readOnlyProduct )
    result.get = function get()
    {
      return this[ fieldSymbol ];
    }
    else if( o.readOnlyProduct )
    result.get = function get()
    {
      var result = this[ fieldSymbol ];
      debugger;
      if( !_.primitiveIs( result ) )
      result = _.proxyReadOnly( result );
      return result;
    }

    // if( o.message )
    // {
    //   var message = o.message;
    //   var _getWithoutMessage = o.get;
    //   o.get = function()
    //   {
    //     // console.info.apply( console,message );
    //     return _getWithoutMessage.apply( this,arguments );
    //   }
    // }

  }

  /* validation */

  _.assert( !result.set || !o.readOnly, () => 'read only, but setter for ' + _.strQuote( o.name ) + ' found in' + _.toStrShort( o.methods ) );

  return result;
}

_propertyGetterSetterMake.defaults =
{
  name : null,
  object : null,
  methods : null,
  preserveValues : 1,
  readOnly : 0,
  readOnlyProduct : 0,
}

//

function _propertyGetterSetterGet( object, propertyName )
{
  var result = Object.create( null );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectIs( object ) );
  _.assert( _.strIs( propertyName ) );

  result.setName = object[ propertyName + 'Set' ] ? propertyName + 'Set' : '_' + propertyName + 'Set';
  result.getName = object[ propertyName + 'Get' ] ? propertyName + 'Get' : '_' + propertyName + 'Get';

  result.set = object[ result.setName ];
  result.get = object[ result.getName ];

  return result;
}

//
//
// function propertyGetterSetterGet( object, propertyName )
// {
//   var result = Object.create( null );
//
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//   _.assert( _.strIs( propertyName ) );
//
//   result.set = object[ '_' + propertyName + 'Set' ] || object[ '' + propertyName + 'Set' ];
//   result.get = object[ '_' + propertyName + 'Get' ] || object[ '' + propertyName + 'Get' ];
//
//   return result;
// }

// --
// proxy
// --

function proxyNoUndefined( ins )
{

  var validator =
  {
    set : function( obj, k, e )
    {
      if( obj[ k ] === undefined )
      throw _.err( 'Map does not have field',k );
      obj[ k ] = e;
      return true;
    },
    get : function( obj, k )
    {
      if( !_.symbolIs( k ) )
      if( obj[ k ] === undefined )
      throw _.err( 'Map does not have field',k );
      return obj[ k ];
    },

  }

  var result = new Proxy( ins, validator );

  return result;
}

//

function proxyReadOnly( ins )
{

  var validator =
  {
    set : function( obj, k, e )
    {
      throw _.err( 'Read only',_.strTypeOf( ins ),ins );
    }
  }

  var result = new Proxy( ins, validator );

  return result;
}

//

function ifDebugProxyReadOnly( ins )
{

  if( !Config.debug )
  return ins;

  return _.proxyReadOnly( ins );
}

//

function proxyMap( dst,original )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( !!dst );
  _.assert( !!original );

  var handler =
  {
    get : function( obj, k )
    {
      if( obj[ k ] !== undefined )
      return obj[ k ];
      return original[ k ];
    },
    set : function( obj, k, val, target )
    {
      if( obj[ k ] !== undefined )
      obj[ k ] = val;
      else if( original[ k ] !== undefined )
      original[ k ] = val;
      else
      obj[ k ] = val;
      return true;
    },
  }

  var result = new Proxy( dst, handler );

  return result;
}

// --
// mixin
// --

/**
 * Make mixin which could be mixed into prototype of another object.
 * @param {object} o - options.
 * @method _mixinDelcare
 * @memberof wTools#
 */

function _mixinDelcare( o )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( o ) || _.routineIs( o ) );
  _.assert( _.routineIs( o.onMixin ) || o.onMixin === undefined || o.onMixin === null, 'expects routine {-o.onMixin-}, but got', _.strTypeOf( o ) );
  _.assert( _.strIsNotEmpty( o.name ), 'mixin should have name' );
  _.assert( _.objectIs( o.extend ) || o.extend === undefined || o.extend === null );
  _.assert( _.objectIs( o.supplementOwn ) || o.supplementOwn === undefined || o.supplementOwn === null );
  _.assert( _.objectIs( o.supplement ) || o.supplement === undefined || o.supplement === null );
  _.assertOwnNoConstructor( o );

  _.routineOptions( _mixinDelcare, o );

  if( !o.onMixin )
  o.mixin = function mixin( dstClass )
  {
    var md = this.__mixin__;

    _.assert( _.objectIs( md ) );
    _.assert( arguments.length === 1, 'expects single argument' );
    _.assert( _.routineIs( dstClass ), 'expects constructor' );
    _.assert( dstClass === dstClass.prototype.constructor );
    _.assertMapHasOnly( this, [ _.KnownConstructorFields, { mixin : 'mixin', __mixin__ : '__mixin__' }, this.prototype.Statics || {} ] );

    _.mixinApply( md, dstClass.prototype );
    if( md.onMixinEnd )
    md.onMixinEnd( md, dstClass );
    return dstClass;
  }
  else
  o.mixin = function mixin( dstClass )
  {
    var md = this.__mixin__;

    _.assert( arguments.length === 1, 'expects single argument' );
    _.assert( _.routineIs( dstClass ), 'expects constructor' );
    _.assert( dstClass === dstClass.prototype.constructor );
    _.assertMapHasOnly( this, [ _.KnownConstructorFields, { mixin : 'mixin', __mixin__ : '__mixin__' }, this.prototype.Statics || {} ] );

    if( o.onMixinEnd )
    debugger;
    md.onMixin( md, dstClass );
    if( md.onMixinEnd )
    md.onMixinEnd( md, dstClass );

    return dstClass;
  }

  /* */

  if( !o.prototype )
  {
    var got = _._classConstructorAndPrototypeGet( o );

    if( got.prototype )
    o.prototype = got.prototype;
    else
    o.prototype = Object.create( null );

    _.classExtend
    ({
      cls : got.cls || null,
      prototype : o.prototype,
      extend : o.extend || null,
      supplementOwn : o.supplementOwn || null,
      supplement : o.supplement || null,
    });

  }

  if( o.prototype )
  {
    _.assert( !o.prototype.mixin,'not tested' );
    o.prototype.mixin = o.mixin;
    if( o.prototype.constructor )
    {
      _.assert( !o.prototype.constructor.mixin || o.prototype.constructor.mixin === o.mixin,'not tested' );
      o.prototype.constructor.mixin = o.mixin;
    }
  }

  Object.freeze( o );

  return o;
}

_mixinDelcare.defaults =
{

  name : null,
  shortName : null,
  prototype : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  onMixin : null,
  onMixinEnd : null,

}

//

function mixinDelcare( o )
{
  var result = Object.create( null );

  _.assert( o.mixin === undefined );

  var md = result.__mixin__ = _._mixinDelcare.apply( this, arguments );
  result.name = md.name;
  result.shortName = md.shortName;
  result.prototype = md.prototype;
  result.mixin = md.mixin;

  Object.freeze( result );

  return result;
}

mixinDelcare.defaults = Object.create( _mixinDelcare.defaults );

//

/**
 * Mixin methods and fields into prototype of another object.
 * @param {object} o - options.
 * @method mixinApply
 * @memberof wTools#
 */

var MixinDescriptorFields =
{

  name : null,
  shortName : null,
  prototype : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  onMixin : null,
  onMixinEnd : null,
  mixin : null,

}

function mixinApply( mixinDescriptor, dstPrototype )
{

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.objectIs( dstPrototype ), () => 'second argument {-dstPrototype-} does not look like prototype, got ' + _.strTypeOf( dstPrototype ) );
  _.assert( _.routineIs( mixinDescriptor.mixin ), 'first argument does not look like mixin descriptor' );
  _.assert( _.objectIs( mixinDescriptor ) );
  _.assert( Object.isFrozen( mixinDescriptor ), 'first argument does not look like mixin descriptor' );
  _.assertMapHasOnly( mixinDescriptor, MixinDescriptorFields );

  /* mixin into routine */

  if( !_.mapIs( dstPrototype ) )
  {
    _.assert( dstPrototype.constructor.prototype === dstPrototype,'mixin :','expects prototype with own constructor field' );
    _.assert( dstPrototype.constructor.name.length || dstPrototype.constructor._name.length,'mixin :','constructor should has name' );
    _.assert( _.routineIs( dstPrototype.init ) );
  }

  /* extend */

  _.assert( _.mapOwnKey( dstPrototype,'constructor' ) );
  _.assert( dstPrototype.constructor.prototype === dstPrototype );
  _.classExtend
  ({
    cls : dstPrototype.constructor,
    extend : mixinDescriptor.extend,
    supplementOwn : mixinDescriptor.supplementOwn,
    supplement : mixinDescriptor.supplement,
    functors : mixinDescriptor.functors,
  });

  /* mixins map */

  if( !_ObjectHasOwnProperty.call( dstPrototype,'_mixinsMap' ) )
  {
    dstPrototype._mixinsMap = Object.create( dstPrototype._mixinsMap || null );
  }

  _.assert( !dstPrototype._mixinsMap[ mixinDescriptor.name ],'attempt to mixin same mixin "' + mixinDescriptor.name + '" several times into ' + dstPrototype.constructor.name );

  dstPrototype._mixinsMap[ mixinDescriptor.name ] = 1;

}

//

function mixinHas( proto,mixin )
{
  if( _.constructorIs( proto ) )
  proto = _.prototypeGet( proto );

  _.assert( _.prototypeIsStandard( proto ) );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( _.strIs( mixin ) )
  {
    return proto._mixinsMap && proto._mixinsMap[ mixin ];
  }
  else
  {
    _.assert( _.routineIs( mixin.mixin ),'expects mixin, but got not mixin',_.strTypeOf( mixin ) );
    _.assert( _.strIsNotEmpty( mixin.name ),'expects mixin, but got not mixin',_.strTypeOf( mixin ) );
    return proto._mixinsMap && proto._mixinsMap[ mixin.name ];
  }

}

// --
// class
// --

/**
* @typedef {object} wTools~prototypeOptions
* @property {routine} [o.cls=null] - constructor for which prototype is needed.
* @property {routine} [o.parent=null] - constructor of parent class.
* @property {object} [o.extend=null] - extend prototype by this map.
* @property {object} [o.supplement=null] - supplement prototype by this map.
* @property {object} [o.static=null] - static fields of a class.
* @property {boolean} [o.usingPrimitiveExtension=false] - extends class with primitive fields from relationship descriptors.
* @property {boolean} [o.usingOriginalPrototype=false] - makes prototype using original constructor prototype.
*/

/**
 * Make prototype for constructor repairing relationship : Composes, Aggregates, Associates, Medials, Restricts.
 * Execute optional extend / supplement if such o present.
 * @param {wTools~prototypeOptions} o - options {@link wTools~prototypeOptions}.
 * @returns {object} Returns constructor's prototype based on( o.parent ) prototype and complemented by fields, static and non-static methods.
 *
 * @example
 *  var Parent = function Alpha(){ };
 *  Parent.prototype.init = function(  )
 *  {
 *    var self = this;
 *    self.c = 5;
 *  };
 *
 *  var Self = function Betta( o )
 *  {
 *    return Self.prototype.init.apply( this,arguments );
 *  }
 *
 *  function init()
 *  {
 *    var self = this;
 *    Parent.prototype.init.call( this );
 *    _.mapExtendConditional( _.field.mapper.srcOwn,self,Composes );
 *  }
 *
 *  var Composes =
 *  {
 *   a : 1,
 *   b : 2,
 *  }
 *
 *  var Proto =
 *  {
 *   init : init,
 *   Composes : Composes
 *  }
 *
 *  _.classDeclare
 *  ({
 *    cls : Self,
 *    parent : Parent,
 *    extend : Proto,
 *  });
 *
 *  var betta = new Betta();
 *  console.log( proto === Self.prototype ); //returns true
 *  console.log( Parent.prototype.isPrototypeOf( betta ) ); //returns true
 *  console.log( betta.a, betta.b, betta.c ); //returns 1 2 5
 *
 * @method classDeclare
 * @throws {exception} If no argument provided.
 * @throws {exception} If( o ) is not a Object.
 * @throws {exception} If( o.cls ) is not a Routine.
 * @throws {exception} If( o.cls.name ) is not defined.
 * @throws {exception} If( o.cls.prototype ) has not own constructor.
 * @throws {exception} If( o.cls.prototype ) has restricted properties.
 * @throws {exception} If( o.parent ) is not a Routine.
 * @throws {exception} If( o.extend ) is not a Object.
 * @throws {exception} If( o.supplement ) is not a Object.
 * @throws {exception} If( o.parent ) is equal to( o.extend ).
 * @throws {exception} If function cant rewrite constructor using original prototype.
 * @throws {exception} If( o.usingOriginalPrototype ) is false and ( o.cls.prototype ) has manually defined properties.
 * @throws {exception} If( o.cls.prototype.constructor ) is not equal( o.cls  ).
 * @memberof wTools
 */

/*
_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});
*/

function classDeclare( o )
{
  var result;

  if( o.withClass === undefined )
  o.withClass = true;

  if( o.cls && !o.name )
  o.name = o.cls.name;

  if( o.cls && !o.shortName )
  o.shortName = o.cls.shortName;

  /* */

  var has = {}
  has.constructor = 'constructor';

  var hasNot =
  {
    Parent : 'Parent',
    Self : 'Self',
  }

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectIs( o ) );
  _.assertOwnNoConstructor( o,'options for classDeclare should have no constructor' );
  _.assert( !( 'parent' in o ) || o.parent !== undefined,'parent is "undefined", something is wrong' );

  if( o.withClass )
  {

    _.assert( _.routineIs( o.cls ),'expects {-o.cls-}' );
    _.assert( _.routineIs( o.cls ),'classDeclare expects constructor' );
    _.assert( _.strIs( o.cls.name ) || _.strIs( o.cls._name ),'constructor should have name' );
    _.assert( _ObjectHasOwnProperty.call( o.cls.prototype,'constructor' ) );
    _.assert( !o.name || o.cls.name === o.name || o.cls._name === o.name,'class has name',o.cls.name + ', but options',o.name );
    _.assert( !o.shortName || !o.cls.shortName|| o.cls.shortName === o.shortName,'class has short name',o.cls.shortName + ', but options',o.shortName );

    _.assertMapOwnAll( o.cls.prototype, has,'classDeclare expects constructor' );
    _.assertMapOwnNone( o.cls.prototype, hasNot );
    _.assertMapOwnNone( o.cls.prototype, DefaultForbiddenNames );

    if( o.extend && _ObjectHasOwnProperty.call( o.extend,'constructor' ) )
    _.assert( o.extend.constructor === o.cls );

  }
  else
  {
    _.assert( !o.cls );
  }

  _.assert( _.routineIs( o.parent ) || o.parent === undefined || o.parent === null, () => 'Wrong type of parent : ' + _.strTypeOf( 'o.parent' ) );
  _.assert( _.objectIs( o.extend ) || o.extend === undefined );
  _.assert( _.objectIs( o.supplement ) || o.supplement === undefined );
  _.assert( o.parent !== o.extend || o.extend === undefined );

  if( o.extend )
  {
    _.assert( o.extend.cls === undefined );
    _.assertOwnNoConstructor( o.extend );
  }
  if( o.supplementOwn )
  {
    _.assert( o.supplementOwn.cls === undefined );
    _.assertOwnNoConstructor( o.supplementOwn );
  }
  if( o.supplement )
  {
    _.assert( o.supplement.cls === undefined );
    _.assertOwnNoConstructor( o.supplement );
  }

  _.routineOptions( classDeclare,o );

  /* */

  var prototype;
  if( !o.parent )
  o.parent = null;

  /* make prototype */

  if( o.withClass )
  {

    if( o.usingOriginalPrototype )
    {

      prototype = o.cls.prototype;
      _.assert( o.parent === null || o.parent === Object.getPrototypeOf( o.cls.prototype ) );

    }
    else
    {
      if( o.cls.prototype )
      {
        _.assert( Object.keys( o.cls.prototype ).length === 0, 'misuse of classDeclare, prototype of constructor has properties which where put there manually',Object.keys( o.cls.prototype ) );
        _.assert( o.cls.prototype.constructor === o.cls );
      }
      if( o.parent )
      {
        prototype = o.cls.prototype = Object.create( o.parent.prototype );
      }
      else
      {
        prototype = o.cls.prototype = Object.create( null );
      }
    }

    /* constructor */

    prototype.constructor = o.cls;

    if( o.parent )
    {
      Object.setPrototypeOf( o.cls, o.parent );
    }

    /* extend */

    // if( prototype.constructor.name === 'BasicConstructor' )
    // debugger;

    _.classExtend
    ({
      cls : o.cls,
      extend : o.extend,
      supplementOwn : o.supplementOwn,
      supplement : o.supplement,
      usingPrimitiveExtension : o.usingPrimitiveExtension,
      usingStatics : 1,
      allowingExtendStatics : o.allowingExtendStatics,
    });

    /* statics */

    _.assert( _.routineIs( prototype.constructor ) );
    _.assert( _.objectIs( prototype.Statics ) );

    // _.assertMapHasAll( prototype, prototype.Statics );
    _.assertMapHasAll( prototype.constructor, prototype.Statics );

    // _.mapExtendConditional( _.field.mapper.dstNotOwnSrcOwn, prototype, prototype.Statics );
    // _.mapExtendConditional( _.field.mapper.dstNotOwnSrcOwn, prototype.constructor, prototype.Statics );

    _.assert( prototype === o.cls.prototype );
    _.assert( _ObjectHasOwnProperty.call( prototype,'constructor' ),'prototype should has own constructor' );
    _.assert( _.routineIs( prototype.constructor ),'prototype should has own constructor' );

    /* mixin tracking */

    if( !_ObjectHasOwnProperty.call( prototype,'_mixinsMap' ) )
    {
      prototype._mixinsMap = Object.create( prototype._mixinsMap || null );
    }

    _.assert( !prototype._mixinsMap[ o.cls.name ] );

    prototype._mixinsMap[ o.cls.name ] = 1;

    result = o.cls;

    /* handler */

    if( prototype.OnClassMakeEnd_meta )
    prototype.OnClassMakeEnd_meta.call( prototype, o );

    if( o.onClassMakeEnd )
    o.onClassMakeEnd.call( prototype, o );

  }

  /* */

  if( o.withMixin )
  {

    var mixinOptions = _.mapExtend( null,o );

    _.assert( !o.usingPrimitiveExtension );
    _.assert( !o.usingOriginalPrototype );
    _.assert( !o.parent );
    _.assert( !o.cls || o.withClass );

    delete mixinOptions.parent;
    delete mixinOptions.cls;
    delete mixinOptions.withMixin;
    delete mixinOptions.withClass;
    delete mixinOptions.usingPrimitiveExtension;
    delete mixinOptions.usingOriginalPrototype;
    delete mixinOptions.allowingExtendStatics;
    delete mixinOptions.onClassMakeEnd;

    if( mixinOptions.extend )
    mixinOptions.extend = _.mapExtend( null, mixinOptions.extend );
    if( mixinOptions.supplement )
    mixinOptions.supplement = _.mapExtend( null, mixinOptions.supplement );
    if( mixinOptions.supplementOwn )
    mixinOptions.supplementOwn = _.mapExtend( null, mixinOptions.supplementOwn );

    mixinOptions.prototype = prototype; /* xxx : remove? */

    _._mixinDelcare( mixinOptions );
    o.cls.__mixin__ = mixinOptions;
    o.cls.mixin = mixinOptions.mixin;

    _.assert( mixinOptions.extend === null || mixinOptions.extend.constructor === undefined );
    _.assert( mixinOptions.supplement === null || mixinOptions.supplement.constructor === undefined );
    _.assert( mixinOptions.supplementOwn === null || mixinOptions.supplementOwn.constructor === undefined );

  }

  /* */

  if( Config.debug )
  if( prototype )
  {
    var descriptor = Object.getOwnPropertyDescriptor( prototype,'constructor' );
    _.assert( descriptor.writable || descriptor.set );
    _.assert( descriptor.configurable );
  }

  return result;
}

classDeclare.defaults =
{
  cls : null,
  parent : null,

  onClassMakeEnd : null,
  onMixin : null,
  onMixinEnd : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  name : null,
  shortName : null,

  usingPrimitiveExtension : false,
  usingOriginalPrototype : false,
  allowingExtendStatics : false,

  withMixin : false,
  withClass : true,

}

//

/**
 * Extends and supplements( o.cls ) prototype by fields and methods repairing relationship : Composes, Aggregates, Associates, Medials, Restricts.
 *
 * @param {wTools~prototypeOptions} o - options {@link wTools~prototypeOptions}.
 * @returns {object} Returns constructor's prototype complemented by fields, static and non-static methods.
 *
 * @example
 * var Self = function Betta( o ) { };
 * var Statics = { staticFunction : function staticFunction(){ } };
 * var Composes = { a : 1, b : 2 };
 * var Proto = { Composes : Composes, Statics : Statics };
 *
 * var proto =  _.classExtend
 * ({
 *     cls : Self,
 *     extend : Proto,
 * });
 * console.log( Self.prototype === proto ); //returns true
 *
 * @method classExtend
 * @throws {exception} If no argument provided.
 * @throws {exception} If( o ) is not a Object.
 * @throws {exception} If( o.cls ) is not a Routine.
 * @throws {exception} If( prototype.cls ) is not a Routine.
 * @throws {exception} If( o.cls.name ) is not defined.
 * @throws {exception} If( o.cls.prototype ) has not own constructor.
 * @throws {exception} If( o.parent ) is not a Routine.
 * @throws {exception} If( o.extend ) is not a Object.
 * @throws {exception} If( o.supplement ) is not a Object.
 * @throws {exception} If( o.static) is not a Object.
 * @throws {exception} If( o.cls.prototype.Constitutes ) is defined.
 * @throws {exception} If( o.cls.prototype ) is not equal( prototype ).
 * @memberof wTools
 */

function classExtend( o )
{

  if( arguments.length === 2 )
  o = { cls : arguments[ 0 ], extend : arguments[ 1 ] };

  if( !o.prototype )
  o.prototype = o.cls.prototype;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( o ) );
  _.assert( !_ObjectHasOwnProperty.call( o,'constructor' ) );
  _.assertOwnNoConstructor( o );
  _.assert( _.objectIs( o.extend ) || o.extend === undefined || o.extend === null );
  _.assert( _.objectIs( o.supplementOwn ) || o.supplementOwn === undefined || o.supplementOwn === null );
  _.assert( _.objectIs( o.supplement ) || o.supplement === undefined || o.supplement === null );
  _.assert( _.routineIs( o.cls ) || _.objectIs( o.prototype ), 'expects class constructor or class prototype' );

  /*
  mixin could could have none class constructor
  */

  if( o.cls /*|| !o.prototype*/ )
  {

    _.assert( _.routineIs( o.cls ), 'expects constructor of class ( o.cls )' );
    _.assert( _.strIs( o.cls.name ) || _.strIs( o.cls._name ), 'class constructor should have name' );
    _.assert( !!o.prototype );
    // if( !o.prototype.Statics )
    // _.assertMapHasOnly( o.cls, [ _.KnownConstructorFields, o.prototype.Statics || {} ] ); /* xxx */

  }

  if( o.extend )
  {
    _.assert( o.extend.cls === undefined );
    _.assertOwnNoConstructor( o.extend );
  }
  if( o.supplementOwn )
  {
    _.assert( o.supplementOwn.cls === undefined );
    _.assertOwnNoConstructor( o.supplementOwn );
  }
  if( o.supplement )
  {
    _.assert( o.supplement.cls === undefined );
    _.assertOwnNoConstructor( o.supplement );
  }

  _.routineOptions( classExtend,o );

  _.assert( _.objectIs( o.prototype ) );

  /* fields groups */

  _.fieldsGroupsDeclareForEachFilter
  ({
    dstPrototype : o.prototype,
    extendMap : o.extend,
    supplementOwnMap : o.supplementOwn,
    supplementMap : o.supplement,
  });

  /* get constructor */

  if( !o.cls )
  o.cls = _._classConstructorAndPrototypeGet( o ).cls;

  /* */

  var staticsOwn = _.mapOwnProperties( o.prototype.Statics );
  var staticsAll = staticsAllGet();
  var fieldsGroups = _.fieldsGroupsGet( o.prototype );

  /* xxx : investigate */
  // if( _.mapKeys( staticsOwn ).length )
  // debugger;

/*

to prioritize ordinary facets adjustment order should be

- static extend
- ordinary extend
- ordinary supplement
- static supplement

*/

  /* static extend */

  if( o.extend && o.extend.Statics )
  declareStaticsForMixin( o.extend.Statics, _.mapExtend );

  /* ordinary extend */

  if( o.extend )
  fieldsDeclare( _.mapExtend, o.extend );

  /* ordinary supplementOwn */

  if( o.supplementOwn )
  fieldsDeclare( _.mapSupplementOwn, o.supplementOwn );

  /* ordinary supplement */

  if( o.supplement )
  fieldsDeclare( _.mapSupplement, o.supplement );

  /* static supplementOwn */

  if( o.supplementOwn && o.supplementOwn.Statics )
  declareStaticsForMixin( o.supplementOwn.Statics, _.mapSupplementOwn );

  /* static supplement */

  if( o.supplement && o.supplement.Statics )
  declareStaticsForMixin( o.supplement.Statics, _.mapSupplement );

  /* primitive extend */

  if( o.usingPrimitiveExtension )
  {
    debugger;
    for( var f in _.DefaultFieldsGroupsRelations )
    if( f !== 'Statics' )
    if( _.mapOwnKey( o.prototype,f ) )
    _.mapExtendConditional( _.field.mapper.srcOwnPrimitive, o.prototype, o.prototype[ f ] );
  }

  /* accessors */

  if( o.supplement )
  declareAccessors( o.supplement );
  if( o.supplementOwn )
  declareAccessors( o.supplementOwn );
  if( o.extend )
  declareAccessors( o.extend );

  /* statics */

  var fieldsOfRelationsGroups = _._fieldsOfRelationsGroups( o.prototype );

  if( o.supplement && o.supplement.Statics )
  declareStaticsForClass( o.supplement.Statics, 0, 0 );
  if( o.supplementOwn && o.supplementOwn.Statics )
  declareStaticsForClass( o.supplementOwn.Statics, 0, 1 );
  if( o.extend && o.extend.Statics )
  declareStaticsForClass( o.extend.Statics, 1, 1 );

  /* functors */

  if( o.functors )
  for( var m in o.functors )
  {
    var func = o.functors[ m ].call( o,o.prototype[ m ] );
    _.assert( _.routineIs( func ),'not tested' );
    o.prototype[ m ] = func;
  }

  /* validation */

  /*
  mixin could could have none class constructor
  */

  if( o.cls )
  {
    _.assert( o.prototype === o.cls.prototype );
    _.assert( _ObjectHasOwnProperty.call( o.prototype,'constructor' ),'prototype should has own constructor' );
    _.assert( _.routineIs( o.prototype.constructor ),'prototype should has own constructor' );
    _.assert( o.cls === o.prototype.constructor );
    //_.assertMapHasOnly( o.cls, [ _.KnownConstructorFields, o.prototype.Statics ] );

  }

  _.assert( _.objectIs( o.prototype.Statics ) );

  return o.prototype;

  /* */

  function fieldsDeclare( extend, src )
  {
    var map = _.mapBut( src, fieldsGroups );

    for( var s in staticsAll )
    if( map[ s ] === staticsAll[ s ] )
    delete map[ s ];

    extend( o.prototype, map );

    if( Config.debug )
    if( !o.allowingExtendStatics )
    if( Object.getPrototypeOf( o.prototype.Statics ) )
    {
      map = _.mapBut( map, staticsOwn );

      var keys = _.mapKeys( _.mapOnly( map, Object.getPrototypeOf( o.prototype.Statics ) ) );
      if( keys.length )
      {
        _.assert( 0,'attempt to extend static field', keys );
      }
    }
  }

  /* */

  function declareStaticsForMixin( statics, extend )
  {

    if( !o.usingStatics )
    return;

    extend( staticsAll, statics );

    /* is pure mixin */
    if( o.prototype.constructor )
    return;

    if( o.usingStatics && statics )
    {
      extend( o.prototype, statics );
      if( o.cls )
      extend( o.cls, statics );
    }

  }

  /* */

  function staticsAllGet()
  {
    var staticsAll = _.mapExtend( null, o.prototype.Statics );
    if( o.supplement && o.supplement.Statics )
    _.mapSupplement( staticsAll, o.supplement.Statics );
    if( o.supplementOwn && o.supplementOwn.Statics )
    _.mapSupplementOwn( staticsAll, o.supplementOwn.Statics );
    if( o.extend && o.extend.Statics )
    _.mapExtend( staticsAll, o.extend.Statics );
    return staticsAll;
  }

  /* */

  function declareStaticsForClass( statics, extending, dstNotOwn )
  {

    /* is class */
    if( !o.prototype.constructor )
    return;
    if( !o.usingStatics )
    return;

    for( var s in statics )
    {

      if( !_ObjectHasOwnProperty.call( o.prototype.Statics, s ) )
      continue;

      _.declareStatic
      ({
        name : s,
        value : o.prototype.Statics[ s ],
        prototype : o.prototype,
        extending : extending,
        dstNotOwn : dstNotOwn,
        fieldsOfRelationsGroups : fieldsOfRelationsGroups,
      });

    }

  }

  /* */

  function declareAccessors( src )
  {
    for( var d in DefaultAccessorsMap )
    if( src[ d ] )
    {
      DefaultAccessorsMap[ d ]( o.prototype,src[ d ] );
    }
  }

}

classExtend.defaults =
{
  cls : null,
  prototype : null,

  extend : null,
  supplementOwn : null,
  supplement : null,
  functors : null,

  usingStatics : true,
  usingPrimitiveExtension : false,
  allowingExtendStatics : false,
}

//

function declareStatic( o )
{

  if( !( 'value' in o ) )
  o.value = o.prototype.Statics[ o.name ];

  if( _.definitionIs( o.value ) )
  _.mapExtend( o, o.value.valueGet() );

  _.routineOptions( declareStatic, arguments );
  _.assert( _.strIs( o.name ) );
  _.assert( arguments.length === 1 );

  if( !o.fieldsOfRelationsGroups )
  o.fieldsOfRelationsGroups = _._fieldsOfRelationsGroups( o.prototype );

  var pd = _.propertyDescriptorGet( o.prototype, o.name );
  var cd = _.propertyDescriptorGet( o.prototype.constructor, o.name );

  if( pd.object !== o.prototype )
  pd.descriptor = null;

  if( cd.object !== o.prototype.constructor )
  cd.descriptor = null;

  if( o.name === 'constructor' )
  return;

  var symbol = Symbol.for( o.name );
  var aname = _._propertyGetterSetterNames( o.name );
  var methods = Object.create( null );

  /* */

  var prototype = o.prototype;
  if( !o.readOnly )
  methods[ aname.set ] = function set( src )
  {
    /*
      should assign fields to the original class / prototype
      not descendant
    */
    prototype[ symbol ] = src;
    prototype.constructor[ symbol] = src;
  }
  methods[ aname.get ] = function get()
  {
    return this[ symbol ];
  }

  /* */

  if( o.fieldsOfRelationsGroups[ o.name ] === undefined )
  if( !pd.descriptor || ( o.extending && pd.descriptor.value === undefined ) )
  {

    if( cd.descriptor )
    {
      o.prototype[ o.name ] = o.value;
    }
    else
    {
      o.prototype[ symbol ] = o.value;

      _.accessor
      ({
        object : o.prototype,
        methods : methods,
        names : o.name,
        combining : 'rewrite',
        configurable : true,
        enumerable : false,
        strict : false,
        readOnly : o.readOnly,
      });

      // Object.defineProperty( o.prototype, o.name,
      // {
      //   set : function set( src )
      //   {
      //     o.prototype[ symbol ] = src;
      //     o.prototype.constructor[ symbol] = src;
      //   },
      //   get : function get()
      //   {
      //     return this[ symbol ];
      //   },
      //   enumerable : false,
      //   configurable : true,
      // });

    }
  }

  /* */

  if( !cd.descriptor || ( o.extending && cd.descriptor.value === undefined ) )
  {
    if( pd.descriptor )
    {
      o.prototype.constructor[ o.name ] = o.value;
    }
    else
    {
      o.prototype.constructor[ symbol ] = o.value;

      // Object.defineProperty( o.prototype.constructor, o.name,
      // {
      //   set : function( src ) { prototype[ symbol ] = src; prototype.constructor[ symbol] = src; },
      //   get : function(){ return this[ symbol ]; },
      //   enumerable : true,
      //   configurable : true,
      // });

      _.accessor
      ({
        object : o.prototype.constructor,
        methods : methods,
        names : o.name,
        combining : 'rewrite',
        enumerable : true,
        configurable : true,
        prime : false,
        strict : false,
        readOnly : o.readOnly,
      });

    }

  }

  /* */

  return true;
}

var defaults = declareStatic.defaults = Object.create( null );

defaults.name = null;
defaults.value = null;
defaults.prototype = null;
defaults.fieldsOfRelationsGroups = null;
defaults.extending = 0; /**/
defaults.dstNotOwn = 0; /* !!! not used */
defaults.readOnly = 0;

//

function constructorGet( src )
{
  var proto;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( _ObjectHasOwnProperty.call( src,'constructor' ) )
  {
    proto = src; /* proto */
  }
  else if( _ObjectHasOwnProperty.call( src,'prototype' )  )
  {
    if( src.prototype )
    proto = src.prototype; /* constructor */
    else
    proto = Object.getPrototypeOf( Object.getPrototypeOf( src ) ); /* instance behind ruotine */
  }
  else
  {
    proto = Object.getPrototypeOf( src ); /* instance */
  }

  if( proto === null )
  return null;
  else
  return proto.constructor;
}

//

function subclassOf( subCls, cls )
{

  _.assert( _.routineIs( cls ) );
  _.assert( _.routineIs( subCls ) );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( cls === subCls )
  return true;

  return Object.isPrototypeOf.call( cls.prototype, subCls.prototype );
}

//

function subOf( sub, parent )
{

  _.assert( !!parent );
  _.assert( !!sub );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( parent === sub )
  return true;

  return Object.isPrototypeOf.call( parent, sub );

}

//

/**
 * Get parent's constructor.
 * @method parentGet
 * @memberof wCopyable#
 */

function parentGet( src )
{
  var c = constructorGet( src );

  _.assert( arguments.length === 1, 'expects single argument' );

  var proto = Object.getPrototypeOf( c.prototype );
  var result = proto ? proto.constructor : null;

  return result;
}

//

function _classConstructorAndPrototypeGet( o )
{
  var result = Object.create( null );

  if( !result.cls )
  if( o.prototype )
  result.cls = o.prototype.constructor;

  if( !result.cls )
  if( o.extend )
  if( o.extend.constructor !== Object.prototype.constructor )
  result.cls = o.extend.constructor;

  if( !result.cls )
  if( o.usingStatics && o.extend && o.extend.Statics )
  if( o.extend.Statics.constructor !== Object.prototype.constructor )
  result.cls = o.extend.Statics.constructor;

  if( !result.cls )
  if( o.supplement )
  if( o.supplement.constructor !== Object.prototype.constructor )
  result.cls = o.supplement.constructor;

  if( !result.cls )
  if( o.usingStatics && o.supplement && o.supplement.Statics )
  if( o.supplement.Statics.constructor !== Object.prototype.constructor )
  result.cls = o.supplement.Statics.constructor;

  if( o.prototype )
  result.prototype = o.prototype;
  else if( result.cls )
  result.prototype = result.cls.prototype;

  if( o.prototype )
  _.assert( result.cls === o.prototype.constructor );

  return result;
}

// --
// prototype
// --

function prototypeGet( src )
{

  if( !( 'constructor' in src ) )
  return null;

  var c = constructorGet( src );

  _.assert( arguments.length === 1, 'expects single argument' );

  return c.prototype;
}

//

/**
 * Make united interface for several maps. Access to single map cause read and write to original maps.
 * @param {array} protos - maps to united.
 * @return {object} united interface.
 * @method prototypeUnitedInterface
 * @memberof wTools
 */

function prototypeUnitedInterface( protos )
{
  var result = Object.create( null );
  var unitedArraySymbol = Symbol.for( '_unitedArray_' );
  var unitedMapSymbol = Symbol.for( '_unitedMap_' );
  var protoMap = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( protos ) );

  //

  function get( fieldName )
  {
    return function unitedGet()
    {
      return this[ unitedMapSymbol ][ fieldName ][ fieldName ];
    }
  }
  function set( fieldName )
  {
    return function unitedSet( value )
    {
      this[ unitedMapSymbol ][ fieldName ][ fieldName ] = value;
    }
  }

  //

  for( var p = 0 ; p < protos.length ; p++ )
  {
    var proto = protos[ p ];
    for( var f in proto )
    {
      if( f in protoMap )
      throw _.err( 'prototypeUnitedInterface :','several objects try to unite have same field :',f );
      protoMap[ f ] = proto;

      var methods = Object.create( null )
      methods[ f + 'Get' ] = get( f );
      methods[ f + 'Set' ] = set( f );
      var names = Object.create( null );
      names[ f ] = f;
      _.accessor
      ({
        object : result,
        names : names,
        methods : methods,
        strict : 0,
        prime : 0,
      });

    }
  }

  /*result[ unitedArraySymbol ] = protos;*/
  result[ unitedMapSymbol ] = protoMap;

  return result;
}

//

/**
 * Append prototype to object. Find archi parent and replace its proto.
 * @param {object} dstMap - dst object to append proto.
 * @method prototypeAppend
 * @memberof wTools
 */

function prototypeAppend( dstMap )
{

  _.assert( _.objectIs( dstMap ) );

  for( var a = 1 ; a < arguments.length ; a++ )
  {
    var proto = arguments[ a ];

    _.assert( _.objectIs( proto ) );

    var parent = _.prototypeArchyGet( dstMap );
    Object.setPrototypeOf( parent, proto );

  }

  return dstMap;
}

//

/**
 * Does srcProto has insProto as prototype.
 * @param {object} srcProto - proto stack to investigate.
 * @param {object} insProto - proto to look for.
 * @method prototypeHasPrototype
 * @memberof wTools
 */

function prototypeHasPrototype( srcProto,insProto )
{

  do
  {
    if( srcProto === insProto )
    return true;
    srcProto = Object.getPrototypeOf( srcProto );
  }
  while( srcProto !== Object.prototype );

  return false;
}

//

/**
 * Return proto owning names.
 * @param {object} srcPrototype - src object to investigate proto stack.
 * @method prototypeHasProperty
 * @memberof wTools
 */

function prototypeHasProperty( srcPrototype,names )
{
  var names = _nameFielded( names );
  _.assert( _.objectIs( srcPrototype ) );

  do
  {
    var has = true;
    for( var n in names )
    if( !_ObjectHasOwnProperty.call( srcPrototype,n ) )
    {
      has = false;
      break;
    }
    if( has )
    return srcPrototype;

    srcPrototype = Object.getPrototypeOf( srcPrototype );
  }
  while( srcPrototype !== Object.prototype && srcPrototype );

  return null;
}

//

/**
 * Returns parent which has default proto.
 * @param {object} srcPrototype - dst object to append proto.
 * @method prototypeArchyGet
 * @memberof wTools
 */

function prototypeArchyGet( srcPrototype )
{

  _.assert( _.objectIs( srcPrototype ) );

  while( Object.getPrototypeOf( srcPrototype ) !== Object.prototype )
  srcPrototype = Object.getPrototypeOf( srcPrototype );

  return srcPrototype;
}

//

function prototypeHasField( src, fieldName )
{
  var prototype = _.prototypeGet( src );

  _.assert( _.prototypeIs( prototype ) );
  _.assert( _.prototypeIsStandard( prototype ),'expects standard prototype' );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( fieldName ) );

  for( var f in _.DefaultFieldsGroupsRelations )
  if( prototype[ f ][ fieldName ] )
  return true;

  return false;
}

//

var _protoCrossReferAssociations = Object.create( null );
function prototypeCrossRefer( o )
{
  var names = _.mapKeys( o.entities );
  var length = names.length;

  var association = _protoCrossReferAssociations[ o.name ];
  if( !association )
  {
    _.assert( _protoCrossReferAssociations[ o.name ] === undefined );
    association = _protoCrossReferAssociations[ o.name ] = Object.create( null );
    association.name = o.name;
    association.length = length;
    association.have = 0;
    association.entities = _.mapExtend( null,o.entities );
  }
  else
  {
    _.assert( _.arraySetIdentical( _.mapKeys( association.entities ), _.mapKeys( o.entities ) ),'cross reference should have same associations' );
  }

  _.assert( association.name === o.name );
  _.assert( association.length === length );

  for( var e in o.entities )
  {
    if( !association.entities[ e ] )
    association.entities[ e ] = o.entities[ e ];
    else if( o.entities[ e ] )
    _.assert( association.entities[ e ] === o.entities[ e ] );
  }

  association.have = 0;
  for( var e in association.entities )
  if( association.entities[ e ] )
  association.have += 1;

  if( association.have === association.length )
  {

    for( var src in association.entities )
    for( var dst in association.entities )
    {
      if( src === dst )
      continue;
      var dstEntity = association.entities[ dst ];
      var srcEntity = association.entities[ src ];
      _.assert( !dstEntity[ src ] || dstEntity[ src ] === srcEntity, 'override of entity',src );
      _.assert( !dstEntity.prototype[ src ] || dstEntity.prototype[ src ] === srcEntity );
      _.classExtend( dstEntity,{ Statics : { [ src ] : srcEntity } } );
      _.assert( dstEntity[ src ] === srcEntity );
      _.assert( dstEntity.prototype[ src ] === srcEntity );
    }

    _protoCrossReferAssociations[ o.name ] = null;

    return true;
  }

  return false;
}

prototypeCrossRefer.defaults =
{
  entities : null,
  name : null,
}

// _.prototypeCrossRefer
// ({
//   namespace : _,
//   entities :
//   {
//     System : Self,
//   },
//   names :
//   {
//     System : 'LiveSystem',
//     Node : 'LiveNode',
//   },
// });

//

/**
 * Iterate through prototypes.
 * @param {object} proto - prototype
 * @method prototypeEach
 * @memberof wTools
 */

function prototypeEach( proto,onEach )
{
  var result = [];

  _.assert( _.routineIs( onEach ) || !onEach );
  _.assert( _.prototypeIs( proto ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  do
  {

    if( onEach )
    onEach.call( this,proto );

    result.push( proto );

    var parent = _.parentGet( proto );

    proto = parent ? parent.prototype : null;

    if( proto && proto.constructor === Object )
    proto = null;

  }
  while( proto );

  return result;
}

//

function _fieldsOfRelationsGroups( src )
{
  var result = Object.create( null );

  _.assert( _.objectIs( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  for( var g in _.DefaultFieldsGroupsRelations )
  {

    if( src[ g ] )
    _.mapExtend( result, src[ g ] );

  }

  return result;
}

//

function fieldsOfRelationsGroups( src )
{
  var prototype = _.prototypeGet( src );

  _.assert( _.prototypeIs( prototype ) );
  _.assert( _.prototypeIsStandard( prototype ),'expects standard prototype' );
  _.assert( arguments.length === 1, 'expects single argument' );

  var result = _._fieldsOfRelationsGroups( prototype );

  return result;
}

//

function fieldsOfCopyableGroups( src )
{
  var prototype = _.prototypeGet( src );
  var result = Object.create( null );

  _.assert( _.prototypeIs( prototype ) );
  _.assert( _.prototypeIsStandard( prototype ),'expects standard prototype' );
  _.assert( arguments.length === 1, 'expects single argument' );

  for( var g in _.DefaultFieldsGroupsCopyable )
  {

    if( prototype[ g ] )
    _.mapExtend( result,prototype[ g ] );

  }

  return result;
}

//

function fieldsOfTightGroups( src )
{
  var prototype = _.prototypeGet( src );
  var result = Object.create( null );

  _.assert( _.prototypeIs( prototype ) );
  _.assert( _.prototypeIsStandard( prototype ),'expects standard prototype' );
  _.assert( arguments.length === 1, 'expects single argument' );

  for( var g in _.DefaultFieldsGroupsTight )
  {

    if( prototype[ g ] )
    _.mapExtend( result,prototype[ g ] );

  }

  return result;
}

//

function fieldsOfInputGroups( src )
{
  var prototype = _.prototypeGet( src );
  var result = Object.create( null );

  _.assert( _.prototypeIs( prototype ) );
  _.assert( _.prototypeIsStandard( prototype ),'expects standard prototype' );
  _.assert( arguments.length === 1, 'expects single argument' );

  for( var g in _.DefaultFieldsGroupsInput )
  {

    if( prototype[ g ] )
    _.mapExtend( result,prototype[ g ] );

  }

  return result;
}

// --
// instance
// --

/*
  usage : return _.instanceConstructor( Self, this, arguments );
  replacement for :

  _.assert( arguments.length === 0 || arguments.length === 1 );
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );

*/

function instanceConstructor( cls, context, args )
{
  _.assert( args.length === 0 || args.length === 1 );
  _.assert( arguments.length === 3 );
  _.routineIs( cls );
  _.arrayLike( args );

  let o = args[ 0 ];

  if( !( context instanceof cls ) )
  if( o instanceof cls )
  {
    _.assert( args.length === 1 );
    return o;
  }
  else
  {
    return new( _.routineJoin( cls, cls, args ) );
  }

  return cls.prototype.init.apply( context, args );
}

//

/**
 * Is this instance finited.
 * @method instanceIsFinited
 * @param {object} src - instance of any class
 * @memberof wCopyable#
 */

function instanceIsFinited( src )
{
  _.assert( _.instanceIs( src ) )
  _.assert( _.objectLikeOrRoutine( src ) );
  return Object.isFrozen( src );
}

//

function instanceFinit( src )
{

  _.assert( !Object.isFrozen( src ) );
  _.assert( _.objectLikeOrRoutine( src ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  // var validator =
  // {
  //   set : function( obj, k, e )
  //   {
  //     debugger;
  //     throw _.err( 'Attempt ot access to finited instance with field',k );
  //     return false;
  //   },
  //   get : function( obj, k, e )
  //   {
  //     debugger;
  //     throw _.err( 'Attempt ot access to finited instance with field',k );
  //     return false;
  //   },
  // }
  // var result = new Proxy( src, validator );

  Object.freeze( src );

}

//

/**
 * Complements instance by its semantic relations : Composes, Aggregates, Associates, Medials, Restricts.
 * @param {object} instance - instance to complement.
 *
 * @example
 * var Self = function Alpha( o ) { };
 *
 * var Proto = { constructor: Self, Composes : { a : 1, b : 2 } };
 *
 * _.classDeclare
 * ({
 *     constructor: Self,
 *     extend: Proto,
 * });
 * var obj = new Self();
 * console.log( _.instanceInit( obj ) ); //returns Alpha { a: 1, b: 2 }
 *
 * @return {object} Returns complemented instance.
 * @method instanceInit
 * @memberof wTools
 */

function instanceInit( instance,prototype )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( prototype === undefined )
  prototype = instance;

  // _.mapComplement( instance, prototype.Restricts );
  // _.mapComplement( instance, prototype.Composes );
  // _.mapComplement( instance, prototype.Aggregates );

  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Restricts );
  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Composes );
  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Aggregates );
  _.mapSupplementOwnFromDefinitionStrictlyPrimitives( instance, prototype.Associates );

  // _.mapSupplementOwn( instance, prototype.Associates );
  // _.mapSupplementOwnAssigning( instance, prototype.Associates );

  return instance;
}

//

function instanceInitExtending( instance,prototype )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( prototype === undefined )
  prototype = instance;

  _.mapExtendConditional( _.field.mapper.assigning, instance, prototype.Restricts );
  _.mapExtendConditional( _.field.mapper.assigning, instance, prototype.Composes );
  _.mapExtendConditional( _.field.mapper.assigning, instance, prototype.Aggregates );
  _.mapExtend( instance,prototype.Associates );

  return instance;
}

//

function instanceFilterInit( o )
{

  _.routineOptions( instanceFilterInit,o );

  // var self = _.instanceFilterInit
  // ({
  //   cls : Self,
  //   parent : Parent,
  //   extend : Extend,
  // });

  _.assertOwnNoConstructor( o );
  _.assert( _.routineIs( o.cls ) );
  _.assert( !o.args || o.args.length === 0 || o.args.length === 1 );

  var result = Object.create( null );

  _.instanceInit( result,o.cls.prototype );

  if( o.args[ 0 ] )
  _.Copyable.prototype.copyCustom.call( o.cls.prototype,
  {
    proto : o.cls.prototype,
    src : o.args[ 0 ],
    dst : result,
    technique : 'object',
  });

  if( !result.original )
  result.original = _.FileProvider.Default();

  _.mapExtend( result,o.extend );

  Object.setPrototypeOf( result,result.original );

  if( o.strict )
  Object.preventExtensions( result );

  return result;
}

instanceFilterInit.defaults =
{
  cls : null,
  parent : null,
  extend : null,
  args : null,
  strict : 1,
}

//

/**
 * Make sure src does not have redundant fields.
 * @param {object} src - source object of the class.
 * @method assertInstanceDoesNotHaveReduntantFields
 * @memberof wTools
 */

function assertInstanceDoesNotHaveReduntantFields( src )
{

  var Composes = src.Composes || Object.create( null );
  var Aggregates = src.Aggregates || Object.create( null );
  var Associates = src.Associates || Object.create( null );
  var Restricts = src.Restricts || Object.create( null );

  _.assert( _.ojbectIs( src ) )
  _.assertMapOwnOnly( src, [ Composes, Aggregates, Associates, Restricts ] );

  return dst;
}

// --
// default
// --

/*
apply default to each element of map, if present
*/

function defaultApply( src )
{

  _.assert( _.objectIs( src ) || _.longIs( src ) );
  _.assert( def === _.def );

  var defVal = src[ def ];

  if( !defVal )
  return src;

  _.assert( _.objectIs( src ) );

  if( _.objectIs( src ) )
  {

    for( var s in src )
    {
      if( !_.objectIs( src[ s ] ) )
      continue;
      _.mapSupplement( src[ s ],defVal );
    }

  }
  else
  {

    for( var s = 0 ; s < src.length ; s++ )
    {
      if( !_.objectIs( src[ s ] ) )
      continue;
      _.mapSupplement( src[ s ],defVal );
    }

  }

  return src;
}

//

/*
activate default proxy
*/

function defaultProxy( map )
{

  _.assert( _.objectIs( map ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  var validator =
  {
    set : function( obj, k, e )
    {
      obj[ k ] = _.defaultApply( e );
      return true;
    }
  }

  var result = new Proxy( map, validator );

  for( var k in map )
  {
    _.defaultApply( map[ k ] );
  }

  return result;
}

//

function defaultProxyFlatteningToArray( src )
{
  var result = [];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectIs( src ) || _.arrayIs( src ) );

  function flatten( src )
  {

    if( _.arrayIs( src ) )
    {
      for( var s = 0 ; s < src.length ; s++ )
      flatten( src[ s ] );
    }
    else
    {
      if( _.objectIs( src ) )
      result.push( defaultApply( src ) );
      else
      result.push( src );
    }

  }

  flatten( src );

  return result;
}

// --
//
// --

function Definition( o )
{
  _.assert( arguments.length === 1 );
  if( !( this instanceof Definition ) )
  if( o instanceof Definition )
  return o;
  else
  return new( _.routineJoin( Definition, Definition, arguments ) );
  _.mapExtend( this, o );
  return this;
}

//

function common( src )
{
  var definition = new Definition({ value : src });

  _.assert( src !== undefined, () => 'Expects object-like or long, but got ' + _.strTypeOf( src ) );
  _.assert( arguments.length === 1 );

  definition.valueGet = function get() { return this.value }

  _.hide( definition, 'valueGet' );

  Object.freeze( definition );
  return definition;
}

//

function own( src )
{
  var definition = new Definition({ value : src });

  _.assert( src !== undefined, () => 'Expects object-like or long, but got ' + _.strTypeOf( src ) );
  _.assert( arguments.length === 1 );

  // definition.valueGet = function get() { return _.entityShallowClone( this.value ) }
  definition.valueGet = function get() { return _.cloneJust( this.value ) }

  _.hide( definition, 'valueGet' );

  Object.freeze( definition );
  return definition;
}

//

function ownInstanceOf( src )
{
  var definition = new Definition({ value : src });

  _.assert( _.routineIs( src ), 'Expects constructor' );
  _.assert( arguments.length === 1 );

  definition.valueGet = function get() { return new this.value() }

  _.hide( definition, 'valueGet' );

  Object.freeze( definition );
  return definition;
}

//

function ownMadeBy( src )
{
  var definition = new Definition({ value : src });

  _.assert( _.routineIs( src ), 'Expects constructor' );
  _.assert( arguments.length === 1 );

  definition.valueGet = function get() { return this.value() }

  _.hide( definition, 'valueGet' );

  Object.freeze( definition );
  return definition;
}

//

function contained( src )
{

  _.assert( _.mapIs( src ) );
  _.assert( arguments.length === 1 );

  var container = _.mapBut( src, contained.defaults );
  var o = _.mapOnly( src, contained.defaults );
  o.container = container;
  o.value = container.value;
  var definition = new Definition( o );

  if( o.shallowCloning )
  definition.valueGet = function get()
  {
    var result = this.container;
    result.value = _.entityShallowClone( definition.value );
    return result;
  }
  else
  definition.valueGet = function get()
  {
    var result = this.container;
    result.value = definition.value;
    return result;
  }

  _.hide( definition, 'valueGet' );

  Object.freeze( definition );
  return definition;
}

contained.defaults =
{
  shallowCloning : 0,
}

// --
// type
// --

class wCallableObject extends Function
{
  constructor()
  {
    super( 'return this.self.__call__.apply( this.self,arguments );' );

    var context = Object.create( null );
    var self = this.bind( context );
    context.self = self;
    Object.freeze( context );

    return self;
  }
}

wCallableObject.shortName = 'CallableObject';

// --
// fields
// --

var Combining = [ 'rewrite','supplement','apppend','prepend' ];

var KnownConstructorFields =
{
  name : null,
  _name : null,
  shortName : null,
  prototype : null,
}

/**
 * @global {Object} wTools~DefaultFieldsGroupsRelations - contains predefined class relationship types.
 * @memberof wTools
 */

var DefaultFieldsGroups = Object.create( null );
DefaultFieldsGroups.Groups = 'Groups';
DefaultFieldsGroups.Composes = 'Composes';
DefaultFieldsGroups.Aggregates = 'Aggregates';
DefaultFieldsGroups.Associates = 'Associates';
DefaultFieldsGroups.Restricts = 'Restricts';
DefaultFieldsGroups.Medials = 'Medials';
DefaultFieldsGroups.Statics = 'Statics';
DefaultFieldsGroups.Copiers = 'Copiers';
Object.freeze( DefaultFieldsGroups );

var DefaultFieldsGroupsRelations = Object.create( null );
DefaultFieldsGroupsRelations.Composes = 'Composes';
DefaultFieldsGroupsRelations.Aggregates = 'Aggregates';
DefaultFieldsGroupsRelations.Associates = 'Associates';
DefaultFieldsGroupsRelations.Restricts = 'Restricts';
Object.freeze( DefaultFieldsGroupsRelations );

var DefaultFieldsGroupsCopyable = Object.create( null );
DefaultFieldsGroupsCopyable.Composes = 'Composes';
DefaultFieldsGroupsCopyable.Aggregates = 'Aggregates';
DefaultFieldsGroupsCopyable.Associates = 'Associates';
Object.freeze( DefaultFieldsGroupsCopyable );

var DefaultFieldsGroupsTight = Object.create( null );
DefaultFieldsGroupsTight.Composes = 'Composes';
DefaultFieldsGroupsTight.Aggregates = 'Aggregates';
Object.freeze( DefaultFieldsGroupsTight );

var DefaultFieldsGroupsInput = Object.create( null );
DefaultFieldsGroupsInput.Composes = 'Composes';
DefaultFieldsGroupsInput.Aggregates = 'Aggregates';
DefaultFieldsGroupsInput.Associates = 'Associates';
DefaultFieldsGroupsInput.Medials = 'Medials';
Object.freeze( DefaultFieldsGroupsInput );

var DefaultForbiddenNames = Object.create( null );
DefaultForbiddenNames.Static = 'Static';
DefaultForbiddenNames.Type = 'Type';
Object.freeze( DefaultForbiddenNames );

var DefaultAccessorsMap = Object.create( null );
DefaultAccessorsMap.Accessors = accessor;
DefaultAccessorsMap.Forbids = accessorForbid;
DefaultAccessorsMap.AccessorsForbid = accessorForbid;
DefaultAccessorsMap.AccessorsReadOnly = accessorReadOnly;

var Forbids =
{
  _ArrayDescriptor : '_ArrayDescriptor',
  ArrayDescriptor : 'ArrayDescriptor',
  _ArrayDescriptors : '_ArrayDescriptors',
  ArrayDescriptors : 'ArrayDescriptors',
  arrays : 'arrays',
  arrayOf : 'arrayOf',
}

// --
// define
// --

var Define =
{
  Definition : Definition,
  common : common,
  own : own,
  ownInstanceOf : ownInstanceOf,
  ownMadeBy : ownMadeBy,
  contained : contained,
}

//

var Fields =
{

  AccessorDefaults : AccessorDefaults,
  Combining : Combining,
  KnownConstructorFields : KnownConstructorFields,

  DefaultFieldsGroups : DefaultFieldsGroups,
  DefaultFieldsGroupsRelations : DefaultFieldsGroupsRelations,
  DefaultFieldsGroupsCopyable : DefaultFieldsGroupsCopyable,
  DefaultFieldsGroupsTight : DefaultFieldsGroupsTight,
  DefaultFieldsGroupsInput : DefaultFieldsGroupsInput,

  DefaultForbiddenNames : DefaultForbiddenNames,
  DefaultAccessorsMap : DefaultAccessorsMap,

  CallableObject : wCallableObject,

}

//

var Routines =
{

  // accessor

  _accessor_pre : _accessor_pre,
  _accessorRegister : _accessorRegister,
  _accessorAct : _accessorAct,
  _accessor : _accessor,

  accessor : accessor,
  accessorForbid : accessorForbid,
  _accessorForbid : _accessorForbid,

  accessorForbidOwns : accessorForbidOwns,
  accessorReadOnly : accessorReadOnly,

  accessorsSupplement : accessorsSupplement,

  constant : constant,
  hide : hide,
  restrictReadOnly : restrictReadOnly,

  accessorToElement : accessorToElement,
  accessorHas : accessorHas,

  // fields group

  fieldsGroupsGet : fieldsGroupsGet,
  fieldsGroupFor : fieldsGroupFor, /* experimental */
  fieldsGroupDeclare : fieldsGroupDeclare,  /* experimental */

  fieldsGroupComposesExtend : fieldsGroupComposesExtend, /* experimental */
  fieldsGroupAggregatesExtend : fieldsGroupAggregatesExtend, /* experimental */
  fieldsGroupAssociatesExtend : fieldsGroupAssociatesExtend, /* experimental */
  fieldsGroupRestrictsExtend : fieldsGroupRestrictsExtend, /* experimental */

  fieldsGroupComposesSupplement : fieldsGroupComposesSupplement, /* experimental */
  fieldsGroupAggregatesSupplement : fieldsGroupAggregatesSupplement, /* experimental */
  fieldsGroupAssociatesSupplement : fieldsGroupAssociatesSupplement, /* experimental */
  fieldsGroupRestrictsSupplement : fieldsGroupRestrictsSupplement, /* experimental */

  fieldsGroupsDeclare : fieldsGroupsDeclare,
  fieldsGroupsDeclareForEachFilter : fieldsGroupsDeclareForEachFilter,

  // getter / setter functors

  setterMapCollection_functor : setterMapCollection_functor,
  setterArrayCollection_functor : setterArrayCollection_functor,

  setterFriend_functor : setterFriend_functor,
  setterCopyable_functor : setterCopyable_functor,
  setterBufferFrom_functor : setterBufferFrom_functor,
  setterChangesTracking_functor : setterChangesTracking_functor,

  setterAlias_functor : setterAlias_functor,
  getterAlias_functor : getterAlias_functor,

  // property

  propertyDescriptorForAccessor : propertyDescriptorForAccessor,
  propertyDescriptorGet : propertyDescriptorGet,
  _propertyGetterSetterNames : _propertyGetterSetterNames,
  _propertyGetterSetterMake : _propertyGetterSetterMake,
  _propertyGetterSetterGet : _propertyGetterSetterGet,

  // proxy

  proxyNoUndefined : proxyNoUndefined,
  proxyReadOnly : proxyReadOnly,
  ifDebugProxyReadOnly : ifDebugProxyReadOnly,
  proxyMap : proxyMap,

  // mixin

  _mixinDelcare : _mixinDelcare,
  mixinDelcare : mixinDelcare,
  mixinApply : mixinApply,
  mixinHas : mixinHas,

  // class

  classDeclare : classDeclare,
  classExtend : classExtend,

  declareStatic : declareStatic,

  constructorGet : constructorGet,

  subclassOf : subclassOf,
  subOf : subOf,

  parentGet : parentGet,
  _classConstructorAndPrototypeGet : _classConstructorAndPrototypeGet,

  // prototype

  prototypeGet : prototypeGet,

  prototypeUnitedInterface : prototypeUnitedInterface, /* experimental */

  prototypeAppend : prototypeAppend, /* experimental */
  prototypeHasPrototype : prototypeHasPrototype, /* experimental */
  prototypeHasProperty : prototypeHasProperty, /* experimental */
  prototypeArchyGet : prototypeArchyGet, /* experimental */
  prototypeHasField : prototypeHasField,

  prototypeCrossRefer : prototypeCrossRefer, /* experimental */
  prototypeEach : prototypeEach, /* experimental */

  _fieldsOfRelationsGroups : _fieldsOfRelationsGroups,
  fieldsOfRelationsGroups : fieldsOfRelationsGroups,
  fieldsOfCopyableGroups : fieldsOfCopyableGroups,
  fieldsOfTightGroups : fieldsOfTightGroups,
  fieldsOfInputGroups : fieldsOfInputGroups,

  // instance

  instanceConstructor : instanceConstructor,

  instanceIsFinited : instanceIsFinited,
  instanceFinit : instanceFinit,

  instanceInit : instanceInit,
  instanceInitExtending : instanceInitExtending,
  instanceFilterInit : instanceFilterInit, /* deprecated */

  assertInstanceDoesNotHaveReduntantFields : assertInstanceDoesNotHaveReduntantFields,

  // default

  defaultApply : defaultApply,
  defaultProxy : defaultProxy,
  defaultProxyFlatteningToArray : defaultProxyFlatteningToArray,

}

//

_.define = Define;
_.mapExtend( _, Routines );
_.mapExtend( _, Fields );
_.accessorForbid( _, Forbids );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

// --
// import
// --

if( typeof module !== 'undefined' )
{

  if( !_.construction )
  require( './ProtoLike.s' );

}

})();
