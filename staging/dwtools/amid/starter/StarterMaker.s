( function _StarterMaker_s_() {

'use strict';

/**
  @module Tools/mid/Starter - Collection of tools to generate background service to start and pack application. Starter consists of 3 pieces, maker - generating code for run-time, client run-time piece, and server run-time piece. Use the module to keep files structure of the application and make code aware wherein the file system is it executed.
*/

/**
 * @file starter/StarterMaker.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
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

  _.include( 'wCopyable' );
  _.include( 'wVerbal' );
  _.include( 'wFiles' );
  _.include( 'wTemplateTreeEnvironment' );

}

//

let _ = wTools;
let Parent = null;
let Self = function wStarterMaker( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'StarterMaker';

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.instanceInit( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

}

//

function exec()
{

  _.assert( arguments.length === 0 );

  let o = {};
  let appArgs = _.appArgs();
  let self = new this.Self( o );

  return self;
}

//

function form()
{
  let self = this;
  let logger = self.logger;

  _.assert( arguments.length === 0 );
  _.assert( !self.formed );
  _.assert( !!self.hubFileProvider );

  self.formed = 1;

  if( self.inPath === null )
  self.inPath = self.outPath;
  if( self.outPath === null )
  self.outPath = self.inPath;

  // self.inPath = self.env.resolve( self.inPath );
  // self.outPath = self.env.resolve( self.outPath );
  // self.toolsPath = self.env.resolve( self.toolsPath );
  // self.initScriptPath = self.env.resolve( self.initScriptPath );

  if( !self.env )
  self.env = _.TemplateTreeEnvironment({ tree : self, path : _.uri });
  self.env.pathsNormalize();

  // /* !!! temp fix, should be replaced but fixing pathsNormalize */
  // self.toolsPath = _.strReplaceAll( self.toolsPath, '//', '/' );

  if( !self.hubFileProvider.providersWithProtocolMap.dst )
  self.hubFileProvider.providerRegister( new _.FileProvider.Extract({ protocol : 'dst'/*, encoding : 'utf8'*/ }) );

  _.assert( !!self.hubFileProvider );
  _.assert( !!self.hubFileProvider.providersWithProtocolMap.src );
  _.assert( !!self.hubFileProvider.providersWithProtocolMap.dst );

  _.assert( _.strIs( self.inPath ) );
  _.assert( _.strIs( self.outPath ) );
  _.assert( _.strIs( self.toolsPath ) );
  _.assert( _.strIs( self.initScriptPath ) );
  _.assert( _.strIs( self.starterDirPath ) );
  _.assert( _.strIs( self.starterScriptPath ) );
  _.assert( _.strIs( self.rootPath ) );
  _.assert( _.strIs( self.pathPrefix ) );

  logger.rbegin({ verbosity : -2 });
  logger.log( 'Starter.paths :' );
  logger.up();
  logger.log( 'inPath :', self.inPath );
  logger.log( 'outPath :', self.outPath );
  logger.log( 'rootPath :', self.rootPath );
  logger.log( 'initScriptPath :', self.initScriptPath );
  logger.log( 'starterDirPath :', self.starterDirPath );
  logger.log( 'starterScriptPath :', self.starterScriptPath );
  logger.log( 'starterConfigPath :', self.starterConfigPath );
  logger.log( 'toolsPath :', self.toolsPath );
  logger.log( 'pathPrefix :', self.pathPrefix );
  logger.down();
  logger.rend({ verbosity : -2 });

  return self;
}

//

function fileProviderForm()
{
  let self = this;

  _.assert( arguments.length === 0 );

  let srcFileProvider = new _.FileProvider.Extract({ protocol : 'src'  });
  let dstFileProvider = new _.FileProvider.Extract({ protocol : 'dst'  });
  let hdFileProvider = new _.FileProvider.HardDrive({});

  self.hubFileProvider = self.hubFileProvider || new _.FileProvider.Hub
  ({
    verbosity : 2,
    providers : [],
  });

  if( !self.hubFileProvider.providersWithProtocolMap.src )
  self.hubFileProvider.providerRegister( new _.FileProvider.Extract({ protocol : 'src'  }) );

  if( !self.hubFileProvider.providersWithProtocolMap.dst )
  self.hubFileProvider.providerRegister( new _.FileProvider.Extract({ protocol : 'dst'  }) );

  if( !self.hubFileProvider.providersWithProtocolMap.file )
  self.hubFileProvider.providerRegister( new _.FileProvider.HardDrive({}) );

  return self;
}

//

function fromHardDriveRead( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { srcPath : arguments[ 0 ] }

  // let protoPath = _.uri.join( 'file://', this.env.pathGet( '{{path.proto}}' ) );
  // let stagingPath = _.uri.join( 'file://', this.env.pathGet( '{{path.staging}}' ) );

  _.assert( arguments.length === 1 );
  _.routineOptions( fromHardDriveRead, o );

  self.hubFileProvider.verbosity = 1;

  let reflect = self.hubFileProvider.filesReflector
  ({
    srcFilter : { basePath : o.srcPath },
    dstFilter : { prefixPath : 'src:///' },
    filter :
    {
      ends : [ '.js', '.s', '.css', '.less', '.jslike' ],
      maskAll : _.files.regexpMakeSafe(),
      maskTransientAll : _.files.regexpMakeSafe()
    },
    linking : 'softlink',
    mandatory : 1,
  });

  let reflected = reflect( '.' );

}

fromHardDriveRead.defaults =
{
  srcPath : null,
}

//

function toHardDriveWrite( o )
{
  let self = this;

  if( _.strIs( arguments[ 0 ] ) )
  o = { dstPath : arguments[ 0 ] }

  _.assert( arguments.length === 1 );
  _.routineOptions( toHardDriveWrite, o );

  let reflect = self.hubFileProvider.filesReflector
  ({
    srcFilter : { basePath : _.uri.join( 'dst://', '/' ) },
    dstFilter : { prefixPath : _.uri.join( 'file://', o.dstPath ) },
    mandatory : 1,
  });

  let reflected = reflect( '.' );

}

toHardDriveWrite.defaults =
{
  dstPath : null,
}

//

function fixesFor( o )
{

  _.routineOptions( fixesFor, arguments );
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.filePath ) );

  if( o.pathPrefix )
  o.filePath = o.pathPrefix + o.filePath;
  if( o.pathPrefix && o.dirPath !== null )
  o.dirPath = o.pathPrefix + o.dirPath;

  // if( o.pathPrefix )
  // o.rootPath = o.pathPrefix + o.rootPath;

  var result = Object.create( null );
  var exts = _.path.exts( o.filePath );

  if( o.running === null )
  o.running = _.arrayHasAny( [ 'run' ], exts );

  if( o.dirPath === null )
  o.dirPath = _.path.dir( o.filePath );
  // var filePath = _.path.normalize( _.path.reroot( o.rootPath, o.filePath ) );
  var shortName = _.strVarNameFor( _.path.fullName( o.filePath ) );

  result.prefix = `/* */ /* > ${o.filePath} */ `
  result.prefix += `( function ${shortName}() { `; /**/
  result.prefix += `var _naked = function ${shortName}_naked() { `; /**/

  /* .. code .. */

  result.postfix = '/* */\n';
  result.postfix += `/* */ }\n`; /* end of _naked */

  result.postfix +=
`/* */
/* */  var _filePath_ = '${o.filePath}';
/* */  var _dirPath_ = '${o.dirPath}';
/* */  var __filename = _filePath_;
/* */  var __dirname = _dirPath_;
/* */  var _scriptFile_, module, include, require;
`

  result.postfix +=
`/* */
/* */  var _preload = function ${shortName}_preload()
/* */  {
/* */    if( typeof _starter_ === 'undefined' )
/* */    return;
/* */    _scriptFile_ = new _starter_.ScriptFile({ filePath : _filePath_, dirPath : _dirPath_ });
/* */    module = _scriptFile_;
/* */    include = _scriptFile_.include;
/* */    require = include;
/* */    _starter_.scriptRewrite( _filePath_, _dirPath_, _naked );
/* */    _starter_._scriptPreloadEnd( _filePath_ );
/* */  }
`

  if( o.running )
  result.postfix +=
`/* */
/* */  _naked();
`
  else
  result.postfix +=
`/* */
/* */  if( typeof _starterScriptsToPreload === 'undefined' )
/* */  _starterScriptsToPreload = Object.create( null )
/* */
/* */  if( typeof _starter_ !== 'undefined' )
/* */  {
/* */    _preload();
/* */  }
/* */  else
/* */  {
/* */    _starterScriptsToPreload[ __filename ] = _preload;
/* */    _naked();
/* */  }
`

  result.postfix += `/* */})();\n`; /* end of r */
  result.postfix += `/* */ /* < ${o.filePath} */`;

  return result;
}

fixesFor.defaults =
{
  pathPrefix : '',
  filePath : null,
  dirPath : null,
  running : null,
}

//

function filesMapMake()
{
  let self = this;
  let logger = self.logger;
  let hubFileProvider = self.hubFileProvider;
  let srcFileProvider = hubFileProvider.providersWithProtocolMap.src;
  // let dstFileProvider = hubFileProvider.providersWithProtocolMap.dst;

  _.assert( _.strIs( self.appName ) );
  _.assert( arguments.length === 0 );

  logger.rbegin({ verbosity : -2 });
  logger.log( 'Making files map..' );
  logger.rend({ verbosity : -2 });

  let fmap = new _.FileProvider.Extract({ protocol : 'fmap' });
  hubFileProvider.providerRegister( fmap );

  /* */

  debugger;
  if( self.useFile === null && self.useFilePath )
  self.useFile = self.hubFileProvider.fileRead
  ({
    filePath : self.useFilePath,
    encoding : 'js.smart',
    sync : 1,
    resolvingSoftLink : 1,
  });
  debugger;
  self.useFile = self.useFile || Object.create( null );
  self.useFile.reflectMap = self.useFile.reflectMap || '**';

  /* */

  // debugger;
  let reflect = self.hubFileProvider.filesReflector
  ({
    // reflectMap : self.useFile || '**',
    dstFilter :
    {
      prefixPath : _.uri.join( self.inPath, 'fmap://' ),
    },
    srcFilter :
    {
      basePath : _.uri.join(  self.inPath, 'src://', ),
    },
    linking : 'fileCopy',
    resolvingSrcSoftLink : 0,
    recursive : 1,
  });
  // debugger;

  debugger;
  let found = reflect( self.useFile );
  debugger;

  if( self.offline )
  {

    let found = self.hubFileProvider.filesFind
    ({
      filePath : 'fmap:///',
      recursive : 1,
      includingTerminals : 1,
      includingTransient : 0,
      resolvingSoftLink : 0,
      onUp : onUp,
    });

    _.sure( !!found.length, 'none script found' );

  }

  // debugger;
  hubFileProvider.fileWriteJs
  ({
    filePath : _.uri.join( 'dst://', self.outPath, self.appName + '.raw.filesmap.s' ),
    prefix : 'FilesMap = \n',
    data : fmap.filesTree,
  });
  // debugger;

  // hubFileProvider.providerUnregister( fmap );
  fmap.finit();
  _.assert( hubFileProvider.providersWithProtocolMap.fmap === undefined );

  /* */

  function onUp( file, op )
  {
    let resolvedPath = hubFileProvider.pathResolveLink( file.absoluteUri );
    let prefixToRemove = /^#\!\s*\/.+/;

    if( self.offline && _.arrayHas( [ 's','js','ss' ], file.ext ) )
    {

      let fixes = self.fixesFor
      ({
        filePath : file.absolute,
      });

      let data = hubFileProvider.fileRead( resolvedPath );
      data = _.strRemoveBegin( data,prefixToRemove );
      data = fixes.prefix + data + fixes.postfix;
      fmap._descriptorWrite( file.absolute, fmap._descriptorScriptMake( file.absolute, data ) );
    }
    else if( file.isSoftLink )
    {
      fmap.linkSoft
      ({
        srcPath : file.absolute,
        dstPath : file.absolute,
        allowMissing : 1,
      });
    }

    return file;
  }

}

//

function starterMake()
{
  let self = this;
  let requireCode = '';
  let builtinMapCode = '';
  let logger = self.logger;
  let hubFileProvider = self.hubFileProvider;
  let srcFileProvider = hubFileProvider.providersWithProtocolMap.src;
  let dstFileProvider = hubFileProvider.providersWithProtocolMap.dst;

  logger.rbegin({ verbosity : -2 });
  logger.log( 'Making starter..' );
  logger.rend({ verbosity : -2 });

  _.assert( arguments.length === 0 );

  let find = self.hubFileProvider.filesFinder
  ({
    filePath : _.uri.join( 'src://', self.toolsPath ),
    recursive : 1,
    includingTerminals : 1,
    includingTransient : 0,
    mandatory : 1,
    onUp : onUpInliningToStarter,
    filter :
    {
      ends : [ '.js','.s' ],
    }
  });

  find( 'abase/l1' );
  find( 'abase/l2' );
  find( 'l3' );
  find( 'abase/l4' );
  find( 'abase/l5' );
  find( 'abase/l7' );
  find( 'abase/l9/consequence' );
  find( 'abase/l9/printer' );

  find( 'amid/amapping/TemplateTreeAresolver.s' );
  find( 'amid/amixin/Verbal.s' );
  find( 'amid/bclass/RegexpObject.s' );

  find( 'amid/files/UseBase.s' );
  find( 'amid/files/l1' );
  find( 'amid/files/l2' );
  find( 'amid/files/l3' );
  find( 'amid/files/l5_provider/Extract.s' );
  find( 'amid/files/l5_provider/HtmlDocument.js' );
  find( 'amid/files/l5_provider/Http.js' );
  find( 'amid/files/l7/Hub.s' );

  _.sure( _.strIs( builtinMapCode ), 'None source script' );

  starterWrite();
  configWrite();
  starterPreloadWrite();
  starterStartWrite();

  /* - */

  function starterWrite()
  {
    let begin = _.fileProvider.fileRead( _.path.join( __dirname, './StarterInitBegin.raw.s' ) );
    let end = _.fileProvider.fileRead( _.path.join( __dirname, './StarterInitEnd.raw.s' ) );

    let fixes = self.fixesFor
    ({
      filePath : self.starterScriptPath,
      dirPath : self.rootPath,
      running : 1,
    });

    let code = fixes.prefix + begin + builtinMapCode + /*settingsCode +*/ requireCode + end + fixes.postfix;
    code = '(function _StarterInit_s_(){\n' + code + '\n})();';
    dstFileProvider.fileWrite( self.starterScriptPath, code );
  }

  /* - */

  function configWrite()
  {

    let begin = _.fileProvider.fileRead( _.path.join( __dirname, './StarterConfigBegin.raw.s' ) );
    let settingsCode =
`
_realGlobal._starter_.pathPrefix = '${self.pathPrefix}';
_realGlobal._starter_.initScriptPath = '${self.initScriptPath}';
_realGlobal._starter_.starterDirPath = '${self.starterDirPath}';
Config.offline = ${_.toStr( !!self.offline )};
`;

    let code = begin + settingsCode;
    dstFileProvider.fileWrite( self.starterConfigPath, code );

  }

  /* - */

  function starterPreloadWrite()
  {
    let code = _.fileProvider.fileRead( _.path.join( __dirname, 'StarterPreloadEnd.raw.s' ) );
    dstFileProvider.fileWrite( _.path.join( self.outPath, 'StarterPreloadEnd.run.s' ), code );
    srcFileProvider.fileWrite( _.path.join( self.outPath, 'StarterPreloadEnd.run.s' ), code );
  }

  /* - */

  function starterStartWrite()
  {
    let code = _.fileProvider.fileRead( _.path.join( __dirname, './StarterStart.raw.s' ) );
    dstFileProvider.fileWrite( _.path.join( self.outPath, 'StarterStart.run.s' ), code );
  }

  /* - */

  function onUpInliningToStarter( file )
  {
    _.assert( file.isActual );

    if( self.verbosity >= 3 )
    logger.log( ' +', 'starter use', file.absolute );

    let read = this.fileCodeRead( file.hubAbsolute );

    builtinMapCode += read;

    return file;
  }

  /* */

  // function onUpInliningToFilesMap( file )
  // {
  //   _.assert( file.isActual );
  //
  //   debugger;
  //   _.assert( 0 );
  //
  //   if( self.verbosity >= 3 )
  //   logger.log( ' +', 'starter use', file.absolute );
  //
  //   let filePath = `['` + file.absolute.split( '/' ).filter( ( e ) => e ? true : false ).join( `']['` ) + `']`;
  //   let line = `_starter_._requireStarting( _starter_.module, '${file.absolute}' );\n`;
  //
  //   requireCode += line;
  //
  //   let fileCode = `FilesMap${filePath}[ 0 ].code`;
  //   let line = `_starter_.modulesBuiltinMap[ '${file.absolute}' ] = { code : ${fileCode}, filePath : '${file.absolute}', dirPath : '${file.dir}', },\n`;
  //
  //   builtinMapCode += line;
  //
  //   return file;
  // }

}

//

function _verbosityChange()
{
  let self = this;

  if( self.hubFileProvider )
  {
    let hubFileProvider = self.hubFileProvider;
    let srcFileProvider = hubFileProvider.providersWithProtocolMap.src;
    let dstFileProvider = hubFileProvider.providersWithProtocolMap.dst;
    hubFileProvider.verbosity = self._verbosityForFileProvider();
    srcFileProvider.verbosity = self._verbosityForFileProvider();
    dstFileProvider.verbosity = self._verbosityForFileProvider();
  }

  if( self.logger )
  {
    self.logger.verbosity = self._verbosityForLogger();
    self.logger.outputGray = self.coloring ? 0 : 1;
  }

}

// --
// relations
// --

let Composes =
{

  inPath : null,
  outPath : null,
  appName : null,
  useFilePath : null,
  toolsPath : '{{inPath}}/dwtools',
  initScriptPath : '{{outPath}}/index.s',
  starterDirPath : '{{outPath}}',
  starterScriptPath : '{{starterDirPath}}/StarterInit.run.s',
  starterConfigPath : '{{starterDirPath}}/{{appName}}.raw.starter.config.s',
  rootPath : '/',
  pathPrefix : '',

  offline : 0,
  verbosity : 2,

}

let Aggregates =
{

  useFile : null,

}

let Associates =
{

  hubFileProvider : null,
  logger : _.define.own( new _.Logger({ output : console }) ),

}

let Restricts =
{
  formed : 0,
  env : null,
}

let Medials =
{
}

let Statics =
{
  exec : exec,
  fixesFor : fixesFor,
}

let Events =
{
}

let Forbids =
{
  inliningScriptsToFilesMap : 'inliningScriptsToFilesMap',
  srcFileProvider : 'srcFileProvider',
  dstFileProvider : 'dstFileProvider',
}

// --
// declare
// --

let Proto =
{

  init : init,
  exec : exec,
  form : form,

  fileProviderForm : fileProviderForm,
  fromHardDriveRead : fromHardDriveRead,
  toHardDriveWrite : toHardDriveWrite,

  fixesFor : fixesFor,
  filesMapMake : filesMapMake,
  starterMake : starterMake,

  _verbosityChange : _verbosityChange,

  // relations

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Medials : Medials,
  Statics : Statics,
  Events : Events,
  Forbids : Forbids,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );

//

_global_[ Self.name ] = wTools[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

if( typeof module !== 'undefined' && !module.parent )
Self.exec();

})();
