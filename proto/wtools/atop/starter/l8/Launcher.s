// ( function _Launcher_s_( ) {
//
// 'use strict';
//
// //
//
// const _ = _global_.wTools;
// const Parent = null;
// const Self = wStarterLauncher;
// function wStarterLauncher( o )
// {
//   return _.workpiece.construct( Self, this, arguments );
// }
//
// Self.shortName = 'Launcher';
//
// // --
// // inter
// // --
//
// function init( o )
// {
//   let launcher = this;
//
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//
//   _.workpiece.initFields( launcher );
//   Object.preventExtensions( launcher );
//
//   if( o )
//   launcher.copy( o );
//
// }
//
// //
//
// function Exec()
// {
//   let launcher = new this.Self();
//   return launcher.exec();
// }
//
// //
//
// function exec()
// {
//   let launcher = this;
//   if( launcher.immediate )
//   return launcher.execImmediate();
//   else
//   return launcher.execCenter();
// }
//
// //
//
// function execCenter()
// {
//   let launcher = this;
//   if( launcher.center === null )
//   launcher.center = new _.starter.Center();
//   return launcher.center.exec();
// }
//
// //
//
// function execImmediate()
// {
//   let launcher = this;
//
//   require( '../include/Top.s' );
//
//   if( launcher.cui === null )
//   launcher.cui = new _.starter.StarterCui();
//   return launcher.cui.exec();
// }
//
// // --
// // relations
// // --
//
// let Composes =
// {
//   immediate : 0,
// }
//
// let Aggregates =
// {
// }
//
// let Associates =
// {
//   cui : null,
//   center : null,
// }
//
// let Restricts =
// {
// }
//
// let Statics =
// {
//   Exec,
// }
//
// let Forbids =
// {
// }
//
// // --
// // declare
// // --
//
// let Extension =
// {
//
//   // inter
//
//   init,
//   Exec,
//   exec,
//   execCenter,
//   execImmediate,
//
//   // relations
//
//   Composes,
//   Aggregates,
//   Associates,
//   Restricts,
//   Statics,
//   Forbids,
//
// }
//
// _.classDeclare
// ({
//   cls : Self,
//   parent : Parent,
//   extend : Extension,
// });
//
// _.Copyable.mixin( Self );
//
// //
//
// if( typeof module !== 'undefined' )
// module[ 'exports' ] = Self;
// _.starter[ Self.shortName ] = Self;
//
// if( !module.parent )
// Self.Exec();
//
// })();
