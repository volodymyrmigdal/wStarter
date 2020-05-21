( function _Maker2_s_() {

'use strict';

let _ = _global_.wTools;
let Parent = _.starter.Maker;
let Self = function wStarterMaker2( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Maker2';

// --
// routines
// --

function sourcesJoinFiles( o )
{
  let maker = this;
  let fileProvider = maker.fileProvider;
  let path = maker.fileProvider.path;
  let logger = maker.logger;

  o = _.routineOptions( sourcesJoinFiles, arguments );

  /* */

  o.inPath = fileProvider.recordFilter( o.inPath );

  if( o.basePath === null )
  o.basePath = o.inPath.basePathSimplest()
  if( o.basePath === null )
  o.basePath = path.current();
  if( o.inPath.prefixPath && path.isRelative( o.inPath.prefixPath ) )
  o.basePath = path.resolve( o.basePath );

  o.inPath.basePathUse( o.basePath );

  o.inPath = fileProvider.filesFind
  ({
    filter : o.inPath,
    mode : 'distinct',
    outputFormat : 'absolute',
  });

  /* */

  if( o.inPath && o.allowedPath )
  o.inPath = _.starter.pathAllowedFilter( o.allowedPath, o.inPath );

  /* */

  if( o.outPath )
  {
    o.outPath = o.outPath || sourcesJoinFiles.defaults.outPath;
    o.outPath = path.resolve( o.basePath, o.outPath );
  }

  /* */

  if( o.entryPath )
  {
    o.entryPath = fileProvider.recordFilter( o.entryPath );
    o.entryPath.basePath = path.resolve( o.entryPath.basePath || o.basePath || '.' );
    o.entryPath = fileProvider.filesFind
    ({
      filter : o.entryPath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });

    if( o.entryPath && o.allowedPath )
    o.entryPath = _.starter.pathAllowedFilter( o.allowedPath, o.entryPath );

    if( !_.longHasAll( o.inPath, o.entryPath ) )
    {
      debugger;
      throw _.errBrief
      (
        'List of source files should have all entry files' +
        '\nSource files\n' + _.toStrNice( o.inPath, { levels : 2 } ) +
        '\nEntry files\n' + _.toStrNice( o.entryPath, { levels : 2 } )
      );
    }
  }

  /* */

  if( o.externalBeforePath )
  {
    o.externalBeforePath = fileProvider.recordFilter( o.externalBeforePath );
    o.externalBeforePath.basePath = path.resolve( o.externalBeforePath.basePath || o.basePath || '.' );
    o.externalBeforePath = fileProvider.filesFind
    ({
      filter : o.externalBeforePath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
    if( o.externalBeforePath && o.allowedPath )
    o.externalBeforePath = _.starter.pathAllowedFilter( o.allowedPath, o.externalBeforePath );
  }

  /* */

  if( o.externalAfterPath )
  {
    o.externalAfterPath = fileProvider.recordFilter( o.externalAfterPath );
    o.externalAfterPath.basePath = path.resolve( o.externalAfterPath.basePath || o.basePath || '.' );
    o.externalAfterPath = fileProvider.filesFind
    ({
      filter : o.externalAfterPath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
    if( o.externalAfterPath && o.allowedPath )
    o.externalAfterPath = _.starter.pathAllowedFilter( o.allowedPath, o.externalAfterPath );
  }

  /* */

  o.basePath = path.resolve( o.basePath || '.' );

  /* */

  let srcScriptsMap = Object.create( null );
  o.inPath = o.inPath.map( ( inPath ) =>
  {
    let srcRelativePath = inPath;
    srcScriptsMap[ srcRelativePath ] = fileProvider.fileRead( inPath );
  });

  let o2 = _.mapExtend( null, o )
  delete o2.inPath;
  o2.filesMap = srcScriptsMap;
  let data = maker.sourcesJoin( o2 )

  if( o.outPath )
  {
    _.sure( !fileProvider.isDir( o.outPath ), () => 'Can rewrite directory ' + _.color.strFormat( o.outPath, 'path' ) );

    fileProvider.fileWrite
    ({
      filePath : o.outPath,
      data : data,
    });
  }

  return data;
}

var defaults = sourcesJoinFiles.defaults = _.mapBut( _.starter.Maker.prototype.sourcesJoin.defaults, { filesMap : null } );
defaults.inPath = null;
defaults.outPath = 'Index.js';
defaults.withServer = 0;

//

function htmlForFiles( o )
{
  let maker = this;
  let fileProvider = maker.fileProvider;
  let path = maker.fileProvider.path;
  let logger = maker.logger;

  o = _.routineOptions( htmlForFiles, arguments );

  /* */

  if( o.inPath !== false )
  if( !_.arrayIs( o.inPath ) || o.inPath.length ) /* if not empty array */
  {
    o.inPath = fileProvider.recordFilter( o.inPath );
    o.inPath.basePathUse( o.basePath );

    if( o.basePath === null )
    o.basePath = o.inPath.basePathSimplest()
    if( o.basePath === null )
    o.basePath = path.current();
    if( o.inPath.prefixPath && path.isRelative( o.inPath.prefixPath ) )
    o.basePath = path.resolve( o.basePath );

    if( o.basePath === o.inPath.filePath )
    o.basePath = path.dir( o.basePath );

    o.inPath = fileProvider.filesFind
    ({
      filter : o.inPath,
      mode : 'distinct',
      outputFormat : 'absolute',
    });
  }

  /* */

  if( o.inPath && o.allowedPath )
  o.inPath = _.starter.pathAllowedFilter( o.allowedPath, o.inPath );

  /* */

  if( o.outPath )
  {
    o.outPath = o.outPath || sourcesJoin.defaults.outPath;
    o.outPath = path.resolve( o.basePath, o.outPath );
  }
  o.basePath = path.resolve( o.basePath || '.' );

  /* */

  if( o.templatePath && o.template === null )
  o.template = fileProvider.fileRead( path.resolve( o.basePath, o.templatePath ) );

  /* */

  let srcScriptsMap = Object.create( null );
  if( o.inPath )
  o.inPath = o.inPath.map( ( inPath ) =>
  {
    let srcRelativePath = inPath;
    if( o.relative && o.basePath )
    srcRelativePath = path.dot( path.relative( o.basePath, srcRelativePath ) );
    if( o.nativize )
    srcRelativePath = path.nativize( srcRelativePath );
    if( o.withStarter === 'inline' )
    srcScriptsMap[ srcRelativePath ] = fileProvider.fileRead( inPath );
    else
    srcScriptsMap[ srcRelativePath ] = null;
  });

  if( o.title === null )
  if( _.lengthOf( srcScriptsMap ) > 0 )
  o.title = path.fullName( _.mapKeys( srcScriptsMap )[ 0 ] );

  let o2 = _.mapOnly( o, maker.htmlFor.defaults );
  o2.srcScriptsMap = srcScriptsMap;
  let data = maker.htmlFor( o2 );

  if( o.outPath )
  {
    _.sure( !fileProvider.isDir( o.outPath ), () => 'Can rewrite directory ' + _.color.strFormat( o.outPath, 'path' ) );
    fileProvider.fileWrite
    ({
      filePath : o.outPath,
      data : data,
    });
  }

  return data;
}

var defaults = htmlForFiles.defaults = _.mapBut( _.starter.Maker.prototype.htmlFor.defaults, { srcScriptsMap : null } );
defaults.inPath = null;
defaults.outPath = 'Index.html';
defaults.basePath = null;
defaults.templatePath = null;
defaults.allowedPath = null;
defaults.relative = 1;
defaults.nativize = 0;

// --
// relations
// --

let Composes =
{
}

let Associates =
{
  fileProvider : null,
  logger : null,
}

let Restricts =
{
}

let Statics =
{

  // PathExcludeNotAllowed,

}

// --
// prototype
// --

let Proto =
{

  /* */

  sourcesJoinFiles,
  htmlForFiles,

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

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.starter[ Self.shortName ] = Self;

})();
