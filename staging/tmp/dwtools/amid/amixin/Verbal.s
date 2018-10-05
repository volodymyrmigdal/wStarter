( function _Verbal_s_() {

'use strict';

/**
  @module Tools/mid/mixin/Verbal - Verbal is small mixin which adds verbosity control to your class. It tracks verbosity changes, reflects any change of verbosity to instance's components, and also clamp verbosity in [ 0 .. 9 ] range. Use it as a companion for a logger, mixing it into logger's carrier.
*/

/**
 * @file Verbal.s.
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

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = function wVerbal( o )
{
  _.assert( arguments.length === 0 || arguments.length === 1 );
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Verbal';

// --
// routines
// --

function verbal_functor( o )
{
  if( _.routineIs( o ) )
  o = { routine : o }
  _.routineOptions( verbal_functor, o );
  _.assert( _.strIsNotEmpty( o.routine.name ) );
  let routine = o.routine;
  let title = _.strCapitalize( _.strToTitle( o.routine.name ) );

  return function verbal()
  {
    let self = this;
    let logger = self.logger;
    let result;
    logger.rbegin({ verbosity : -1 });
    logger.log( title + ' ..' );
    logger.up();

    try
    {
      result = routine.apply( this, arguments );
    }
    catch( err )
    {
      throw _.err( err );
    }

    _.Consequence.from( result ).split()
    .doThen( () =>
    {
      logger.down();
      logger.rend({ verbosity : -1 });
    });

    return result;
  }
}

verbal_functor.defaults =
{
  routine : null,
}

//

function _verbositySet( src )
{
  let self = this;

  if( _.boolIs( src ) )
  src = src ? 1 : 0;

  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( src ) );

  src = _.numberClamp( src, 0, 9 );

  self[ verbositySymbol ] = src;

  self._verbosityChange();
}

//

function _verbosityChange()
{
  let self = this;

  if( self.fileProvider )
  self.fileProvider.verbosity = self._verbosityForFileProvider();

  if( self.logger )
  {
    self.logger.verbosity = self._verbosityForLogger();
    self.logger.outputGray = self.coloring ? 0 : 1;
  }

}

//

function _coloringSet( src )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.boolLike( src ) );

  if( !src )
  debugger;

  if( self.logger )
  {
    self[ coloringSymbol ] = src;
    self.logger.outputGray = src ? 0 : 1;
  }
  else
  {
    self[ coloringSymbol ] = src;
  }

}

//

function _coloringGet()
{
  let self = this;
  if( self.logger )
  return !self.logger.outputGray;
  return self[ coloringSymbol ];
}

//

function _verbosityForFileProvider()
{
  let self = this;
  let less = _.numberClamp( self.verbosity-2, 0, 9 );
  _.assert( arguments.length === 0 );
  return less;
}

//

function _fileProviderSet( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  // if( src )
  // src.verbosity = self._verbosityForFileProvider();

  self[ fileProviderSymbol ] = src;

  self._verbosityChange();

}

//

function _verbosityForLogger()
{
  let self = this;
  _.assert( arguments.length === 0 );
  return self.verbosity;
}

//

function _loggerSet( src )
{
  let self = this;

  _.assert( arguments.length === 1 );

  self[ loggerSymbol ] = src;

  if( src )
  {
    // src.verbosity = self._verbosityForLogger();
    src.outputGray = self.coloring ? 0 :1;
  }

  self._verbosityChange();
}

// --
// vars
// --

let verbositySymbol = Symbol.for( 'verbosity' );
let coloringSymbol = Symbol.for( 'coloring' );
let fileProviderSymbol = Symbol.for( 'fileProvider' );
let loggerSymbol = Symbol.for( 'logger' );

// --
// relations
// --

let Composes =
{
  verbosity : 0,
  coloring : 1,
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  verbal_functor : verbal_functor,
}

let Forbids =
{
}

let Accessors =
{
  verbosity : { combining : 'supplement' },
  coloring : { combining : 'supplement' },
  fileProvider : { combining : 'supplement' },
  logger : { combining : 'supplement' },
}

// --
// declare
// --

let Supplement =
{

  _verbositySet : _verbositySet,
  _verbosityChange : _verbosityChange,
  _coloringSet : _coloringSet,
  _coloringGet : _coloringGet,

  _verbosityForFileProvider : _verbosityForFileProvider,
  _fileProviderSet : _fileProviderSet,
  _verbosityForLogger : _verbosityForLogger,
  _loggerSet : _loggerSet,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,
  Accessors : Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
