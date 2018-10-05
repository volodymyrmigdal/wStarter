(function _ToFile_s_() {

'use strict';

/**
  @module Tools/base/printer/ToFile - Class to redirect logging to a file. Logger supports colorful formatting, verbosity control, chaining, combining several loggers/consoles into logging network. Logger provides 10 levels of verbosity [ 0,9 ] any value beyond clamped and multiple approaches to control verbosity. Logger may use console/stream/process/file as input or output. Unlike alternatives, colorful formatting is cross-platform and works similarly in the browser and on the server side. Use the module to make your diagnostic code working on any platform you work with and to been able to redirect your output to/from any destination/source.
*/

/**
 * @file printer/ToFile.ss.
 */

// require

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../dwtools/Base.s';
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
  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wLogger' );
  _.include( 'wFiles' );

}

//

/**
 * @classdesc Logger based on [wLogger]{@link wLogger} that writes messages( incoming & outgoing ) to file specified by path( outputPath ).
 *
 * Writes each message to the end of file. Creates new file( outputPath ) if it doesn't exist.
 *
 * <br><b>Methods:</b><br><br>
 * Output:
 * <ul>
 * <li>log
 * <li>error
 * <li>info
 * <li>warn
 * </ul>
 * Chaining:
 * <ul>
 *  <li>Add object to output list [outputTo]{@link wPrinterMid.outputTo}
 *  <li>Remove object from output list [outputUnchain]{@link wPrinterMid.outputUnchain}
 *  <li>Add current logger to target's output list [inputFrom]{@link wPrinterMid.inputFrom}
 *  <li>Remove current logger from target's output list [inputUnchain]{@link wPrinterMid.inputUnchain}
 * </ul>
 * @class wPrinterToFile
 * @param { Object } o - Options.
 * @param { Object } [ o.output=null ] - Specifies single output object for current logger.
 * @param { Object } [ o.outputPath=null ] - Specifies file path for output.
 *
 * @example
 * var path = __dirname +'/out.txt';
 * var l = new wPrinterToFile({ outputPath : path });
 * var File = _.FileProvider.HardDrive();
 * l.log( '1' );
 * FilefileReadAct
 * ({
 *  filePath : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 * @example
 * var path = __dirname +'/out2.txt';
 * var l = new wPrinterToFile({ outputPath : path });
 * vae l2 = new _.Logger({ output : l });
 * var File = _.FileProvider.HardDrive();
 * l2.log( '1' );
 * FilefileReadAct
 * ({
 *  filePath : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 */

var _global = _global_;
var _ = _global_.wTools;
var Parent = _.PrinterTop;
var Self = function wPrinterToFile( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'PrinterToFile';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

  if( _.path.effectiveMainDir )
  self.outputPath = _.path.join( _.path.effectiveMainDir(),self.outputPath );

  if( !self.fileProvider )
  self.fileProvider = _.FileProvider.HardDrive();

}

//

// function __initChainingMixinWrite( name )
// {
//   var proto = this;
//   var nameAct = name + 'Act';

//   _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
//   _.assert( arguments.length === 1 );
//   _.assert( _.strIs( name ) );

//   /* */

//   function write()
//   {
//     this._writeToFile.apply( this, arguments );
//     if( this.output )
//     return this[ nameAct ].apply( this,arguments );
//   }

//   proto[ name ] = write;
// }

function write()
{
  var self = this;

  debugger;
  var o = _.PrinterBase.prototype.write.apply( self,arguments );

  if( !o )
  return;

  _.assert( o );
  _.assert( _.arrayIs( o.output ) );
  _.assert( o.output.length === 1 );

  var terminal = o.output[ 0 ];
  if( self.usingTags && _.mapKeys( self.attributes ).length )
  {

    var text = terminal;
    terminal = Object.create( null );
    terminal.text = text;

    for( var t in self.attributes )
    {
      terminal[ t ] = self.attributes[ t ];
    }

  }

  self.fileProvider.fileWriteAct
  ({
    filePath :  self.outputPath,
    data : terminal + '\n',
    writeMode : 'append',
    sync : 1
  });

  return o;
}

//

function _transformEnd( o )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  // debugger

  o = Parent.prototype._transformEnd.call( self, o );

  if( !o )
  return;

  _.assert( _.arrayIs( o.outputForTerminal ) );
  _.assert( o.outputForTerminal.length === 1 );

  var terminal = o.outputForTerminal[ 0 ];
  if( self.usingTags && _.mapKeys( self.attributes ).length )
  {

    var text = terminal;
    terminal = Object.create( null );
    terminal.text = text;

    for( var t in self.attributes )
    {
      terminal[ t ] = self.attributes[ t ];
    }

  }

  self.fileProvider.fileWrite
  ({
    filePath : _.path.path.nativize( self.outputPath ),
    data : terminal + '\n',
    writeMode : 'append',
    sync : 1
  });

  return o;
}

//

// function _writeToFile()
// {
//   var self = this;
//   _.assert( arguments.length );
//   _.assert( _.strIs( self.outputPath ),'outputPath is not defined for PrinterToFile' );

//   var data = _.strConcat.apply( { },arguments ) + '\n';

//   self.fileProvider.fileWriteAct
//   ({
//     filePath :  self.outputPath,
//     data : data,
//     writeMode : 'append',
//     sync : 1
//   });

// }

// --
// relations
// --

var Composes =
{
  outputPath : 'output.log',
}

var Aggregates =
{
}

var Associates =
{
  fileProvider : null,
}

// --
// prototype
// --

var Proto =
{

  init : init,

  // __initChainingMixinWrite : __initChainingMixinWrite,

  write : write,

  _transformEnd : _transformEnd,
  // _writeToFile : _writeToFile,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_global_[ Self.name ] = _[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
