( function _TemplateFileWriter_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wCopyable' );
  _.include( 'wFiles' );
  _.include( 'wTemplateTreeResolver' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = function wTemplateFileWriter( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'TemplateFileWriter';

// --
// inter
// --

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.instanceInit( self );

  if( self.constructor === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( !self.fileProvider )
  self.fileProvider = _.fileProvider;

}

//

function form()
{
  let self = this;

  _.assert( arguments.length === 0 );

  if( !self.currentPath )
  self.currentPath = self.fileProvider.current();

  if( !self.basePath )
  self.basePath = '.';

  self.basePath = self.fileProvider.path.resolve( self.currentPath, self.basePath );

  // let mainDirPath = _.path.effectiveMainDir();

  if( self.template === null )
  {
    try
    {
      self.templateFilePath = self.fileProvider.path.resolve( self.currentPath, self.templateFilePath || './Template.s' );
      self.template = require( _.path.path.nativize( self.templateFilePath ) );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
    if( !self.template )
    throw _.errLogOnce( 'Cant read template', _.strQuote( self.templateFilePath ) );
  }

  let config = self.configGet();

  if( !self.resolver )
  self.resolver = _.TemplateTreeResolver();
  self.resolver.tree = config;

  self.templateResolved = self.resolver.resolve( self.template );
  self.templateProvider = new _.FileProvider.Extract({ filesTree : self.templateResolved });

  self.templateProvider.readToProvider
  ({
    dstProvider : _.fileProvider,
    dstPath : self.currentPath,
    basePath : self.basePath,
    allowDeleteForRelinking : 1,
  });

}

//

function exec()
{
  let self = new this.Self();
  self.form();
  return self;
}
//

function nameGet()
{
  let self = this;
  if( self.name !== null && self.name !== undefined )
  return self.name;
  return _.path.name( self.currentPath );
}

//

function configGet()
{
  let self = this;
  let result = self.onConfigGet();
  return result;
}

//

function onConfigGet()
{
  let self = this;

  let name = self.nameGet();
  let lowName = name.toLowerCase();
  let highName = name.toUpperCase();

  let result = { name : name, lowName : lowName, highName : highName, shortName : shortName, };
  return result;
}

// --
// relations
// --

let Composes =
{
  currentPath : null,
  basePath : null,
  templateFilePath : null,
  name : null,
}

let Associates =
{

  fileProvider : null,
  resolver : null,
  template : null,
  templateResolved : null,

  onConfigGet : null,

}

let Restricts =
{

  templateProvider : null,

}

let Statics =
{
  exec : exec,
}

// --
// declare
// --

let Proto =
{

  init : init,
  form : form,
  exec : exec,

  nameGet : nameGet,
  configGet : configGet,

  // relations

  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

// define

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

_[ Self.shortName ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' )
if( !module.parent )
Self.exec();

})();
