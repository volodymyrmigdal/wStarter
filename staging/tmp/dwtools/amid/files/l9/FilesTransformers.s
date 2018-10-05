(function _FileTransformers_s_() {

'use strict';

/**
  @module Tools/mid/files/FilesTransformers - Collection of files transformers for Files module. Use it to read configs in different formats.
*/

/**
 * @file files/FilesTransformers.s.
 */

if( typeof module === 'undefined' )
return;

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
  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wFiles' );

}
var _global = _global_;
var _ = _global_.wTools;
var encoders = _.FileProvider.Partial.prototype.fileRead.encoders;

/*
and writing encoders
*/

// --
//
// --

try
{
  var Coffee = require( 'coffee-script' );
}
catch( err )
{
}

if( Coffee )
encoders[ 'coffee' ] =
{

  exts : [ 'coffee' ],
  forInterpreter : 1,

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'coffee' );
    e.operation.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    _.assert( _.strIs( e.data ), '( fileRead.encoders.coffee.onEnd ) expects string' );
    e.data = Coffee.eval( e.data, { filename : e.operation.filePath } );
  },

}


//

try
{
  var Yaml = require( 'js-yaml' );
}
catch( err )
{
}

if( Yaml )
encoders[ 'yaml' ] =
{

  exts : [ 'yaml','yml' ],
  forInterpreter : 1,

  onBegin : function( e )
  {
    _.assert( e.operation.encoding === 'yaml' );
    e.operation.encoding = 'utf8';
  },

  onEnd : function( e )
  {
    debugger;
    _.assert( _.strIs( e.data ), '( fileRead.encoders.coffee.onEnd ) expects string' );
    e.data = Yaml.load( e.data,{ filename : e.operation.filePath } );
  },

}

// --
// export
// --

var Self = wTools.FileTransformers = encoders;

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
