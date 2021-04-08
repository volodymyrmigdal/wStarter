
/**
 * Collection of tools to generate background service to start and pack application. Use the module to keep files structure of the application and make code aware wherein the file system is it executed.
  @module Tools/mid/Starter
*/

// const _ = require( './include/Top.s' );
// if( !module.parent )
// _.starter.StarterCui.Exec();
// module[ 'exports' ] = _.starter.StarterCui;

// const _ = require( './include/Launcher.s' );
// if( !module.parent )
// _.starter.Launcher.Exec();
// module[ 'exports' ] = _.starter.Launcher;

const _ = require( '../include/Center.s' );
if( !module.parent )
_.starter.Center.Exec();
module[ 'exports' ] = _;
