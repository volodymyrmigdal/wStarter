( function _StarterMaker_s_()
{

'use strict';

// debugger;
// console.log( typeof exports ); /* xxx qqq : write test routine for exports. ask how */
// debugger;

//

let Jsdom, Pretty;
let _ = _global_.wTools;
let Parent = null
let Self = wStarterMakerLight;
function wStarterMakerLight( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Maker';

// --
// relations
// --

let LibrarySplits =
{
  prefix : '',
  predefined : '',
  early : '',
  extract : '',
  proceduring : '',
  globing : '',
  interpreter : '',
  starter : '',
  env : '',
  files : '',
  externalBefore : '',
  entry : '',
  externalAfter : '',
  postfix : '',
}

// --
// routines
// --

function instanceOptions( o )
{
  let maker = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o )
  for( let k in o )
  {
    if( o[ k ] === null && maker.InstanceDefaults[ k ] !== undefined )
    o[ k ] = maker[ k ];
  }
  else
  for( let k in maker.InstanceDefaults )
  {
    if( maker[ k ] === null && maker.InstanceDefaults[ k ] !== undefined )
    maker[ k ] = maker.InstanceDefaults[ k ];
  }

  return o;
}

// --
// file
// --

function sourceWrapSplits( o )
{
  let maker = this;

  _.routineOptions( sourceWrapSplits, arguments );
  _.assert( arguments.length === 1 );
  _.assert( _.longHas( [ 'njs', 'browser' ], o.interpreter ) );

  let relativeFilePath = _.starter.pathRealToVirtual
  ({
    realPath : o.filePath,
    basePath : o.basePath,
    realToVirtualMap : o.realToVirtualMap,
    verbosity : o.loggingPathTranslations,
  });

  _.assert( !_.path.isDotted( relativeFilePath ) || relativeFilePath === '.', `Path ${o.filePath} is beyond base path` );

  relativeFilePath = _.path.dot( relativeFilePath );
  let relativeDirPath = _.path.dir( relativeFilePath );
  relativeDirPath = _.path.dot( relativeDirPath );

  let fileName = _.strVarNameFor( _.path.fullName( o.filePath ) );
  let fileNameNaked = fileName + '_naked';

  let prefix1 = `/* */  /* begin of file ${fileName} */ ( function ${fileName}() { `;
  let prefix2 = `function ${fileNameNaked}() { `;

  let postfix2 = `\n/* */    };`;

  let ware = '\n';

  if( o.interpreter === 'browser' )
  ware +=
`/* */  if( typeof _starter_ === 'undefined' && typeof importScripts !== 'undefined' ) /* qqq xxx : ? */
/* */  importScripts( '/.starter' );
/* */  let _filePath_ = _starter_._pathResolveLocal( null, '/', '${relativeFilePath}' );
/* */  let _dirPath_ = _starter_._pathResolveLocal( null, '/', '${relativeDirPath}' );`
  else
  ware +=
`/* */  let _filePath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, '${relativeFilePath}' );
/* */  let _dirPath_ = _starter_._pathResolveLocal( null, _libraryFilePath_, '${relativeDirPath}' );`

  ware +=
`
/* */  let __filename = _filePath_;
/* */  let __dirname = _dirPath_;
/* */  let module = _starter_._sourceMake( _filePath_, _dirPath_, ${fileNameNaked} );
/* */  let exports = module.exports;
/* */  let require = module.include;
/* */  let include = module.include;
`

  if( o.running )
  ware += `/* */  _starter_._sourceIncludeResolvedCalling( null, module, module.filePath );`;

  let postfix1 =
`
/* */  /* end of file ${fileName} */ })();
`

  let result = Object.create( null );
  result.prefix1 = prefix1;
  result.prefix2 = prefix2;
  result.ware = ware;
  result.postfix2 = postfix2;
  result.postfix1 = postfix1;
  return result;
}

sourceWrapSplits.defaults =
{
  filePath : null,
  basePath : null,
  running : 0,
  interpreter : 'njs',
  realToVirtualMap : null,
  loggingPathTranslations : null,
}

//

function sourceWrap( o )
{
  let maker = this;
  _.assert( arguments.length === 1 );
  _.routineOptions( sourceWrap, arguments );
  maker.instanceOptions( o );

  if( o.removingShellPrologue )
  o.fileData = maker.sourceRemoveShellPrologue( o.fileData );

  let splits = maker.sourceWrapSplits({ filePath : o.filePath, basePath : o.basePath });
  let result = splits.prefix1 + splits.prefix2 + o.fileData + splits.postfix2 + splits.ware + splits.postfix1;
  return result;
}

var defaults = sourceWrap.defaults = Object.create( sourceWrapSplits.defaults );
defaults.fileData = null;
defaults.removingShellPrologue = null;

//

function sourceWrapSimple( o )
{
  let maker = this;
  _.assert( arguments.length === 1 );
  _.routineOptions( sourceWrapSimple, arguments );
  maker.instanceOptions( o );

  if( o.removingShellPrologue )
  o.fileData = maker.sourceRemoveShellPrologue( o.fileData );

  let fileName = _.strCamelize( _.path.fullName( o.filePath ) );

  let prefix = `( function ${fileName}() { // == begin of file ${fileName}\n`;

  let postfix =
`// == end of file ${fileName}
})();
`

  let result = prefix + o.fileData + postfix;

  return result;
}

sourceWrapSimple.defaults =
{
  filePath : null,
  fileData : null,
  removingShellPrologue : null,
}

//

/*
qqq : investigate and add test case for such case
  if( fileData.charCodeAt( 0 ) === 0xFEFF )
  fileData = fileData.slice(1);
*/

function sourceRemoveShellPrologue( fileData )
{
  let maker = this;
  let splits = _.strSplitFast( fileData, /^\s*\#\![^\n]*\n/ );
  _.assert( arguments.length === 1 );
  if( splits.length > 1 )
  return '// ' + splits[ 1 ] + splits[ 2 ];
  else
  return fileData;
}

// --
// files
// --

function sourcesJoinSplits( o )
{
  let maker = this;
  let r = _.mapExtend( null, maker.LibrarySplits );
  Object.preventExtensions( r );

  o = _.routineOptions( sourcesJoinSplits, arguments );
  _.assert( _.longHas( [ 'njs', 'browser' ], o.interpreter ) );
  _.assert( _.boolLike( o.debug ) );
  _.assert( _.boolLike( o.proceduring ) );
  _.assert( _.boolLike( o.globing ) );
  _.assert( _.boolLike( o.catchingUncaughtErrors ) );
  _.assert( _.boolLike( o.withServer ) );
  _.assert( _.boolLike( o.loggingApplication ) );
  _.assert( _.boolLike( o.loggingSourceFiles ) );

  if( o.entryPath )
  {
    _.assert( _.strIs( o.basePath ) );
    _.assert( _.strIs( o.entryPath ) || _.arrayIs( o.entryPath ) )
    o.entryPath = _.arrayAs( o.entryPath );
    o.entryPath = _.path.s.join( o.basePath, o.entryPath );
  }

  if( o.libraryName === null )
  o.libraryName = _.strVarNameFor( _.path.fullName( o.outPath ) );

  /* prefix */

  r.prefix =
`
/* */  /* begin of library ${o.libraryName} */ ( function _library_() {
`

  /* predefined */

  debugger

  r.predefined =
`
/* */  /* begin of predefined */ ( function _predefined_() {

  ${_.routineParse( maker.PredefinedCode.begin ).bodyUnwrapped};

/* */  _global_._starter_.debug = ${o.debug};
/* */  _global_._starter_.interpreter = '${o.interpreter}';
/* */  _global_._starter_.proceduring = ${o.proceduring};
/* */  _global_._starter_.globing = ${o.globing};
/* */  _global_._starter_.catchingUncaughtErrors = ${o.catchingUncaughtErrors};
/* */  _global_._starter_.loggingApplication = ${o.loggingApplication};
/* */  _global_._starter_.loggingSourceFiles = ${o.loggingSourceFiles};
/* */  _global_._starter_.withServer = ${o.withServer};
/* */  _global_._starter_.redirectingConsole = ${o.redirectingConsole};
/* */  _global_._starter_.loggingPath = '${o.loggingPath}';

/* */  _global_.Config.debug = ${o.debug};

  ${_.routineParse( maker.PredefinedCode.end ).bodyUnwrapped};

/* */  /* end of predefined */ })();

`

  /* early */

  r.early =
`
/* */  /* begin of early */ ( function _early_() {

  ${_.routineParse( maker.EarlyCode.begin ).bodyUnwrapped};
  ${_.routineParse( maker.EarlyCode.end ).bodyUnwrapped};

/* */  /* end of early */ })();

  `

  /* extract */

  r.extract =
`
/* */  /* begin of extract */ ( function _extract_() {

  ${_.routineParse( maker.ExtractCode.begin ).bodyUnwrapped};

  ${extract()}

  ${_.routineParse( maker.ExtractCode.end ).bodyUnwrapped};

/* */  /* end of extract */ })();

`

  /* proceduring */

  if( o.proceduring )
  r.proceduring =
`
/* */  /* begin of proceduring */ ( function _proceduring_() {

  ${_.routineParse( maker.ProceduringCode.begin ).bodyUnwrapped};

  ${_.routineParse( maker.ProceduringCode.end ).bodyUnwrapped};

/* */  /* end of proceduring */ })();

`

  /* globing */

  if( !o.withServer )
  if( o.globing )
  r.globing =
`
/* */  /* begin of globing */ ( function _proceduring_() {

  ${_.routineParse( maker.GlobingCode.begin ).bodyUnwrapped};

  ${globingExtract()}

  ${_.routineParse( maker.GlobingCode.end ).bodyUnwrapped};

/* */  /* end of globing */ })();

`

  /* bro */

  if( o.interpreter === 'browser' )
  r.interpreter =
`
/* */  /* begin of bro */ ( function _bro_() {

  ${_.routineParse( maker.BroCode.begin ).bodyUnwrapped};
  ${_.routineParse( maker.BroCode.end ).bodyUnwrapped};

/* */  /* end of bro */ })();

`

  if( o.interpreter === 'browser' )
  if( o.redirectingConsole )
  r.interpreter +=
`
/* */  /* begin of broConsole */ ( function _broConsole_() {

  ${_.routineParse( maker.BroConsoleCode.begin ).bodyUnwrapped};
  ${_.routineParse( maker.BroConsoleCode.end ).bodyUnwrapped};

/* */  /* end of broConsole */ })();

`

  if( o.interpreter === 'browser' )
  r.interpreter +=
`
/* */  /* begin of broProcess */ ( function _broProcess_() {

  ${_.routineParse( maker.BroProcessCode.begin ).bodyUnwrapped};
  ${_.routineParse( maker.BroProcessCode.end ).bodyUnwrapped};

/* */  /* end of broProcess */ })();

`


  /* njs */

  if( o.interpreter === 'njs' )
  r.interpreter =
`
/* */  /* begin of njs */ ( function _njs_() {

  ${_.routineParse( maker.NjsCode.begin ).bodyUnwrapped};
  ${_.routineParse( maker.NjsCode.end ).bodyUnwrapped};

/* */  /* end of njs */ })();

`

  /* starter */

  r.starter =
`
/* */  /* begin of starter */ ( function _starter_() {

  ${_.routineParse( maker.StarterCode.begin ).bodyUnwrapped};
  ${_.routineParse( maker.StarterCode.end ).bodyUnwrapped};

/* */  /* end of starter */ })();

`

  /* env */

  r.env = ``;

  if( o.interpreter !== 'browser' )
  r.env +=
`
/* */  let _libraryFilePath_ = _starter_.path.canonizeTolerant( __filename );
/* */  let _libraryDirPath_ = _starter_.path.canonizeTolerant( __dirname );

`

  if( o.interpreter === 'browser' )
  r.env +=
`
/* */  if( !_global_._libraryFilePath_ )
/* */  _global_._libraryFilePath_ = '/';
/* */  if( !_global_._libraryDirPath_ )
/* */  _global_._libraryDirPath_ = '/';
`

  /* code */

  /* ... code goes here ... */

  /* external */

  if( o.externalBeforePath || o.externalAfterPath )
  _.assert( _.strDefined( o.outPath ), 'Expects option::outPath if option::externalBeforePath or option::externalAfterPath defined' );

  r.externalBefore = '\n';
  if( o.externalBeforePath )
  o.externalBeforePath.forEach( ( externalPath ) =>
  {
    if( _.path.isAbsolute( externalPath ) )
    externalPath = _.path.dot( _.path.relative( _.path.dir( o.outPath ), externalPath ) );
    r.externalBefore += `/* */  _starter_._sourceInclude( null, _libraryDirPath_, '${externalPath}' );\n`;
  });

  r.externalAfter = '\n';
  if( o.externalAfterPath )
  o.externalAfterPath.forEach( ( externalPath ) =>
  {
    if( _.path.isAbsolute( externalPath ) )
    externalPath = _.path.dot( _.path.relative( _.path.dir( o.outPath ), externalPath ) );
    r.externalAfter += `/* */  _starter_._sourceInclude( null, _libraryDirPath_, '${externalPath}' );\n`;
  });

  /* entry */

  r.entry = '\n';
  if( o.entryPath )
  o.entryPath.forEach( ( entryPath ) =>
  {
    entryPath = _.path.relative( o.basePath, entryPath );
    if( o.interpreter === 'njs' )
    r.entry += `/* */  module.exports = _starter_._sourceInclude( null, _libraryFilePath_, './${entryPath}' );\n`;
    else
    r.entry += `/* */  _starter_._sourceInclude( null, _libraryFilePath_, './${entryPath}' );\n`;
  });

  /* postfix */

  r.postfix =
`
/* */  /* end of library ${o.libraryName} */ })()
`

  /* */

  return r;

  /* */

  function extract()
  {

    return `
  ${rou( 'strQuote' )}
  ${rou( 'errInStr' )}
  ${rou( 'errFromStr' )}
  ${rou( 'errOriginalMessage' )}
  ${rou( 'errOriginalStack' )}
  ${rou( 'err' )}
  ${rou( '_err' )}
  ${rou( '_errMake' )}
  ${rou( 'errLogged' )}
  ${rou( 'errAttend' )}
  ${rou( '_errFields' )}
  ${rou( 'errIsStandard' )}
  ${rou( 'errIsAttended' )}
  ${rou( 'errProcess' )}
  ${rou( 'assert' )}
  ${fields( 'error' )}

  ${rou( 'introspector', 'code' )}
  ${rou( 'introspector', 'stack' )}
  ${rou( 'introspector', 'stackCondense' )}
  ${rou( 'introspector', 'location' )}
  ${rou( 'introspector', 'locationFromStackFrame' )}
  ${rou( 'introspector', 'locationToStack' )}
  ${rou( 'introspector', 'locationNormalize' )}

  ${rou( 'path', 'refine' )}
  ${rou( 'path', '_normalize' )}
  ${rou( 'path', 'normalize' )}
  ${rou( 'path', 'canonize' )}
  ${rou( 'path', 'canonizeTolerant' )}
  ${rou( 'path', '_unescape' )}
  ${rou( 'path', 'unescape' )}
  ${rou( 'path', '_nativizeWindows' )}
  ${rou( 'path', '_nativizeMinimalWindows' )}
  ${rou( 'path', '_nativizePosix' )}
  ${rou( 'path', 'isGlob' )}
  ${rou( 'path', 'isRelative' )}
  ${rou( 'path', 'isAbsolute' )}
  ${rou( 'path', 'ext' )}
  ${rou( 'path', 'isGlobal' )}
  ${fields( 'path' )}

  ${rou( 'strIs' )}
  ${rou( 'strDefined' )}
  ${rou( '_strBeginOf' )}
  ${rou( '_strEndOf' )}
  ${rou( '_strRemovedBegin' )}
  ${rou( '_strRemovedEnd' )}
  ${rou( 'strBegins' )}
  ${rou( 'strEnds' )}
  ${rou( 'strRemoveBegin' )}
  ${rou( 'strRemoveEnd' )}
  ${rou( 'regexpIs' )}
  ${rou( 'longIs' )}
  ${rou( 'primitiveIs' )}
  ${rou( 'symbolIs' )}
  ${rou( 'strBegins' )}
  ${rou( 'objectIs' )}
  ${rou( 'objectLike' )}
  ${rou( 'arrayLike' )}
  ${rou( 'hasMethodIterator' )}
  ${rou( 'mapLike' )}
  ${rou( 'strsLikeAll' )}
  ${rou( 'boolLike' )}
  ${rou( 'boolLikeTrue' )}
  ${rou( 'arrayIs' )}
  ${rou( 'numberIsFinite' )}
  ${rou( 'numberIs' )}
  ${rou( 'intIs' )}
  ${rou( 'setIs' )}
  ${rou( 'setLike' )}
  ${rou( 'hashMapIs' )}
  ${rou( 'hashMapLike' )}
  ${rou( 'argumentsArrayIs' )}
  ${rou( 'routineIs' )}
  ${rou( 'routineIsTrivial' )}
  ${rou( 'lengthOf' )}
  ${rou( 'mapIs' )}
  ${rou( 'sure' )}
  ${rou( 'mapBut' )}
  ${rou( 'mapOwn' )}
  ${rou( '_mapKeys' )}
  ${rou( 'mapOnlyOwnKeys' )}
  ${rou( 'sureMapHasOnly' )}
  ${rou( 'sureMapHasNoUndefine' )}
  ${rou( 'mapSupplementStructureless' )}
  ${rou( 'assertMapHasOnly' )}
  ${rou( 'assertMapHasNoUndefine' )}
  ${rou( 'routineOptions' )}
  ${rou( 'mapExtend' )}
  ${rou( 'mapSupplement' )}
  ${rou( 'routineExtend' )}
  ${rou( 'arrayAppend' )}
  ${rou( 'arrayAppendArray' )}
  ${rou( 'arrayAppendArrays' )}
  ${rou( 'arrayAppendedArray' )}
  ${rou( 'arrayAppendedArrays' )}
  ${rou( 'arrayAppended' )}
  ${rou( 'arrayAppendOnceStrictly' )}
  ${rou( 'arrayAppendArrayOnce' )}
  ${rou( 'arrayAppendedArrayOnce' )}
  ${rou( 'arrayAppendedOnce' )}
  ${rou( 'arrayRemoveOnceStrictly' )}
  ${rou( 'arrayRemoveElementOnceStrictly' )}
  ${rou( 'arrayRemovedElement' )}
  ${rou( 'arrayRemovedElementOnce' )}
  ${rou( 'arrayIsEmpty' )}
  ${rou( 'longLike' )}
  ${rou( 'longLeft' )}
  ${rou( 'longLeftIndex' )}
  ${rou( 'longLeftDefined' )}
  ${rou( 'longHas' )}
  ${rou( 'routineUnite' )}
  ${rou( 'arrayAs' )}
  ${rou( 'errIs' )}
  ${rou( 'unrollIs' )}
  ${rou( 'strType' )}
  ${rou( 'strConcat' )}
  ${rou( 'strPrimitiveType' )}
  ${rou( 'strHas' )}
  ${rou( 'strLike' )}
  ${rou( 'intervalIs' )}
  ${rou( 'numberDefined' )}
  ${rou( 'numbersAreAll' )}
  ${rou( 'bufferTypedIs' )}
  ${rou( 'bufferNodeIs' )}
  ${rou( 'strLinesStrip' )}
  ${rou( 'strLinesNumber' )}
  ${rou( 'strLinesSplit' )}
  ${rou( 'strLinesJoin' )}
  ${rou( 'strSplitFast' )}
  ${rou( 'strStrip' )}
  ${rou( 'strLinesSelect' )}
  ${rou( '_strLeftSingle_' )}
  ${rou( '_strRightSingle_' )}
  ${rou( 'strIsolate' )}
  ${rou( 'strIsolateLeftOrNone' )}
  ${rou( 'strIsolateRightOrNone' )}
  ${rou( 'strIsolateLeftOrAll' )}
  ${rou( 'strIsolateRightOrAll' )}
  ${rou( 'strLinesIndentation' )}
  ${rou( 'numberFromStrMaybe' )}
  ${field( 'TranslatedType' )}

  ${rou( 'error', '_setupUncaughtErrorHandler2' )}
  ${rou( 'error', '_setupUncaughtErrorHandler9' )}
  ${rou( 'error', '_handleUncaughtHead' )}
  ${rou( 'error', '_handleUncaught1' )}
  ${rou( 'error', '_handleUncaughtPromise1' )}
  ${rou( 'error', '_handleUncaught2' )}

  ${rou( 'event', '_chainGenerate' )}
  ${rou( 'event', '_chainToCallback' )}
  ${rou( 'event', '_chainValidate' )}
  ${rou( 'event', '_callbackMapValidate' )}
  ${rou( 'event', 'nameValueFrom' )}
  ${rou( 'event', 'nameIs' )}
  ${rou( 'event', 'chainIs' )}
  ${rou( 'event', 'Name' )}
  ${rou( 'event', 'Chain' )}
  ${rou( 'event', 'on' )}
  ${rou( 'event', 'once' )}
  ${rou( 'event', 'off' )}
  ${rou( 'event', 'off_functor' )}
  ${rou( 'event', 'eventHasHandler' )}
  ${rou( 'event', 'eventGive' )}
  ${fields( 'event' )}

  ${rou( 'each' )}


  /*
  Uri namespace( parseConsecutive ) is required to make _.include working in a browser
  */

  // parseFull maybe?

  ${rou( 'uri', 'parseConsecutive' )}
  ${rou( 'uri', 'refine' )}
  ${rou( 'uri', '_normalize' )}
  ${rou( 'uri', 'canonize' )}
  ${rou( 'uri', 'canonizeTolerant' )}
  ${fields( 'uri' )}

  ${rou( 'property', '_ofAct' )}
  ${rou( 'property', 'fields' )}

  ${rou( 'color', 'strFg' )}
  ${rou( 'color', 'strBg' )}
  ${rou( 'color', 'rgbaHtmlFrom' )}
  ${rou( 'color', 'rgbaHtmlFromTry' )}
  ${rou( 'color', 'rgbaHtmlToRgba' )}
  ${rou( 'color', 'hslaToRgba' )}
  ${rou( 'color', '_colorDistance' )}
  ${rou( 'color', '_rgbByBitmask' )}
  ${rou( 'color', '_rgbaFromNotName' )}
  ${rou( 'color', '_colorNameNearest' )}
  ${rou( 'color', 'colorNameNearest' )}
  ${rou( 'color', '_fromTable' )}
  ${rou( 'color', 'fromTable' )}
  ${rou( 'color', 'hexToColor' )}
  ${fields( 'color' )}
  ${field( 'color', 'ColorMap' )}

  ${rou( 'Logger', 'TransformCssStylingToDirectives' )}

`

  }

  /* */

  function globingExtract()
  {

    return `

  ${rou( 'mapExtend' )}
  ${rou( 'mapSupplement' )}
  ${rou( 'vectorize' )}
  ${rou( 'strsAreAll' )}
  ${rou( 'strReplaceAll' )}
  ${rou( 'strFindAll' )}
  ${rou( 'strReverse' )}
  ${rou( 'strCount' )}
  ${rou( 'strLeft_' )}
  ${rou( 'tokensSyntaxFrom' )}
  ${rou( '_strReplaceMapPrepare' )}
  ${rou( 'assertMapHasAll' )}
  ${rou( 'sureMapHasAll' )}
  ${rou( 'longSlice' )}
  ${rou( 'arrayLikeResizable' )}
  ${rou( 'regexpEscape' )}
  ${rou( 'filter_' )}
  ${rou( '_filter_functor' )}
  ${rou( 'entityMakeUndefined' )}
  ${rou( 'mapKeys' )}

  ${rou( 'path', 'globShortFilterKeys' )}
  ${rou( 'path', 'globShortSplitsToRegexps' )}
  ${rou( 'path', '_globShortSplitToRegexpSource' )}

`

  }

  /* */

  function rou()
  {
    return _.introspector.rou( ... arguments );
  }

  /* */

  function fields()
  {
    return _.introspector.fields( ... arguments );
  }

  /* */

  function field()
  {
    return _.introspector.field( ... arguments );
  }

  /* */

}

sourcesJoinSplits.defaults =
{
  basePath : null,
  entryPath : null,
  outPath : null,
  libraryName : null,
  externalBeforePath : null,
  externalAfterPath : null,
  interpreter : 'njs',
  debug : 1,
  proceduring : 0,
  globing : 1,
  catchingUncaughtErrors : 1,
  loggingApplication : 0,
  loggingSourceFiles : 0,
  withServer : null,
  redirectingConsole : 1,
  loggingPath : 'ws://127.0.0.1:15000/.log/'
}

//

function sourcesJoin( o )
{
  let maker = this;

  _.routineOptions( sourcesJoin, arguments );
  maker.instanceOptions( o );

  /* */

  o.filesMap = _.map_( null, o.filesMap, ( fileData, filePath ) =>
  {
    return maker.sourceWrap
    ({
      filePath,
      fileData,
      basePath : o.basePath,
      removingShellPrologue : o.removingShellPrologue,
    });
  });

  /* */

  let result = _.mapVals( o.filesMap ).join( '\n' );

  let o2 = _.mapOnly( o, maker.sourcesJoinSplits.defaults );
  let splits = maker.sourcesJoinSplits( o2 );

  splits.files = result;

  result = maker.sourcesSplitsJoin( splits );

  return result;
}

var defaults = sourcesJoin.defaults = Object.create( sourcesJoinSplits.defaults );

defaults.filesMap = null;
defaults.removingShellPrologue = null;

//

function sourcesSplitsJoin( o )
{
  let maker = this;

  _.routineOptions( sourcesSplitsJoin, arguments );

  for( let i in o )
  {
    _.assert( _.strIs( o[ i ] ) );
  }

  let result =
      o.prefix
    + o.predefined
    + o.early
    + o.extract
    + o.proceduring
    + o.globing
    + o.interpreter
    + o.starter
    + o.env
    + o.files
    + o.externalBefore
    + o.entry
    + o.externalAfter
    + o.postfix;

  return result;
}

var defaults = sourcesSplitsJoin.defaults =
{
  ... LibrarySplits,
}

// --
// etc
// --

function htmlSplitsFor( o )
{
  let maker = this;
  let r = Object.create( null );

  _.routineOptions( htmlSplitsFor, arguments );

  if( o.withScripts === null )
  {
    o.withScripts = 'include';
  }
  if( o.withStarter === null )
  {
    if( o.withScripts === 'single' )
    o.withStarter = false;
    else
    o.withStarter = 'include';
  }

  _.assert( _.longHas( [ 'include', 'inline', 0, false ], o.withStarter ), () => `Expects option::withStarter [ include, inline, false ], but got ${o.withStarter}` );
  _.assert( _.longHas( [ 'include', 0, false ], o.withStarter ) );
  _.assert( _.longHas( [ 'single', 'include', 'inline', 0, false ], o.withScripts ) );
  _.assert( _.longHas( [ 'single', 'include' ], o.withScripts ) );
  _.assert( o.withScripts !== 'single' || _.lengthOf( o.srcScriptsMap ) <= 1, 'not implemented' );
  _.assert( o.withScripts !== 'single' || !o.withStarter, 'If option::withScripts is single then option::withStarter should be off' );

  if( o.template === null )
  o.template =
`
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
</body>
</html>
`

  r = templateHandle();

  return r;

  /* */

  function templateHandle()
  {
    _.assert( _.strDefined( o.template ) );

    if( !Jsdom )
    Jsdom = require( 'jsdom' );
    if( !Pretty && maker.pretty )
    Pretty = require( 'pretty' );

    let dom = new Jsdom.JSDOM( o.template );
    let document = dom.window.document;

    if( o.title )
    {
      let title = document.head.querySelector( 'title' );
      if( !title )
      {
        title = document.createElement( 'title' );
        document.head.insertBefore( title, document.head.children[ 0 ] )
      }
      title.text = o.title;
    }

    if( o.withStarter === 'include' )
    prependScript( document, '/.starter' );

    for( let filePath in o.srcScriptsMap )
    {
      if( o.withScripts === 'include' )
      appendScript( document, filePath );
      else if( o.withScripts === 'single' )
      appendScript( document, filePath + '?withScripts:single' );
      else _.assert( 0 );
    }

    let result = dom.serialize();

    if( maker.pretty )
    result = Pretty( result );

    return result;
  }

  /* */

  function prependScript( document, filePath )
  {
    let script = document.createElement( 'script' );
    script.type = 'text/javascript';
    script.src = filePath;
    let child = document.head.querySelector( 'script' ) || document.head.children[ 0 ];
    if( child )
    document.head.insertBefore( script, child );
    else
    document.head.append( script )
  }

  /* */

  function appendScript( document, filePath )
  {
    let script = document.createElement( 'script' );
    script.type = 'text/javascript';
    script.src = filePath;
    document.head.append( script )
  }

  /* */

}

htmlSplitsFor.defaults =
{
  srcScriptsMap : null,
  template : null,
  withStarter : null,
  withScripts : null,
  title : null,
}

//

function htmlFor( o )
{
  let maker = this;
  _.routineOptions( htmlFor, arguments );
  let result = maker.htmlSplitsFor( o );
  return result;
}

htmlFor.defaults = Object.create( htmlSplitsFor.defaults );

/*

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Title</title>
  <script src="http://localhost:4444/Starter.js"></script>
  {each::<script src="{::filePath}"></script>}
</head>
<body>
  <script>
    require( '.' )
  </script>
</body>
</html>

*/

// --
// relations
// --

let InstanceDefaults =
{
  removingShellPrologue : 1,
};

let Composes =
{
  removingShellPrologue : 1,
  pretty : 1,
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
  LibrarySplits,
  PredefinedCode : require( '../l1_boot/Predefined.txt.s' ),
  EarlyCode : require( '../l1_boot/Early.txt.s' ),
  ExtractCode : require( '../l1_boot/Extract.txt.s' ),
  ProceduringCode : require( '../l1_boot/Proceduring.txt.s' ),
  GlobingCode : require( '../l1_boot/Globing.txt.s' ),
  BroCode : require( '../l1_boot/Bro.txt.s' ),
  BroConsoleCode : require( '../l1_boot/BroConsole.txt.s' ),
  BroProcessCode : require( '../l1_boot/BroProcess.txt.s' ),
  NjsCode : require( '../l1_boot/Njs.txt.s' ),
  StarterCode : require( '../l1_boot/Starter.txt.s' ),
  InstanceDefaults,
}

// --
// prototype
// --

let Proto =
{

  instanceOptions,

  sourceWrapSplits,
  sourceWrap,

  sourceWrapSimple,
  sourceRemoveShellPrologue,

  sourcesJoinSplits,
  sourcesJoin,
  sourcesSplitsJoin,

  htmlSplitsFor,
  htmlFor,

  /* */

  Composes,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.starter[ Self.shortName ] = Self;

})();
