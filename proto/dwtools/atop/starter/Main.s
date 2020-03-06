
/**
 * Collection of tools to generate background service to start and pack application. Use the module to keep files structure of the application and make code aware wherein the file system is it executed.
  @module Tools/mid/Starter
*/

let _ = require( './include/Top.s' );
if( !module.parent )
_.starter.StarterCui.Exec();
debugger;
module[ 'exports' ] = _.starter.StarterCui;
