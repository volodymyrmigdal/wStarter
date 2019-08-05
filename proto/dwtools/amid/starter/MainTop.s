( function _MainTop_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './MainBase.s' );
  require( './IncludeTop.s' );

}

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

  return ca.appArgsPerform({ appArgs : appArgs });
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
  o2.dstPath = o2.dstPath || path.current();
  o2.basePath = o2.basePath || path.current();

  debugger;
  let html = starter.htmlFor( o2 );
  debugger;
  console.log( html );

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
