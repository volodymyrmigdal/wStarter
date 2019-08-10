( function _MainTop_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './MainBase.s' );
  require( './IncludeTop.s' );

}

/*
cls && local-starter .html.for builder/include/dwtools/amid/starter/processes.experiment/**
cls && local-starter .serve .
*/

//

let _ = wTools;
let Parent = _.Starter;
let Self = function wStarterCli( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'StarterCli';

// --
// exec
// --

function Exec()
{
  let starter = new this.Self();
  return starter.exec();
}

//

function exec()
{
  let starter = this;

  if( !starter.formed )
  starter.form();

  _.assert( _.instanceIs( starter ) );
  _.assert( arguments.length === 0 );

  let logger = starter.logger;
  let fileProvider = starter.fileProvider;
  let appArgs = _.appArgs();
  let ca = starter.commandsMake();

  return _.Consequence
  .Try( () =>
  {
    return ca.appArgsPerform({ appArgs });
  })
  .catch( ( err ) =>
  {
    _.appExitCode( -1 );
    return _.errLogOnce( err );
  });
}

//

function commandsMake()
{
  let starter = this;
  let logger = starter.logger;
  let fileProvider = starter.fileProvider;
  let appArgs = _.appArgs();

  _.assert( _.instanceIs( starter ) );
  _.assert( arguments.length === 0 );

  let commands =
  {
    'help' :              { e : _.routineJoin( starter, starter.commandHelp ),                h : 'Get help' },
    'imply' :             { e : _.routineJoin( starter, starter.commandImply ),               h : 'Change state or imply value of a variable' },
    'html for' :          { e : _.routineJoin( starter, starter.commandHtmlFor ),             h : 'Generate HTML for specified files' },
    'files wrap' :        { e : _.routineJoin( starter, starter.commandFilesWrap ),           h : 'Wrap script files found at specified directory' },
    'serve' :             { e : _.routineJoin( starter, starter.commandServe ),               h : 'Run server at specified directory' },
  }

  let ca = _.CommandsAggregator
  ({
    basePath : fileProvider.path.current(),
    commands : commands,
    commandPrefix : 'node ',
  })

  // starter._commandsConfigAdd( ca );

  ca.form();

  return ca;
}

//

function commandHelp( e )
{
  let starter = this;
  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let logger = starter.logger;

  ca._commandHelp( e );

  return starter;
}

//

function commandImply( e )
{
  let starter = this;
  let ca = e.ca;
  let logger = starter.logger;

  let namesMap =
  {
    v : 'verbosity',
    verbosity : 'verbosity',
  }

  let request = starter.Resolver.strRequestParse( e.argument );

  _.appArgsReadTo
  ({
    dst : starter,
    propertiesMap : request.map,
    namesMap : namesMap,
  });

}

//

function commandHtmlFor( e )
{
  let starter = this.form();
  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let request = _.strRequestParse( e.argument );

  let o2 = _.mapExtend( null, e.propertiesMap );
  o2.srcPath = o2.srcPath || request.subject;

  let html = starter.htmlFor( o2 );

  // logger.log( html );
  if( starter.verbosity )
  logger.log( ' + html saved to ' + _.color.strFormat( o2.dstPath, 'path' ) )

  return null;
}

//

function commandFilesWrap( e )
{
  let starter = this.form();
  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let request = _.strRequestParse( e.argument );

  let o2 = _.mapExtend( null, e.propertiesMap );
  o2.srcPath = o2.srcPath || request.subject;

  if( !o2.srcPath )
  throw _.errBriefly
  (
    'Please specify where to look for script file.\nFor example: '
    + _.color.strFormat( 'starter .files.wrap ./proto', 'code' )
  );

  let r = starter.filesWrap( o2 );

  if( starter.verbosity )
  logger.log( ' + filesWrap to ' + _.color.strFormat( o2.dstPath, 'path' ) )

  return r;
}

//

function commandServe( e )
{
  let starter = this.form();
  let ca = e.ca;
  let fileProvider = starter.fileProvider;
  let path = starter.fileProvider.path;
  let logger = starter.logger;
  let request = _.strRequestParse( e.argument );

  let o2 = _.mapExtend( null, e.propertiesMap );
  o2.rootPath = o2.rootPath || request.subject;

  if( !o2.rootPath )
  throw _.errBriefly
  (
    'Please specify what directory to serve.\nFor example: '
    + _.color.strFormat( 'starter .serve ./proto', 'code' )
  );

  starter.serve( o2 );

  return null;
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

  // exec

  Exec,
  exec,

  commandsMake,
  commandHelp,
  commandImply,
  commandHtmlFor,
  commandFilesWrap,
  commandServe,

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

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
wTools[ Self.shortName ] = Self;

if( !module.parent )
Self.Exec();

})();
