( function _ModulesRegistry_s_() {

'use strict';

let _global = _global_;
if( !Object.hasOwnProperty.call( _global, 'ModuleRegistry' ) )
_global.ModulesRegistry = Object.create( null );
let Self = _global.ModulesRegistry;

// --
// include map
// --

// base

/* qqq : use only 2 paths instead of 3 */

let wLogger =
{
  includeAny : [ '../../abase/l9/printer/top/Logger.s','abase/l9/printer/top/Logger.s','wLogger' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Logger; },
}

let wPrinterToFile =
{
  includeAny : [ '../../abase/l9/printer/top/ToFile.ss','abase/l9/printer/top/ToFile.ss','wloggertofile' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.PrinterToFile; },
}

let wPrinterToJs =
{
  includeAny : [ '../../abase/l9/printer/top/ToJstructure.s','abase/l9/printer/top/ToJstructure.s','wloggertojs' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.PrinterToJs; },
}

let wConsequence =
{
  includeAny : [ '../../abase/l9/consequence/Consequence.s','abase/l9/consequence/Consequence.s','wConsequence' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Consequence; },
}

let wConsequizer =
{
  includeAny : [ '../../abase/l7/Consequizer.s','abase/l7/Consequizer.','wconsequizer' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Consequizer; },
}

let wCopyable =
{
  includeAny : [ '../../abase/l7/Copyable.s','abase/l7/Copyable.s','wCopyable' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Copyable; },
}

let wInstancing =
{
  includeAny : [ '../../abase/l7/Instancing.s','abase/l7/Instancing.s','winstancing' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Instancing; },
}

let wEventHandler =
{
  includeAny : [ '../../abase/l7/EventHandler.s','abase/l7/EventHandler.s','wEventHandler' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.EventHandler; },
}

let wFieldsStack =
{
  includeAny : [ '../../abase/l7/FieldsStack.s','abase/l7/FieldsStack.s','wfieldsstack' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FieldsStack; },
}

// base/l3

let wNameTools =
{
  includeAny : [ '../../abase/l3/NameTools.s','abase/l3/NameTools.s','wNameTools' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.idWithInt; },
}

let wLooker =
{
  includeAny : [ '../../abase/l3/Looker.s','abase/l3/Looker.s','wlooker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.look; },
}

let wPathFundamentals =
{
  includeAny : [ '../../abase/l3/Path.s','abase/l3/Path.s','wpathfundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.path },
}

let wProto =
{
  includeAny : [ '../../abase/l3/Proto.s','abase/l3/Proto.s','wProto' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.mixinDelcare },
}

let wSelector =
{
  includeAny : [ '../../abase/l3/Selector.s','abase/l3/Selector.s','wselector' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.select; },
}

let wStringer =
{
  includeAny : [ '../../abase/l3/Stringer.s','abase/l3/Stringer.s','wstringer' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Stringer; },
}

// base/l4

let wArraySorted =
{
  includeAny : [ '../../abase/l4/ArraySorted.s','abase/l4/ArraySorted.s','warraysorted' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.sorted },
}

let wArraySparse =
{
  includeAny : [ '../../abase/l4/ArraySparse.s','abase/l4/ArraySparse.s','warraysparse' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.sparse },
}

let wExternalFundamentals =
{
  includeAny : [ '../../abase/l4/External.s','abase/l4/External.s','wexternalfundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.shell },
}

let wUriFundamentals =
{
  includeAny : [ '../../abase/l4/Uri.s','abase/l4/Uri.s','wurifundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.uri },
}

let wComparator =
{
  includeAny : [ '../../abase/l4/LookerComparator.s','abase/l4/LookerComparator.s','wcomparator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.entityIdentical },
}

let wLookerExtra =
{
  includeAny : [ '../../abase/l4/LookerExtra.s','abase/l4/LookerExtra.s','wlookerextra' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.entitySearch },
}

let wTraverser =
{
  includeAny : [ '../../abase/l4/Traverser.s','abase/l4/Traverser.s','wtraverser' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._traverse },
}

let wBaseEncoder =
{
  includeAny : [ '../../abase/l4/Encoder.s','abase/l4/Encoder.s','wbaseencoder' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.encode },
}

let wRoutineTransform =
{
  includeAny : [ '../../abase/l4/RoutineTransform.s','abase/RoutineTransform/Cloner.s','wroutinetransform' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.routineNew },
}

// base/l5

let wWebUriFundamentals =
{
  includeAny : [ '../../abase/l5/WebUri.s','abase/l5/WebUri.s','wweburifundamentals' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.weburi },
}

let wCloner =
{
  includeAny : [ '../../abase/l5/Cloner.s','abase/l5/Cloner.s','wcloner' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._clone },
}

let wStringsExtra =
{
  includeAny : [ '../../abase/l5/StringTools.s','abase/l5/StringTools.s','wstringsextra' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.strSorterParse; },
}

// abase_dom

let wDomBaseLayer1 =
{
  includeAny : [ '../../abase_dom/l1/Common.js','abase_dom/l1/Common.js','wdombaselayer1' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._domBaselayer1Loaded },
}

let wDomBaseLayer3 =
{
  includeAny : [ '../../abase_dom/l3/Common.js','abase_dom/l3/Common.js','wdombaselayer3' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._domBaselayer3Loaded },
}

let wDomBaseLayer5 =
{
  includeAny : [ '../../abase_dom/l5/Common.js','abase_dom/l5/Common.js','wdombasel5' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools._domBasel5Loaded },
}

// amid

let wRegexpObject =
{
  includeAny : [ '../../amid/bclass/RegexpObject.s','amid/bclass/RegexpObject.s','wRegexpObject' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.RegexpObject; },
}

let wColor =
{
  includeAny : [ '../../amid/color/Color.s','amid/color/Color.s','wColor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ColorMap },
}

let wColor256 =
{
  includeAny : [ '../../amid/color/Color256.s','amid/color/Color256.s','wColor256' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ColorMap && Object.keys( _global.wTools.ColorMap ).length > 100 },
}

let wChangeTransactor =
{
  includeAny : [ '../../amid/changes/ChangeTransactor.s','amid/changes/ChangeTransactor.s','wChangeTransactor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ChangeTransactor },
}

let wVocabulary =
{
  includeAny : [ '../../amid/bclass/Vocabulary.s','amid/bclass/Vocabulary.s','wvocabulary' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Vocabulary },
}

let wCommandsAggregator =
{
  includeAny : [ '../../amid/l7/Commands/CommandsAggregator.s','amid/l7/Commands/CommandsAggregator.s','wcommandsaggregator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.CommandsAggregator },
}

let wCommandsConfig =
{
  includeAny : [ '../../amid/l7/commands/mixin/CommandsConfig.s','amid/l7/commands/l7/CommandsConfig.s','wcommandsconfig' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.CommandsConfig },
}

let wFiles =
{
  includeAny : [ '../../amid/files/UseTop.s','amid/files/UseTop.s','wFiles' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.fileProvider },
}

let wFilesArchive =
{
  includeAny : [ '../../amid/files/UseFilesArchive.s','amid/files/UseFilesArchive.s','wfilesarchive' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FilesArchive },
}

let wFilesTransformers =
{
  includeAny : [ '../../amid/files/l1/EncodersExtended.s','amid/files/l1/EncodersExtended.s','wfilestransformers' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FileTransformers },
}

let wFilesSvn =
{
  includeAny : [ '../../amid/files/fprovider/pSvn.ss','amid/files/fprovider/pSvn.ss','wFilesSvn' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.fileProvider.Svn },
}

let wTimeMarker =
{
  includeAny : [ '../../amid/amixin/TimeMarker.s','amid/amixin/TimeMarker.s','wtimemarker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TimeMarker },
}

let wVerbal =
{
  includeAny : [ '../../amid/amixin/Verbal.s','amid/amixin/Verbal.s','wverbal' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Verbal },
}

let wStateStorage =
{
  includeAny : [ '../../amid/amixin/aStateStorage.s','amid/amixin/aStateStorage.s','wstatestorage' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StateStorage },
}

let wStateSession =
{
  includeAny : [ '../../amid/amixin/StateSession.s','amid/amixin/StateSession.s','wstatesession' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StateSession },
}

let wPathTranslator =
{
  includeAny : [ '../../amid/l5/PathTranslator.s','amid/l5/PathTranslator.s','wpathtranslator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.PathTranslator },
}

let wFileExecutor =
{
  includeAny : [ '../../../dwtools/amid/l7/executor/FileExecutor.s', 'amid/l7/executor/FileExecutor.s', 'wFileExecutor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.wFileExecutor },
}

let wFileExecutorHtmlFormatters =
{
  includeAny : [ '../../../dwtools/amid/l7/executor/HtmlFormatters.s','amid/l7/executor/HtmlFormatters.s','wFileExecutorHtmlFormatters' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FileExecutorHtmlFormatters },
}

let wTranspilationStrategy =
{
  includeAny : [ '../../../dwtools/amid/l9/transpilationStrategy/MainBase.s','amid/l9/transpilationStrategy/MainBase.s','wtranspilationstrategy' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TranspilationStrategy },
}

let wNameMapper =
{
  includeAny : [ '../../amid/amapping/NameMapper.s','amid/amapping/NameMapper.s','wnamemapper' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.NameMapper },
}

let wTemplateTreeResolver =
{
  includeAny : [ '../../amid/amapping/TemplateTreeAresolver.s','amid/amapping/TemplateTreeAresolver.s','wtemplatetreeresolver' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TemplateTreeResolver },
}

let wTemplateTreeEnvironment =
{
  includeAny : [ '../../amid/amapping/TemplateTreeEnvironment.s','amid/amapping/TemplateTreeEnvironment.s','wtemplatetreeenvironment' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TemplateTreeEnvironment },
}

let wTemplateFileWriter =
{
  includeAny : [ '../../amid/amapping/TemplateFileWriter.s','amid/amapping/TemplateFileWriter.s','wtemplatefilewriter' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.TemplateFileWriter },
}

let wGraph =
{
  includeAny : [ '../../amid/agraph/UseTop.s','amid/agraph/UseTop.s','wgraph' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.graph },
}

let wGraphLive =
{
  includeAny : [ '../../amid/agraph/UseLive.s','amid/agraph/UseLive.s','wgraphlive' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.LiveSystem },
}

let wSchema =
{
  includeAny : [ '../../amid/schema/Top.s','amid/schema/Top.s','wSchema' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.schema },
}

let wScriptLauncher =
{
  includeAny : [ '../../amid/launcher/ScriptLauncher.s','amid/launcher/ScriptLauncher.s','wscriptlauncher' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ScriptLauncher },
}

let wExchangePoint =
{
  includeAny : [ '../../amid/exchangePoint/ExchangePoint.s','amid/exchangePoint/ExchangePoint.s','wExchangePoint' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.ExchangePoint },
}

let wCommunicator =
{
  includeAny : [ '../../amid/communicator/Communicator.s','amid/communicator/Communicator.s','wCommunicator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Communicator },
}

let wIncubator =
{
  includeAny : [ '../../amid/worker/Incubator.s','amid/worker/Incubator.s','wIncubator' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Incubator },
}

let wCollectionOfInstances =
{
  includeAny : [ '../../amid/container/CollectionOfInstances.s','amid/container/CollectionOfInstances.s','wcollectionofinstances' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.CollectionOfInstances },
}

let wStarterMaker =
{
  includeAny : [ '../../amid/starter/StarterMaker.s','amid/starter/StarterMaker.s','wstartermaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.StarterMaker },
}

// math

let wMathScalar =
{
  includeAny : [ '../../../dwtools/amath/l1/Scalar.s','amath/l1/Scalar.s','wmathscalar' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.clamp },
}

let wMathVector =
{
  includeAny : [ '../../../dwtools/amath/l3_vector/Main.s','amath/l3_vector/Main.s','wmathvector' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.vector },
}

let wMathSpace =
{
  includeAny : [ '../../../dwtools/amath/l5_space/Main.s','amath/l5_space/Main.s','wmathspace' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Space },
}

let wMathConcepts =
{
  includeAny : [ '../../../dwtools/amath/l8/Concepts.s','amath/l8/Concepts.ss','wmathconcepts' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.box },
}

// top

let wTesting =
{
  includeAny : [ '../../atop/tester/Main.mid.s','atop/tester/Main.mid.s', 'wTesting' ],
  isIncluded : function(){ return _realGlobal_.wTester && _realGlobal_.wTester._isReal_; },
}

//

let wFilesOperationsDirector =
{
  includeAny : [ '../../../dwtools/atop/files/OperationsDirector.s','atop/files/OperationsDirector.s','wfilesoperationsdirector' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FilesOperationsDirector },
}

let wFilesLinker =
{
  includeAny : [ '../../../dwtools/atop/files/Linker.s','atop/files/Linker.s','wfileslinker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.FilesLinker },
}

let wBaker =
{
  includeAny : [ '../../../dwtools/atop/baker/Baker.s','atop/baker/Baker.s','wBaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Baker },
}

let wBakerWithFileExecutor =
{
  includeAny : [ '../../../dwtools/atop/baker/BakerWithFileExecutor.s','atop/baker/BakerWithFileExecutor.s','wBakerWithFileExecutor' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.wBakerWithFileExecutor },
}

let wMaker =
{
  includeAny : [ '../../../dwtools/atop/maker/Maker.s','atop/maker/Maker.s','wMaker' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.Maker },
}

let wServlet =
{
  includeAny : [ '../../../dwtools/atop/servlet/Servlet.ss','atop/servlet/Servlet.ss','wServlet' ],
  isIncluded : function(){ return !!_global.wTools && !!_global.wTools.servlet },
}

// --
// declare
// --

let Extend =
{

  // base

  wLogger,
  wPrinterToFile,
  wPrinterToJs,
  wConsequence,
  wConsequizer,
  wCopyable,
  wInstancing,
  wEventHandler,
  wFieldsStack,

  // base/l3

  wNameTools,
  wLooker,
  wPathFundamentals,
  wProto,
  wSelector,

  // base/l4

  wExternalFundamentals,
  wUriFundamentals,
  wComparator,
  wLookerExtra,
  wTraverser,
  wArraySorted,
  wArraySparse,
  wBaseEncoder,
  wStringer,
  wRoutineTransform,

  // base/l5

  wWebUriFundamentals,
  wCloner,
  wStringsExtra,

  // base_dom

  wDomBaseLayer1,
  wDomBaseLayer3,
  wDomBaseLayer5,

  // mid

  wRegexpObject,
  wColor,
  wColor256,
  wChangeTransactor,
  wVocabulary,
  wCommandsAggregator,
  wCommandsConfig,
  wFiles,
  wFilesArchive,
  wFilesTransformers,
  wFilesSvn,
  wTimeMarker,
  wVerbal,
  wStateStorage,
  wStateSession,
  wPathTranslator,
  wFileExecutor,
  wFileExecutorHtmlFormatters,
  wTranspilationStrategy,
  wNameMapper,
  wTemplateTreeResolver,
  wTemplateTreeEnvironment,
  wTemplateFileWriter,
  wGraph,
  wGraphLive,
  wSchema,
  wScriptLauncher,
  wExchangePoint,
  wCommunicator,
  wIncubator,
  wCollectionOfInstances,
  wStarterMaker,

  // math

  wMathScalar,
  wMathVector,
  wMathSpace,
  wMathConcepts,

  // top

  wTesting,
  wFilesOperationsDirector,
  wFilesLinker,
  wBaker,
  wBakerWithFileExecutor,
  wMaker,
  wServlet,

}

Object.assign( Self, Extend );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
{ /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
