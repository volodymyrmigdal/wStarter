( function _FieldsStack_s_( ) {

'use strict';

/**
  @module Tools/base/FieldsStack - Mixin adds fields rotation mechanism to your class. It's widespread problem to change the value of a field and then after some steps revert old value, no matter what it was. FieldsStack does it for you behind the scene. FieldsStack mixins methods fieldPush, fieldPop which allocate a map of stacks of fields and manage it to avoid any corruption. Use the module to keep it simple and don't repeat yourself.
*/

/**
 * @file FieldsStack.s.
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

  _.include( 'wProto' );

}

let _ObjectHasOwnProperty = Object.hasOwnProperty;
let _global = _global_;
let _ = _global_.wTools;

//

/**
 * @class wEventHandler
 */

let Parent = null;
let Self = function wFieldsStack( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'FieldsStack';

// let Self = _.fieldsStack = _.fieldsStack || Object.create( null );
//
//
//
// function onMixin( mixinDescriptor, dstClass )
// {
//   let dstPrototype = dstClass.prototype;
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( _.routineIs( dstClass ) );
//   _.assert( _.mixinHas( dstPrototype,_.Copyable ),'wCopyable should be mixed in first' );
//
//   _.mixinApply( this, dstPrototype );
//
//   // _.mixinApply
//   // ({
//   //   dstPrototype : proto,
//   //   descriptor : Self,
//   // });
//
// }
//
//
//
// function declareMixinClass()
// {
//   let _ = _global_.wTools.withArray.Float32;
//
//   // Declare class
//   let o =
//   {
//     storageFileName : null,
//     storageLoaded : null,
//     storageToSave : null,
//     fields : null,
//     fileProvider : null,
//   }
//
//   let Associates =
//   {
//     storageFileName : o.storageFileName,
//     fileProvider : _.define.own( o.fileProvider ),
//   }
//
//   function SampleClass( o )
//   {
//     return _.instanceConstructor( SampleClass, this, arguments );
//   }
//
//   function init( o )
//   {
//     _.instanceInit( this );
//   }
//   let Extend =
//   {
//     init : init,
//     storageLoaded : o.storageLoaded,
//     storageToSave : o.storageToSave,
//     Composes : o.fields,
//     Associates : Associates,
//   }
//   _.classDeclare
//   ({
//     cls : SampleClass,
//     extend : Extend,
//   });
//
//   // Mixin
//   _.Copyable.mixin( SampleClass );
//   _.FieldsStack.mixin( SampleClass );
//
//   let sample = new SampleClass();
//   return sample;
// }

//

function fieldSet( fields )
{
  let self = this;

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( arguments[ 0 ] ) );
    _.assert( arguments[ 1 ] !== undefined );
    fields = { [ arguments[ 0 ] ] : arguments[ 1 ] }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.mapIs( fields ) )

  for( let s in fields )
  {
    if( !self._fields[ s ] )
    self._fields[ s ] = [];
    self._fields[ s ].push( self[ s ] );
    // logger.log( 'fieldSet ' + s + ' ' + _.toStrShort( self[ s ] ) + ' -> ' + _.toStrShort( fields[ s ] ) );
    self[ s ] = fields[ s ];
    // logger.log( 'fieldSet new value of ' + s + ' ' + self[ s ] );
  }

  return self;
}

//

function fieldReset( fields )
{
  let self = this;
  let result = Object.create( null );

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( arguments[ 0 ] ) );
    _.assert( arguments[ 1 ] !== undefined );
    fields = { [ arguments[ 0 ] ] : arguments[ 1 ] }
  }
  else if( arguments.length === 1 && _.strIs( arguments[ 0 ] ) )
  {
    fields = { [ arguments[ 0 ] ] : _.nothing }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.mapIs( fields ) );

  for( let s in fields )
  {
    let wasVal = fields[ s ];
    let selfVal = self[ s ];
    let _field = self._fields[ s ];

    // logger.log( 'fieldReset ' + s + ' ' + _.toStrShort( selfVal ) + ' ~ ' + _.toStrShort( wasVal ) );

    _.assert( _.arrayIs( _field ) );
    _.assert( selfVal === wasVal || wasVal === _.nothing, () => 'Decoupled fieldReset ' + _.toStrShort( selfVal ) + ' != ' + _.toStrShort( wasVal ) );
    self[ s ] = _field.pop();
    if( !self._fields[ s ].length )
    delete self._fields[ s ];
    result[ s ] = self[ s ];
  }

  if( !Object.keys( result ).length === 1 )
  debugger;

  if( Object.keys( result ).length === 1 )
  result = result[ Object.keys( result )[ 0 ] ];

  return result;
}

// --
// relations
// --

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
  _fields : _.define.own( {} ),
}

let Statics =
{
}

// --
// declare
// --

let Supplement =
{

  // declareMixinClass : declareMixinClass,

  fieldSet : fieldSet,
  fieldReset : fieldReset,

  fieldPush : fieldSet,
  fieldPop : fieldReset,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

// //
//
// let Self =
// {
//
//   onMixin : onMixin,
//   supplement : Supplement,
//   name : 'wFieldsStack',
//   shortName : 'FieldsStack',
//
// }

//

_.classDeclare
({
  cls : Self,
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

// _global_[ Self.name ] = _[ Self.shortName ] = _.mixinDelcare( Self );

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
