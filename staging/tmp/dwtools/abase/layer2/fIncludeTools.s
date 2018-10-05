( function _Include_s_() {

'use strict';

//

var usingSinglePath = 0;
var Self = _global_.wTools;
var _global = _global_;
var _ = _global_.wTools;
var _global = _global_;

var Module = null;
var __include;
if( typeof require !== 'undefined' )
__include = require;
else if( typeof importScripts !== 'undefined' )
__include = importScripts;
else if( _global._remoteRequire )
__include = _global._remoteRequire;

// --
// routines
// --

function usePath( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );

  if( _.path && _.path.refine )
  src = _.path.refine( src );

  if( typeof module !== 'undefined' )
  module.paths.push( src );

}

//

function usePathGlobally( paths )
{

  if( _.strIs( paths ) )
  paths = [ paths ];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.arrayIs( paths ) );

  if( _.fileProvider && _.path.refine )
  {
    for( var p = 0 ; p < paths.length ; p++ )
    {
      paths[ p ] = _.fileProvider.path.nativize( _.path.resolve( paths[ p ] ) );
      console.log( 'usePathGlobally',paths[ p ] );
    }
  }

  return _usePathGlobally( module,paths,[] );
}

//

function _usePathGlobally( _module,paths,visited )
{

  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( _.arrayIs( paths ) );

  if( visited.indexOf( _module ) !== -1 )
  return;

  if( !Module )
  Module = require( 'module' );

  [].push.apply( Module.globalPaths, paths );

  /* patch parents */

  while( _module )
  {
    _usePathGloballyChildren( _module,paths,visited );
    _module = _module.parent;
  }

}

//

function _usePathGloballyChildren( _module,paths,visited )
{

  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( _.arrayIs( paths ) );

  if( visited.indexOf( _module ) !== -1 )
  return;

  visited.push( _module );
  [].push.apply( _module.paths, paths );

  /* patch parents */

  if( _module.children )
  for( var c = 0 ; c < _module.children.length ; c++ )
  _usePathGloballyChildren( _module.children[ c ],paths,visited );

}

//

function _includeWithRequireAct( src )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ),'include expects string' );

  /* console.log( '_includeWithRequireAct', '"' + src + '"' ); */

  if( typeof module !== 'undefined' )
  try
  {
    // debugger;
    return __include( src );
  }
  catch( err )
  {
    debugger;
    throw _.err( err,'\n','Cant require',src );
  }
  else throw _.err( 'Cant include, no "require".' );

}

//

function _includeAct( src )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( src ) );

  var handler;
  if( IncludeHandlersMap[ src ] )
  handler = IncludeHandlersMap[ src ];

  if( !handler )
  {
    return _includeWithRequireAny( src );
  }

  /* */

  if( handler.isIncluded )
  if( handler.isIncluded() )
  return handler.returned;

  var result;
  if( handler.include )
  {
    result = _includeWithRequire( handler.include );
  }
  else if( handler.includeAny )
  {
    _.assert( _.arrayIs( handler.includeAny ),'include handler expect an array ( includeAny ) if present' );
    result = _includeWithRequireAny.apply( _,handler.includeAny );
  }
  else throw _.err( 'Handler does not has ( include ) neither ( includeAny ).\nCant use the handler to include file',src );

  handler.returned = result;

  return result;
}

//

function _includeAnyAct( srcs )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.longIs( srcs ) );

  /* */

  var paths = [];
  for( var s = 0 ; s < srcs.length ; s++ )
  {
    var src = srcs[ s ];
    var handler = IncludeHandlersMap[ src ];

    if( !handler )
    {
      paths.push({ path : src });
      continue;
    }

    if( handler.isIncluded )
    if( handler.isIncluded() )
    return handler.returned;

    var result;
    if( handler.include )
    {
      paths.push({ path : handler.include, handler : handler }); debugger;
    }
    else if( handler.includeAny )
    {
      _.assert( _.arrayIs( handler.includeAny ),'include handler expect an array ( includeAny ) if present' );
      for( var p = 0 ; p < handler.includeAny.length ; p++ )
      paths.push({ path : handler.includeAny[ p ], handler : handler });
    }
    else throw _.err( 'Handler does not has ( include ) neither ( includeAny ).\nCant use the handler to include file',src );

  }

  /* */

  for( var a = 0 ; a < paths.length ; a++ )
  {
    var src = paths[ a ].path;

    if( src !== '' )
    try
    {
      var resolved = __include.resolve( src );
      src = resolved;
    }
    catch( err )
    {
      if( a !== paths.length-1 && !usingSinglePath )
      continue;
    }

    if( a === paths.length-1 && src === '' )
    return;

    var result = _includeWithRequireAct( src );
    if( paths[ a ].handler )
    paths[ a ].handler.returned = result;
    return result;
  }

  /* */

  debugger;
  throw _.err( 'Can include none of file',srcs );
}

//

function _includeWithRequire( src )
{
  if( arguments.length !== 1 )
  return _includeWithRequire( arguments );

  if( _.longIs( src ) )
  {
    var result = [];
    src = _.arrayFlatten( [], src );
    for( var a = 0 ; a < src.length ; a++ )
    result[ a ] = _includeWithRequireAct( src[ a ] );
    return result;
  }

  return _includeWithRequireAct( src );
}

//

function include( src )
{
  if( arguments.length !== 1 )
  return _includeAct( arguments );

  if( _.longIs( src ) )
  {
    var result = [];
    src = _.arrayFlatten( [], src );
    for( var a = 0 ; a < src.length ; a++ )
    result[ a ] = _includeAct( src[ a ] );
    return result;
  }

  return _includeAct( src );
}

//

function _includeWithRequireAny( src )
{
  var errors = [];

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var src = arguments[ a ];

    if( src !== '' )
    try
    {
      var resolved = __include.resolve( src );
      src = resolved;
    }
    catch( err )
    {
      if( a !== arguments.length-1 && !usingSinglePath )
      continue;
    }

    if( a === arguments.length-1 && src === '' )
    return;

    var result = _includeWithRequireAct( src );
    return result;

  }

  _.assert( 0,'unexpected' );
}

//

function includeAny()
{
  return _includeAnyAct( arguments );
}

//

function isIncluded( src )
{

  var handler;
  if( IncludeHandlersMap[ src ] )
  handler = IncludeHandlersMap[ src ];

  if( !handler )
  return false;

  if( !handler.isIncluded )
  return false;

  return handler.isIncluded();
}

// --
// include map
// --

var IncludeHandlersMap = Object.create( null );

IncludeHandlersMap[ 'wLogger' ] =
{
  includeAny : [ '../../abase/printer/top/Logger.s','abase/printer/top/Logger.s','wLogger' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Logger; },
}

IncludeHandlersMap[ 'wPrinterToFile' ] =
{
  includeAny : [ '../../abase/printer/top/ToFile.ss','abase/printer/top/ToFile.ss','wloggertofile' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.PrinterToFile; },
}

IncludeHandlersMap[ 'wPrinterToJs' ] =
{
  includeAny : [ '../../abase/printer/top/ToJstructure.s','abase/printer/top/ToJstructure.s','wloggertojs' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.PrinterToJs; },
}

IncludeHandlersMap[ 'wConsequence' ] =
{
  includeAny : [ '../../abase/oclass/Consequence.s','abase/oclass/Consequence.s','wConsequence' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Consequence; },
}

IncludeHandlersMap[ 'wConsequizer' ] =
{
  includeAny : [ '../../abase/mixin/Consequizer.s','abase/mixin/Consequizer.','wconsequizer' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Consequizer; },
}

IncludeHandlersMap[ 'wCopyable' ] =
{
  includeAny : [ '../../abase/mixin/Copyable.s','abase/mixin/Copyable.s','wCopyable' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Copyable; },
}

IncludeHandlersMap[ 'wInstancing' ] =
{
  includeAny : [ '../../abase/mixin/Instancing.s','abase/mixin/Instancing.s','winstancing' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Instancing; },
}

IncludeHandlersMap[ 'wEventHandler' ] =
{
  includeAny : [ '../../abase/mixin/EventHandler.s','abase/mixin/EventHandler.s','wEventHandler' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.EventHandler; },
}

IncludeHandlersMap[ 'wFieldsStack' ] =
{
  includeAny : [ '../../abase/mixin/FieldsStack.s','abase/mixin/FieldsStack.s','wfieldsstack' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FieldsStack; },
}

IncludeHandlersMap[ 'wNameTools' ] =
{
  includeAny : [ '../../abase/layer3//NameTools.s','abase/layer3//NameTools.s','wNameTools' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.idWithInt; },
}

IncludeHandlersMap[ 'wProto' ] =
{
  includeAny : [ '../../abase/layer3/Proto.s','abase/layer3/Proto.s','wProto' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.mixinDelcare },
}

IncludeHandlersMap[ 'wExternalFundamentals' ] =
{
  includeAny : [ '../../abase/layer4/External.s','abase/layer4/External.s','wexternalfundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.shell },
}

IncludeHandlersMap[ 'wPathFundamentals' ] =
{
  includeAny : [ '../../abase/layer3/Path.s','abase/layer3/Path.s','wpathfundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.path },
}

IncludeHandlersMap[ 'wUriFundamentals' ] =
{
  includeAny : [ '../../abase/layer4/Uri.s','abase/layer4/Uri.s','wurifundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.uri },
}

IncludeHandlersMap[ 'wWebUriFundamentals' ] =
{
  includeAny : [ '../../abase/layer5/WebUri.s','abase/layer5/WebUri.s','wweburifundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.weburi },
}

IncludeHandlersMap[ 'wTraverser' ] =
{
  includeAny : [ '../../abase/layer4/Traverser.s','abase/layer4/Traverser.s','wtraverser' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._traverse },
}

IncludeHandlersMap[ 'wArraySorted' ] =
{
  includeAny : [ '../../abase/layer4/ArraySorted.s','abase/layer4/ArraySorted.s','warraysorted' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.sorted },
}

IncludeHandlersMap[ 'wArraySparse' ] =
{
  includeAny : [ '../../abase/layer4/ArraySparse.s','abase/layer4/ArraySparse.s','warraysparse' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.sparse },
}

IncludeHandlersMap[ 'wBaseEncoder' ] =
{
  includeAny : [ '../../abase/layer4/Encoder.s','abase/layer4/Encoder.s','wbaseencoder' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.encode },
}

IncludeHandlersMap[ 'wStringer' ] =
{
  includeAny : [ '../../abase/layer4/aStringer.s','abase/layer4/aStringer.s','wstringer' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Stringer; },
}

IncludeHandlersMap[ 'wRoutineTransform' ] =
{
  includeAny : [ '../../abase/layer4/RoutineTransform.s','abase/RoutineTransform/Cloner.s','wroutinetransform' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.routineNew },
}

IncludeHandlersMap[ 'wCloner' ] =
{
  includeAny : [ '../../abase/layer5/Cloner.s','abase/layer5/Cloner.s','wcloner' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._clone },
}

IncludeHandlersMap[ 'wStringsExtra' ] =
{
  includeAny : [ '../../abase/layer5/StringTools.s','abase/layer5/StringTools.s','wstringsextra' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.strSorterParse; },
}

//

IncludeHandlersMap[ 'wDomBaseLayer1' ] =
{
  includeAny : [ '../../abase_dom/l1/Common.js','abase_dom/l1/Common.js','wdombaselayer1' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._domBaselayer1Loaded },
}

IncludeHandlersMap[ 'wDomBaseLayer3' ] =
{
  includeAny : [ '../../abase_dom/l3/Common.js','abase_dom/l3/Common.js','wdombaselayer3' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._domBaselayer3Loaded },
}

IncludeHandlersMap[ 'wDomBaseLayer5' ] =
{
  includeAny : [ '../../abase_dom/l5/Common.js','abase_dom/l5/Common.js','wdombaselayer5' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._domBaselayer5Loaded },
}

//

IncludeHandlersMap[ 'wRegexpObject' ] =
{
  includeAny : [ '../../amid/bclass/RegexpObject.s','amid/bclass/RegexpObject.s','wRegexpObject' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.RegexpObject; },
}

IncludeHandlersMap[ 'wColor' ] =
{
  includeAny : [ '../../amid/color/Color.s','amid/color/Color.s','wColor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ColorMap },
}

IncludeHandlersMap[ 'wColor256' ] =
{
  includeAny : [ '../../amid/color/Color256.s','amid/color/Color256.s','wColor256' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ColorMap && Object.keys( _global.wTools.ColorMap ).length > 100 },
}

IncludeHandlersMap[ 'wChangeTransactor' ] =
{
  includeAny : [ '../../amid/changes/ChangeTransactor.s','amid/changes/ChangeTransactor.s','wChangeTransactor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ChangeTransactor },
}

IncludeHandlersMap[ 'wVocabulary' ] =
{
  includeAny : [ '../../amid/bclass/Vocabulary.s','amid/bclass/Vocabulary.s','wvocabulary' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Vocabulary },
}

IncludeHandlersMap[ 'wCommandsAggregator' ] =
{
  includeAny : [ '../../amid/l7/CommandsAggregator.s','amid/l7/CommandsAggregator.s','wcommandsaggregator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.CommandsAggregator },
}

IncludeHandlersMap[ 'wFiles' ] =
{
  includeAny : [ '../../amid/files/UseTop.s','amid/files/UseTop.s','wFiles' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.fileProvider },
}

IncludeHandlersMap[ 'wFilesArchive' ] =
{
  includeAny : [ '../../amid/files/UseFilesArchive.s','amid/files/UseFilesArchive.s','wfilesarchive' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FilesArchive },
}

IncludeHandlersMap[ 'wFilesTransformers' ] =
{
  includeAny : [ '../../amid/files/l9/FilesTransformers.s','amid/files/l9/FilesTransformers.s','wfilestransformers' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FileTransformers },
}

IncludeHandlersMap[ 'wFilesSvn' ] =
{
  includeAny : [ '../../amid/files/fprovider/pSvn.ss','amid/files/fprovider/pSvn.ss','wFilesSvn' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.fileProvider.Svn },
}

IncludeHandlersMap[ 'wTimeMarker' ] =
{
  includeAny : [ '../../amid/amixin/TimeMarker.s','amid/amixin/TimeMarker.s','wtimemarker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TimeMarker },
}

IncludeHandlersMap[ 'wVerbal' ] =
{
  includeAny : [ '../../amid/amixin/Verbal.s','amid/amixin/Verbal.s','wverbal' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Verbal },
}

IncludeHandlersMap[ 'wStateStorage' ] =
{
  includeAny : [ '../../amid/amixin/aStateStorage.s','amid/amixin/aStateStorage.s','wstatestorage' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StateStorage },
}

IncludeHandlersMap[ 'wStateSession' ] =
{
  includeAny : [ '../../amid/amixin/StateSession.s','amid/amixin/StateSession.s','wstatesession' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StateSession },
}

IncludeHandlersMap[ 'wPathTranslator' ] =
{
  includeAny : [ '../../amid/l5/PathTranslator.s','amid/l5/PathTranslator.s','wpathtranslator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.PathTranslator },
}

IncludeHandlersMap[ 'wFileExecutor' ] =
{
  includeAny : [ '../../../dwtools/amid/l7/executor/FileExecutor.s', 'amid/l7/executor/FileExecutor.s', 'wFileExecutor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.wFileExecutor },
}

IncludeHandlersMap[ 'wFileExecutorHtmlFormatters' ] =
{
  includeAny : [ '../../../dwtools/amid/l7/executor/HtmlFormatters.s','amid/l7/executor/HtmlFormatters.s','wFileExecutorHtmlFormatters' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FileExecutorHtmlFormatters },
}

IncludeHandlersMap[ 'wStarterMaker' ] =
{
  includeAny : [ '../../../dwtools/amid/starter/StarterMaker.s','amid/starter/StarterMaker.s','wStarterMaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StarterMaker },
}

IncludeHandlersMap[ 'wNameMapper' ] =
{
  includeAny : [ '../../amid/amapping/NameMapper.s','amid/amapping/NameMapper.s','wnamemapper' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.NameMapper },
}

IncludeHandlersMap[ 'wTemplateTreeResolver' ] =
{
  includeAny : [ '../../amid/amapping/TemplateTreeAresolver.s','amid/amapping/TemplateTreeAresolver.s','wtemplatetreeresolver' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TemplateTreeResolver },
}

IncludeHandlersMap[ 'wTemplateTreeEnvironment' ] =
{
  includeAny : [ '../../amid/amapping/TemplateTreeEnvironment.s','amid/amapping/TemplateTreeEnvironment.s','wtemplatetreeenvironment' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TemplateTreeEnvironment },
}

IncludeHandlersMap[ 'wTemplateFileWriter' ] =
{
  includeAny : [ '../../amid/amapping/TemplateFileWriter.s','amid/amapping/TemplateFileWriter.s','wtemplatefilewriter' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TemplateFileWriter },
}

IncludeHandlersMap[ 'wGraph' ] =
{
  includeAny : [ '../../amid/agraph/UseTop.s','amid/agraph/UseTop.s','wgraph' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.graph },
}

IncludeHandlersMap[ 'wGraphLive' ] =
{
  includeAny : [ '../../amid/agraph/UseLive.s','amid/agraph/UseLive.s','wgraphlive' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.LiveSystem },
}

IncludeHandlersMap[ 'wSchema' ] =
{
  includeAny : [ '../../amid/schema/Top.s','amid/schema/Top.s','wSchema' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.schema },
}

IncludeHandlersMap[ 'wScriptLauncher' ] =
{
  includeAny : [ '../../amid/launcher/ScriptLauncher.s','amid/launcher/ScriptLauncher.s','wscriptlauncher' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ScriptLauncher },
}

IncludeHandlersMap[ 'wExchangePoint' ] =
{
  includeAny : [ '../../amid/exchangePoint/ExchangePoint.s','amid/exchangePoint/ExchangePoint.s','wExchangePoint' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ExchangePoint },
}

IncludeHandlersMap[ 'wCommunicator' ] =
{
  includeAny : [ '../../amid/communicator/Communicator.s','amid/communicator/Communicator.s','wCommunicator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Communicator },
}

IncludeHandlersMap[ 'wIncubator' ] =
{
  includeAny : [ '../../amid/worker/Incubator.s','amid/worker/Incubator.s','wIncubator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Incubator },
}

IncludeHandlersMap[ 'wCollectionOfInstances' ] =
{
  includeAny : [ '../../amid/container/CollectionOfInstances.s','amid/container/CollectionOfInstances.s','wcollectionofinstances' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.CollectionOfInstances },
}

IncludeHandlersMap[ 'wStarterMaker' ] =
{
  includeAny : [ '../../amid/starter/StarterMaker.s','amid/starter/StarterMaker.s','wstartermaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StarterMaker },
}

IncludeHandlersMap[ 'wStarterMaker' ] =
{
  includeAny : [ '../../../dwtools/amid/starter/StarterMaker.s','amid/starter/StarterMaker.s','wstartermaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StarterMaker },
}

//

IncludeHandlersMap[ 'wTesting' ] =
{
  includeAny : [ '../../atop/tester/aBase.debug.s','atop/tester/aBase.debug.s', 'wTesting' ],
  isIncluded : function(){ return _realGlobal_.wTester && _realGlobal_.wTester._isReal_; },
}

//

IncludeHandlersMap[ 'wMathScalar' ] =
{
  includeAny : [ '../../../dwtools/amath/arithmetic/cScalar.s','amath/arithmetic/cScalar.s','wmathscalar' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.clamp },
}

IncludeHandlersMap[ 'wMathVector' ] =
{
  includeAny : [ '../../../dwtools/amath/cvector/Base.s','amath/cvector/Base.s','wmathvector' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.vector },
}

IncludeHandlersMap[ 'wMathSpace' ] =
{
  includeAny : [ '../../../dwtools/amath/space/wSpace.s','amath/space/wSpace.s','wmathspace' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Space },
}

IncludeHandlersMap[ 'wMathConcepts' ] =
{
  includeAny : [ '../../../dwtools/amath/geometric/aConcepts.s','amath/geometric/aConcepts.ss','wmathconcepts' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.box },
}

//

IncludeHandlersMap[ 'wFilesOperationsDirector' ] =
{
  includeAny : [ '../../../dwtools/atop/files/OperationsDirector.s','atop/files/OperationsDirector.s','wfilesoperationsdirector' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FilesOperationsDirector },
}

IncludeHandlersMap[ 'wFilesLinker' ] =
{
  includeAny : [ '../../../dwtools/atop/files/Linker.s','atop/files/Linker.s','wfileslinker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FilesLinker },
}

IncludeHandlersMap[ 'wBaker' ] =
{
  includeAny : [ '../../../dwtools/atop/baker/Baker.s','atop/baker/Baker.s','wBaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Baker },
}

IncludeHandlersMap[ 'wBakerWithFileExecutor' ] =
{
  includeAny : [ '../../../dwtools/atop/baker/BakerWithFileExecutor.s','atop/baker/BakerWithFileExecutor.s','wBakerWithFileExecutor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.wBakerWithFileExecutor },
}

IncludeHandlersMap[ 'wMaker' ] =
{
  includeAny : [ '../../../dwtools/atop/maker/Maker.s','atop/maker/Maker.s','wMaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Maker },
}

IncludeHandlersMap[ 'wDeployerUnit' ] =
{
  includeAny : [ '../../../dwtools/atop/deployer/Unit.s','atop/deployer/Unit.s','wDeployerUnit' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.DeployerUnit },
}

IncludeHandlersMap[ 'wServlet' ] =
{
  includeAny : [ '../../../dwtools/atop/servlet/Servlet.ss','atop/servlet/Servlet.ss','wServlet' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.servlet },
}

// --
// declare
// --

var Proto =
{

  usePath : usePath,

  usePathGlobally : usePathGlobally,
  _usePathGlobally : _usePathGlobally,
  _usePathGloballyChildren : _usePathGloballyChildren,

  //

  _includeWithRequireAct : _includeWithRequireAct,
  _includeAct : _includeAct,
  _includeAnyAct : _includeAnyAct,

  _includeWithRequire : _includeWithRequire,
  include : include,

  _includeWithRequireAny : _includeWithRequireAny,
  includeAny : includeAny,

  isIncluded : isIncluded,

  //

  IncludeHandlersMap : IncludeHandlersMap,

}

_.mapExtend( Self, Proto );

if( _.usePath && typeof __dirname !== 'undefined' )
_.usePath( __dirname + '/../..' );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
