// ( function _StarterLegacy_test_s_()
//{

// 'use strict'; /*bbb*/

// if( typeof module !== 'undefined' )
// {

//   const _ = require( '../../../node_modules/Tools' );

//   _.include( 'wTesting' );

//   require( '../starter/include/Top.s' );

// }

// const _global = _global_;
// const _ = _global_.wTools;

// //

// function onSuiteBegin()
// {
//   let self = this;

//   self.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'Starter' );
//   self.assetsOriginalPath = _.path.join( __dirname, '_asset' );
//   self.find = _.fileProvider.filesFinder
//   ({
//     withTerminals : 1,
//     withDirs : 1,
//     withTransient : 1,
//     allowingMissed : 1,
//     maskPreset : 0,
//     outputFormat : 'relative',
//     filter :
//     {
//       filePath : { 'node_modules' : 0, 'package.json' : 0, 'package-lock.json' : 0 },
//       recursive : 2,
//     }
//   });

// }

// //

// function assetFor( test, name, puppeteer )
// {
//   let self = this;
//   let a = Object.create( null );

//   a.test = test;
//   a.name = name;
//   a.originalAssetPath = _.path.join( self.assetsOriginalPath, name );
//   a.routinePath = _.path.join( self.suiteTempPath, test.name );
//   a.fileProvider = _.fileProvider;
//   a.path = _.fileProvider.path;
//   a.ready = _.Consequence().take( null );

//   a.reflect = function reflect()
//   {
//     _.fileProvider.filesDelete( a.routinePath );
//     _.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : a.routinePath } });
//   }

//   // a.shell = _.process.starter
//   // ({
//   //   currentPath : a.routinePath,
//   //   outputCollecting : 1,
//   //   outputGraying : 1,
//   //   ready : a.ready,
//   //   mode : 'shell',
//   // })

//   _.assert( a.fileProvider.isDir( a.originalAssetPath ) );

//   a.willbeExecPath = _.path.normalize( require.resolve( 'willbe' ) );
//   a.willbe = _.process.starter
//   ({
//     execPath : 'node ' + a.willbeExecPath,
//     currentPath : a.routinePath,
//     outputCollecting : 1,
//     outputGraying : 1,
//     ready : a.ready,
//     mode : 'spawn',
//   })

//   return a;

// }

// //

// function onSuiteEnd()
// {
//   let self = this;
//   _.assert( _.strHas( self.suiteTempPath, '/wtools/tmp.tmp' ) || _.strHas( self.suiteTempPath, '/Temp/' ) )
//   _.fileProvider.filesDelete( self.suiteTempPath );
// }

// // --
// //
// // --

// async function trivial( test )
// {
//   let self = this;
//   let a = self.assetFor( test, 'legacy-trivial', true );
//   var srcPath = _.path.join( a.routinePath, 'out/debug' );
//   var initScriptPath = _.path.join( srcPath, 'Init.s' );
//   var indexHtmlPath = _.path.join( srcPath, 'Index.html' );

//   var indexHtmlSource =
//   `<html>
//     <head>
//       <script src="./Test.raw.filesmap.s" type="text/javascript"></script>
//       <script src="./Test.raw.starter.config.s" type="text/javascript"></script>
//       <script src="./StarterInit.run.s" type="text/javascript"></script>
//       <script src="./StarterStart.run.s" type="text/javascript"></script>
//     </head>
//   </html>`
//   ;
//   var initScriptSource = `console.log( 'Init script' )`;

//   _.fileProvider.fileWrite( indexHtmlPath, indexHtmlSource );
//   _.fileProvider.fileWrite( initScriptPath, initScriptSource );

//   a.reflect();
//   await a.willbe({ args : '.build' });

//   /*
//     ... grab all required files into tmp/wtools dir ...
//   */

//   try
//   {

//     var starterMaker = new _.StarterMaker
//     ({
//       appName : 'Test',
//       inPath : '/',
//       outPath : '/',
//       toolsPath : '/wtools',
//       initScriptPath : '/Init.s',
//       offline : 1,
//       verbosity : 5,
//       logger : new _.Logger({ output : logger }),
//     });

//     starterMaker.fileProviderForm();
//     starterMaker.fromHardDriveRead({ srcPath : _.uri.join( 'file:///', srcPath ) });
//     starterMaker.form();

//     starterMaker.starterMake();
//     starterMaker.filesMapMake();
//     starterMaker.toHardDriveWrite({ dstPath : _.uri.join( 'file:///', srcPath ) });

//   }
//   catch( err )
//   {
//     test.exceptionReport({ err : err });
//   }

//   var files = _.fileProvider.dirRead( srcPath );
//   var expected =
//   [
//     'Index.html',
//     'Init.s',
//     'StarterInit.run.s',
//     'StarterPreloadEnd.run.s',
//     'StarterStart.run.s',
//     'Test.raw.filesmap.s',
//     'Test.raw.starter.config.s'
//   ];
//   test.identical( files, expected );
// }

// trivial.timeOut = 300000;

// // --
// //
// // --

// const Proto =
// {

//   name : 'Tools.mid.StarterLegacy',
//   silencing : 1,
//   enabled : 0,

//   onSuiteBegin,
//   onSuiteEnd,

//   context :
//   {
//     suiteTempPath : null,
//     assetsOriginalPath : null,
//     find : null,
//     assetFor
//   },

//   tests :
//   {
//     trivial,
//   }

// }

// const Self = wTestSuite( Proto );
// if( typeof module !== 'undefined' && !module.parent )
// wTester.test( Self.name );

// })();
