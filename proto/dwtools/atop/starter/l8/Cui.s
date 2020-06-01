( function _Cui_s_( ) {

'use strict';

/*
cls && local-starter .html.for builder/include/dwtools/amid/starter/processes.experiment/**
cls && local-starter .serve .
*/

//

let _ = _global_.wTools;
let Parent = null;
let Self = function wStarterCui( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Cui';

// --
// inter
// --

function init( o )
{
  let cui = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( cui );
  Object.preventExtensions( cui );

  if( o )
  cui.copy( o );

  if( cui.starter === null )
  cui.starter = new _.starter.System();

}

//

function Exec()
{
  let cui = new this.Self();
  return cui.exec();
}

//

function exec()
{
  let cui = this;
  let starter = cui.starter;

  if( !starter.formed )
  starter.form();

  _.assert( _.instanceIs( starter ) );
  _.assert( arguments.length === 0 );

  let logger = starter.logger;
  let fileProvider = starter.fileProvider;
  let appArgs = _.process.args();
  let ca = cui.commandsMake();

  return _.Consequence
  .Try( () =>
  {
    return ca.appArgsPerform({ appArgs });
  })
  .catch( ( err ) =>
  {
    _.process.exitCode( -1 );
    logger.log( _.errOnce( err ) );
    _.procedure.terminationBegin();
    _.process.exit();
    return err;
  });
}

// --
// commands
// --

function commandsMake()
{
  let cui = this;
  let starter = cui.starter;
  let logger = starter.logger;
  let fileProvider = starter.fileProvider;
  let appArgs = _.process.args();

  _.assert( _.instanceIs( cui ) );
  _.assert( _.instanceIs( starter ) );
  _.assert( arguments.length === 0 );

  let commands =
  {
    'help' :              { e : _.routineJoin( cui, cui.commandHelp ),          },
    'version' :           { e : _.routineJoin( cui, cui.commandVersion ),       },
    'imply' :             { e : _.routineJoin( cui, cui.commandImply ),         },
    'html for' :          { e : _.routineJoin( cui, cui.commandHtmlFor ),       },
    'sources join' :      { e : _.routineJoin( cui, cui.commandSourcesJoin ),   },
    'http open' :         { e : _.routineJoin( cui, cui.commandHttpOpen ),      },
    'start' :             { e : _.routineJoin( cui, cui.commandStart )          },
  }

  let ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands : commands,
    commandPrefix : 'node ',
  })

  ca.form();

  return ca;
}

//

function commandHelp( e )
{
  let cui = this;
  let starter = cui.starter;
  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let logger = starter.logger;

  ca._commandHelp( e );

  return cui;
}

commandHelp.hint = 'Get help.';

//

function commandVersion( e )
{
  let cui = this;
  let starter = cui.starter;

  starter.form();

  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;

  let packageJsonPath = path.join( __dirname, '../../../../../package.json' );
  let packageJson =  fileProvider.fileRead({ filePath : packageJsonPath, encoding : 'json', throwing : 0 });

  return _.process.start
  ({
    execPath : 'npm view wstarter@latest version',
    outputCollecting : 1,
    outputPiping : 0,
    inputMirroring : 0,
    throwingExitCode : 0,
  })
  .then( ( got ) =>
  {
    let current = packageJson ? packageJson.version : 'unknown';
    let latest = _.strStrip( got.output );

    if( got.exitCode || !latest )
    latest = 'unknown'

    logger.log( 'Current version:', current );
    logger.log( 'Available version:', latest );

    return null;
  })

}

commandVersion.hint = 'Get information about version.';

//

function commandImply( e )
{
  let cui = this;
  let starter = cui.starter;

  let ca = e.ca;
  let logger = starter.logger;

  let namesMap =
  {
    v : 'verbosity',
    verbosity : 'verbosity',
  }

  let request = _.strRequestParse( e.argument );

  _.process.argsReadTo
  ({
    dst : starter,
    propertiesMap : request.map,
    namesMap : namesMap,
  });

}

commandImply.hint = 'Change state or imply value of a variable.';

//

function commandHtmlFor( e )
{
  let cui = this;
  let starter = cui.starter;

  starter.form();

  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let request = _.strRequestParse( e.argument );

  logger.log( e.propertiesMap )

  request.subject = _.strStructureParse
  ({
    src : request.subject,
    parsingArrays : 1,
    defaultStructure : 'string',
  })

  let o2 = _.mapExtend( null, e.propertiesMap );
  o2.inPath = o2.inPath || request.subject;

  let html = starter.htmlForFiles( o2 );

  if( starter.verbosity > 3 )
  logger.log( html );

  if( starter.verbosity )
  logger.log( ' + html saved to ' + _.color.strFormat( o2.outPath, 'path' ) )

  return null;
}

commandHtmlFor.commandProperties =
{
  inPath : 'Path to files to include into HTML file to generate.',
  outPath : 'Path to save generated HTML file.',
}

commandHtmlFor.hint = 'Generate HTML for specified files.';

//

function commandSourcesJoin( e )
{
  let cui = this;
  let starter = cui.starter;

  starter.form();

  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let request = _.strRequestParse( e.argument );

  let o2 = _.mapExtend( null, e.propertiesMap );
  o2.inPath = o2.inPath || request.subject;

  if( !o2.inPath )
  throw _.errBriefly
  (
    'Please specify where to look for source file.\nFor example: '
    + _.color.strFormat( 'starter .files.wrap ./proto', 'code' )
  );

  let r = starter.sourcesJoinFiles( o2 );

  if( starter.verbosity )
  logger.log( ' + sourcesJoin to ' + _.color.strFormat( o2.outPath, 'path' ) )

  return r;
}

commandSourcesJoin.commandProperties =
{
  inPath : 'Path to files to use for merging and wrapping.',
  outPath : 'Path to save merged file.',
}

commandSourcesJoin.hint = 'Join source files found at specified directory.';

//

function commandHttpOpen( e )
{
  let cui = this;
  let starter = cui.starter;

  starter.form();

  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let request = _.strRequestParse({ src : e.argument, severalValues : 1 });

  let o2 = _.mapExtend( null, e.propertiesMap );
  o2.basePath = o2.basePath || request.subject;

  /* xxx qqq : write option-less test routine */

  if( request.subject && request.subject !== o2.basePath )
  throw _.errBrief
  (
    'Subject if specified should be option::basePath, but option::basePath specified too!'
  );

  if( !o2.basePath )
  o2.basePath = '.';

  if( !o2.basePath )
  throw _.errBrief
  (
    'Please specify what directory to serve.\nFor example: '
    + _.color.strFormat( 'starter .http.open ./proto', 'code' )
  );

  starter.httpOpen( o2 );

  return null;
}

commandHttpOpen.commandProperties =
{
  basePath : 'Path to make available over HTTP.',
  allowedPath : 'Restrict access of client-side to files in specified directory. Default : same as basePath.',
  templatePath : 'Path to HTML file to use as a template.',
  // includePath : 'Path to make available. Could be specidied several such paths. If basePath is not specified then includePath is used to deduce basePath.',
  format : 'Explicitly specified format of entry file. Could be: js / html.',
  withModule : 'Specify one or several modules to include extending basePath. If basePath is specified explicitly then option::withModule has no effect.',
  withNpm : 'Include npm paths into the list of allowed paths and enable npm packages to be available. Default : true',
  loggingApplication : 'Enable printing of application output. Default : false.',
  loggingRequestsAll : 'Enable logging of request to the server. Default : true.',
  loggingRequests : 'Enable printing requests to the servlet. Default : false.',
  loggingSessionEvents : 'Enable logging of events of session. Default : false.',
  loggingOptions : 'Enable logging of options of session. Default : false.',
  loggingSourceFiles : 'Enable logging of constructing source files. Default : false',
  loggingPathTranslations : 'Enable logging of path translations. Default : false',
  // resolvingNpm : 'Make npm modules available. Default : true',
  proceduring : 'Watching asynchronous procedures to terminate the application when all will run out. Default : true.',
  catchingUncaughtErrors : 'Catching uncaught errors and handling them properly. Default : true.',
  naking : 'Disable wrapping of scripts. Default : false.',
  withScripts : 'How to ship scripts. Alternatives : [ include, inline, single, 0 ]. Default : include.',
  withStarter : 'Run-time environment. Alternatives : [ include, inline, 0 ]. Default : include.',
  interpreter : 'Interpreter to use. Alternatives [ browser, njs ]. Default : browser'
}

commandHttpOpen.hint = 'Run HTTP server to serve files in a specified directory.';

//

function commandStart( e )
{
  let cui = this;
  let starter = cui.starter;

  starter.form();

  let ca = e.ca;
  let logger = starter.logger;
  let request = _.strRequestParse({ src : e.argument, severalValues : 1 });

  let o2 = _.mapExtend( null, e.propertiesMap );
  o2.entryPath = o2.entryPath || request.subject;

  if( request.subject && request.subject !== o2.entryPath )
  throw _.errBrief
  (
    'Subject if specified should be option::entryPath, but option::entryPath specified too!'
  );

  if( !o2.entryPath )
  throw _.errBriefly
  (
    'Please specify where to look for source file.\nFor example: '
    + _.color.strFormat( 'starter .start Index.js', 'code' )
  );

  starter.start( o2 );

  return null;
}

commandStart.commandProperties =
{
  ... commandHttpOpen.commandProperties,
  loggingApplication : 'Enable printing of application output. Default : true',
  loggingRequestsAll : 'Enable logging of request to the server. Default : false',
  curating : 'Automatic opening of the application in curated window. Default : true',
  headless : 'Headless mode. Default : false',
}

commandStart.hint = 'Run executable file. By default in browser.';

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
  starter : null,
}

let Restricts =
{
}

let Statics =
{
  Exec,
}

let Forbids =
{
}

// --
// declare
// --

let Extend =
{

  // inter

  init,
  Exec,
  exec,

  // commands

  commandsMake,
  commandHelp,
  commandVersion,

  commandImply,
  commandHtmlFor,
  commandSourcesJoin,
  commandHttpOpen,
  commandStart,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.starter[ Self.shortName ] = Self;

if( !module.parent )
Self.Exec();

})();
